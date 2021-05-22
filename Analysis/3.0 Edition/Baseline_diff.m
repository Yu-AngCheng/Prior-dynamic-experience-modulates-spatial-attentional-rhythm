%% based on jackknife
clear
idx_odd = [1,2,5,8,11,13,16,19,21,23,25]; % odd
idx_even = [3,4,6,7,9,10,12,14,15,17,18,20,22,24]; % even
load PSD.mat
fs = 30;
N = 64;
shift = 0.2;
f = (0:N/2)*fs/N;
t = ((1:24)/fs)'+shift;
alpha = 0.05;
gaussianwindow = 3;
detrendnumber = 3;

figure(3)
subplot(1,2,1);
PSD_even_diff = PSD_post_even - PSD_pretest_even;
shadedErrorBar(f',mean(PSD_even_diff,2),nanstd(PSD_even_diff,[],2)/sqrt(size(PSD_even_diff,2)));
n_perms = 10000;
[datobs, datrnd] = cluster_test_helper(PSD_even_diff,n_perms); % randomize data at each time-point
[h, p, clusterinfo] = cluster_test(datobs,datrnd,1,0.05,0.05,'sum');
fprintf('Out of %d tests, %d is significant. \n',length(h),sum(h));
h(h==0)=NaN;

xlabel('Frequency (Hz)');
ylabel('PSD (a.u.)')
title('5Hz prime group')
subplot(1,2,2);
PSD_odd_diff = PSD_post_odd - PSD_pretest_odd;
shadedErrorBar(f',mean(PSD_odd_diff,2),nanstd(PSD_odd_diff,[],2)/sqrt(size(PSD_odd_diff,2)));
n_perms = 10000;
[datobs, datrnd] = cluster_test_helper(PSD_even_diff,n_perms); % randomize data at each time-point
[h, p, clusterinfo] = cluster_test(datobs,datrnd,1,0.05,0.05,'sum');
fprintf('Out of %d tests, %d is significant. \n',length(h),sum(h));
h(h==0)=NaN;

xlabel('Frequency (Hz)');
ylabel('PSD (a.u.)')
title('3Hz prime group')
