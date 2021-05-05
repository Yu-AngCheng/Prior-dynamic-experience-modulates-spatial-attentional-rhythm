clear
load pretest_pool.mat
isCongruent = width_pretest(:,1,:) == width_pretest(:,2,:);
TimeInterval = width_pretest(:,3,:);
isCorrect = width_pretest(:,4,:);
nsubs = 30;
for sub = 1:nsubs
    [temp,grouptemp] = grpstats(isCorrect(:,:,sub),[isCongruent(:,:,sub),TimeInterval(:,:,sub)],{'nanmean','gname'});
    pretest(:,[1,2],sub) = str2double(grouptemp);
    pretest(:,3,sub) = temp;
end
Fs = 30;
time = 0.2:1/Fs:1-1/Fs;
L = length(time);
f = Fs*(0:(L/2))/L;
for sub = 1:nsubs
    X = squeeze(pretest(1:24,3,sub) - pretest(25:48,3,sub));
    X = detrend(smoothdata(X,'gaussian',2),1);
    amplitude(:,sub) = X;
end