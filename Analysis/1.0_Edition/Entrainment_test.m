%% Entrainment test
clear
load Amplitude.mat
k = 6;
idx_odd = [1,2,5,8,11,13,16,19,21,23,25]; % odd
idx_even = [3,4,6,7,9,10,12,14,15,17,18,20,22,24]; % even
[~,idx_temp] = maxk(Amplitude_post_even,k);
f_peak_post_even = mean(f(idx_temp),1);
[~,idx_temp] = maxk(Amplitude_post_odd,k);
f_peak_post_odd = mean(f(idx_temp),1);
[~,idx_temp] = maxk(Amplitude_pretest(:,idx_odd),k);
f_peak_pre_odd = mean(f(idx_temp),1);
[~,idx_temp] = maxk(Amplitude_pretest(:,idx_even),k);
f_peak_pre_even = mean(f(idx_temp),1);
[~,p1] = ttest(f_peak_pre_even,f_peak_post_even,'Tail','Left');
[~,p2] = ttest(f_peak_pre_odd,f_peak_post_odd);
[~,p3] = ttest2(f_peak_pre_even,f_peak_pre_odd);
[~,p4] = ttest2(f_peak_post_even,f_peak_post_odd);
%%
figure
subplot(1,2,1);
histogram(f_peak_pre_odd, 4,'Normalization','probability',...
    'EdgeColor','none','FaceColor',[0.9,0.1,0.1],'FaceAlpha',0.5);
hold on
histogram(f_peak_post_odd,4,'Normalization','probability',...
    'EdgeColor','none','FaceColor',[0.1,0.1,0.9],'FaceAlpha',0.5);
box off;
xlim([0,10])
xticks(0:2:10)
xlabel('Peak spatial attention frequency')
ylabel('Normalized frenquency')
legend({'pre','post'})
legend boxoff;
title('3Hz prime group')
subplot(1,2,2);
histogram(f_peak_pre_even,4,'Normalization','probability',...
       'EdgeColor','none','FaceColor',[0.9,0.1,0.1],'FaceAlpha',0.5);
hold on
histogram(f_peak_post_even,4,'Normalization','probability',...
    'EdgeColor','none','FaceColor',[0.1,0.1,0.9],'FaceAlpha',0.5);
box off;
xlabel('Peak spatial attention frequency')
ylabel('Normalized frenquency')
xlim([0,10])
xticks(0:2:10)
legend({'pre','post'})
legend boxoff;
title('5Hz prime group')
%%
mean(f_peak_pre_even)
mean(f_peak_post_even)
mean(f_peak_pre_odd)
mean(f_peak_post_odd)
