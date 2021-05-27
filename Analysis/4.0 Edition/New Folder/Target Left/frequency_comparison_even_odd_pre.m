%% even (5Hz) based on jackknife
clear
load pretest.mat
idx_even = [3,4,6,7,9,10,12,14,15,17,18,20,22,24]; % even
idx_odd = [1,2,5,8,11,13,16,19,21,23,25]; % odd

fs = 30;
N = 64;
shift = 0.2;
f = (0:N/2)*fs/N;
t = ((1:24)/fs)'+shift;
alpha = 0.05;
gaussianwindow = 4;
detrendnumber = 2;
k = 4;

for sub = 1:size(width_pretest, 3)
    pretest_sub = squeeze(width_pretest(:,:,sub));
    xx = pretest_sub(:,4) == 0;pretest_sub(xx,4) = 2;
    
    idx1 = ~isnan(pretest_sub(:,4)) & (pretest_sub(:,4) == pretest_sub(:,2));
    idx2 = ~isnan(pretest_sub(:,4)) & (pretest_sub(:,4) ~= pretest_sub(:,2));
    width_pretest(idx1,4,sub) = 1; width_pretest(idx2,4,sub) = 0;
end

width_pretest_even = width_pretest(:,:,idx_even);
width_pretest_odd = width_pretest(:,:,idx_odd);

for j = 1 :size(width_pretest_even,3)
    for sub = 1:size(width_pretest_even,3)
        
        pretest_even_sub = squeeze(width_pretest_even(:,:,sub));
        PSD_pretest_even(:,sub) = NaN(size(f'));
        
        if sub == j
            continue
        end
        
        Target = pretest_even_sub(:,2);
        pretest_even_sub(Target == 2,:)=[];
        C_IC = pretest_even_sub(:,1) == pretest_even_sub(:,2);
        time_interval = pretest_even_sub(:,3)*1/fs+shift;
        RT = pretest_even_sub(:,4);
        [M_RT,G]=grpstats(RT,[C_IC,time_interval],{'nanmean','gname'});G=str2double(G);
        C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
        C_IC_RT = smoothdata(C_IC_RT,'gaussian',gaussianwindow);
        PSD_pretest_even(:,sub) = periodogram(detrend(C_IC_RT,detrendnumber),[],N,fs);
   
    end
    [~,idx_pre_even] = maxk(nanmean(PSD_pretest_even,2),k);
    f_pre_even(j) = mean(f(idx_pre_even));
end

for j = 1 :size(width_pretest_odd,3)
    for sub = 1:size(width_pretest_odd,3)
        
        pretest_odd_sub = squeeze(width_pretest_odd(:,:,sub));
        PSD_pretest_odd(:,sub) = NaN(size(f'));
        
        if sub == j
            continue
        end
        
        Target = pretest_odd_sub(:,2);
        pretest_odd_sub(Target == 2,:)=[];
        C_IC = pretest_odd_sub(:,1) == pretest_odd_sub(:,2);
        time_interval = pretest_odd_sub(:,3)*1/fs+shift;
        RT = pretest_odd_sub(:,4);
        [M_RT,G]=grpstats(RT,[C_IC,time_interval],{'nanmean','gname'});G=str2double(G);
        C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
        C_IC_RT = smoothdata(C_IC_RT,'gaussian',gaussianwindow);
        PSD_pretest_odd(:,sub) = periodogram(detrend(C_IC_RT,detrendnumber),[],N,fs);
   
    end
    [~,idx_pre_odd] = maxk(nanmean(PSD_pretest_odd,2),k);
    f_pre_odd(j) = mean(f(idx_pre_odd));
end
SE_even_jack = sqrt(sum((f_pre_even-mean(f_pre_even)).^2)./length(f_pre_even).*(length(f_pre_even)-1));
SE_odd_jack = sqrt(sum((f_pre_odd-mean(f_pre_odd)).^2)./length(f_pre_odd).*(length(f_pre_odd)-1));
