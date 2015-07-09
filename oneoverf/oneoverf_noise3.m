function [cnoise, cube] = oneoverf_noise3(space_nsamps, space_oversamp, space_alpha, time_nsamps, time_oversamp, time_alpha, distspec)
% ONEOVERF_NOISE3 - generate a 1/f^alpha noise cube
%  
% Description: Creates a cube of 1/f^alpha noise, with possibly different
%              alpha in space (dims 1 and 2) and time (dim 3). 
%
%              First uses oneoverf_noise.m to generate a time-series at each
%              spatial position with time_alpha.  Then use
%              oneoverf_noise2.m to filter each plane with space_alpha.
%              As in oneoverf_noise.m, the oversampling 
%              factors are used to add low-spatial frequency information to
%              the noise, and avoid edge effects.  In both time and space 
%              a noise field of size nsamps*oversamp is generated and 
%              filtered, and then the central nsamps is extracted and 
%              returned.  The output is normalized by setting the variance 
%              in each of the space_nsamps*space_oversamps plane to 1.
%
% References: See "Generalized Noll Analysis..." by Jared Males
%
% Syntax:  cnoise = oneoverf_noise3(space_nsamps, space_oversamp, space_alpha, time_nsamps, time_oversamp, time_alpha)
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
% See also: char_oneoverf.m
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
Ntime = time_nsamps*time_oversamp;

%Allocate the working cube
cube = zeros(space_nsamps, space_nsamps, Ntime);

%Now generate each plane of the cube
for i=1:Ntime 
   cube(:,:,i) = oneoverf_noise2(space_nsamps, space_oversamp, space_alpha, 'dist', distspec);
end



%Now allocate the final cube
cnoise = zeros(space_nsamps, space_nsamps, time_nsamps);

%And filter and extract each time series
for i=1:space_nsamps
   for j=1:space_nsamps
      cnoise(i,j,:) = oneoverf_noise(time_nsamps, time_oversamp, time_alpha, reshape(cube(i,j,:),1,[]));
   end
end







end





