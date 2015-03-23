function planet = planet_initialize(star, Rp, Ag, orbit, ts)

tol = 1e-6; %tolerance for solving Kepler's equation
itmax = 200; %maximum number of iterations for solving Kepler's equation

planet.R = Rp;
planet.Ag = Ag;
planet.orbit = orbit;

planet.orbit.setPeriod(star.mass, 0.);


[x, y, r, phi] = planet.orbit.cartesian_orbit_contrasts(ts);

planet.r= r;
planet.phi = phi;

planet.contrast = 1.818e-9*planet.R^2*planet.Ag*phi./(r.^2);
   
planet.star_flux = star.flux;

planet.x = star.x + x/star.distance;
planet.y = star.y + y/star.distance;

end








