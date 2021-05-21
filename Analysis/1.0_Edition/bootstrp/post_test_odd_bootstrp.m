%% 3 Hz
clear
load post_test_odd.mat

fs = 30;
N = 128;
subs = 11;
shift = 0.2;
f = (0:N/2)*fs/N;
t = ((1:24)/fs)'+shift;
alpha = 0.05;
gaussianwindow = 3;

%%
tic
for sub = 1:size(width_posttest, 3)
    posttest_sub = squeeze(width_posttest(:,:,sub));
    xx = posttest_sub(:,4) == 0;posttest_sub(xx,4) = 2;
    
    idx1 = ~isnan(posttest_sub(:,4)) & (posttest_sub(:,4) == posttest_sub(:,2));
    idx2 = ~isnan(posttest_sub(:,4)) & (posttest_sub(:,4) ~= posttest_sub(:,2));
    posttest_sub(idx1,4) = 1; posttest_sub(idx2,4) = 0;
end
for nboot = 1:1000
    idx = randsample(subs,subs,true);
    width_posttest_bootstrp = width_posttest(:,:,idx);
    for sub = 1:size(width_posttest, 3)      
        posttest_sub = squeeze(width_posttest_bootstrp(:,:,sub));
       
        C_IC = posttest_sub(:,1) == posttest_sub(:,2);
        time_interval = posttest_sub(:,3)*1/fs+shift;
        RT = posttest_sub(:,4);
        [M_RT,G]=grpstats(RT,[C_IC,time_interval],{'nanmean','gname'});G=str2double(G);
        C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
        C_IC_RT = smoothdata(C_IC_RT,'gaussian',gaussianwindow);
        Y = fft(detrend(C_IC_RT,1),N);
        P2 = abs(Y/N);
        P1 = P2(1:N/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        Amplitude_posttest(:,sub) = P1;
    end
    Amplitude_mean_posttest(:,nboot) = mean(Amplitude_posttest,2);
end
toc
%%
[~,idx_f] = max(Amplitude_mean_posttest);
f_peak_post_odd = f(idx_f);
save f_peak_post_odd.mat f_peak_post_odd