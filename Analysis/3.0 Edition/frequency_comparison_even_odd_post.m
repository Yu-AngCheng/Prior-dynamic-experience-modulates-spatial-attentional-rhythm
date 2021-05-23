%% posttest
clear
load PSD.mat
[~,idx_post_even] = max(nanmean(PSD_post_even,2));
[~,idx_post_odd] = max(nanmean(PSD_post_odd,2));
f_post_even = f(idx_post_even);
f_post_odd = f(idx_post_odd);
f_diff_origin = f_post_even - f_post_odd;

load post_test_even.mat
temp = width_posttest;
load post_test_odd.mat
width_posttest = cat(3,width_posttest,temp);

fs = 30;
N = 64;
shift = 0.2;
f = (0:N/2)*fs/N;
t = ((1:24)/fs)'+shift;
alpha = 0.05;
gaussianwindow = 3;
detrendnumber = 3;

for sub = 1:size(width_posttest, 3)
    posttest_sub = squeeze(width_posttest(:,:,sub));
    xx = posttest_sub(:,4) == 0;posttest_sub(xx,4) = 2;
    
    idx1 = ~isnan(posttest_sub(:,4)) & (posttest_sub(:,4) == posttest_sub(:,2));
    idx2 = ~isnan(posttest_sub(:,4)) & (posttest_sub(:,4) ~= posttest_sub(:,2));
    width_posttest(idx1,4,sub) = 1; width_posttest(idx2,4,sub) = 0;
end
for permutation = 1:1000
    idx_odd = randperm(25,11); % odd
    idx_even = setdiff(1:25,idx_odd); % even
    for sub = 1:size(width_posttest, 3)
        
        PSD_posttest_even(:,sub) = NaN(size(f'));
        PSD_posttest_odd(:,sub) = NaN(size(f'));
        
        posttest_sub = squeeze(width_posttest(:,:,sub));
        
        C_IC = posttest_sub(:,1) == posttest_sub(:,2);
        time_interval = posttest_sub(:,3)*1/fs+shift;
        RT = posttest_sub(:,4);
        [M_RT,G]=grpstats(RT,[C_IC,time_interval],{'nanmean','gname'});G=str2double(G);
        C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
        C_IC_RT = smoothdata(C_IC_RT,'gaussian',gaussianwindow);
        if sum(idx_even == sub)
            PSD_posttest_even(:,sub) = periodogram(detrend(C_IC_RT,detrendnumber),[],N,fs);
        elseif sum(idx_odd == sub)
            PSD_posttest_odd(:,sub) = periodogram(detrend(C_IC_RT,detrendnumber),[],N,fs);
        end
    end
    [~,idx_post_even] = max(nanmean(PSD_posttest_even,2));
    [~,idx_post_odd] = max(nanmean(PSD_posttest_odd,2));
    f_post_even = f(idx_post_even);
    f_post_odd = f(idx_post_odd);
    f_diff(permutation) = f_post_even - f_post_odd;
end

p = sum(abs(f_diff)>=abs(f_diff_origin))./length(f_diff);
