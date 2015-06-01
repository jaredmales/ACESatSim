function [beta, varmean] = char_oneoverf(nsamp, oversamp, alpha)
% CHAR_ONEOVERF - calculate various parameters for simulated 1/f^alpha
%                 noise
%  
% Description: Calculates the PSD normalization (beta) and the variance 
%              of the mean for a 1/f^alpha noise process which has 
%              variance = 1.
%
%              The form of the PSD is: 
%
%                 PSD(f) = beta*(1/|f|^alpha)
%
%              So the normalization is calculated as
%                   
%                 2*beta*integral[fmin,fmax](1/f^alpha) df = 1.0
%              
%              where fmin=1/(nsamp*oversamp) and fmax=0.5
%
% References: See "Generalized Noll Analysis..." by Jared Males
%
% Syntax:  [beta, varmean] = char_oneoverf(1024, 8, 2.5);
%
% Inputs:
%    nsamps   - the number of samples desired in the output
%    oversamp - the multiplicative oversampling factor, >= 1
%    alpha    - the PSD exponent
%
%
% Outputs:
%    beta    - the PSD normalization constat for variance=1
%    varmean - the variance of the mean
%
% Other m-files required: none
%
% Subfunctions: none
%
% MAT-files required: none
%
% See also: oneoverf_noise.m
%
% Author: Jared R. Males
% email: jaredmales@gmail.com
% 
% History:
%  - written by JRM on 2015.05.29
%

%------------- BEGIN CODE --------------


%The minimum and maximum frequencies based on oversampling
fmin = 1.0/(nsamp*oversamp);

fmax = 0.5;


%Calculate the PSD normalization
if alpha == 1.0
   %Interpolate across alpha=1
   betan = 0.5*(-0.999+1)/(fmax.^(-0.999+1) - fmin.^(-0.999+1));
   betap = 0.5*(-1.001+1)/(fmax.^(-1.001+1) - fmin.^(-1.001+1));
   beta = 0.5*(betan+betap);
else
   beta = 0.5*(-alpha+1)/(fmax.^(-alpha+1) - fmin.^(-alpha+1));
end

%Now calculate the A integral
fun = @(x) x.^(-(alpha+1)).*(besselj(0.5,2*pi*x)).^2;

A = integral(fun, 0.5*nsamp*fmin, 0.5*nsamp*fmax);

%Variance of the mean
varmean = 0.5*beta*(2./nsamp)^(1-alpha)*A;


end








