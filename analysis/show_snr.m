nPVals = 20;
pp = find(pData(1).nPVals(1,:) == nPVals);
figure;
plot(pData(1).binFactor(:,pp), pData(1).binSnr(:,pp), ...
    pData(2).binFactor(:,pp), pData(2).binSnr(:,pp), ...
    pData(3).binFactor(:,pp), pData(3).binSnr(:,pp), ...
    pData(4).binFactor(:,pp), pData(4).binSnr(:,pp), ...
    pData(5).binFactor(:,pp), pData(5).binSnr(:,pp), ...
    pData(6).binFactor(:,pp), pData(6).binSnr(:,pp), ...
    pData(7).binFactor(:,pp), pData(7).binSnr(:,pp));
legend('\alpha = 0.4', '\alpha = 0.6', '\alpha = 0.9', '\alpha = 1.1', '\alpha = 1.4', 'mix 1', 'mix 2');
xlabel('binning factor');
ylabel('corrected SNR');
title(['SNR vs. binning factor for ' num2str(nPVals) ' principal components']);

nBins = 20;
pp = find(pData(1).binFactor(:,1) == nBins);
figure;
plot(pData(1).nPVals(pp,:), pData(1).binSnr(pp,:), ...
    pData(2).nPVals(pp,:), pData(2).binSnr(pp,:), ...
    pData(3).nPVals(pp,:), pData(3).binSnr(pp,:), ...
    pData(4).nPVals(pp,:), pData(4).binSnr(pp,:), ...
    pData(5).nPVals(pp,:), pData(5).binSnr(pp,:), ...
    pData(6).nPVals(pp,:), pData(6).binSnr(pp,:), ...
    pData(7).nPVals(pp,:), pData(7).binSnr(pp,:));
legend('\alpha = 0.4', '\alpha = 0.6', '\alpha = 0.9', '\alpha = 1.1', '\alpha = 1.4', 'mix 1', 'mix 2');
xlabel('# of principal components');
ylabel('corrected SNR');
title(['SNR vs. # of principal components for ' num2str(nBins) ' binning']);

%%

noiseExp = {'\alpha = 0.4', '\alpha = 0.6', '\alpha = 0.9', '\alpha = 1.1', '\alpha = 1.4', 'mix [1 0 1 0 1]', 'mix [1 1 1 1 1]'};
for i=1:7
    figure;
    mesh(pData(i).binFactor, pData(i).nPVals, pData(i).binSnr);
    xlabel('binning factor');
    ylabel('# of principal components');
    zlabel('corrected SNR');
    title(noiseExp{i});
end
%%

noiseExp = {'\alpha = 0.4', '\alpha = 0.6', '\alpha = 0.9', '\alpha = 1.1', '\alpha = 1.4', 'mix [0.4 0 0.9 0 1.4]', 'mix [1 1 1 1 1]'};
for i=1:7
    figure;
    [C, h] = contour(pData(i).binFactor, pData(i).nPVals, pData(i).binSnr);
    clabel(C,h);
    xlabel('binning factor');
    ylabel('# of principal components');
    zlabel('corrected SNR');
    title(['snr contours, case b, ' noiseExp{i}]);
end
