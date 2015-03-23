function [E, nits, D] = kepler_danby( e, M, tol, itmax)
%KEPLER_DANBY - solve Kepler's equation. Using Danby's quartic Newton-Raphson method.
%
% References: 
%
% Syntax:  [E, nits, D] = kepler_danby( e, M, tol, itmax)
%
% Inputs:
%    e - the orbit eccentricity
%    M - the mean anomaly
%    tol - the desired fractional tolerance
%    itmax - the maximum number of iterations 
%
% Outputs:
%    E - the eccentric anomaly
%    nits - the number of iterations performed
%    D - the error at the last iteration
%
% Example: 
%    Line 1 of example
%    Line 2 of example
%    Line 3 of example
%
% Other m-files required: none
%
% Subfunctions: kepler_danby_1
%
% MAT-files required: none
%
% See also: none
%
% Author: Jared R. Males
% email: jaredmales@gmail.com
% 
% History:
%  - ported from c+++ library of JRM on 2014.08.22
%

%------------- BEGIN CODE --------------

sin_E = sin(M);
sign = 1.0;

if (sin_E < 0.0)
    sign = -1.0;
end

E = M + 0.85*e*sign;
nits = 0;

for i=1:itmax
    lastE = E;
    E = kepler_danby_1(e, M, E);
      
    %Test for convergence to within tol
    %Make sure we have iterated at least twice to prevent early convergence
    if(i > 2. && abs((E)-lastE) < tol)
        D = M - (E-e*sin(E));
        nits = i;
        return
    end
end
 
 nits = i;
 return

end


function nextit = kepler_danby_1(e, M, Ei)
%KEPLER_DANBY_1 - next iteration of Danby's quartic Newton-Raphson method.
%
% References: 
%
% Syntax:  nextit = kepler_danby_1(e, M, Ei)
%
% Inputs:
%    e - the orbit eccentricity
%    M - the mean anomaly
%    Ei - current mean anomaly
%
% Outputs:
%    nexit - the next eccentric anomaly
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
% Website: http://makana.as.arizona.edu
% 
% History:
%  - ported from c library of JRM on 2014.08.22
%

%------------- BEGIN CODE --------------


%These are expensive, do them just once.
cosE = cos(Ei);
sinE = sin(Ei);
   
fi = Ei - e*sinE - M;
fi1 = 1.0 - e*cosE;
fi2 = e*sinE;
fi3 = e*cosE;
   
di1 = -fi / fi1;
di2 = -fi/(fi1 + 0.5*di1*fi2);
di3 = -fi/(fi1 + 0.5*di2*fi2 + di2*di2*fi3/6.0);
   
nextit = Ei + di3;

end