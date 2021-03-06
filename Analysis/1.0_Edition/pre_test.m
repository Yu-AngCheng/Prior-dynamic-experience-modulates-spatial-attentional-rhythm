clear
load pretest.mat


fs = 30;
N = 128;
subs = 25;
shift = 0.2;
f = (0:N/2)*fs/N;
t = ((1:24)/fs)'+shift;
alpha = 0.05;
gaussianwindow = 3;

for sub = 1:size(width_pretest, 3)
    pretest_sub = squeeze(width_pretest(:,:,sub));
    xx = pretest_sub(:,4) == 0;pretest_sub(xx,4) = 2;
    
    idx1 = ~isnan(pretest_sub(:,4)) & (pretest_sub(:,4) == pretest_sub(:,2));
    idx2 = ~isnan(pretest_sub(:,4)) & (pretest_sub(:,4) ~= pretest_sub(:,2));
    width_pretest(idx1,4,sub) = 1; width_pretest(idx2,4,sub) = 0;
end

for sub = 1:size(width_pretest, 3)
    pretest_sub = squeeze(width_pretest(:,:,sub));

    C_IC = pretest_sub(:,1) == pretest_sub(:,2);
    time_interval = pretest_sub(:,3)*1/fs+shift;
    RT = pretest_sub(:,4);
    
    [M_RT,G]=grpstats(RT,[C_IC,time_interval],{'nanmean','gname'});G=str2double(G);
    ACC_pretest(:,sub) = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
    C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
    C_IC_RT = smoothdata(C_IC_RT,'gaussian',gaussianwindow);
    
    Y = fft(detrend(C_IC_RT,2),N);
    P2 = abs(Y/N);
    P1 = P2(1:N/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    Amplitude_pretest(:,sub) = P1;
    
end
Amplitude_mean_pretest = mean(Amplitude_pretest,2);


runs = 1000;
for shuffletime = 1:runs
    for sub = 1:size(width_pretest, 3)
        pretest_sub = squeeze(width_pretest(:,:,sub));
        
        C_IC = pretest_sub(:,1) == pretest_sub(:,2);
        time_interval = pretest_sub(:,3)*1/fs+shift;
        RT = pretest_sub(:,4);
        
        [M_RT,G]=grpstats(RT,[C_IC,time_interval],{'nanmean','gname'});G=str2double(G);
        C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
        C_IC_RT = smoothdata(C_IC_RT,'gaussian',gaussianwindow);
        C_IC_RT = C_IC_RT(randperm(length(C_IC_RT)));
        
        Y = fft(detrend(C_IC_RT,2),N);
        P2 = abs(Y/N);
        P1 = P2(1:N/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        Amplitude_shuffle(:,sub,shuffletime) = P1;
        
    end
end
Amplitude_shuffle_mean = squeeze(mean(Amplitude_shuffle,2));
Amplitude_shuffle_mean = sort(Amplitude_shuffle_mean,2);


criterion = max(Amplitude_shuffle_mean(:,round(runs*(1-alpha))));
h_pretest = Amplitude_mean_pretest > criterion;
fprintf('Out of %d tests, %d is significant.\n',length(h_pretest),sum(h_pretest));
%%
sig_pretest = NaN(size(h_pretest));
sig_pretest(h_pretest) = max(Amplitude_mean_pretest).*1.35;
figure(1)
subplot(3,2,1)
shadedErrorBar(f',Amplitude_mean_pretest,nanstd(Amplitude_pretest,[],2)/sqrt(subs));
hold on;
plot(f,sig_pretest,'r-','LineWidth',2.5);
hold on;
% plot(f,ones(size(f))*criterion,'--k','LineWidth',0.5);
xlabel('Frequency (Hz)');
ylabel('Amplitude (a.u.)')
title('baseline')
subplot(3,2,2)
shadedErrorBar(t,-mean(ACC_pretest,2),nanstd(ACC_pretest,[],2)/sqrt(subs));
xlim([0.2,1.05])
xlabel('Time (s)')
ylabel('Accuracy (C-IC)')
title('baseline')
%%
save Amplitude.mat Amplitude_pretest f