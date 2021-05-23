%% pretest
clear
load PSD.mat

[~,idx_pre_even] = max(nanmean(PSD_pretest_even,2));
[~,idx_pre_odd] = max(nanmean(PSD_pretest_odd,2));
f_pre_even = f(idx_pre_even);
f_pre_odd = f(idx_pre_odd);
f_diff_origin = f_pre_even - f_pre_odd;

load pretest.mat

fs = 30;
N = 64;
shift = 0.2;
f = (0:N/2)*fs/N;
t = ((1:24)/fs)'+shift;
alpha = 0.05;
gaussianwindow = 3;
detrendnumber = 1;

for sub = 1:size(width_pretest, 3)
    pretest_sub = squeeze(width_pretest(:,:,sub));
    xx = pretest_sub(:,4) == 0;pretest_sub(xx,4) = 2;
    
    idx1 = ~isnan(pretest_sub(:,4)) & (pretest_sub(:,4) == pretest_sub(:,2));
    idx2 = ~isnan(pretest_sub(:,4)) & (pretest_sub(:,4) ~= pretest_sub(:,2));
    width_pretest(idx1,4,sub) = 1; width_pretest(idx2,4,sub) = 0;
end
for permutation = 1:1000
    idx_odd = randperm(25,11); % odd
    idx_even = setdiff(1:25,idx_odd); % even
    for sub = 1:size(width_pretest, 3)
        
        PSD_pretest_even(:,sub) = NaN(size(f'));
        PSD_pretest_odd(:,sub) = NaN(size(f'));
        
        pretest_sub = squeeze(width_pretest(:,:,sub));
        
        C_IC = pretest_sub(:,1) == pretest_sub(:,2);
        time_interval = pretest_sub(:,3)*1/fs+shift;
        RT = pretest_sub(:,4);
        [M_RT,G]=grpstats(RT,[C_IC,time_interval],{'nanmean','gname'});G=str2double(G);
        C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
        C_IC_RT = smoothdata(C_IC_RT,'gaussian',gaussianwindow);
        if sum(idx_even == sub)
            PSD_pretest_even(:,sub) = periodogram(detrend(C_IC_RT,detrendnumber),[],N,fs);
        elseif sum(idx_odd == sub)
            PSD_pretest_odd(:,sub) = periodogram(detrend(C_IC_RT,detrendnumber),[],N,fs);
        end
    end
    [~,idx_pre_even] = max(nanmean(PSD_pretest_even,2));
    [~,idx_pre_odd] = max(nanmean(PSD_pretest_odd,2));
    f_pre_even = f(idx_pre_even);
    f_pre_odd = f(idx_pre_odd);
    f_diff(permutation) = f_pre_even - f_pre_odd;
end

p = sum(abs(f_diff)>=abs(f_diff_origin))./length(f_diff);
