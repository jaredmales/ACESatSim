function var_mean = testcnoisetau(ntrials, nsamps, oversamp, alpha)


meanvs = zeros(1,ntrials);

for i=1:ntrials
   cnoise = oneoverf_noise(nsamps, oversamp, alpha, 'dist', 'uniform');
   meanvs(i) = mean(cnoise);
end

var_mean = var(meanvs);

end





