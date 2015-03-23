function phot = blackbody_phot(lam, T, R, dpc)
%BLACKBODY_PHOT - calculate the photon flux density from a blackbody
%
% References: 
%
% Syntax: phot = blackbody_phot(lam, T, R, dpc)
%
% Inputs:
%    lam - wavelength vector, in microns
%    T   - Temperature in Kelvin
%    R   - Radius, in solar units
%    dpc - distance in pc
%
% Outputs:
%    phot - photon flux, in photons/m^2/micron (photons/area/wavelength)
%
% Other m-files required: none
%
% Subfunctions: none
%
% MAT-files required: none
%
% Author: Jared R. Males
% email: jaredmales@gmail.com
% 
% History:
%  - written by JRM on 2014.10.04
%

%------------- BEGIN CODE --------------

% Constants
h = 6.626068d-34;
k = 1.3806504d-23;
c = 299792458.;
pc = 3.0856776e+16;
Rsun = 6.958e8;
 
% Solid angle diluation factor
solidang = pi*  ( (R*Rsun) / (dpc*pc) )^2;

% Flux
phot = 2*c/(exp( h*c./((lam*1e-6)*k*T) )-1.)*solidang./(lam*1e-6).^4 / 1e6;



end
   