function s = pca_reconstruct(s, sBasis, binFactor, basisLength, offset)
% function s = pac_reconstruct(s, sBasis, binFactor, basisLength, offset)
% reconstruct images in s using basis in sBasis

if nargin < 5
    offset = 1;
end
% build a reconstructed binned image
s.testIm = mean(s.mim(:,:,offset:offset+binFactor-1), 3);
s.rstIm = reshape((sBasis.zlk(1:basisLength-1,:)*s.testIm(:))'*sBasis.zlk(1:basisLength-1,:), 128, 128);
s.residIm = s.testIm-s.rstIm;

% reconstruct each frame and take median
rstIm = zeros(size(s.mim));
for i=1:size(s.mim, 3)
    mim = s.mim(:,:,i);
    rstIm(:,:,i) = mim - reshape((sBasis.zlk(1:basisLength-1,:)*mim(:))'*sBasis.zlk(1:basisLength-1,:), 128, 128);
end
s.medResidIm = median(rstIm, 3);