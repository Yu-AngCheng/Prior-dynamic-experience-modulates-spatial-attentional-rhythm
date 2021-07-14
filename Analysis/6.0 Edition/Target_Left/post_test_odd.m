%% 3 Hz
clear all
% close all
load post_test_odd.mat
%%
fs = 30; % the sampling frequency
N = 64; % NFFT
subs = 11; % number of subjects
shift = 0.2; % time lag

alpha = 0.01; % the significance level
gaussianwindow = 3;% the length of gaussian moving window 
detrendnumber = 1; % if 1, remove the linear trend

f = (0:N/2)*fs/N;
t = ((1:24)/fs)'+shift;
%%
for sub = 1:size(width_posttest, 3)
    posttest_sub = squeeze(width_posttest(:,:,sub));
    xx = posttest_sub(:,4) == 0;posttest_sub(xx,4) = 2;

    idx1 = ~isnan(posttest_sub(:,4)) & (posttest_sub(:,4) == posttest_sub(:,2));
    idx2 = ~isnan(posttest_sub(:,4)) & (posttest_sub(:,4) ~= posttest_sub(:,2));
    width_posttest(idx1,4,sub) = 1; width_posttest(idx2,4,sub) = 0;
end
%%
for sub = 1:size(width_posttest, 3)
    
    posttest_odd_sub = squeeze(width_posttest(:,:,sub));
    
    % remove the right target condition
    Target = posttest_odd_sub(:,2);
    posttest_odd_sub(Target == 2,:)=[];
    
    C_IC = posttest_odd_sub(:,1) == posttest_odd_sub(:,2);
    time_interval = posttest_odd_sub(:,3)*1/fs+shift;
    Y = posttest_odd_sub(:,4);
    [M_Y,G]=grpstats(Y,[C_IC,time_interval],{'nanmean','gname'});
    G=str2double(G);
    
    C_IC_Y = M_Y(1:length(M_Y)/2) - M_Y(length(M_Y)/2+1:end);
    C_IC_Y = smoothdata(C_IC_Y,'gaussian',gaussianwindow);
    
    ACC_post_odd(:,sub) = C_IC_Y;
    PSD_post_odd(:,sub) = periodogram(detrend(C_IC_Y,detrendnumber),[],N,fs);
end

PSD_mean_post_odd = mean(PSD_post_odd,2);

runs = 1000;
for shuffletime = 1:runs
    for sub = 1:size(width_posttest, 3)
        
        posttest_odd_sub = squeeze(width_posttest(:,:,sub));
        
        % remove the right target condition
        Target = posttest_odd_sub(:,2);
        posttest_odd_sub(Target == 2,:)=[];
        
        C_IC = posttest_odd_sub(:,1) == posttest_odd_sub(:,2);
        time_interval = posttest_odd_sub(:,3)*1/fs+shift;
        Y = posttest_odd_sub(:,4);
        [M_Y,G]=grpstats(Y,[C_IC,time_interval],{'nanmean','gname'});
        G=str2double(G);
        
        C_IC_Y = M_Y(1:length(M_Y)/2) - M_Y(length(M_Y)/2+1:end);
        C_IC_Y = smoothdata(C_IC_Y,'gaussian',gaussianwindow);
        
        C_IC_Y = C_IC_Y(randperm(length(C_IC_Y)));
        PSD_shuffle(:,sub,shuffletime) = periodogram(detrend(C_IC_Y,detrendnumber),[],N,fs);
    end
end
PSD_shuffle_mean = squeeze(mean(PSD_shuffle,2));
PSD_shuffle_mean = sort(PSD_shuffle_mean,2);
criterion = max(PSD_shuffle_mean(:,round(runs*(1-alpha))));
h_post_odd = PSD_mean_post_odd > criterion;
fprintf('Out of %d tests, %d is significant.\n',length(h_post_odd),sum(h_post_odd));
sig_post_odd = NaN(size(h_post_odd));
sig_post_odd(h_post_odd) = max(PSD_mean_post_odd).*1.5;
%%
figure(1)
subplot(3,2,5)
shadedErrorBar(f',PSD_mean_post_odd,nanstd(PSD_post_odd,[],2)/sqrt(subs));
hold on; plot(f,sig_post_odd,'r-','LineWidth',2.5);
xlabel('Frequency (Hz)'); ylabel('PSD (a.u.)'); title('3Hz prime');
subplot(3,2,6)
shadedErrorBar(t,-mean(ACC_post_odd,2),nanstd(ACC_post_odd,[],2)/sqrt(subs));
%%
for iRun = 1:100
    fo = fitoptions('Method','NonlinearLeastSquares',...
                    'Lower', [0, 0, 0, 0],...
                    'Upper', [1, 1, 10, 2*pi],...
                    'StartPoint', [rand(), rand(), 10*rand(), 2*pi*rand()]);
    ft = fittype('c+a*sin(2*pi*f*x+phi)', 'options', fo,...
        'independent', 'x','dependent','y');
    [fitObj_tmp{iRun}, gof] = fit(t, -mean(ACC_post_odd,2), ft);
    rsquare_temp(iRun) = gof.rsquare;
end
[~, idx_opt] = max(rsquare_temp);fitObj = fitObj_tmp{idx_opt};
c = fitObj.c; a = fitObj.a; ff = fitObj.f; phi = fitObj.phi;
hold on; plot(t,c+a*sin(2*pi*ff*t+phi),'r-','LineWidth',1);
xlim([0.2,1.05])
xlabel('SOA (s)'); ylabel('Accuracy (C-IC)'); title('3Hz prime')
%%
save PSD.mat PSD_post_odd -append;