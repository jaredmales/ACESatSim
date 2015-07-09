
alpha = 0:0.25:4.0;
alpha(3)=1.001;

nsamp = 1024;

oversamp = [4,8,16, 32, 64,128,256, 512, 1024];

calc_mean = zeros(length(alpha), length(oversamp));
emp_mean = calc_mean;


for i=1:length(alpha)
   for j=1:length(oversamp)
      fprintf(1, '%d/%d %d/%d\n', i,length(alpha), j,length(oversamp));
      
      [beta, calc_mean(i,j)] = char_oneoverf(nsamp, oversamp(j), alpha(i));

      emp_mean(i,j) = testcnoisetau(10000, nsamp,oversamp(j),alpha(i) );
   end
end

save('oneoverftest_004.mat','alpha', 'nsamp', 'oversamp', 'calc_mean', 'emp_mean');



