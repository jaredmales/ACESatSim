function P = period_solar(m1, m2, a)
%PERIOD_SOLAR - calculate the period of an orbit in solar units
%
% The units are solar mass, AU, and days.
%
% References: 
%
% Syntax:  P = period_solar(m1, m2, a)
%
% Inputs:
%    m1 - mass of the primary (solar masses)
%    m2 - mass of the secondary (solar masses)
%    a - semi-major axis (AU)
%
% Outputs:
%    P - period of the orbit, in days
%
% Other m-files required: none
%
% Subfunctions: none
%
% MAT-files required: none
%
% See also: none
%
% Author: Jared R. Males
% email: jaredmales@gmail.com
% 
% History:
%  - written by JRM on 2014.08.22
%

%------------- BEGIN CODE --------------

%Solar Gravitational Constant, units = AU^3/day^2
SQRT_GM_SOL_AUD = 0.01720209895;


P = 2.0*pi*sqrt((a^3)/(m1+m2))/SQRT_GM_SOL_AUD;

end
   
   
   