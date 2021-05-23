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
gaussianwindow = 3;
detrendnumber = 3;

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
        
        C_IC = pretest_even_sub(:,1) == pretest_even_sub(:,2);
        time_interval = pretest_even_sub(:,3)*1/fs+shift;
        RT = pretest_even_sub(:,4);
        [M_RT,G]=grpstats(RT,[C_IC,time_interval],{'nanmean','gname'});G=str2double(G);
        C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
        C_IC_RT = smoothdata(C_IC_RT,'gaussian',gaussianwindow);
        PSD_pretest_even(:,sub) = periodogram(detrend(C_IC_RT,detrendnumber),[],N,fs);
        
        C_IC = posttest_even_sub(:,1) == posttest_even_sub(:,2);
        time_interval = posttest_even_sub(:,3)*1/fs+shift;
        RT = posttest_even_sub(:,4);
        [M_RT,G]=grpstats(RT,[C_IC,time_interval],{'nanmean','gname'});G=str2double(G);
        C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
        C_IC_RT = smoothdata(C_IC_RT,'gaussian',gaussianwindow);
        PSD_posttest_even(:,sub) = periodogram(detrend(C_IC_RT,detrendnumber),[],N,fs);
        
    end
    [~,idx_pre_even] = max(nanmean(PSD_pretest_even,2));
    [~,idx_post_even] = max(nanmean(PSD_posttest_even,2));
    f_pre_even = f(idx_pre_even);
    f_post_even = f(idx_post_even);
    f_diff(j) = f_post_even - f_pre_even;
end
SE_jack = sqrt(sum((f_diff(j)-mean(f_diff)).^2)/length(f_diff)*(length(f_diff)-1));
T = mean(f_diff(j))/SE_jack;
p = tcdf(T,length(f_diff)-1,'upper');
%% 5Hz even bootstrapping
% clear
% load pretest.mat
% load post_test_even.mat
% idx_even = [3,4,6,7,9,10,12,14,15,17,18,20,22,24]; % even
% width_pretest = width_pretest(:,:,idx_even);
% 
% fs = 30;
% N = 64;
% subs = 14;
% shift = 0.2;
% f = (0:N/2)*fs/N;
% t = ((1:24)/fs)'+shift;
% alpha = 0.05;
% gaussianwindow = 3;
% detrendnumber = 3;
% 
% for sub = 1:size(width_pretest, 3)
%     pretest_sub = squeeze(width_pretest(:,:,sub));
%     xx = pretest_sub(:,4) == 0;pretest_sub(xx,4) = 2;
%     
%     idx1 = ~isnan(pretest_sub(:,4)) & (pretest_sub(:,4) == pretest_sub(:,2));
%     idx2 = ~isnan(pretest_sub(:,4)) & (pretest_sub(:,4) ~= pretest_sub(:,2));
%     width_pretest(idx1,4,sub) = 1; width_pretest(idx2,4,sub) = 0;
% end
% for sub = 1:size(width_posttest, 3)
%     posttest_sub = squeeze(width_posttest(:,:,sub));
%     xx = posttest_sub(:,4) == 0;posttest_sub(xx,4) = 2;
%     
%     idx1 = ~isnan(posttest_sub(:,4)) & (posttest_sub(:,4) == posttest_sub(:,2));
%     idx2 = ~isnan(posttest_sub(:,4)) & (posttest_sub(:,4) ~= posttest_sub(:,2));
%     width_posttest(idx1,4,sub) = 1; width_posttest(idx2,4,sub) = 0;
% end
% 
% tic
% for nboot = 1:1000
%     idx = randsample(subs,subs,true);
%     width_pretest_bootstrp = width_pretest(:,:,idx);
%     width_posttest_bootstrp = width_posttest(:,:,idx);
%     for sub = 1:size(width_pretest, 3)      
%         pretest_even_sub = squeeze(width_pretest_bootstrp(:,:,sub));
%         posttest_sub = squeeze(width_posttest_bootstrp(:,:,sub));
%         
%         C_IC = pretest_even_sub(:,1) == pretest_even_sub(:,2);
%         time_interval = pretest_even_sub(:,3)*1/fs+shift;
%         RT = pretest_even_sub(:,4);
%         [M_RT,G]=grpstats(RT,[C_IC,time_interval],{'nanmean','gname'});G=str2double(G);
%         C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
%         C_IC_RT = smoothdata(C_IC_RT,'gaussian',gaussianwindow);
%         PSD_pretest_even(:,sub) = periodogram(detrend(C_IC_RT,detrendnumber),[],N,fs);
%         
%         C_IC = posttest_sub(:,1) == posttest_sub(:,2);
%         time_interval = posttest_sub(:,3)*1/fs+shift;
%         RT = posttest_sub(:,4);
%         [M_RT,G]=grpstats(RT,[C_IC,time_interval],{'nanmean','gname'});G=str2double(G);
%         C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
%         C_IC_RT = smoothdata(C_IC_RT,'gaussian',gaussianwindow);
%         PSD_posttest_even(:,sub) = periodogram(detrend(C_IC_RT,detrendnumber),[],N,fs);
%     end
%     [~,idx_pre_even] = max(nanmean(PSD_pretest_even,2));
%     [~,idx_post_even] = max(nanmean(PSD_posttest_even,2));
%     f_pre_even = f(idx_pre_even);
%     f_post_even = f(idx_post_even);
%     f_diff(nboot) = f_post_even - f_pre_even;
% end
% toc
% p = sum(f_diff<0)./length(f_diff);
% histogram(f_diff)
