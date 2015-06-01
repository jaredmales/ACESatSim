function psd = cubespsd(cube)

[dim1 dim2 nims] = size(cube);

psd = zeros(dim1, dim2);

w = hann(dim1);
w2 = w*w';


for i=1:nims    
   rpsd = ( abs( fft2( cube(:,:,i).*w2)  ).^2);

   psd = psd + rpsd / sum(sum(rpsd));   
end

psd = psd/(nims);

end




