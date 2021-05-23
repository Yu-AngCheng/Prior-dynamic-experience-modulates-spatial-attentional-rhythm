%% even (5Hz) based on jackknife
clear
load pretest.mat
load post_test_even.mat
idx_even = [3,4,6,7,9,10,12,14,15,17,18,20,22,24]; % even
width_pretest = width_pretest(:,:,idx_even);

fs = 30;
N = 64;
subs = 14;
shift = 0.2;
f = (0:N/2)*fs/N;
t = ((1:24)/fs)'+shift;
alpha = 0.05;
gaussianwindow = 4;
detrendnumber = 2;
k = 3;

for sub = 1:size(width_pretest, 3)
    pretest_even_sub = squeeze(width_pretest(:,:,sub));
    xx = pretest_even_sub(:,4) == 0;pretest_even_sub(xx,4) = 2;
    
    idx1 = ~isnan(pretest_even_sub(:,4)) & (pretest_even_sub(:,4) == pretest_even_sub(:,2));
    idx2 = ~isnan(pretest_even_sub(:,4)) & (pretest_even_sub(:,4) ~= pretest_even_sub(:,2));
    width_pretest(idx1,4,sub) = 1; width_pretest(idx2,4,sub) = 0;
end
for sub = 1:size(width_posttest, 3)
    posttest_even_sub = squeeze(width_posttest(:,:,sub));
    xx = posttest_even_sub(:,4) == 0;posttest_even_sub(xx,4) = 2;
    
    idx1 = ~isnan(posttest_even_sub(:,4)) & (posttest_even_sub(:,4) == posttest_even_sub(:,2));
    idx2 = ~isnan(posttest_even_sub(:,4)) & (posttest_even_sub(:,4) ~= posttest_even_sub(:,2));
    width_posttest(idx1,4,sub) = 1; width_posttest(idx2,4,sub) = 0;
end
for j = 1 :subs
    for sub = 1:subs
        
        pretest_even_sub = squeeze(width_pretest(:,:,sub));
        PSD_pretest_even(:,sub) = NaN(size(f'));
        posttest_even_sub = squeeze(width_posttest(:,:,sub));
        PSD_posttest_even(:,sub) = NaN(size(f'));
        
        if sub == j
            continue
        end
        Target = pretest_even_sub(:,2);
        pretest_even_sub(Target == 1,:)=[];
        C_IC = pretest_even_sub(:,1) == pretest_even_sub(:,2);
        time_interval = pretest_even_sub(:,3)*1/fs+shift;
        RT = pretest_even_sub(:,4);
        [M_RT,G]=grpstats(RT,[C_IC,time_interval],{'nanmean','gname'});G=str2double(G);
        C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
        C_IC_RT = smoothdata(C_IC_RT,'gaussian',gaussianwindow);
        PSD_pretest_even(:,sub) = periodogram(detrend(C_IC_RT,detrendnumber),[],N,fs);
        Target = posttest_even_sub(:,2);
        posttest_even_sub(Target == 1,:)=[];
        C_IC = posttest_even_sub(:,1) == posttest_even_sub(:,2);
        time_interval = posttest_even_sub(:,3)*1/fs+shift;
        RT = posttest_even_sub(:,4);
        [M_RT,G]=grpstats(RT,[C_IC,time_interval],{'nanmean','gname'});G=str2double(G);
        C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
        C_IC_RT = smoothdata(C_IC_RT,'gaussian',gaussianwindow);
        PSD_posttest_even(:,sub) = periodogram(detrend(C_IC_RT,detrendnumber),[],N,fs);
        
    end
    [~,idx_pre_even] = maxk(nanmean(PSD_pretest_even,2),k);
    [~,idx_post_even] = maxk(nanmean(PSD_posttest_even,2),k);
    f_pre_even = mean(f(idx_pre_even));
    f_post_even = mean(f(idx_post_even));
    f_diff(j) = f_post_even - f_pre_even;
end
SE_jack = sqrt(sum((f_diff-mean(f_diff)).^2)/length(f_diff)*(length(f_diff)-1));
T = mean(f_diff)/SE_jack;
p = tcdf(T,length(f_diff)-1,'upper');
