function make_psf( star, optics, sci, filter, outputdir)


%%Create sources structure with no planet flux
stars(1) = star;

orbitPlanet = orbit(1.,0,0,0,0,0,0);
planets(1) = planet_initialize(star, 1.0, 0., orbitPlanet, 100.);

sources = astrophysics_initialize(stars, planets);

%% Turn off the coronagraph and set aberrations to 0.
optics.coronagraph = 0;
optics.primary.aberrations = optics.primary.aberrations*0;


%% Turn off photon noise
sci.noise = 0;


%% Turn off jitter
disturbance.tip(1) = 0;
disturbance.tilt(1) = 0;


%% Now propagate and expose the PSF
sci.E = optics_propagate(sources, optics, sci, filter.lambda*1e-6, disturbance(1), 1);
im = sci_expose(sci);

%% And save
folderout = sprintf('%s/%s/band%d', outputdir, star.sptype, filter.bandno);
mkdir(folderout);
filename = sprintf('%s/psf.fits', folderout);
    
fits_write(filename, im);
