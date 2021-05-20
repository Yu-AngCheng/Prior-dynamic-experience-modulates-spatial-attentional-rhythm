%% Entrainment test
clear
load PSD.mat

idx_odd = [1,2,5,8,11,13,16,19,21,23,25]; % odd
idx_even = [3,4,6,7,9,10,12,14,15,17,18,20,22,24]; % even
[~,idx_temp] = max(PSD_post_even);
f_peak_post_even = f(idx_temp);
[~,idx_temp] = max(PSD_post_odd);
f_peak_post_odd = f(idx_temp);
[~,idx_temp] = max(PSD_pretest(:,idx_odd));
f_peak_pre_odd = f(idx_temp);
[~,idx_temp] = max(PSD_pretest(:,idx_even));
f_peak_pre_even = f(idx_temp);
[~,p1] = ttest(f_peak_pre_even,f_peak_post_even);
[~,p2] = ttest(f_peak_pre_odd,f_peak_post_odd);
[~,p3] = ttest2(f_peak_pre_even,f_peak_pre_odd);
[~,p4] = ttest2(f_peak_post_even,f_peak_post_odd);
%%
figure
subplot(1,2,1);
histogram(f_peak_pre_odd,20,'Normalization','probability',...
    'EdgeColor','none','FaceColor',[0.9,0.1,0.1],'FaceAlpha',0.5);
hold on
histogram(f_peak_pre_even,20,'Normalization','probability',...
    'EdgeColor','none','FaceColor',[0.1,0.1,0.9],'FaceAlpha',0.5);
box off;
xlim([0,10])
xticks(0:2:10)
xlabel('Peak spatial attention frequency')
ylabel('Normalized frenquency')
legend({'3Hz prime','5Hz prime'})
legend boxoff;
title('before priming')
subplot(1,2,2);
histogram(f_peak_post_odd,20,'Normalization','probability',...
       'EdgeColor','none','FaceColor',[0.9,0.1,0.1],'FaceAlpha',0.5);
hold on
histogram(f_peak_post_even,20,'Normalization','probability',...
    'EdgeColor','none','FaceColor',[0.1,0.1,0.9],'FaceAlpha',0.5);
box off;
xlabel('Peak spatial attention frequency')
ylabel('Normalized frenquency')
xlim([0,10])
xticks(0:2:10)
legend({'3Hz prime','5Hz prime'})
legend boxoff;
title('after priming')
%%
mean(f_peak_post_even)
mean(f_peak_post_odd)
mean(f_peak_pre_even)
mean(f_peak_pre_odd)