function Eout = optics_propagate(sources, optics, sci, lambda, disturbance, n);

primary = optics.primary;
PIAA = optics.PIAA;

primary.phase_error = (2*primary.aberrations + disturbance.tilt * primary.xx + disturbance.tip * primary.yy)/lambda; %radians

for j = 1:length(sources)
    %JRM added: have to multiply grid cell size to get photometry right
    amp = sqrt(sources(j).flux(n));
    primary.Ein = amp * exp(i*2*pi* ( (sources(j).x(n)/206265.)* primary.xx + (sources(j).y(n)/206265.)* primary.yy)/lambda);
    primary.E = primary.Ein.*primary.A.*exp(i*2*pi*primary.phase_error);

    if(optics.coronagraph == 0)
    %% No Coronagraph
      exitpup = primary;  
     
    end
    %% Coronagraph case #1: ideal coronagraph
%     exitpup = primary;
%     exitpup.E = primary.E - sum(sum(primary.E.*primary.A))/sum(sum(primary.A.^2))*primary.A;

    % Coronagraph case #2: Exo-C coronagraph
    if(optics.coronagraph == 1)
      % Propagate from Primary to PIAA1 and apply the pre-apodizer
      PIAA.M1.E = primary.E; % 1-1 imaging (for now)
      PIAA.M1.E = PIAA.M1.E.* PIAA.M1.aapod;

      % Propagate from PIAA1 to PIAA2
      PIAA.M2.E = PIAA.M2.AA .* interp2(PIAA.M1.xx, PIAA.M1.yy, PIAA.M1.E, PIAA.M2.rremap.*cos(PIAA.M2.ttheta), PIAA.M2.rremap.*sin(PIAA.M2.ttheta), 'spline');

      % Propagate from PIAA2 to invPIAA1, applying the occulter in-between
      PIAA.M2inv = pupil_to_Lyot(PIAA.M2, PIAA.mask, lambda);
      PIAA.M2inv.E = PIAA.M2inv.E.*(PIAA.M2.rr < 1*PIAA.M2.Dx/2);

      % Propagate from invPIAA2 to invPIAA1
      PIAA.M1inv.E = interp2(PIAA.M2inv.xx, PIAA.M2inv.yy, PIAA.M2inv.E./PIAA.M2.AA , PIAA.M1inv.rremap.*cos(PIAA.M1inv.ttheta), PIAA.M1inv.rremap.*sin(PIAA.M1inv.ttheta), 'cubic');
      PIAA.M1inv.E(isnan(PIAA.M1inv.E)) = 0;
      
      exitpup = PIAA.M1inv;
      exitpup.E = exitpup.E.*(exitpup.rr < 0.95*exitpup.Dx/2);
    end
    
    %% Propagate from exit pupil to image plane
    Eout(:,:,j) = Fraunhofer_focal(exitpup, sci, exitpup.f, lambda);




end
