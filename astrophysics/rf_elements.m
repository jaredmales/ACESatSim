function [r,f,E] = rf_elements(e, M, a, tol, itmax)
%RF_ELEMENTS - calculate the radius and true anomaly of an orbit
%
% References: 
%
% Syntax:  [r,f,E] = rf_elements(e, M, a, tol, itmax)
%
% Inputs:
%    e - the eccentricity
%    M - the current mean anomaly
%    a - the semi-major axis
%    tol - the desired tolerance in the solution to Kepler's equation
%    itmax - the maximum number of iterations in solving Kepler's equation
%
% Outputs:
%    r - the radius at M
%    f - the true anomaly at M
%    E - the eccentric anomaly at M
%
% Other m-files required: none
%
% Subfunctions: none
%
% MAT-files required: none
%
% See also: mean_anomaly.m
%
% Author: Jared R. Males
% email: jaredmales@gmail.com
% 
% History:
%  - ported from c++ library of JRM on 2014.08.22
%

%------------- BEGIN CODE --------------

if e < 0.0
   error('rf_elements: e < 0', 'eccentricity can not be less than 0');      
end

if e >= 1.0
   error('rf_elements: e >= 1', 'eccentricity greater than or equal to 1 not implemented');      
end
   
   
[E, nits] = kepler_danby( e, M, tol, itmax);
   

%check itmax here
   
if e >= 1.0
   %*f = 2.0*std::atan(std::sqrt((e+1.0)/(e-1.0))*std::tanh(*E/2.0));
   %*r = a*(1.0-e*std::cosh(*E));
else
   if e == 0.0  
      f = M;
      r = a;
   else
      f = 2.0*atan(sqrt((1.0+e)/(1.0-e))*tan(E/2.0));
      r = a * (1.0-e*cos(E));
   end
end
   
