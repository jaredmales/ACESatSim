function psd = cubetpsd(cube)

[dim1 dim2 nims] = size(cube);

psd = zeros(1,nims);

w = hann(nims)';

for i=1:dim1
   for j=1:dim2
    
      rpsd = ( abs(fft( reshape(cube(i,j,:),1,[]) .*w)  ).^2);

      psd = psd + rpsd / sum(sum(rpsd));   
   end
end

psd = psd/(dim1*dim2);

end




