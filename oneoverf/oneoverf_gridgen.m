%generate a set of fits cubes containing 1/f^alpha filtered noise.


%edit these to change setup [especially basename]:
basename = 'oneoverf_128_52596_r0';

space_nsamp = 128;
space_oversamp = 2;
space_alpha = 3.0;

time_nsamp = 365.25*2.*24.*3.;
time_oversamp = 4;
time_alphas = [ 3.0];


%edit no more!


head = cell(4,3);

head{1,1} = 'SPACOSMP';
head{1,2} = space_oversamp;
head{1,3} = 'Space oversampling factor';


head{2,1} = 'SPACALFA';
head{2,2} = space_alpha;
head{2,3} = 'Space alpha';


head{3,1} = 'TIMEOSMP';
head{3,2} = time_oversamp;
head{3,3} = 'Time oversampling factor';

head{4,1} = 'TIMEALFA';
head{4,3} = 'Time alpha';


    

laststr = 0;
for i=1:length(time_alphas)

    head{4,2} = time_alphas(i);
    
    laststr = status_line(sprintf('%d/%d time_alpha = %f:  ', i, length(time_alphas), time_alphas(i)), laststr);
    
    cnoise=oneoverf_noise3(space_nsamp, space_oversamp, space_alpha, time_nsamp, time_oversamp, time_alphas(i));
    
    sz = size(cnoise);

    folderout=sprintf('%s_%f',basename, time_alphas(i));
    mkdir(folderout);
    for j=1:sz(3)
        fname = sprintf('%s_%f/frame_%05d.fits', basename, time_alphas(i),j);
    
        fits_write(fname, cnoise(:,:,j), head);
    end
end

status_line('', laststr);




