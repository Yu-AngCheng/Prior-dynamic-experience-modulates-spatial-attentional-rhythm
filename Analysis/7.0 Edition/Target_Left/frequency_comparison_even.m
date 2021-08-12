%% even (5Hz) frequency comparison based on jackknife
clear
load pretest.mat
load post_test_even.mat
idx_even = [3,4,6,7,9,10,12,14,15,17,18,20,22,24]; % even
width_pretest = width_pretest(:,:,idx_even);
width_posttest = width_posttest(:,:,:);
%%
fs = 30; % the sampling frequency
N = 64; % NFFT
subs = 14; % number of subjects
shift = 0.2; % time lag

f = (0:N/2)*fs/N;
t = ((1:24)/fs)'+shift;

alpha = 0.05; % significance level
gaussianwindow = 3;% the length of gaussian moving window
detrendnumber = 1;% if 1, removes the linear trend
k = 4; % choose the top 4 frequency point
%%
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
%%
for subjectomitted = 1 :subs
    PSD_pretest_even = NaN(length(f'),subs);
    PSD_posttest_even = NaN(length(f'),subs);
    for sub = 1:subs
        
        pretest_even_sub = squeeze(width_pretest(:,:,sub));
        posttest_even_sub = squeeze(width_posttest(:,:,sub));
        PSD_pretest_even(:,sub) = NaN(size(f'));
        PSD_posttest_even(:,sub) = NaN(size(f'));
        
        % omit the subjectomitted subject
        if sub == subjectomitted
            continue
        end
        
        % remove the right target condition
        Target = pretest_even_sub(:,2);
        pretest_even_sub(Target == 2,:)=[];
        
        C_IC = pretest_even_sub(:,1) == pretest_even_sub(:,2);
        time_interval = pretest_even_sub(:,3)*1/fs+shift;
        Y = pretest_even_sub(:,4);
        [M_Y,G]=grpstats(Y,[C_IC,time_interval],{'nanmean','gname'});
        G=str2double(G);
        
        C_IC_Y = M_Y(1:length(M_Y)/2) - M_Y(length(M_Y)/2+1:end);
        C_IC_Y = smoothdata(C_IC_Y,'gaussian',gaussianwindow);
        
        PSD_pretest_even(:,sub) = periodogram(detrend(C_IC_Y,detrendnumber),[],N,fs);
        
        % remove the right target condition
        Target = posttest_even_sub(:,2);
        posttest_even_sub(Target == 2,:)=[];
        
        C_IC = posttest_even_sub(:,1) == posttest_even_sub(:,2);
        time_interval = posttest_even_sub(:,3)*1/fs+shift;
        Y = posttest_even_sub(:,4);
        [M_Y,G]=grpstats(Y,[C_IC,time_interval],{'nanmean','gname'});
        G=str2double(G);
        
        C_IC_Y = M_Y(1:length(M_Y)/2) - M_Y(length(M_Y)/2+1:end);
        C_IC_Y = smoothdata(C_IC_Y,'gaussian',gaussianwindow);
        
        PSD_posttest_even(:,sub) = periodogram(detrend(C_IC_Y,detrendnumber),[],N,fs);
        
    end
    
    [~,idx_pre_even] = maxk(nanmean(PSD_pretest_even,2),k);
    [~,idx_post_even] = maxk(nanmean(PSD_posttest_even,2),k);
    f_pre_even(subjectomitted) = mean(f(idx_pre_even));
    f_post_even(subjectomitted) = mean(f(idx_post_even));
end
%%
f_diff = f_post_even - f_pre_even;
SE_jack = sqrt(sum((f_diff-mean(f_diff)).^2)/length(f_diff)*(length(f_diff)-1));
T = mean(f_diff)/SE_jack;
p = tcdf(T,length(f_diff)-1,'upper');
