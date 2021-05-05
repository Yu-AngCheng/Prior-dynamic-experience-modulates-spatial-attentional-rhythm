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

for sub = 1:size(width_posttest, 3)
    pretest_sub = squeeze(width_posttest(:,:,sub));
    C_IC = pretest_sub(:,1) == pretest_sub(:,2);
    time_interval = pretest_sub(:,3)*1/fs+shift;
    RT = pretest_sub(:,4);
    [M_RT,G]=grpstats(RT,[C_IC,time_interval],{'nanmean','gname'});G=str2double(G);
    ACC_post_odd(:,sub) = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
    M_RT=smoothdata(M_RT,'gaussian',3);
    C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
    Y = fft(detrend(C_IC_RT,1),N);
    P2 = abs(Y/N);
    P1 = P2(1:N/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    Amplitude_post_odd(:,sub) = P1;
end
Amplitude_mean_post_odd = mean(Amplitude_post_odd,2);
runs = 1000;
for shuffletime = 1:runs
    for sub = 1:size(width_posttest, 3)
        pretest_sub = squeeze(width_posttest(:,:,sub));
        C_IC = pretest_sub(:,1) == pretest_sub(:,2);
        time_interval = pretest_sub(:,3)*1/fs+shift;
        RT = pretest_sub(:,4);
        [M_RT,G]=grpstats(RT,[C_IC,time_interval],{'nanmean','gname'});G=str2double(G);
        M_RT=smoothdata(M_RT,'gaussian',3);
        C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
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
h_post_odd = Amplitude_mean_post_odd > criterion;
fprintf('Out of %d tests, %d is significant.\n',length(h_post_odd),sum(h_post_odd));
%%
sig_post_odd = NaN(size(h_post_odd));
sig_post_odd(h_post_odd) = max(Amplitude_mean_post_odd).*1.25;
figure(1)
subplot(3,2,5)
shadedErrorBar(f',Amplitude_mean_post_odd,nanstd(Amplitude_post_odd,[],2)/sqrt(subs));
hold on;
plot(f,sig_post_odd,'-r','LineWidth',2.5);
hold on;
plot(f,ones(size(f))*criterion,'--k','LineWidth',1);
xlabel('Frequency (Hz)');
ylabel('Amplitude (a.u.)')
title('post test (3Hz prime)')
subplot(3,2,6)
shadedErrorBar(t,mean(ACC_post_odd,2),nanstd(ACC_post_odd,[],2)/sqrt(subs));
xlabel('Time (s)')
ylabel('Accuracy')
title('post test (3Hz prime)')