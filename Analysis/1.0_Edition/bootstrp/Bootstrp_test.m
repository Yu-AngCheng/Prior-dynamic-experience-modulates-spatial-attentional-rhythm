%% Entrainment test
clear
load f_peak_pretest.mat
load f_peak_post_odd.mat
load f_peak_post_even.mat
load f_peak_pre_odd.mat
load f_peak_pre_even.mat

%%
edges=0:1:10;
figure
subplot(1,2,1);
histogram(f_peak_pre_odd,edges,'Normalization','probability',...
    'EdgeColor','none','FaceColor',[0.9,0.1,0.1],'FaceAlpha',0.5);
hold on
histogram(f_peak_post_odd,edges,'Normalization','probability',...
    'EdgeColor','none','FaceColor',[0.1,0.1,0.9],'FaceAlpha',0.5);
box off;
xlim([0,10])
xticks(0:2:10)
xlabel('Peak spatial attention frequency')
ylabel('Normalized frenquency')
legend({'pre','post'})
legend boxoff;
subplot(1,2,2);
histogram(f_peak_pre_even,edges,'Normalization','probability',...
       'EdgeColor','none','FaceColor',[0.9,0.1,0.1],'FaceAlpha',0.5);
hold on
histogram(f_peak_post_even,edges,'Normalization','probability',...
    'EdgeColor','none','FaceColor',[0.1,0.1,0.9],'FaceAlpha',0.5);
box off;
xlabel('Peak spatial attention frequency')
ylabel('Normalized frenquency')
xlim([0,10])
xticks(0:2:10)
legend({'pre','post'})
legend boxoff;
%%
[N_peak_pre_even,~] = histcounts(f_peak_pre_even,edges);
[N_peak_pre_odd,~] = histcounts(f_peak_pre_odd,edges);
[N_peak_post_even,~] = histcounts(f_peak_post_even,edges);
[N_peak_post_odd,~] = histcounts(f_peak_post_odd,edges);
p1 = chi2test([N_peak_pre_odd;N_peak_pre_even])

function p = chi2test(X)
    N = sum(X,'all');
    Y = zeros(size(X));
    for i = 1: size(X,1)
        for j = 1:size(X,2)
            Y(i,j) = sum(X(i,:))*sum(X(:,j))/N;
        end
    end
    chi2 = sum((X-Y).^2./Y,'all');
    df  = (size(X,1)-1)*(size(X,2)-1);
    p = chi2cdf(chi2,df,'upper');
end