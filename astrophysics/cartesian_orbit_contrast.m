function [x, y, r, phi, alf] = cartesian_orbit_contrast(t, P, a, e, t0, i, w, W, tol, itmax)
%CARTESIAN_ORBIT_CONTRAST - calculate the position of an orbit and its phase function.
%
% References: 
%
% Syntax:  [x, y, r, phi, alf] = cartesian_orbit_contrast(t, P, a, e, t0, i, w, W, tol, itmax)
%
% Inputs:
%    t - the time(s)  where outputs are desired
%    P - the period (in same units as time)
%    a - the semi-major axis
%    e - the eccentricity
%    t0 - the reference time (time of pericenter)
%    i - the inclination
%    w - the argument of pericenter
%    W - longitude of the ascending node
%    tol - the desired tolerance in the solution to Kepler's equation
%    itmax - the maximum number of iterations in solving Kepler's equation
%
% Outputs:
%    x - the x position at t
%    y - the y position at t
%    r - the physical separation at t
%    phi - the Lambert phase function position at t
%    alf - the phase angle at position at t
%
% Other m-files required: mean_anomaly.m, rf_elements.m, orbital_phase.m,
% lambert_phi.m
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
%  - adapted from cartesian_orbit_contrast on 2014.08.26
%

%------------- BEGIN CODE --------------

%Just do these calcs once
cos_i = cos(i);
sin_i = sin(i);
cos_W = cos(W);
sin_W = sin(W);
 
%Convert time to mean anomaly
M = mean_anomaly(t, t0, P);

N = length(M);

x   = zeros(1,N);
y   = zeros(1,N);
r   = zeros(1,N);
alf = zeros(1,N);
phi = zeros(1,N);


for  j=1:N
      
   [r_tmp,f_tmp] = rf_elements(e, M(j), a,tol,itmax);
          
   r(j) = r_tmp;
   
   %one calc
   cos_wf = cos(w+f_tmp);
   sin_wf = sin(w+f_tmp);
      
   x(j) = r_tmp*(cos_W*cos_wf-sin_W*sin_wf*cos_i);
   y(j) = r_tmp*(sin_W*cos_wf+cos_W*sin_wf*cos_i);
      
   alf(j) = orbital_phase(f_tmp, w, i);
     
   phi(j) = lambert_phi(alf(j));
      
end
