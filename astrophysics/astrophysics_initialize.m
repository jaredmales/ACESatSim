function sources = astrophysics_initialize(stars, planets);

len = length(stars(1).x);

n = 1;

for m=1:length(stars)
   
   sources(n) = struct('flux', stars(m).flux*ones(1,len), 'x', stars(m).x ,'y',  stars(m).y);
   n = n +1;
end

for m=1:length(planets)

   sources(n) = struct('flux', planets(m).star_flux*planets(m).contrast, 'x', planets(m).x, 'y', planets(m).y);

   n=n+1;
end




