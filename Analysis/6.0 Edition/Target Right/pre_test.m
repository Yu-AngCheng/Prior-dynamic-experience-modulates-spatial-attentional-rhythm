clear all
% close all
load pretest.mat
%%
fs = 30; % the sampling frequency
N = 64; % NFFT
subs = 25; % number of subjects
shift = 0.2; % time lag

alpha = 0.05; % the significance level
gaussianwindow = 3;% the length of gaussian moving window 
detrendnumber = 1; % if 1, remove the linear trend

f = (0:N/2)*fs/N;
t = ((1:24)/fs)'+shift;

color1 = [0.8290 0.5 0.1];
color2 = [0.90,0.33,0.33];
color3 = [0.20,0.20,0.80];
color0 = [0.50,0.50,0.50];
%%
for sub = 1:size(width_pretest, 3)
    pretest_sub = squeeze(width_pretest(:,:,sub));
    xx = pretest_sub(:,4) == 0;pretest_sub(xx,4) = 2;
    
    idx1 = ~isnan(pretest_sub(:,4)) & (pretest_sub(:,4) == pretest_sub(:,2));
    idx2 = ~isnan(pretest_sub(:,4)) & (pretest_sub(:,4) ~= pretest_sub(:,2));
    width_pretest(idx1,4,sub) = 1; width_pretest(idx2,4,sub) = 0;
end
%%
for sub = 1:size(width_pretest, 3)
    
    pretest_sub = squeeze(width_pretest(:,:,sub));
    
    % remove the left target condition
    Target = pretest_sub(:,2);
    pretest_sub(Target == 1,:)=[];
    
    C_IC = pretest_sub(:,1) == pretest_sub(:,2);
    time_interval = pretest_sub(:,3)*1/fs+shift;
    Y= pretest_sub(:,4);
    [M_Y,G]=grpstats(Y,[C_IC,time_interval],{'nanmean','gname'});
    G=str2double(G);
    
    C_IC_Y = M_Y(1:length(M_Y)/2) - M_Y(length(M_Y)/2+1:end);
    C_IC_Y = smoothdata(C_IC_Y,'gaussian',gaussianwindow);
    
    ACC_pretest(:,sub) = C_IC_Y;
    PSD_pretest(:,sub) = periodogram(detrend(C_IC_Y,detrendnumber),[],N,fs);
end

PSD_mean_pretest = mean(PSD_pretest,2);

runs = 1000;
for shuffletime = 1:runs
    
    for sub = 1:size(width_pretest, 3)
        
        pretest_sub = squeeze(width_pretest(:,:,sub));
        
        % remove the left target condition
        Target = pretest_sub(:,2);
        pretest_sub(Target == 1,:)=[];
        
        C_IC = pretest_sub(:,1) == pretest_sub(:,2);
        time_interval = pretest_sub(:,3)*1/fs+shift;
        Y = pretest_sub(:,4);
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
h_pretest = PSD_mean_pretest > criterion;
fprintf('Out of %d tests, %d is significant.\n',length(h_pretest),sum(h_pretest));
sig_pretest = NaN(size(h_pretest)); sig_pretest(h_pretest) = max(PSD_mean_pretest).*1.35;
%%
figure(1);
subplot(3,2,1); % frequency domain
h1 = shadedErrorBar(f',PSD_mean_pretest,nanstd(PSD_pretest,[],2)/sqrt(subs),'lineprops',{'color',color1});
hold on; plot(f,sig_pretest,'-','LineWidth',2.5,'Color',color1);
xlabel('Frequency (Hz)'); ylabel('PSD (a.u.)'); title('baseline');
subplot(3,2,2) % the time domain
shadedErrorBar(t,-mean(ACC_pretest,2),nanstd(ACC_pretest,[],2)/sqrt(subs),'lineprops',{'color',color1});
xlim([0.2,1.05]);
xlabel('SOA (s)'); ylabel('Accuracy (C-IC)'); title('baseline');
%%
subplot(3,2,1);hold on;
text(2.4,4.7e-3,'**','FontWeight','bold','HorizontalAlignment','center');
ylim([0,5e-3])
%%
for iRun = 1:100
     fo = fitoptions('Method','NonlinearLeastSquares',...
                    'Lower', [0, 0, 0, 0],...
                    'Upper', [1, 1, 10, 2*pi],...
                    'StartPoint', [rand(), rand(), 10*rand(), 2*pi*rand()]);
    ft = fittype('c+a*sin(2*pi*f*x+phi)', 'options', fo,...
        'independent', 'x','dependent','y');
    [fitObj_tmp{iRun}, gof] = fit(t, -mean(ACC_pretest,2), ft);
    rsquare_temp(iRun) = gof.rsquare;
end
[~, idx_opt] = max(rsquare_temp);fitObj = fitObj_tmp{idx_opt};
c = fitObj.c; a = fitObj.a; ff = fitObj.f; phi = fitObj.phi;
subplot(3,2,2);hold on;
plot(linspace(t(1),t(end)),c+a*sin(2*pi*ff*linspace(t(1),t(end))+phi),'-','LineWidth',2,'Color',color0);
%%
save PSD.mat PSD_pretest f;