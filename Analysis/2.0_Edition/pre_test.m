clear
load pretest.mat

fs = 30;
N = 64;
subs = 25;
shift = 0.2;
f = (0:N/2)*fs/N;
t = ((1:24)/fs)'+shift;
alpha = 0.05;
gaussianwindow = 3;

for sub = 1:size(width_pretest, 3)
    pretest_sub = squeeze(width_pretest(:,:,sub));
    idx1 = ~isnan(pretest_sub(:,4)) & (pretest_sub(:,4) == pretest_sub(:,2));
    idx2 = ~isnan(pretest_sub(:,4)) & (pretest_sub(:,4) ~= pretest_sub(:,2));
    pretest_sub(idx1,4) = 1; pretest_sub(idx2,4) = 0;
    C_IC = pretest_sub(:,1) == pretest_sub(:,2);
    time_interval = pretest_sub(:,3)*1/fs+shift;
    RT = pretest_sub(:,4);
    [M_RT,G]=grpstats(RT,[C_IC,time_interval],{'nanmean','gname'});G=str2double(G);
    ACC_pretest(:,sub) = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
    C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
    C_IC_RT = smoothdata(C_IC_RT,'gaussian',gaussianwindow);
    PSD_pretest(:,sub) = periodogram(detrend(C_IC_RT,1),[],N,fs);
end
PSD_mean_pretest = mean(PSD_pretest,2);
runs = 1000;
for shuffletime = 1:runs
    for sub = 1:size(width_pretest, 3)
        pretest_sub = squeeze(width_pretest(:,:,sub));
        C_IC = pretest_sub(:,1) == pretest_sub(:,2);
        time_interval = pretest_sub(:,3)*1/fs+shift;
        RT = pretest_sub(:,4);
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
h_pretest = PSD_mean_pretest > criterion;
fprintf('Out of %d tests, %d is significant.\n',length(h_pretest),sum(h_pretest));
%%
sig_pretest = NaN(size(h_pretest));
sig_pretest(h_pretest) = max(PSD_mean_pretest).*1.5;
figure(1)
subplot(3,2,1)
shadedErrorBar(f',PSD_mean_pretest,nanstd(PSD_pretest,[],2)/sqrt(subs));
hold on;
plot(f,sig_pretest,'r-','LineWidth',2.5);
hold on;
% plot(f,ones(size(f))*criterion,'--k','LineWidth',0.5);
xlabel('Frequency (Hz)');
ylabel('PSD (a.u.)')
title('baseline')
subplot(3,2,2)
shadedErrorBar(t,mean(ACC_pretest,2),nanstd(ACC_pretest,[],2)/sqrt(subs));
xlim([0.2,1.05])
xlabel('Time (s)')
ylabel('Accuracy (C-IC)')
title('baseline')