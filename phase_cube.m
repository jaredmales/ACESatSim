function cube = phase_cube(Npix, Nsamp, space_alpha, mirror_figure, time_alpha)

cube = randn(Npix, Npix, Nsamp);

for n=1:Nsamp
   cube(:,:,n) = color_noise2(cube(:,:,n), space_alpha)*mirror_figure;
end

for ix=1:Npix
   for iy=1:Npix
      cube(ix,iy,:) = color_noise(reshape(cube(ix,iy,:), [1,Nsamp]), time_alpha);
   end
end

end






