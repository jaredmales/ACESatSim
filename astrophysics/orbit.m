classdef orbit < handle
   %orbit A class to manage a Keplerian orbit
   %   
   
   properties
      a = 0; %The semi-major axis
      P = 0; %The period
      e = 0; %eccentricity
      i = 0; %inclination
      t0 = 0; %time of pericenter
      w = 0; %argument of pericenter
      W = 0; %longitude of ascending node
      
      tol = 1e-6;
      itmax = 200;
   end
   
   methods
      function orb = orbit(a, P, e, i, t0, w, W)
         orb.a = a;
         orb.P = P;
         orb.e = e;
         orb.i = i;
         orb.t0 = t0;
         orb.w = w;
         orb.W = W;
      end %function orbit
      
      function setPeriod(orb, mass1, mass2)
         orb.P = period_solar(mass1, mass2, orb.a);
      end %function setPeriod
      
      function [x, y, r, phi] = cartesian_orbit_contrasts(orb, ts);
         
         if orb.a == 0
            x = ts*0;
            y = ts*0;
            r = ts*0;
            phi = ts*0 + 1;
         else
            [x, y, r, phi] = cartesian_orbit_contrast(ts, orb.P, orb.a, orb.e, orb.t0, orb.i, orb.w, orb.W, orb.tol, orb.itmax);
         end
      end
   end
   
end

