clear
for testCase = ['a','b','c']
    disp(testCase);
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

    phaseStrength = [1 0 1 0 1];

    maxPVals = 100;
    maxBin = 100;

    pData = repmat(struct('phaseStrength', 0, ...
        'binFactor', zeros(maxBin, maxPVals), ...
        'nPVals', zeros(maxBin, maxPVals), ...
        'binSnr', zeros(maxBin, maxPVals), ...
        'rawSnr', zeros(maxBin, maxPVals)), 5, 1);
    for p=1:7
        if p < 6
            phaseStrength = zeros(1,5);
            phaseStrength(p) = 1;
        elseif p == 6
            phaseStrength = [1 0 1 0 1];
        else
            phaseStrength = [1 1 1 1 1];
        end
        normPhaseStrength = phaseStrength/sum(phaseStrength);
        phaseError = zeros(sz);
        for i=1:length(phaseStrength)
            phaseError = phaseError + phaseData(:,:,:,i)*normPhaseStrength(i);
        end
        calibPhaseError = zeros(sz);
        for i=1:length(phaseStrength)
            calibPhaseError = calibPhaseError + calibPhaseData(:,:,:,i)*normPhaseStrength(i);
        end

        rng('default');
        rng(2);
        [cs noPSource] = simulate_observations(1, 2, 'test1', false, calibPhaseError, calibOffset);
        rng('default');
        rng(1);
        [s noPSource] = simulate_observations(1, 2, 'test1', false, phaseError);
        rng('default');
        rng(1);
        [ps pSource] = simulate_observations(1, 2, 'planet', true, phaseError);

        pData(p).phaseStrength = phaseStrength;

        cs = make_pca_basis(cs);

        bCount = 1;
        for binFactor = 1:maxBin
            pCount = 1;
            for nPVals = 1:maxPVals
                s = pca_reconstruct(s, cs, binFactor, nPVals);
                ps = pca_reconstruct(ps, cs, binFactor, nPVals);

                ps = measure_snr(ps, s);
                pData(p).binFactor(bCount, pCount) = binFactor;
                pData(p).nPVals(bCount, pCount) = nPVals;
                pData(p).binSnr(bCount, pCount) = ps.psfPhot(9).snr(36);
                pData(p).rawSnr(bCount, pCount) = ps.psfPhot(9).rawSnr(36);
                pCount = pCount + 1;
            end
            bCount = bCount + 1;
        end
    end
    save(['snrData_case' testCase '.mat'], 'pData');
end