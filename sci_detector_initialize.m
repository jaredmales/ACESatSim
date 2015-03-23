function sci = sci_detector_initialize(flD, dt);

% initialize science plane
sci.N = 128;%128;
sci.lambda_ref = 500e-9; % reference lambda for pixel scaling
sci.dx = flD/4;
sci.dy = flD/4;
sci.gridsize = sci.N*sci.dx;
sci.x = -(sci.gridsize - sci.dx)/2 : sci.dx : (sci.gridsize - sci.dx)/2;
sci.y = -(sci.gridsize - sci.dy)/2 : sci.dy : (sci.gridsize - sci.dy)/2;
[sci.xx sci.yy] = meshgrid(sci.x, sci.y);
sci.rr = sqrt(sci.xx.^2 + sci.yy.^2);

sci.dt = dt;

%Include photon noise if sci.noise == 1
sci.noise = 1;

