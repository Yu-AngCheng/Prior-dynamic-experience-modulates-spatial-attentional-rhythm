clear
load pretest.mat
idx_even = [3,4,6,7,9,10,12,14,15,17,18,20,22,24]; % even
width_pretest = width_pretest(:,:,idx_even);

fs = 30;
N = 64;
subs = 14;
shift = 0.2;
f = (0:N/2)*fs/N;
t = ((1:24)/fs)'+shift;
alpha = 0.05;
gaussianwindow = 3;
detrendnumber = 1;

for sub = 1:size(width_pretest, 3)
    pretest_even_sub = squeeze(width_pretest(:,:,sub));
    xx = pretest_even_sub(:,4) == 0;pretest_even_sub(xx,4) = 2;
    
    idx1 = ~isnan(pretest_even_sub(:,4)) & (pretest_even_sub(:,4) == pretest_even_sub(:,2));
    idx2 = ~isnan(pretest_even_sub(:,4)) & (pretest_even_sub(:,4) ~= pretest_even_sub(:,2));
    width_pretest(idx1,4,sub) = 1; width_pretest(idx2,4,sub) = 0;
end

for sub = 1:size(width_pretest, 3)
    pretest_even_sub = squeeze(width_pretest(:,:,sub));
    Target = pretest_even_sub(:,2);
    pretest_even_sub(Target == 2,:)=[];
    C_IC = pretest_even_sub(:,1) == pretest_even_sub(:,2);
    time_interval = pretest_even_sub(:,3)*1/fs+shift;
    RT = pretest_even_sub(:,4);
    [M_RT,G]=grpstats(RT,[C_IC,time_interval],{'nanmean','gname'});G=str2double(G);
    ACC_pretest_even(:,sub) = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
    C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
    C_IC_RT = smoothdata(C_IC_RT,'gaussian',gaussianwindow);
    PSD_pretest_even(:,sub) = periodogram(detrend(C_IC_RT,detrendnumber),[],N,fs);
end
PSD_mean_pretest_even = mean(PSD_pretest_even,2);
runs = 1000;
for shuffletime = 1:runs
    for sub = 1:size(width_pretest, 3)
        pretest_even_sub = squeeze(width_pretest(:,:,sub));
        Target = pretest_even_sub(:,2);
        pretest_even_sub(Target == 2,:)=[];
        C_IC = pretest_even_sub(:,1) == pretest_even_sub(:,2);
        time_interval = pretest_even_sub(:,3)*1/fs+shift;
        RT = pretest_even_sub(:,4);
        [M_RT,G]=grpstats(RT,[C_IC,time_interval],{'nanmean','gname'});G=str2double(G);
        C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
        C_IC_RT = smoothdata(C_IC_RT,'gaussian',gaussianwindow);
        C_IC_RT = C_IC_RT(randperm(length(C_IC_RT)));
        PSD_shuffle(:,sub,shuffletime) = periodogram(detrend(C_IC_RT,detrendnumber),[],N,fs);
    end
end
PSD_shuffle_mean = squeeze(mean(PSD_shuffle,2));
PSD_shuffle_mean = sort(PSD_shuffle_mean,2);
criterion = max(PSD_shuffle_mean(:,round(runs*(1-alpha))));
h_pretest = PSD_mean_pretest_even > criterion;
fprintf('Out of %d tests, %d is significant.\n',length(h_pretest),sum(h_pretest));
%%
sig_pretest = NaN(size(h_pretest));
sig_pretest(h_pretest) = max(PSD_mean_pretest_even).*1.5;
figure(2)
subplot(2,2,1)
shadedErrorBar(f',PSD_mean_pretest_even,nanstd(PSD_pretest_even,[],2)/sqrt(subs));
hold on;
plot(f,sig_pretest,'r-','LineWidth',2.5);
hold on;
% plot(f,ones(size(f))*criterion,'--k','LineWidth',0.5);
xlabel('Frequency (Hz)');
ylabel('PSD (a.u.)')
title('5Hz prime group baseline')
subplot(2,2,2)
shadedErrorBar(t,-mean(ACC_pretest_even,2),nanstd(ACC_pretest_even,[],2)/sqrt(subs));
xlim([0.2,1.05])
xlabel('SOA (s)')
ylabel('Accuracy (C-IC)')
title('5Hz prime group baseline')
%%
save PSD.mat PSD_pretest_even -append;