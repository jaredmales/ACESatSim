function im = sci_expose(sci)
% assumptions
% units of sci.E are sqrt(photons/sec)
%

%JRM: Added sci.dx*sci.dy
im = sum(abs(sci.E).^2,3)*(sci.dx*sci.dy)*sci.dt;
%im = imnoise(im/1e14, 'poisson')*1e14;

if (sci.noise == 1)
   %Add Gaussian white noise with Poisson statistics
   % -- works for flux > 1e12
   im =  im + randn(size(im)).*(im.^0.5);
end

