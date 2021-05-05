%% Entrainment Index

clear
load Amplitude.mat
fs = 30;
shift = 0.2;
N =64;
f = (0:N/2)*fs/N;
t = ((1:24)/fs)'+shift;

idx_odd = [1,2,5,8,11,13,16,19,21,23,25]; % odd
idx_even = [3,4,6,7,9,10,12,14,15,17,18,20,22,24]; % even

f_3 = [6, 7, 8, 9];
f_5 = [10,11,12,13];

Entrainment_post_even = sum(Amplitude_post_even(f_5,:),1);
Entrainment_post_odd = sum(Amplitude_post_odd(f_3,:),1);
Entrainment_pre_even = sum(Amplitude_pretest(f_5,idx_even),1);
Entrainment_pre_odd = sum(Amplitude_pretest(f_3,idx_odd),1);
Entrainment_Index_even = Entrainment_post_even ./ Entrainment_pre_even;
Entrainment_Index_odd = Entrainment_post_odd ./ Entrainment_pre_odd;

[h_odd,p_odd] = ttest(Entrainment_Index_odd,1,'Tail','Right');
[h_even,p_even] = ttest(Entrainment_Index_even,1,'Tail','Right');
[h,p] = ttest([Entrainment_Index_even,Entrainment_Index_odd],1,'Tail','Right');

%%
figure(2)
histogram([Entrainment_Index_even,Entrainment_Index_odd],13);
xline(1,'--r','LineWidth',1);
xlabel('Entrainment Index');
ylabel('Counts')
box off;
ylim([0,5]);
xlim([0,4])