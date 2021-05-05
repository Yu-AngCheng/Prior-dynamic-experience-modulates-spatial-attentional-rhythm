originalsignal=tempsignal;
for k=1:size(originalsignal,3)
    idx=originalsignal(:,4,k)==0;
    idxx=isnan(originalsignal(:,4,k));
    originalsignal(idx,4,k)=2;
    originalsignal(:,4,k)=double(originalsignal(:,4,k)==originalsignal(:,2,k));
    originalsignal(idxx,4,k)=NaN;
end
tempsignal_correction=originalsignal;