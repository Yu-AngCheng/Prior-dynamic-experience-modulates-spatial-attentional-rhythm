clear
load PSD.mat
fs = 30;
N = 64;
shift = 0.2;
f = (0:N/2)*fs/N;
t = ((1:24)/fs)'+shift;
alpha = 0.05;
gaussianwindow = 3;
detrendnumber = 1;
k = 4;

figure(30)
subplot(1,2,1);
PSD_even_diff = log(PSD_post_even) - log(PSD_pretest_even);
n_perms = 10000;
[datobs, datrnd] = cluster_test_helper(PSD_even_diff,n_perms,'t'); % randomize data at each time-point
[h, p, clusterinfo] = cluster_test(datobs,datrnd,1,0.05,0.05,'size');
fprintf('Out of %d tests, %d is significant. \n',length(h),sum(h));

shadedErrorBar(f',mean(PSD_even_diff,2),nanstd(PSD_even_diff,[],2)/sqrt(size(PSD_even_diff,2)));
sig = NaN(size(h)); sig(h) = max(mean(PSD_even_diff,2)).*2;
hold on; plot(f,sig,'r-','LineWidth',2.5);
xlabel('Frequency (Hz)'); ylabel('PSD (post - pre) (a.u.)'); title('5Hz prime group')
%%
subplot(1,2,2);
PSD_odd_diff = log(PSD_post_odd) - log(PSD_pretest_odd);
n_perms = 10000;
[datobs, datrnd] = cluster_test_helper(PSD_odd_diff,n_perms); % randomize data at each time-point
[h, p, clusterinfo] = cluster_test(datobs,datrnd,1,0.05,0.05,'size');
fprintf('Out of %d tests, %d is significant. \n',length(h),sum(h));

shadedErrorBar(f',mean(PSD_odd_diff,2),nanstd(PSD_odd_diff,[],2)/sqrt(size(PSD_odd_diff,2)));
sig = NaN(size(h)); sig(h) = max(mean(PSD_odd_diff,2)).*2;
hold on; plot(f,sig,'r-','LineWidth',2.5);
xlabel('Frequency (Hz)');ylabel('PSD (post - pre)(a.u.)'); title('3Hz prime group')
