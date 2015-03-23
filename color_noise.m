function out = color_noise(noise, alpha)

N = length(noise);

x = fftshift((0:1:N-1)-N/2);

envelope = 1./(abs(x).^(alpha/2.0));
envelope(1) = 0;


FT = fft(noise).*envelope;

out = real((ifft(FT)));

out = out./std(out).*std(noise);

end















