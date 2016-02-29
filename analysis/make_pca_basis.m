function s = make_pca_basis(s)
%%
s.linIm = zeros(size(s.im, 1)*size(s.im, 2), size(s.im, 3));
for i=1:size(s.im, 3)
    m = s.mim(:,:,i);
    s.linIm(:,i) = m(:);
end
s.cov = s.linIm'*s.linIm;
[s.covEvec, s.covEval] = eig(s.cov);
s.covEval = diag(s.covEval);
s.covEval(s.covEval <= 0) = 1e-9;
[s.covEval, ii] = sort(s.covEval, 'descend');
s.covEvec = s.covEvec(:, ii);

s.zlk = s.covEvec'*s.linIm';
for i=1:size(s.zlk, 1)
    s.zlk(i,:) = s.zlk(i,:)./sqrt(sum(s.zlk(i,:).*s.zlk(i,:)));
end
