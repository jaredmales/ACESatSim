function optics = optics_initialize;

% initialize primary plane
primary.N = 128;
primary.gridsize = 0.45; % meters
primary.Dx = 0.45; %meters
primary.Dy = 0.45; %meters
primary.dx = primary.gridsize/primary.N;
primary.dy = primary.gridsize/primary.N;
primary.x = -(primary.gridsize - primary.dx)/2 : primary.dx : (primary.gridsize - primary.dx)/2;
primary.y = -(primary.gridsize - primary.dy)/2 : primary.dy : (primary.gridsize - primary.dy)/2;
[primary.xx primary.yy] = meshgrid(primary.x, primary.y);
primary.rr = sqrt(primary.xx.^2 + primary.yy.^2);
primary.ttheta = atan2(primary.yy, primary.xx);
primary.A = (primary.rr < 0.5*primary.Dx); %entrance pupil D/2
primary.f = 10; % in meters

% initialize PIAA
load rM2_rM1.txt;
load rM1_apodpre.txt;
load rM2_apodPIAA.txt;

PIAA.M1 = primary;
PIAA.M1.r = rM1_apodpre(:,1)*PIAA.M1.Dx/2;
PIAA.M1.apod = rM1_apodpre(:,2);
PIAA.M1.aapod = interp1(PIAA.M1.r, PIAA.M1.apod, PIAA.M1.rr, 'spline',0).*(PIAA.M1.rr < PIAA.M1.Dx/2);

PIAA.M2 = PIAA.M1;
PIAA.M2.r = rM2_rM1(:,1)*PIAA.M2.Dx/2;
PIAA.M2.remap = rM2_rM1(:,2)*PIAA.M1.Dx/2;
PIAA.M2.A = rM2_apodPIAA(:,2);
C = 1;%trapz(PIAA.M2.A.^2.*PIAA.M2.r)/trapz(PIAA.M2.r);
PIAA.M2.A = PIAA.M2.A/sqrt(C);
PIAA.M2.AA = interp1(PIAA.M2.r, PIAA.M2.A, PIAA.M2.rr, 'spline').*(PIAA.M2.rr < PIAA.M2.Dx/2);

PIAA.M2.rremap = interp1(PIAA.M2.r, PIAA.M2.remap, PIAA.M2.rr,'spline');

PIAA.M = 2; %PIAA magnification;

PIAA.mask.N = PIAA.M1.N;
PIAA.mask.flD = PIAA.M*PIAA.M2.f*500e-9/PIAA.M2.Dx;
PIAA.mask.gridsize = 32*PIAA.mask.flD;
PIAA.mask.R = 1.8*PIAA.mask.flD;
PIAA.mask.dx = PIAA.mask.gridsize / PIAA.mask.N;
PIAA.mask.dy = PIAA.mask.dx;
PIAA.mask.x = -(PIAA.mask.gridsize - PIAA.mask.dx)/2 : PIAA.mask.dx : (PIAA.mask.gridsize - PIAA.mask.dx)/2;
PIAA.mask.y = -(PIAA.mask.gridsize - PIAA.mask.dy)/2 : PIAA.mask.dy : (PIAA.mask.gridsize - PIAA.mask.dy)/2;
[PIAA.mask.xx PIAA.mask.yy] = meshgrid(PIAA.mask.x, PIAA.mask.y);
PIAA.mask.rr = sqrt(PIAA.mask.xx.^2 + PIAA.mask.yy.^2);
PIAA.mask.ttheta = atan2(PIAA.mask.yy, PIAA.mask.xx);
PIAA.mask.M = (PIAA.mask.rr > PIAA.mask.R).*(PIAA.mask.rr < 9*PIAA.mask.flD);

PIAA.M2inv = PIAA.M2;

PIAA.M1inv = PIAA.M2inv;
PIAA.M1inv.rremap = interp1(PIAA.M2.remap, PIAA.M2.r, PIAA.M2.rr,'spline');

% create random aberrations on primary (height in units of meters)
primary.aberrations = phase_error(primary.N, 2, 0.1e-9/sqrt(3.7)); % last parameter is rms in m

optics.primary = primary;
optics.PIAA = PIAA;

optics.flD_ref = optics.primary.f*(0.5*1e-6)/optics.primary.Dx;


optics.coronagraph = 1;

