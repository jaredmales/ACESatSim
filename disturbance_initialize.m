function disturbances = disturbance_initialize(ts)

mas = pi/180/60/60/1000;


%For proposal used 0.5
%0.25 is for show
rms = 0.0

%Calculate amplitude of time series so that it has correct 2-axis rms 
amp = rms*sqrt(12)/sqrt(2)*mas

for n = 1:length(ts)
    disturbances(n).tilt = amp*(rand - 0.5); % in units of radians
    disturbances(n).tip = amp*(rand - 0.5); % in units of radians
end
