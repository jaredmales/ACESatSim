function filter = aCEND_filters(bandno)

filter.bandno = bandno;

switch bandno
   case 1
      lambda1=400;
      lambda2=440;
      throughput=0.46;
   case 2
      lambda1=445;
      lambda2=490;
      throughput=0.58;
   case 3
      lambda1=495;
      lambda2=545;
      throughput=0.58;
   case 4
      lambda1=552;
      lambda2=608;
      throughput=0.56;
   case 5
      lambda1=615;
      lambda2=677;
      throughput=0.55;
end

filter.lambda = 0.5*(lambda1+lambda2)/1000;
filter.dlambda = (lambda2-lambda1)/1000;
filter.throughput = throughput;





