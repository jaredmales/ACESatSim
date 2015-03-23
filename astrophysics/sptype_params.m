function [R, T, M, L, dpc] = sptype_params(SpT)


%%Stars we know about:

if(strcmp(SpT,'acenA') )
   %From Bruntt+ (2010): http://adsabs.harvard.edu/abs/2010MNRAS.405.1907B
   R =  1.24; %from L and Teff
   T =  5746.;
   M =  1.14; %From binary orbit
   L =  1.47;
   dpc = 1.34;
   return
end
   
if(strcmp(SpT, 'acenB'))
   %From Bruntt+ (2010): http://adsabs.harvard.edu/abs/2010MNRAS.405.1907B
   R =  0.91;  %from L and Teff
   T =  5140.;
   M =  0.934; %From binary orbit
   L =  0.47; 
   dpc = 1.34;
   return
end

%% Generic spectral type, interpolate on the main sequence

Nspt = sptype_numeric(SpT);


%This table from here: http://ads.harvard.edu/books/hsaa/toc.html 
%(via Wikipedia - need to check conversions)
n0 = [6,        10,      15,     20,   25,   30,   35,    40,   42,    45,   50,    55,     60,     65,     68];
r0 = [18,       7.4,    3.8,    2.5,  1.7,   1.3,  1.2,  1.05, 1.00,  0.93,  0.85, 0.74,   0.63,   0.32,   0.13];
t0 = [38000.,  30000,  16400, 10800, 8620,  7240, 6540, 5920,  5780, 5610,  5240,  4410,   3920,  3120,    2660.];
m0 = [40,       18,     6.5,   3.2,   2.1,  1.7,  1.3,  1.1,   1.0,  0.93,  0.78,  0.69,   0.47,  0.21,     0.1];
l0 = [500000., 20000.,  800.,   80.,  20.,   6.,   2.5, 1.26,  1.00, 0.79,  0.40,  0.16,   0.063,  0.0079,  0.0008];


R = interp1(n0,r0, Nspt);
T = interp1(n0,t0, Nspt);
M = interp1(n0,m0,Nspt);
L = interp1(n0,l0,Nspt);

dpc = -1;
end





