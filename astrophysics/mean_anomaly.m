function M = mean_anomaly(t, t0, P) 
%MEAN_ANOMALY - calculate the mean anomaly of an orbit
%
% References: 
%
% Syntax:  M = mean_anomaly(t, t0, P)
%
% Inputs:
%    t - the current time
%    t0 - the time of periastron passage (the reference time)
%    P - the period of the orbit
%
% Outputs:
%    M - the mean anomaly, 0 <= M < 2*pi
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
M = 2.*pi*(t-t0)/P;

end

