%%
clear

load pretest.mat
fs = 30;
shift = 0.2;
t = ((1:24)/fs)'+shift;
for sub = 1:size(width_pretest, 3)
    pretest_sub = squeeze(width_pretest(:,:,sub));
    xx = pretest_sub(:,4) == 0;pretest_sub(xx,4) = 2;
    
    idx1 = ~isnan(pretest_sub(:,4)) & (pretest_sub(:,4) == pretest_sub(:,2));
    idx2 = ~isnan(pretest_sub(:,4)) & (pretest_sub(:,4) ~= pretest_sub(:,2));
    width_pretest(idx1,4,sub) = 1; width_pretest(idx2,4,sub) = 0;
end
for sub = 1:size(width_pretest, 3)
    pretest_sub = squeeze(width_pretest(:,:,sub));
    
    C_IC = pretest_sub(:,1) == pretest_sub(:,2);
    Target = pretest_sub(:,2);
    time_interval = pretest_sub(:,3)*1/fs+shift;
    RT = pretest_sub(:,4);
    [M_RT(:,sub),G]=grpstats(RT,[C_IC,Target],{'nanmean','gname'});G=str2double(G);
    
end
ACC(:,1) = nanmean(M_RT,2);
SEM(:,1) = nanstd(M_RT,[],2)./sqrt(size(M_RT,2));
%%
clearvars -except ACC SEM
load post_test_even.mat
fs = 30;
shift = 0.2;
t = ((1:24)/fs)'+shift;

for sub = 1:size(width_posttest, 3)
    posttest_sub = squeeze(width_posttest(:,:,sub));
    xx = posttest_sub(:,4) == 0;posttest_sub(xx,4) = 2;

    idx1 = ~isnan(posttest_sub(:,4)) & (posttest_sub(:,4) == posttest_sub(:,2));
    idx2 = ~isnan(posttest_sub(:,4)) & (posttest_sub(:,4) ~= posttest_sub(:,2));
    width_posttest(idx1,4,sub) = 1; width_posttest(idx2,4,sub) = 0;
end
for sub = 1:size(width_posttest, 3)
    posttest_sub = squeeze(width_posttest(:,:,sub));
    
    C_IC = posttest_sub(:,1) == posttest_sub(:,2);
    Target = posttest_sub(:,2);

    time_interval = posttest_sub(:,3)*1/fs+shift;
    RT = posttest_sub(:,4);
    [M_RT(:,sub),G]=grpstats(RT,[C_IC,Target],{'nanmean','gname'});G=str2double(G);
    
end
ACC(:,2) = nanmean(M_RT,2);
SEM(:,2) = nanstd(M_RT,[],2)./sqrt(size(M_RT,2));

%%
clearvars -except ACC SEM

load post_test_odd.mat
fs = 30;
shift = 0.2;
t = ((1:24)/fs)'+shift;

for sub = 1:size(width_posttest, 3)
    posttest_sub = squeeze(width_posttest(:,:,sub));
    xx = posttest_sub(:,4) == 0;posttest_sub(xx,4) = 2;

    idx1 = ~isnan(posttest_sub(:,4)) & (posttest_sub(:,4) == posttest_sub(:,2));
    idx2 = ~isnan(posttest_sub(:,4)) & (posttest_sub(:,4) ~= posttest_sub(:,2));
    width_posttest(idx1,4,sub) = 1; width_posttest(idx2,4,sub) = 0;
end
for sub = 1:size(width_posttest, 3)
    posttest_sub = squeeze(width_posttest(:,:,sub));
    
    C_IC = posttest_sub(:,1) == posttest_sub(:,2);
    Target = posttest_sub(:,2);
    time_interval = posttest_sub(:,3)*1/fs+shift;
    RT = posttest_sub(:,4);
    [M_RT(:,sub),G]=grpstats(RT,[C_IC,Target],{'nanmean','gname'});G=str2double(G);
    
end

ACC(:,3) = nanmean(M_RT,2);
SEM(:,3) = nanstd(M_RT,[],2)./sqrt(size(M_RT,2));
%%
figure
subplot(1,2,1)
bar1 = barwitherr(SEM([1,3],:),ACC([1,3],:),'EdgeColor','none');
set(bar1(1),...
    'FaceColor',[0.501960813999176 0.501960813999176 0.501960813999176]);
set(bar1(2),...
    'FaceColor',[0.901960790157318 0.627451002597809 0.627451002597809]);
set(bar1(3),...
    'FaceColor',[0.627451002597809 0.843137264251709 0.901960790157318]);
ylim([0,1]);
box off;
xticks([1,2]);
xticklabels({'Incongruent Trials','Congruent Trials'})
ylabel('Accuracy')
legend({'baseline','3Hz prime','5Hz prime'});
legend boxoff;
title('Target Left');
subplot(1,2,2)
bar1 = barwitherr(SEM([2,4],:),ACC([2,4],:),'EdgeColor','none');
set(bar1(1),...
    'FaceColor',[0.501960813999176 0.501960813999176 0.501960813999176]);
set(bar1(2),...
    'FaceColor',[0.901960790157318 0.627451002597809 0.627451002597809]);
set(bar1(3),...
    'FaceColor',[0.627451002597809 0.843137264251709 0.901960790157318]);
ylim([0,1]);
box off;
xticks([1,2]);
xticklabels({'Incongruent Trials','Congruent Trials'})
ylabel('Accuracy')
legend({'baseline','3Hz prime','5Hz prime'});
legend boxoff;
title('Target Right');