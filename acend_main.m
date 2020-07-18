function acend_main(star, bandno, outputdir)


%% Mission Set Up
%star = 1; %1 for A, 2 for B

%bandno = 1;        % filter, in terms of bands defined in proposal,Table
%E-3


missionLength = 2.0; % length of mission in years
cadence = 1;      % time in days between observing in the same bandpass

dwell = 24.0/24.0; % time in days spent in the bandpass
dt =1200;          % frame period in seconds;

startday = 1; %bandno;      % first day for this filter
if(star == 2)
   startday = startday + 0.5*cadence;
end

%Set this directory to the one containing the 1/f^alpha noise frames
phase_dir = '/home/jaredmales/Source/matlab/acesat_phasescreens/oneoverf_128_52596_r0_2.000000';

%RMS mirror figure, in meters
mirror_figure =  0.1e-9/sqrt(3.7);

%RMS of the T/T disturbance in mas
%For proposal used 0.5
%0.25 is for show
tiptilt_rms = 0.25;

%% ------------------- initializations -------------------------

[git_sha1 git_mod] = git_status('./acesatsim');

%Calculate number of visits, frames per visit, and total frames in mission
Nvisits = floor(missionLength*365.25/cadence);
NframesVisit = floor((dwell*86400.0) /dt); 
Nframes = Nvisits*NframesVisit;
Nsamples = floor(missionLength*365.25)*86400/dt; %This is the total number of exp-time length periods in mission


%Construct the time series
ts = (startday-1)*86400 + [0:NframesVisit-1]*dt;
for i=1:Nvisits
   ts = [ts, (startday-1)*86400 + i*cadence*86400 + [0:NframesVisit-1]*dt];
end

filter = aCEND_filters(bandno);


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

%Single 1AU*sqrt(L) terrestrial planeti
inc = 0.;%79.2;
Womega = 204.85;
orbitPlanet = orbit(sqrt(stars(1).luminosity), 0., 0., inc*pi/180.,35., 0., Womega*pi/180);
orbitPlanet2 = orbit(2.5, 0., 0., inc*pi/180.,0., 0., Womega*pi/180);
orbitPlanet3 = orbit(0.72*sqrt(stars(1).luminosity), 0., 0., inc*pi/180.,-15., pi, Womega*pi/180);

Ag1 = aCEND_albedo(bandno, 'earth');
Ag2 = aCEND_albedo(bandno, 'rmars');
Ag3 = aCEND_albedo(bandno, 'venus');

planet = planet_initialize(stars(1), 11.0, Ag1, orbitPlanet, ts/86400.);
planet2 = planet_initialize(stars(1), 1., Ag2, orbitPlanet2, ts/86400.);
planet3 = planet_initialize(stars(1), 0.95, Ag3, orbitPlanet3, ts/86400.0);
noplanet = planet_initialize(stars(1), 1.0, 0, orbitPlanet, ts/86400.);



%No planet around B
if (star == 2)
   planet = noplanet;
   planet2 = noplanet;
   planet3 = noplanet;
end

planets(1) = planet;
%planets(2) = planet2;
%planets(3) = planet3;

sources = astrophysics_initialize(stars, planets);
%sources_staronly = astrophysics_initialize(stars, noplanet);



%% Optics and Disturbances
optics = optics_initialize;

%flD = optics.primary.f*(filter.lambda*1e-6)/optics.primary.Dx;

%flD_ref = optics.primary.f*(0.5*1e-6)/optics.primary.Dx;

sci = sci_detector_initialize(optics.flD_ref, dt);

make_psf( stars(1), optics, sci, filter, outputdir);

disturbances = disturbance_initialize(tiptilt_rms, ts);

%Create fits header
head = cell(5,3);
head{1,1} = 'BAND';
head{1,2} = bandno;
head{1,3} = 'Filter band number';
head{2,1} = 'DATEOBS';
head{2,3} = 'observation date in days';
head{3,1} = 'EXPTIME';
head{3,2} = dt;
head{3,3} = 'Exposure time in seconds';
head{4,1} = 'GITSHA1';
head{4,2} = git_sha1;
head{4,3} = 'Git commit sha1';
head{5,1} = 'GITMOD';
head{5,2} = git_mod;
head{5,3} = 'Git repo modified flag';

%Prepare directory    
folderout = sprintf('%s/%s/band%d', outputdir, stars(1).sptype, filter.bandno);
mkdir(folderout);

%% --------------------Simulation
fprintf(1, 'Beginning simulation . . .\n');
laststat = 0;
for n = 1:Nframes
    laststat = status_line(sprintf('Frame: %d/%d', n, Nframes), laststat);
    
    %Set current abberation
    nsamp = ts(n)/dt+1;
    %abber = fits_read(sprintf('%s/frame_%05d.fits', phase_dir, nsamp));
    abber = 1.0;
    optics.primary.aberrations = abber* mirror_figure;
    
    %compute science frame
    sci.E = optics_propagate(sources, optics, sci, filter.lambda*1e-6, disturbances(n), n);
    sci.im(:,:,n) = sci_expose(sci); % - sci.im_ref);
    
    filename = sprintf('%s/exposure%05d.fits', folderout, n);
    
    head{2,2} = ts(n)/86400.; %
    
    fits_write(filename, sci.im(:,:,n), head);
end
laststat = status_line('', laststat);
fprintf(1, 'Simulation complete\n');
    
end
