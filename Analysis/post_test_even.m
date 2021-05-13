%% 5Hz
clear
load post_test_even.mat

fs = 30;
N = 128;
subs = 14;
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
    ACC_post_even(:,sub) = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
    C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
    C_IC_RT = smoothdata(C_IC_RT,'gaussian',gaussianwindow);
    Y = fft(detrend(C_IC_RT,1),N);
    P2 = abs(Y/N);
    P1 = P2(1:N/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    Amplitude_post_even(:,sub) = P1;
end
Amplitude_mean_post_even = mean(Amplitude_post_even,2);
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
        Y = fft(detrend(C_IC_RT,1),N);
        P2 = abs(Y/N);
        P1 = P2(1:N/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        Amplitude_shuffle(:,sub,shuffletime) = P1;
    end
end
Amplitude_shuffle_mean = squeeze(mean(Amplitude_shuffle,2));
Amplitude_shuffle_mean = sort(Amplitude_shuffle_mean,2);
criterion = max(Amplitude_shuffle_mean(:,round(runs*(1-alpha))));
h_post_even = Amplitude_mean_post_even > criterion;
fprintf('Out of %d tests, %d is significant.\n',length(h_post_even),sum(h_post_even));
%%
sig_post_even = NaN(size(h_post_even));
sig_post_even(h_post_even) = max(Amplitude_mean_post_even).*1.35;
figure(1)
subplot(3,2,3)
shadedErrorBar(f',Amplitude_mean_post_even,nanstd(Amplitude_post_even,[],2)/sqrt(subs));
hold on;
plot(f,sig_post_even,'r-','LineWidth',2.5);
hold on;
% plot(f,ones(size(f))*criterion,'--k','LineWidth',0.5);
xlabel('Frequency (Hz)');
ylabel('Amplitude (a.u.)')
title('5Hz prime')
subplot(3,2,4)
shadedErrorBar(t,mean(ACC_post_even,2),nanstd(ACC_post_even,[],2)/sqrt(subs));
xlim([0.2,1.05])
xlabel('Time (s)')
ylabel('Accuracy (C-IC)')
title('5Hz prime')
