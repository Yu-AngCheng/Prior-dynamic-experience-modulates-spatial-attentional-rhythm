%% odd (3Hz) frequency comparison based on jackknife
clear
load pretest.mat
load post_test_odd.mat
idx_odd = [1,2,5,8,11,13,16,19,21,23,25]; % odd
width_pretest = width_pretest(:,:,idx_odd);
width_posttest = width_posttest(:,:,:);
%%
fs = 30; % the sampling frequency
N = 64; % NFFT
subs = 11; % number of subjects
shift = 0.2;% time lag

f = (0:N/2)*fs/N;
t = ((1:24)/fs)'+shift;

alpha = 0.05; % significance level
gaussianwindow = 3;% the length of gaussian moving window
detrendnumber = 1;% if 1, removes the linear trend
k = 4; % choose the top 4 frequency point
%%
for sub = 1:size(width_pretest, 3)
    pretest_odd_sub = squeeze(width_pretest(:,:,sub));
    xx = pretest_odd_sub(:,4) == 0;pretest_odd_sub(xx,4) = 2;
    
    idx1 = ~isnan(pretest_odd_sub(:,4)) & (pretest_odd_sub(:,4) == pretest_odd_sub(:,2));
    idx2 = ~isnan(pretest_odd_sub(:,4)) & (pretest_odd_sub(:,4) ~= pretest_odd_sub(:,2));
    width_pretest(idx1,4,sub) = 1; width_pretest(idx2,4,sub) = 0;
end
for sub = 1:size(width_posttest, 3)
    posttest_odd_sub = squeeze(width_posttest(:,:,sub));
    xx = posttest_odd_sub(:,4) == 0;posttest_odd_sub(xx,4) = 2;
    
    idx1 = ~isnan(posttest_odd_sub(:,4)) & (posttest_odd_sub(:,4) == posttest_odd_sub(:,2));
    idx2 = ~isnan(posttest_odd_sub(:,4)) & (posttest_odd_sub(:,4) ~= posttest_odd_sub(:,2));
    width_posttest(idx1,4,sub) = 1; width_posttest(idx2,4,sub) = 0;
end
%%
for subjectomitted = 1 :subs
    PSD_pretest_odd = NaN(length(f'),subs);
    PSD_posttest_odd = NaN(length(f'),subs);
    for sub = 1:subs
        
        pretest_odd_sub = squeeze(width_pretest(:,:,sub));
        posttest_odd_sub = squeeze(width_posttest(:,:,sub));
        
        % omit the subjectomitted subject
        if sub == subjectomitted
            continue
        end
        
        % remove the left target condition
        Target = pretest_odd_sub(:,2);
        pretest_odd_sub(Target == 1,:)=[];
        
        C_IC = pretest_odd_sub(:,1) == pretest_odd_sub(:,2);
        time_interval = pretest_odd_sub(:,3)*1/fs+shift;
        Y = pretest_odd_sub(:,4);
        [M_Y,G]=grpstats(Y,[C_IC,time_interval],{'nanmean','gname'});
        G=str2double(G);
        
        C_IC_Y = M_Y(1:length(M_Y)/2) - M_Y(length(M_Y)/2+1:end);
        C_IC_Y = smoothdata(C_IC_Y,'gaussian',gaussianwindow);
        
        PSD_pretest_odd(:,sub) = periodogram(detrend(C_IC_Y,detrendnumber),[],N,fs);
        
        % remove the left target condition
        Target = posttest_odd_sub(:,2);
        posttest_odd_sub(Target == 1,:)=[];
        
        C_IC = posttest_odd_sub(:,1) == posttest_odd_sub(:,2);
        time_interval = posttest_odd_sub(:,3)*1/fs+shift;
        Y = posttest_odd_sub(:,4);
        [M_Y,G]=grpstats(Y,[C_IC,time_interval],{'nanmean','gname'});
        G=str2double(G);
        
        C_IC_Y = M_Y(1:length(M_Y)/2) - M_Y(length(M_Y)/2+1:end);
        C_IC_Y = smoothdata(C_IC_Y,'gaussian',gaussianwindow);
        
        PSD_posttest_odd(:,sub) = periodogram(detrend(C_IC_Y,detrendnumber),[],N,fs);
        
    end
    
    [~,idx_pre_odd] = maxk(nanmean(PSD_pretest_odd,2),k);
    [~,idx_post_odd] = maxk(nanmean(PSD_posttest_odd,2),k);
    f_pre_odd(subjectomitted) = mean(f(idx_pre_odd));
    f_post_odd(subjectomitted) = mean(f(idx_post_odd));
end
%%
f_diff = f_post_odd - f_pre_odd;
SE_jack = sqrt(sum((f_diff-mean(f_diff)).^2)/length(f_diff)*(length(f_diff)-1));
T = mean(f_diff)/SE_jack;
p = tcdf(T,length(f_diff)-1,'upper');
