clear
% case a: calibration data = same noise realization as science data at same time
% case b: calibration data = same noise realization as science data at a later time
% case c: calibration data = different noise realization from science data
testCase = 'b'; 
phaseVal = [0.4 0.6 0.9 1.1 1.4]; % various noise slopes (= -log(noise slope))
phaseStrength = [1 0 1 0 1]; % use this to set the strength of various noise slopes
phaseString = '';
for i=1:length(phaseVal)
    phaseString = [phaseString sprintf('%0.1f', phaseVal(i)*phaseStrength(i))];
    if i<length(phaseVal)
        phaseString = [phaseString '-'];
    end
end
%%
if ~exist('s', 'var') 
    if exist('simData.mat', 'file')
        load simData.mat
    else
%%
        noiseFolder = 'noise_data/';
        sz = size(fits_read([noiseFolder 'oneoverf_128_52596_r0_0.600000.fits']));
        phaseData = zeros([sz, 5]);
        phaseData(:,:,:,1) = fits_read([noiseFolder 'oneoverf_128_52596_r0_0.400000.fits']);
        phaseData(:,:,:,2) = fits_read([noiseFolder 'oneoverf_128_52596_r0_0.600000.fits']);
        phaseData(:,:,:,3) = fits_read([noiseFolder 'oneoverf_128_52596_r0_0.900000.fits']);
        phaseData(:,:,:,4) = fits_read([noiseFolder 'oneoverf_128_52596_r0_1.100000.fits']);
        phaseData(:,:,:,5) = fits_read([noiseFolder 'oneoverf_128_52596_r0_1.400000.fits']);
        
        switch testCase
            case 'a'
                calibNoiseFolder = 'noise_data/';
                calibOffset = 0;
                
            case 'b'
                calibNoiseFolder = 'noise_data/';
                calibOffset = 200;
                
            case 'c'
                calibNoiseFolder = 'noise_data2/';
                calibOffset = 200;
                
            otherwise
                error('bad test case');
        end
            
        calibPhaseData = zeros([sz, 5]);
        calibPhaseData(:,:,:,1) = fits_read([calibNoiseFolder 'oneoverf_128_52596_r0_0.400000.fits']);
        calibPhaseData(:,:,:,2) = fits_read([calibNoiseFolder 'oneoverf_128_52596_r0_0.600000.fits']);
        calibPhaseData(:,:,:,3) = fits_read([calibNoiseFolder 'oneoverf_128_52596_r0_0.900000.fits']);
        calibPhaseData(:,:,:,4) = fits_read([calibNoiseFolder 'oneoverf_128_52596_r0_1.100000.fits']);
        calibPhaseData(:,:,:,5) = fits_read([calibNoiseFolder 'oneoverf_128_52596_r0_1.400000.fits']);

        % normalize by sum of the components, but multiply by root n to
        % make up for averaging.  
        normPhaseStrength = phaseStrength/sqrt(sum(phaseStrength));
        phaseError = zeros(sz);
        for i=1:length(phaseStrength)
            phaseError = phaseError + phaseData(:,:,:,i)*normPhaseStrength(i);
        end
        calibPhaseError = zeros(sz);
        for i=1:length(phaseStrength)
            calibPhaseError = calibPhaseError + calibPhaseData(:,:,:,i)*normPhaseStrength(i);
        end

%%
        rng('default');
        rng(2);
        [cs noPSource] = simulate_observations(1, 2, 'test1', false, calibPhaseError, calibOffset);
        rng('default');
        rng(1);
        [s noPSource] = simulate_observations(1, 2, 'test1', false, phaseError);
        rng('default');
        rng(1);
        [ps pSource] = simulate_observations(1, 2, 'planet', true, phaseError);
    end
end
%%
cs = make_pca_basis(cs);
s = make_pca_basis(s);
ps = make_pca_basis(ps);
%%
binFactor = 40;
nPVals = 20;
offset = 1;

s = pca_reconstruct(s, cs, binFactor, nPVals, offset);
ps = pca_reconstruct(ps, cs, binFactor, nPVals, offset);
figure;
subplot(2, 4, 1);
imagesc(s.mim(:,:,ceil(binFactor/2)));
title('no planet: single image');
axis equal;
axis tight;
axis xy;

subplot(2, 4, 2);
imagesc(s.testIm);
% colorbar;
c = caxis;
title('no planet: binned image');
axis equal;
axis tight;
axis xy;

subplot(2, 4, 3);
imagesc(s.rstIm);
% colorbar;
caxis(c);
title('no planet: reconstructed image');
axis equal;
axis tight;
axis xy;

subplot(2, 4, 4);
imagesc(s.residIm);
% colorbar;
title('no planet: corrected image');
axis equal;
axis tight;
axis xy;


subplot(2, 4, 4+1);
imagesc(ps.mim(:,:,ceil(binFactor/2)));
title('planet: single image');
axis equal;
axis tight;
axis xy;

subplot(2, 4, 4+2);
imagesc(ps.testIm);
% colorbar;
c = caxis;
title('planet: binned image');
axis equal;
axis tight;
axis xy;

subplot(2, 4, 4+3);
imagesc(ps.rstIm);
% colorbar;
caxis(c);
title('planet: reconstructed image');
axis equal;
axis tight;
axis xy;

subplot(2, 4, 4+4);
imagesc(ps.residIm);
% colorbar;
title('planet: corrected image');
c = caxis();
axis equal;
axis tight;
axis xy;

subplot(2,4,4);
caxis(c);

psf = fits_read('planet/G2/band2/psf.fits');

ps = measure_snr(ps, s);

figure;
subplot(1,2,1);
imagesc(ps.residIm);
axis xy;
axis equal;
axis tight;
title(['residual image with planet, bin ' num2str(binFactor) ', PCA # ' num2str(nPVals) ', alpha = ' phaseString, ', case ' testCase]);
subplot(1,2,2);
imagesc(ps.medResidIm);
axis xy;
axis equal;
axis tight;
title(['median residual image with planet, PCA # ' num2str(nPVals) ', alpha = ' phaseString, ', case ' testCase]);
% hold on;
% cth = 0:0.1:2*pi;
% for i=1:ps.nPhotElements
%     plot(ps.yy(i) + ps.resWidth*sin(cth), ps.xx(i) + ps.resWidth*cos(cth), 'r');
% end
% hold off;

planetX = 55;
planetY = 65;
psc = conv2(ps.residIm, psf, 'same');
figure;
mesh(psc);
hold on;
plot3(planetX, planetY, psc(planetY, planetX), 'r*');
hold off;
title(['residual image with planet, bin ' num2str(binFactor) ', PCA # ' num2str(nPVals) ', alpha = ' phaseString, ', case ' testCase]);
%%
ps = measure_snr(ps, s, 'psf');

% figure;
% ppx = 1:length(ps.pFlux);
% plot(ppx, ps.pFlux, ppx, ps.noPFlux);
% title([phaseString ' case ' testCase ' snr = ' num2str(ps.snr)]);
% title(['residual image with planet, snr = ' num2str(ps.snr) ', bin ' num2str(binFactor) ', PCA # ' num2str(nPVals) ', alpha = ' phaseString, ', case ' testCase]);


figure;
subplot(1,2,1);
imagesc(ps.medResidIm);
axis xy;
axis equal;
axis tight;
hold on;
resElem = ps.psfFwhm;
cth = 0:0.1:2*pi;
for d=1:length(ps.psfPhot)
    for a = 1:length(ps.psfPhot(d).snr)
        if ps.psfPhot(d).snr(a) > 3 && ps.psfPhot(d).snr(a)  < 5
            plot(ps.psfPhot(d).y(a)+resElem*cos(cth), ...
                ps.psfPhot(d).x(a)+resElem*sin(cth), 'g');
        end
    end
end
for d=1:length(ps.psfPhot)
    for a = 1:length(ps.psfPhot(d).snr)
        if ps.psfPhot(d).snr(a) >= 5
            plot(ps.psfPhot(d).y(a)+resElem*cos(cth), ...
                ps.psfPhot(d).x(a)+resElem*sin(cth), 'r', 'LineWidth', 2);
        end
    end
end
plot(planetX, planetY, 'm*');
hold off;
title(['median residual image with planet, PCA # ' num2str(nPVals) ', alpha = ' phaseString, ', case ' testCase]);
colorbar
subplot(1,2,2);
snrImage = zeros(size(ps.medResidIm));
for d=1:length(ps.psfPhot)
    for a = 1:length(ps.psfPhot(d).snr)
        snrImage(ps.psfPhot(d).x(a), ps.psfPhot(d).y(a)) ...
            = ps.psfPhot(d).snr(a);
    end
end
imagesc(snrImage);
hold on;
plot(planetX, planetY, 'r*');
hold off;
axis xy;
axis equal;
axis tight;
title(['reduced snr image with planet, bin ' num2str(binFactor) ', PCA # ' num2str(nPVals) ', alpha = ' phaseString, ', case ' testCase]);
colorbar;

return;

%% show calibration and science PCA bases
rs = [min(s.zlk(i,:)) max(s.zlk(i,:))];
rc = [min(cs.zlk(i,:)) max(cs.zlk(i,:))];
figure;
for i=1:size(s.im, 3)
    subplot(1,2,1);
    imagesc(reshape(ps.zlk(i,:),128,128), rc);
    title(['calibration basis ' num2str(i)]);
    subplot(1,2,2);
    imagesc(reshape(s.zlk(i,:),128,128), rs);
    title(['no-planet science basis ' num2str(i)]);
    drawnow();
    pause();
end
    
%%
dt =1200;
[git_sha1 git_mod] = git_status('./acesatsim');
head = cell(5,3);
head{1,1} = 'BAND';
head{1,2} = 1;
head{1,3} = 'Filter band number';
head{2,1} = 'DATEOBS';
head{2,2} = 1;
head{2,3} = 'observation date in days';
head{3,1} = 'EXPTIME';
head{3,2} = dt;
head{3,3} = 'Exposure time in seconds';
head{4,1} = 'GITSHA1';
head{4,2} = git_sha1;
head{4,3} = 'Git commit sha1';
head{5,1} = 'GITMOD';
head{5,2} = git_mod;
head{5,3} = 'Git repo modified flag';

folderout = '/Users/steve/work/acend/acesatsim/acesatsim/test1';
mkdir(folderout);
filename = sprintf('%s/img_%s_%s_bin%d_nComp%d.fits', folderout, phaseString, testCase, binFactor, nPVals);
fits_write(filename, ps.residIm, head);

filename = sprintf('%s/p_%s_%s_bin%d_nComp%d.fits', folderout, phaseString, testCase, binFactor, nPVals);
fits_write(filename, ps.im, head);

filename = sprintf('%s/np_%s_%s_bin%d_nComp%d.fits', folderout, phaseString, testCase, binFactor, nPVals);
fits_write(filename, s.im, head);

filename = sprintf('%s/c_%s_%s_bin%d_nComp%d.fits', folderout, phaseString, testCase, binFactor, nPVals);
fits_write(filename, cs.im, head);


