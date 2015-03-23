function alf = orbital_phase(f, w, i)
%ORBITAL_PHASE - calculate the orbital phase angle
%
% References: 
%
% Syntax:  alf = orbital_phase(f, w, i)
%
% Inputs:
%    f - the true anomaly
%    w - the argument of periastron
%    i - the inclination
%
% Outputs:
%    alf - the orbital phase angle
%
% Other m-files required: none
%
% Subfunctions: none
%
% MAT-files required: none
%
% See also: rf_elements.m, lambert_phi.m
%
% Author: Jared R. Males
% email: jaredmales@gmail.com
% 
% History:
%  - written by JRM on 2014.08.22
%

%------------- BEGIN CODE --------------
alf = acos(sin(f+w)*sin(i));

end

