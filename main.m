function acend_main(star, bandno)


%% Mission Set Up
%star = 1; %1 for A, 2 for B

%bandno = 2;        % filter, in terms of bands defined in proposal,2-6

newoptics = true;  % if true, optics are re-initialized.   if false, optics.m is loaded
missionLength = 2; % length of mission in years
cadence = 12;      % time in days between observing in the same bandpass

dwell = 23.0/24.0; % time in days spent in the bandpass
dt =600;          % frame period in seconds;

startday = bandno-1;      % first day for this filter
if(star == 2)
   startday = startday + 0.5*cadence;
end

outputdir = 'images009';




%% ------------------- initializations -------------------------

%Calculate number of visits, frames per visit, and total frames in mission
Nvisits = floor(missionLength*365.25/cadence);
NframesVisit = floor((dwell*86400.0) /dt); 
Nframes = Nvisits*NframesVisit;


%Construct the time series
ts = (startday-1)*86400 + [0:NframesVisit-1]*dt;
for i=1:Nvisits
   ts = [ts, (startday-1)*86400 + i*cadence*86400 + [0:NframesVisit-1]*dt];
end


[filter, Ag] = aCEND_filters(bandno);





%% Stars and Planets
%alpha Cen A
orbitA = orbit(0,0,0,0,0,0,0);

if (star == 1) 
   stars(1) = star_initialize('acenA', -1, filter, orbitA, ts/86400.);
else
   stars(1) = star_initialize('acenB', -1, filter, orbitA, ts/86400.);
end

%alpha Cen B
%orbital elements from Pourbaix 2002
%orbitB = orbit(23.58, 79.9*365.25 , 0.5179, 79*pi/180, (1875.66-2015.0)*365.25, 231.65*pi/180, 204.85*pi/180);
%stars(2) = star_initialize('acenB', -1, lambda*1e6, dlambda, orbitB, ts/86400.);

%Single 1AU*sqrt(L) terrestrial planet
orbitPlanet = orbit(sqrt(stars(1).luminosity), 0., 0., 79.*pi/180.,0., 0., -45.*pi/180);


planet = planet_initialize(stars(1), 1.0, Ag, orbitPlanet, ts/86400.);
noplanet = planet_initialize(stars(1), 1.0, 0, orbitPlanet, ts/86400.);

%No planet around B
if (star == 2)
   planet = noplanet
end

sources = astrophysics_initialize(stars, planet);
sources_staronly = astrophysics_initialize(stars, noplanet);

%% Optics and Disturbances
if newoptics
   optics = optics_initialize;
   save('optics.mat', 'optics');
else
   load('optics.mat');
end

flD = optics.primary.f*(filter.lambda*1e-6)/optics.primary.Dx;
sci = sci_detector_initialize(flD);

disturbances = disturbance_initialize(ts);
disturbance.tip(1) = 0;
disturbance.tilt(1) = 0;
sci.E = optics_propagate(sources_staronly, optics, sci, filter.lambda*1e-6, disturbances(1), 1);
sci.im_ref = sci_expose(sci, dt);


head = cell(3,3);
head{1,1} = 'BAND';
head{1,2} = bandno;
head{1,3} = 'Filter band number';
head{3,1} = 'EXPTIME';
head{3,2} = dt;
head{3,3} = 'Exposure time in seconds';

folderout = sprintf('%s/%d/band%d', outputdir, star, bandno);
mkdir(folderout);

%% --------------------Simulation
%simulation
nextmon = 1;
nextday = 1;
nextqtr = 1;
for n = 1:Nframes
    
    day = floor(ts(n)/86400.)
    mon = floor(ts(n)/(30.4*86400.))
    qtr = floor(ts(n)/(91.5*86400.))

    %Kick the primary once a day
%    if (day == nextday)
%      optics.primary.aberrations = phase_error(primary.N, 2, 1.0e-9);
%      nextday = nextday + 1;
%    end
 
    %Kick the primary once a quarter  
    if (qtr = nextqtr)
      optics.primary.aberrations = phase_error(primary.N,2,1.0e-9);
      nextqtr = nextqtr + 1;
    end

    %compute science frame
    sci.E = optics_propagate(sources, optics, sci, filter.lambda*1e-6, disturbances(n), n);
    sci.im(:,:,n) = sci_expose(sci, dt); % - sci.im_ref);
        
    %display frame
%    figure(1)
%    Cnorm = (sum(sum(optics.primary.A))*optics.primary.dx*optics.primary.dy/(lambda*optics.primary.f)).^2 * stars(1).flux(1)*dt;
%    imagesc(sci.x/flD, sci.y/flD, log10(abs(sci.im(:,:,n))/Cnorm), [-11 -5]); axis image; colorbar;
%    xlabel('x (\lambda/D)');
%    ylabel('y (\lambda/D)');
    
    filename = sprintf('%s/exposure%05d.fits', folderout, n);
    
    head{2,1} = 'DATEOBS';
    head{2,2} = ts(n)/86400.; %
    head{2,3} = 'observation date in days';
    
    fits_write(filename, sci.im(:,:,n), head);
end

end
