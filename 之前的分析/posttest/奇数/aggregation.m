originalsignal=tempsignal_correction;
signal=[];
for k=1:size(originalsignal,3)
    [M,G]=grpstats(originalsignal(:,end,k),originalsignal(:,[1 3],k),{'nanmean','gname'});
    G=str2double(G);
    signal=cat(3,signal,[G,M]);
    signal(:,3,k)=detrend(signal(:,3,k),1);
end
    signal_sem=sqrt(nanvar(signal(:,3,:),[],3)/11);
    signal=nanmean(signal,3);
    