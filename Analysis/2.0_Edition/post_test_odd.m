%% 3 Hz
clear
load post_test_odd.mat

fs = 30;
N = 64;
subs = 11;
shift = 0.2;
f = (0:N/2)*fs/N;
t = ((1:24)/fs)'+shift;
alpha = 0.05;
gaussianwindow = 3;


for sub = 1:size(width_posttest, 3)
    posttest_sub = squeeze(width_posttest(:,:,sub));
    idx1 = ~isnan(posttest_sub(:,4)) & (posttest_sub(:,4) == posttest_sub(:,2));
    idx2 = ~isnan(posttest_sub(:,4)) & (posttest_sub(:,4) ~= posttest_sub(:,2));
    posttest_sub(idx1,4) = 1; posttest_sub(idx2,4) = 0;
    C_IC = posttest_sub(:,1) == posttest_sub(:,2);
    time_interval = posttest_sub(:,3)*1/fs+shift;
    RT = posttest_sub(:,4);
    [M_RT,G]=grpstats(RT,[C_IC,time_interval],{'nanmean','gname'});G=str2double(G);
    ACC_post_odd(:,sub) = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
    C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
    C_IC_RT = smoothdata(C_IC_RT,'gaussian',gaussianwindow);
    PSD_post_odd(:,sub) = periodogram(detrend(C_IC_RT,1),[],N,fs);
end
PSD_mean_post_odd = mean(PSD_post_odd,2);
runs = 1000;
for shuffletime = 1:runs
    for sub = 1:size(width_posttest, 3)
        posttest_sub = squeeze(width_posttest(:,:,sub));
        C_IC = posttest_sub(:,1) == posttest_sub(:,2);
        time_interval = posttest_sub(:,3)*1/fs+shift;
        RT = posttest_sub(:,4);
        [M_RT,G]=grpstats(RT,[C_IC,time_interval],{'nanmean','gname'});G=str2double(G);
        C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
        C_IC_RT = smoothdata(C_IC_RT,'gaussian',4);
        C_IC_RT = C_IC_RT(randperm(length(C_IC_RT)));
        PSD_shuffle(:,sub,shuffletime) = periodogram(detrend(C_IC_RT,1),[],N,fs);
    end
end
PSD_shuffle_mean = squeeze(mean(PSD_shuffle,2));
PSD_shuffle_mean = sort(PSD_shuffle_mean,2);
criterion = max(PSD_shuffle_mean(:,round(runs*(1-alpha))));
h_post_odd = PSD_mean_post_odd > criterion;
fprintf('Out of %d tests, %d is significant.\n',length(h_post_odd),sum(h_post_odd));
%%
sig_post_odd = NaN(size(h_post_odd));
sig_post_odd(h_post_odd) = max(PSD_mean_post_odd).*1.5;
figure(1)
subplot(3,2,5)
shadedErrorBar(f',PSD_mean_post_odd,nanstd(PSD_post_odd,[],2)/sqrt(subs));
hold on;
plot(f,sig_post_odd,'r-','LineWidth',2.5);
hold on;
% plot(f,ones(size(f))*criterion,'--k','LineWidth',0.5);
xlabel('Frequency (Hz)');
ylabel('PSD (a.u.)')
title('3Hz prime')
subplot(3,2,6)
shadedErrorBar(t,mean(ACC_post_odd,2),nanstd(ACC_post_odd,[],2)/sqrt(subs));
xlim([0.2,1.05])
xlabel('Time (s)')
ylabel('Accuracy (C-IC)')
title('3Hz prime')