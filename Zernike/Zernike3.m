function R = Zernike2(n,m,x);
%
% Return the Zernike Polynomial R_n^m of x
% normalized so that R(end) = 1
%

R = (-1)^((n-m)/2)*x.^m.*JacobiP(1-2*x.^2,m,0,(n-m)/2);

R = R/R(end);

% R = 0*x;
% for l = 0:((n-m)/2)
%     R = R + (-1)^l*factorial(n-l)/(factorial(l)*factorial(0.5*(n+m)-l)*factorial(0.5*(n-m)-l))*x.^(n-2*l);
% end

% R=0;
% if (n-m)/2==round((n-m)/2),
%     for l=0:(n-m)/2,
%         R=R+x.^(n-2*l)*(-1)^l*gamma(n-l+1)/(gamma(l+1)*gamma((n+m)/2-l+1)*gamma((n-m)/2-l+1));
%     end
% end
% R(isnan(R)) = 0;

% At this point R(1) = 1, which is the standard zernike normalization. The
% next few lines normalize it to unity rms on the unit circle

% R_norm=R*sqrt(2*(n+1));
% if m == 0,
%    R=R/sqrt(2);
% end