%% parameters
clear all
close all
fs = 30;
shift = 0.2;
t = ((1:24)/fs)'+shift;
color1 = [0.92,0.78,0.60];
color2 = [0.64,0.64,0.91];
color3 = [0.96,0.70,0.70];
%% pretest
clearvars -except ACC SEM fs shift t color1 color2 color3 color 0 ALL
load pretest.mat

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
    Y = pretest_sub(:,4);
    [M_Y(:,sub),G]=grpstats(Y,[C_IC,Target],{'nanmean','gname'});
    G=str2double(G);
    
end

ALL{1} = M_Y';
ACC(:,1) = nanmean(M_Y,2);
SEM(:,1) = nanstd(M_Y,[],2)./sqrt(size(M_Y,2));

%% post_test_even
clearvars -except ACC SEM fs shift t color1 color2 color3 color 0 ALL
load post_test_even.mat

for sub = 1:size(width_posttest, 3)
    posttest_even_sub = squeeze(width_posttest(:,:,sub));
    xx = posttest_even_sub(:,4) == 0;posttest_even_sub(xx,4) = 2;

    idx1 = ~isnan(posttest_even_sub(:,4)) & (posttest_even_sub(:,4) == posttest_even_sub(:,2));
    idx2 = ~isnan(posttest_even_sub(:,4)) & (posttest_even_sub(:,4) ~= posttest_even_sub(:,2));
    width_posttest(idx1,4,sub) = 1; width_posttest(idx2,4,sub) = 0;
end

for sub = 1:size(width_posttest, 3)
    posttest_even_sub = squeeze(width_posttest(:,:,sub));
    
    C_IC = posttest_even_sub(:,1) == posttest_even_sub(:,2);
    Target = posttest_even_sub(:,2);
    Y = posttest_even_sub(:,4);
    [M_Y(:,sub),G]=grpstats(Y,[C_IC,Target],{'nanmean','gname'});
    G=str2double(G);
    
end

ALL{2} = M_Y';
ACC(:,2) = nanmean(M_Y,2);
SEM(:,2) = nanstd(M_Y,[],2)./sqrt(size(M_Y,2));

%%
clearvars -except ACC SEM fs shift t color1 color2 color3 color 0 ALL
load post_test_odd.mat

for sub = 1:size(width_posttest, 3)
    posttest_odd_sub = squeeze(width_posttest(:,:,sub));
    xx = posttest_odd_sub(:,4) == 0;posttest_odd_sub(xx,4) = 2;

    idx1 = ~isnan(posttest_odd_sub(:,4)) & (posttest_odd_sub(:,4) == posttest_odd_sub(:,2));
    idx2 = ~isnan(posttest_odd_sub(:,4)) & (posttest_odd_sub(:,4) ~= posttest_odd_sub(:,2));
    width_posttest(idx1,4,sub) = 1; width_posttest(idx2,4,sub) = 0;
end

for sub = 1:size(width_posttest, 3)
    
    posttest_odd_sub = squeeze(width_posttest(:,:,sub));
    
    C_IC = posttest_odd_sub(:,1) == posttest_odd_sub(:,2);
    Target = posttest_odd_sub(:,2);
    Y = posttest_odd_sub(:,4);
    [M_Y(:,sub),G]=grpstats(Y,[C_IC,Target],{'nanmean','gname'});
    G=str2double(G);
end

ALL{3} = M_Y';
ACC(:,3) = nanmean(M_Y,2);
SEM(:,3) = nanstd(M_Y,[],2)./sqrt(size(M_Y,2));
%%
h = figure(127);
set(h,'Position',[276,105,848,498])
subplot(1,2,1)
bar1 = barwitherr(SEM([1,3],:),ACC([1,3],:),'EdgeColor','none');
set(bar1(1),'FaceColor',color1);
set(bar1(2),'FaceColor',color2);
set(bar1(3),'FaceColor',color3);
xticks([1,2]); xticklabels({'Incongruent Trials','Congruent Trials'})
ylim([0,1.3]); ylabel('Accuracy');yticks(0:0.2:1);
title('Target Left');box off;
subplot(1,2,2)
bar2 = barwitherr(SEM([2,4],:),ACC([2,4],:),'EdgeColor','none');
set(bar2(1),'FaceColor',color1);
set(bar2(2),'FaceColor',color2);
set(bar2(3),'FaceColor',color3);
xticks([1,2]); xticklabels({'Incongruent Trials','Congruent Trials'})
ylim([0,1.3]); ylabel('Accuracy');yticks(0:0.2:1);
title('Target Right');box off;
%%
figure(127)
subplot(1,2,1);hold on;
line([1,2],[1,1],'Color','k');
line([bar1(1).XEndPoints;bar1(3).XEndPoints],[0.90,0.90;0.90,0.90],'Color','k')
text(1.5,1.02,'**','FontWeight','bold','HorizontalAlignment','center');
text(1,0.92,'*','FontWeight','bold','HorizontalAlignment','center');
text(2,0.92,'*','FontWeight','bold','HorizontalAlignment','center');
legend(bar1,{'baseline','3Hz prime','5Hz prime'});legend boxoff;
subplot(1,2,2); hold on;
line([1,2],[1,1],'Color','k');
line([bar2(1).XEndPoints;bar2(3).XEndPoints],[0.90,0.90;0.90,0.90],'Color','k')
text(1.5,1.02,'**','FontWeight','bold','HorizontalAlignment','center');
text(1,0.93,'n.s.','HorizontalAlignment','center');
text(2,0.93,'n.s.','HorizontalAlignment','center');
legend(bar2,{'baseline','3Hz prime','5Hz prime'});legend boxoff;
