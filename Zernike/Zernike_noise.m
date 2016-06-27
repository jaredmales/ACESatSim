optics = optics_initialize; % this is only necessary to establish the pupil plane XY grid. Comment out if already done

% The following three lines define the Noise parameters: which zernikes are
% present, as well as their relative strengths and power law coefficients
% These can be manually specified as below (e.g. for a specific missin
% where there is no particular pattern for Zernike amplitudes or alphas),
% or automatically generated (e.g. using some kind of a power law decay for
% amplitudes of higher order zernikes.
Noll_modes = [  2       3       4       5];     % 1 = piston, 2 = tip, 3 = tilt, 4 = defocus, etc.
amplitudes = [  1       1       1       1]*0.1; % relative strengths of each mode in radians
alphas     = [  3       3       3       3];     % time power laws of each mode (f^-alpha)

% time series 1/f noise # of samples
nsamps = 100;
oversamp = 1;

%initializing noise cube
noisecube = zeros(optics.primary.N, optics.primary.N, nsamps);

for i = 1:length(Noll_modes)
    [n m] = Noll(Noll_modes(i));
    i
    
    % compute Zernike mode, normalized such that Z(1) = 1;
    Z_xy = Zernike2D(n, m, optics.primary.rr/optics.primary.Dx*2, optics.primary.ttheta);
    
    % create random time variation of that mode
    A = amplitudes(i)*oneoverf_noise(nsamps, oversamp, alphas(i));
    
    for t = 1:nsamps
        noisecube(:,:,t) = noisecube(:,:,t) + A(t)*Z_xy;
    end
   
  
end

% see the noise movie
noise_min = min(min(min(noisecube)));
noise_max = max(max(max(noisecube)));
for t = 1:nsamps
    imagesc(optics.primary.x, optics.primary.y, noisecube(:,:,t), [noise_min/2 noise_max/2]); axis image; colorbar; pause(0.1);
end

% % write to file sequence
for t = 1:nsamps
    filename = sprintf('noise_image%05d.fits', t);
    fits_write(sprintf('noise_image%05d.fits', t), noisecube(:,:,t));
end