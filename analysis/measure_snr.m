function ps = measure_snr(ps, s, type)
if nargin < 3
    type = 'psf';
end

switch type
    case 'phot'
        ps = measure_snr_phot(ps, s);
    case 'psf'
        ps = measure_snr_psf(ps, s);
    otherwise
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ps = measure_snr_phot(ps, s)        
planetX = 55;
planetY = 66;
planetAngle = atan2(-(planetY - 64.5), planetX - 64.5);
planetD = norm([planetX - 64.5 planetY - 64.5]);
ps.resWidth = 2;
resSize = 2*ps.resWidth + 1;
photSize = 1;
ps.nResElements = fix(2*pi*planetD/resSize);
ps.nPhotElements = fix(2*pi*planetD/photSize);
resAngle = 2*pi/ps.nPhotElements;

ps.planetFlux = sum(sum(ps.residIm(planetY-ps.resWidth:planetY+ps.resWidth, planetX-ps.resWidth:planetX+ps.resWidth)));

ps.th = zeros(ps.nPhotElements, 1);
ps.xx = zeros(ps.nPhotElements, 1);
ps.yy = zeros(ps.nPhotElements, 1);
ps.noPFlux = zeros(ps.nPhotElements, 1);
ps.pFlux = zeros(ps.nPhotElements, 1);
for i=1:ps.nPhotElements
    ps.th(i) = planetAngle + (i-1)*resAngle;
    ps.xx(i) = round(64.5 + planetD*cos(ps.th(i)));
    ps.yy(i) = round(64.5 + planetD*sin(ps.th(i)));
    ps.noPFlux(i) = sum(sum(s.residIm(round(ps.yy(i)-ps.resWidth:ps.yy(i)+ps.resWidth), round(ps.xx(i)-ps.resWidth:ps.xx(i)+ps.resWidth))));
    ps.pFlux(i) = sum(sum(ps.residIm(round(ps.yy(i)-ps.resWidth:ps.yy(i)+ps.resWidth), round(ps.xx(i)-ps.resWidth:ps.xx(i)+ps.resWidth))));
end

ps.snr = (max(ps.pFlux) - mean(ps.noPFlux))/(std(ps.noPFlux)*sqrt(1+1/ps.nResElements));
ps.rawSnr = max(ps.pFlux)/std(ps.noPFlux);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ps = measure_snr_psf(ps, s)        
planetX = 55;
planetY = 66;
planetAngle = atan2(-(planetY - 64.5), planetX - 64.5);
planetD = norm([planetX - 64.5 planetY - 64.5]);
ps.resWidth = ps.psfFwhm;
resSize = 2*ps.resWidth + 1;
ps.nResElements = fix(2*pi*planetD/resSize);
ps.nPhotElements = fix(2*pi*planetD);
resAngle = 2*pi/ps.nPhotElements;

ps.psfPhot = measure_psf_phot(ps);
ps.psfPhotNoPlanet = measure_psf_phot(s);
for d=1:length(ps.psfPhot)
    ps.psfPhot(d).rawSnr = ps.psfPhot(d).flux./ps.psfPhotNoPlanet(d).photResSizeMaxStd;
%     ps.psfPhot(d).rawSnr = ps.psfPhot(d).flux./ps.psfPhotNoPlanet(d).std;
%     ps.psfPhot(d).nResElements = length(ps.psfPhot(d).flux)/(2*ps.psfFwhm);
%     if ps.psfPhot(d).nResElements < 1
%         ps.psfPhot(d).nResElements = 1;
%     end
    ps.psfPhot(d).snr = ps.psfPhot(d).rawSnr/sqrt(1+1/(ps.psfPhot(d).nResElements-1));
    [ps.psfPhot(d).maxSnr, ps.psfPhot(d).maxSnrIdx] = max(ps.psfPhot(d).snr);
    ps.psfPhot(d).maxSnrLoc = [ps.psfPhot(d).x(ps.psfPhot(d).maxSnrIdx), ...
        ps.psfPhot(d).y(ps.psfPhot(d).maxSnrIdx)];
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function phot = measure_psf_phot(ps) 
psf = ps.psf/max(ps.psf(:));
convIm = conv2(ps.medResidIm, psf, 'same');

[X, Y] = meshgrid(1:size(convIm, 2), 1:size(convIm, 1));
cX = size(convIm, 2)/2;
cY = size(convIm, 1)/2;

pixDist = sqrt((X - cX).^2 + (Y - cY).^2);
pixAngle = atan2(Y-cY, -(X-cX));

resSize = 4;

for d=1:cX
    pp = find(pixDist > d-0.5 & pixDist <= d+0.5);
    phot(d).flux = convIm(pp);
    phot(d).y = X(pp);
    phot(d).x = Y(pp);
    [dd sIdx] = sort(pixAngle(pp));
    phot(d).dist = d;
    phot(d).flux = phot(d).flux(sIdx);
    phot(d).x = phot(d).x(sIdx);
    phot(d).y = phot(d).y(sIdx);
    phot(d).mean = mean(phot(d).flux);
    phot(d).median = median(phot(d).flux);
    phot(d).std = std(phot(d).flux);
    phot(d).max = max(phot(d).flux);
    phot(d).min = min(phot(d).flux);
    
    phot(d).nResElements = fix(length(phot(d).flux));
    for r = 1:resSize
        dr = r:resSize:length(phot(d).flux);
        phot(d).photResSize(r).flux = phot(d).flux(dr);
        phot(d).photResSize(r).x = phot(d).x(dr);
        phot(d).photResSize(r).y = phot(d).y(dr);
        phot(d).photResSize(r).mean = mean(phot(d).photResSize(r).flux);
        phot(d).photResSize(r).median = median(phot(d).photResSize(r).flux);
        phot(d).photResSize(r).std = std(phot(d).photResSize(r).flux);
        phot(d).photResSize(r).max = max(phot(d).photResSize(r).flux);
        phot(d).photResSize(r).min = min(phot(d).photResSize(r).flux);
    end
    phot(d).photResSizeMaxStd = max([phot(d).photResSize.std]);
    phot(d).photResSizeMinStd = min([phot(d).photResSize.std]);
end
