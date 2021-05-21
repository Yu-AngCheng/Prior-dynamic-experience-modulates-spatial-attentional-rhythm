%% Entrainment test
clear
load f_peak_pretest.mat
load f_peak_post_odd.mat
load f_peak_post_even.mat
load f_peak_pre_odd.mat
load f_peak_pre_even.mat

%%
figure
subplot(1,2,1);
histogram(f_peak_pre_odd,25,'Normalization','probability',...
    'EdgeColor','none','FaceColor',[0.9,0.1,0.1],'FaceAlpha',0.5);
hold on
histogram(f_peak_post_odd,25,'Normalization','probability',...
    'EdgeColor','none','FaceColor',[0.1,0.1,0.9],'FaceAlpha',0.5);
box off;
xlim([0,10])
xticks(0:2:10)
xlabel('Peak spatial attention frequency')
ylabel('Normalized frenquency')
legend({'pre','post'})
legend boxoff;
subplot(1,2,2);
histogram(f_peak_pre_even,25,'Normalization','probability',...
       'EdgeColor','none','FaceColor',[0.9,0.1,0.1],'FaceAlpha',0.5);
hold on
histogram(f_peak_post_even,25,'Normalization','probability',...
    'EdgeColor','none','FaceColor',[0.1,0.1,0.9],'FaceAlpha',0.5);
box off;
xlabel('Peak spatial attention frequency')
ylabel('Normalized frenquency')
xlim([0,10])
xticks(0:2:10)
legend({'pre','post'})
legend boxoff;
%%
mean(f_peak_post_even)
mean(f_peak_post_odd)
mean(f_peak_pre_even)
mean(f_peak_pre_odd)