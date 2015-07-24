function [cnoise, cube] = oneoverf_noise3(space_nsamps, space_oversamp, space_alpha, time_nsamps, time_oversamp, time_alpha, distspec)
% ONEOVERF_NOISE3 - generate a 1/f^alpha noise cube
%  
% Description: Creates a cube of 1/f^alpha noise, with possibly different
%              alpha in space (dims 1 and 2) and time (dim 3). 
%
%              First uses oneoverf_noise2.m to generate a 2D image at each
%              point in the time-series, with a 1/f PSD given by 
%              space_alpha. Then uses oneoverf_noise.m to filter each 
%              spatial point with time_alpha.
%              As in oneoverf_noise.m, the oversampling 
%              factors are used to add low-spatial frequency information to
%              the noise, and avoid edge effects.  In both time and space 
%              a noise field of size nsamps*oversamp is generated and 
%              filtered, and then the central nsamps is extracted and 
%              returned.  The output is normalized by setting the variance 
%              in each of the time_nsamps*time_oversamps planes to 1.
%
% References: See "Generalized Noll Analysis..." by Jared Males
%
% Syntax:  cnoise = oneoverf_noise3(space_nsamps, space_oversamp, space_alpha, time_nsamps, time_oversamp, time_alpha)
%          cnoise = oneoverf_noise3(space_nsamps, space_oversamp, space_alpha, time_nsamps, time_oversamp, time_alpha, distspec)
%
% Inputs:
%    space_nsamps   - the spatial dimension, output will be
%                     space_nsamps*space_nsamps in size
%    space_oversamp - the multiplicative oversampling factor in space, >= 1
%    space_alpha    - the exponent for the spatial PSD
%    time_nsamps    - the time dimension, output will be time_nsamps long
%    time_oversamp  - the multiplicative oversampling factor in space, >= 1
%    time_alpha     - the exponent for the temporal PSD
%    distspec       - optional: either 'normal' [default] or 'uniform'
%
% Outputs:
%    cnoise   - the correlated noise cube of size
%               space_nsamps^2*time_nsamps
%
% Other m-files required: oneoverf_noise.m, oneoverf_noise2.m
%
% Subfunctions: none
%
% MAT-files required: none
%
% See also: oneoverf_char.m
%
% Author: Jared R. Males
% email: jaredmales@gmail.com
% 
% History:
%  - written by JRM on 2015.05.29
%

%------------- BEGIN CODE --------------



%handle distspec default
if nargin < 7 || isempty(distspec)
   distspec = 'normal';
end


if space_oversamp < 1
   space_oversamp = 1;
end

if time_oversamp < 1 
   time_oversamp = 1;
end


Nspace = space_nsamps*space_oversamp;

%The time series is typically longer, and we make it a power of 2
% to make fft as efficient as possible.
Ntime = 2^nextpow2(time_nsamps*time_oversamp);


%There are two ways to do this:
% -- start by generating a time series for each pixel in the oversampled planes, 
% then filter each plane (order==0)
% -- start by generating a plane for each point in the oversampled time
% series, then filter the time series (order == 1)
%
% Choice depends on memory usage for the cube temporary
order = 0;

if (Nspace*Nspace*time_nsamps > space_nsamps*space_nsamps*Ntime)
    order = 1;
end

%For status_line
laststr = 0;

if (order==0)

    %Allocate the working cube, single precision to save
    %space
    cube = zeros(Nspace, Nspace, time_nsamps, 'single');

    %Now allocate the final cube
    cnoise = zeros(space_nsamps, space_nsamps, time_nsamps, 'single');


    %Generate a time series for each pixel in the oversampled cube
    
    for i=1:Nspace
        for j=1:Nspace
            laststr = status_line(sprintf('%d/%d %d/%d', i, Nspace, j, Nspace), laststr);
            
            
            cube(i,j,:) = oneoverf_noise(time_nsamps, time_oversamp, time_alpha);
        end
    end

    %Now filter and extract each plane
    for i=1:time_nsamps 
        laststr = status_line(sprintf('%d/%d', i, time_nsamps), laststr);
        
        cnoise(:,:,i) = oneoverf_noise2(space_nsamps, space_oversamp, space_alpha, cube(:,:,i));
    end

else

    %Allocate the working cube, in single precision to save space
    cube = zeros(space_nsamps, space_nsamps, Ntime, 'single');
 
    %Now allocate the final cube
    cnoise = zeros(space_nsamps, space_nsamps, time_nsamps, 'single');
 
    %Now generate each plane of the cube
    for i=1:Ntime 
        laststr = status_line(sprintf('%d/%d\n', i, Ntime), laststr);
        cube(:,:,i) = oneoverf_noise2(space_nsamps, space_oversamp, space_alpha, 'dist', distspec);
    end

    %And filter and extract each time series
    for i=1:space_nsamps
        for j=1:space_nsamps
            laststr = status_line(sprintf('%d/%d %d/%d\n', i, space_nsamps, j, space_nsamps));
            cnoise(i,j,:) = oneoverf_noise(time_nsamps, time_oversamp, time_alpha, double(reshape(cube(i,j,:),1,[])));
        end
    end
end

status_line('', laststr);

end





