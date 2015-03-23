function phi = lambert_phi(alf)
%LAMBERT_PHI - calculate the Lambert phase function
%
% The Lambert phase function describes the brightness of a planet
% as a function of orbital phase.
%
% References: 
%
% Syntax:  phi = lambert_phi(alf)
%
% Inputs:
%    alf - the orbital phase
%
% Outputs:
%    phi - the value of the phase function at alf
%
% Other m-files required: none
%
% Subfunctions: kepler_danby_1
%
% MAT-files required: none
%
% See also: orbital_phase.m
%
% Author: Jared R. Males
% email: jaredmales@gmail.com
% 
% History:
%  - written by JRM on 2014.08.22
%

%------------- BEGIN CODE --------------

phi = (sin(alf) + (pi-alf)*cos(alf))/pi;

end



