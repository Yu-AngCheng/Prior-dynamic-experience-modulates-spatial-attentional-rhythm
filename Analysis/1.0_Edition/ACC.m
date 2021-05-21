clear
load pretest.mat
fs = 30;
shift = 0.2;
t = ((1:24)/fs)'+shift;

idx1 = ~isnan(tall_pretest(:,4)) & (tall_pretest(:,4) == tall_pretest(:,2));
idx2 = ~isnan(tall_pretest(:,4)) & (tall_pretest(:,4) ~= tall_pretest(:,2));
tall_pretest(idx1,4) = 1; tall_pretest(idx2,4) = 0;
C_IC = tall_pretest(:,1) == tall_pretest(:,2);
time_interval = tall_pretest(:,3)*1/fs+shift;
AC = tall_pretest(:,4);
[M_RT,G]=grpstats(AC,[C_IC],{'nanmean','gname'});G=str2double(G);
C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);
clear
load post_test_odd.mat
fs = 30;
shift = 0.2;
t = ((1:24)/fs)'+shift;
idx1 = ~isnan(tall_posttest(:,4)) & (tall_posttest(:,4) == tall_posttest(:,2));
idx2 = ~isnan(tall_posttest(:,4)) & (tall_posttest(:,4) ~= tall_posttest(:,2));
tall_posttest(idx1,4) = 1; tall_posttest(idx2,4) = 0;
C_IC = tall_posttest(:,1) == tall_posttest(:,2);
time_interval = tall_posttest(:,3)*1/fs+shift;
AC = tall_posttest(:,4);
[M_RT,G]=grpstats(AC,[C_IC],{'nanmean','gname'});G=str2double(G);
C_IC_RT = M_RT(1:length(M_RT)/2) - M_RT(length(M_RT)/2+1:end);


