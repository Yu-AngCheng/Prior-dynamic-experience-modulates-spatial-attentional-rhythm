%% 3Hz pre odd
clear
load pretest.mat

fs = 30;
N = 128;
subs = 11;
shift = 0.2;
f = (0:N/2)*fs/N;
t = ((1:24)/fs)'+shift;
alpha = 0.05;
gaussianwindow = 3;
idx_odd = [1,2,5,8,11,13,16,19,21,23,25]; % odd
width_pretest = width_pretest(:,:,idx_odd);
%%
tic
for nboot = 1:1000
    idx = randsample(subs,subs,true);
    width_pretest_bootstrp = width_pretest(:,:,idx);
    for sub = 1:size(width_pretest, 3)      
        pretest_sub = squeeze(width_pretest_bootstrp(:,:,sub));
        idx1 = ~isnan(pretest_sub(:,4)) & (pretest_sub(:,4) == pretest_sub(:,2));
        idx2 = ~isnan(pretest_sub(:,4)) & (pretest_sub(:,4) ~= pretest_sub(:,2));
        pretest_sub(idx1,4) = 1; pretest_sub(idx2,4) = 0;
        C_IC = pretest_sub(:,1) == pretest_sub(:,2);
        time_interval = pretest_sub(:,3)*1/fs+shift;
        RT = pretest_sub(:,4);
        [M_RT,G]=grpstats(RT,[C_IC,time_interval],{'nanmean','gname'});G=str2double(G);
        C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
        C_IC_RT = smoothdata(C_IC_RT,'gaussian',gaussianwindow);
        Y = fft(detrend(C_IC_RT,1),N);
        P2 = abs(Y/N);
        P1 = P2(1:N/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        Amplitude_pretest(:,sub) = P1;
    end
    Amplitude_mean_pretest(:,nboot) = mean(Amplitude_pretest,2);
end
toc
%%
[~,idx_f] = max(Amplitude_mean_pretest);
f_peak_pre_odd = f(idx_f);
save f_peak_pre_odd.mat f_peak_pre_odd