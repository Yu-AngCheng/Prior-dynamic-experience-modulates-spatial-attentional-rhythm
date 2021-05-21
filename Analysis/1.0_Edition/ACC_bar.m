clearvars -except ACC

load pretest.mat
fs = 30;
shift = 0.2;
t = ((1:24)/fs)'+shift;

xx = tall_pretest(:,4) == 0;tall_pretest(xx,4) = 2;
idx1 = ~isnan(tall_pretest(:,4)) & (tall_pretest(:,4) == tall_pretest(:,2));
idx2 = ~isnan(tall_pretest(:,4)) & (tall_pretest(:,4) ~= tall_pretest(:,2));
tall_pretest(idx1,4) = 1; tall_pretest(idx2,4) = 0;
C_IC = tall_pretest(:,1) == tall_pretest(:,2);
time_interval = tall_pretest(:,3)*1/fs+shift;
AC = tall_pretest(:,4);

[M_RT,G]=grpstats(AC,[C_IC],{'nanmean','gname'});G=str2double(G);
ACC(:,1) = M_RT;
%%
clearvars -except ACC
load post_test_even.mat
fs = 30;
shift = 0.2;
t = ((1:24)/fs)'+shift;

xx = tall_posttest(:,4) == 0;tall_posttest(xx,4) = 2;
idx1 = ~isnan(tall_posttest(:,4)) & (tall_posttest(:,4) == tall_posttest(:,2));
idx2 = ~isnan(tall_posttest(:,4)) & (tall_posttest(:,4) ~= tall_posttest(:,2));
tall_posttest(idx1,4) = 1; tall_posttest(idx2,4) = 0;
C_IC = tall_posttest(:,1) == tall_posttest(:,2);
time_interval = tall_posttest(:,3)*1/fs+shift;
AC = tall_posttest(:,4);
[M_RT,G]=grpstats(AC,[C_IC],{'nanmean','gname'});G=str2double(G);
ACC(:,2) = M_RT;

%%
clearvars -except ACC

load post_test_odd.mat
fs = 30;
shift = 0.2;
t = ((1:24)/fs)'+shift;

xx = tall_posttest(:,4) == 0;tall_posttest(xx,4) = 2;
idx1 = ~isnan(tall_posttest(:,4)) & (tall_posttest(:,4) == tall_posttest(:,2));
idx2 = ~isnan(tall_posttest(:,4)) & (tall_posttest(:,4) ~= tall_posttest(:,2));
tall_posttest(idx1,4) = 1; tall_posttest(idx2,4) = 0;
C_IC = tall_posttest(:,1) == tall_posttest(:,2);
time_interval = tall_posttest(:,3)*1/fs+shift;
AC = tall_posttest(:,4);
[M_RT,G]=grpstats(AC,[C_IC],{'nanmean','gname'});G=str2double(G);
ACC(:,3) = M_RT;
%%
bar1 = bar(ACC,'EdgeColor','none');
set(bar1(1),...
    'FaceColor',[0.501960813999176 0.501960813999176 0.501960813999176]);
set(bar1(2),...
    'FaceColor',[0.901960790157318 0.627451002597809 0.627451002597809]);
set(bar1(3),...
    'FaceColor',[0.627451002597809 0.843137264251709 0.901960790157318]);
ylim([0,1]);
box off;
xticks([1,2]);
xticklabels({'Congruent Trials','Incongruent Trials'})
ylabel('Accuracy')
legend({'baseline','3Hz prime','5Hz prime'});
legend boxoff;