function star = star_initialize(sptype, distance, filter, orbit, ts)
%STAR_INITIALIZE - initialize a star structure
%
% References: 
%
% Syntax: star = star_initialize(sptype, distance, lam0, dlam, orbit, ts)
%
%
% Inputs:
%   sptype - either a spectral type or a star name
%            spectral types are 'G2', 'K4', etc.
%            currently valid star names are:
%               'acenA'
%               'acenB'
%   distance - distance in pc
%              This is ony used for spectral types, for named stars
%              it is ignored.
%   orbit    - orbit structure
%   ts       - time points to calculate the orbit
%
% Outputs:
%   star     - structure containing orbit and flux of star
%
% Other m-files required: sptype_params.m, blackbody_phot.m, orbit.m
%
% Subfunctions: none
%
% MAT-files required: none
%
% Author: Jared R. Males
% email: jaredmales@gmail.com
% 
% History:
%  - written by JRM in 2014.08
%  - JRM added photon flux from blackbody on 2014.10.04

%------------- BEGIN CODE --------------



[R, T, M, L, dpc] = sptype_params(sptype);

star.mass = M;
star.radius = R;
star.Teff = T;
star.luminosity = L;
if (dpc > 0)
   distance = dpc;
end
star.distance=distance;

star.sptype = sptype;



%% Here we will one day get spectrum based on sptype
%Future: if sptype is a spectral type
%        Read spectrum
%          Scale spectrum for Vmag (or Lum?)
%          if sptype is a star name
%        Read spectrum, but don't scale
 

%% Here we integrate spectrum over bandpasses
% for now just use square wave and BB

star.flux = blackbody_phot(filter.lambda, star.Teff, star.radius, star.distance) .* filter.dlambda*filter.throughput;

%% Calculate and project orbit
[x,y] = orbit.cartesian_orbit_contrasts(ts);

star.x = x/star.distance;
star.y = y/star.distance;


end


