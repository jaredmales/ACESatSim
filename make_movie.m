% Note: the "old laser" data was taken with 1 frame/s, 1000 frames
% the "new laser" data was taken with 0.1 frames/s, 100 frames

colormap jet;
N = floor(2*365/7);
for i = 1:N
    fname = sprintf('C:\\Users\\rbelikov.NDC\\Desktop\\research\\Ames\\aCEND\\instrument_simulator\\V2.1\\images\\exposure%05d.fits',i);
    im = fitsread(fname);
    im = im*0.5e4/1e3;
    %im = (im/2.5 + 1)*63;
    im(im<0) = 0;
    im(im>63) = 63;
    im = im + 1;
    M(i) = im2frame(im, colormap);
    i
end

movie2avi(M, 'acend15.avi', 'FPS', 30, 'COMPRESSION', 'none');