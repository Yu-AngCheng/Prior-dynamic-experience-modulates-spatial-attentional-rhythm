figure
tempsignal_correction=pretesttraillist;
[temp,spec12,spec,f,flag]=data_analysis12(tempsignal_correction,500);
subplot(1,2,1);
plot(f,spec);
hold on
plot(f,repmat(temp,size(f,1),1));
[temp,spec34,spec,f,flag]=data_analysis34(tempsignal_correction,500); %#ok<*ASGLU>
subplot(1,2,2);
plot(f,spec);
hold on
plot(f,repmat(temp,size(f,1),1));
figure
[temp,spec1234,spec,f,flag]=data_analysis1234(tempsignal_correction,500);
plot(f,spec);
hold on
plot(f,repmat(temp,size(f,1),1));


function [temp,ss,sspec,f,flag]=data_analysis12(originalsignal,T)
fs=30;
% N=fs*0.8;
N=128;
f=(0:(N-1))*fs/N;
t=((1:N)/fs)'+0.2;
alpha=0.05;
spec1=zeros(N,size(originalsignal,3));
spec2=zeros(N,size(originalsignal,3));
parfor k=1:size(originalsignal,3)
    [M,G]=grpstats(originalsignal(:,end,k),originalsignal(:,[1 2 3],k),{'nanmean','gname'});
    signal=M;
    signal1=signal(1:24,:);%Ð´µÄºÃÆæ¹Ö°¡
    signal2=signal(25:48,:);
    signal1=detrend(signal1,1);
    signal2=detrend(signal2,1);
    FF1=fft(signal1,N);%²¹0
    FF2=fft(signal2,N);
    spec1(:,k)=abs(FF1)*2/N;
    spec2(:,k)=abs(FF2)*2/N;
%     spec1(1,k)=spec1(1,k)/2;%FFT·ùÖµ
%     spec2(1,k)=spec2(1,k)/2;
end
sspec1=mean(spec1,2);
sspec2=mean(spec2,2);
sspec=mean([sspec1,sspec2],2);
temp=zeros(N,T+1);
temp(:,1)=sspec;
ss=mean(cat(3,spec1,spec2),3);
parfor i=1:T
    temp_spec1=zeros(N,size(originalsignal,3));
    temp_spec2=zeros(N,size(originalsignal,3));
    for j=1:size(originalsignal,3)
        rng shuffle
        idx1=randperm(24);
        idx2=randperm(24);
        tsignal=sortrows(originalsignal(:,:,j),[1 2 3]);
        [M,G]=grpstats(tsignal(:,end),tsignal(:,[1 2 3]),{'nanmean','gname'});
        tsignal=M;
        tsignal1=tsignal(1:24,:);%Ð´µÄºÃÆæ¹Ö°¡
        tsignal2=tsignal(25:48,:);%Ð´µÄºÃÆæ¹Ö°¡
        tsignal1(:,:)=tsignal1(idx1,:);
        tsignal2(:,:)=tsignal2(idx2,:);
        tsignal1=detrend(tsignal1,1);
        tsignal2=detrend(tsignal2,1);
        temp_FF1=fft(tsignal1,N);%²¹0
        temp_FF2=fft(tsignal2,N);%²¹0
        temp_spec1(:,j)=abs(temp_FF1)*2/N;%FFT·ùÖµ
        temp_spec2(:,j)=abs(temp_FF2)*2/N;%FFT·ùÖµ
%         temp_spec1(1,j)=temp_spec1(1,j)/2;%FFT·ùÖµ
%         temp_spec2(1,j)=temp_spec2(1,j)/2;%FFT·ùÖµ
    end
    temp_sspec1=mean(temp_spec1,2);
    temp_sspec2=mean(temp_spec2,2);
    temp_sspec=mean([temp_sspec1,temp_sspec2],2);
    temp(:,i+1)=temp_sspec;
end
temp=sort(temp,2);
temp=temp(:,round(T*(1-alpha)));
temp=max(temp);
flag=sspec>=temp;
f=f';
end
function [temp,ss,sspec,f,flag]=data_analysis34(originalsignal,T)
fs=30;
% N=fs*0.8;
N=128;
f=(0:(N-1))*fs/N;
t=((1:N)/fs)'+0.2;
alpha=0.05;
spec1=zeros(N,size(originalsignal,3));
spec2=zeros(N,size(originalsignal,3));
parfor k=1:size(originalsignal,3)
    [M,G]=grpstats(originalsignal(:,end,k),originalsignal(:,[1 2 3],k),{'nanmean','gname'});
    signal=M;
    signal1=signal(49:72,:);%Ð´µÄºÃÆæ¹Ö°¡
    signal2=signal(73:96,:);
    signal1=detrend(signal1,1);
    signal2=detrend(signal2,1);
    FF1=fft(signal1,N);%²¹0
    FF2=fft(signal2,N);
    spec1(:,k)=abs(FF1)*2/N;
    spec2(:,k)=abs(FF2)*2/N;
%     spec1(1,k)=spec1(1,k)/2;%FFT·ùÖµ
%     spec2(1,k)=spec2(1,k)/2;
end
sspec1=mean(spec1,2);
sspec2=mean(spec2,2);
sspec=mean([sspec1,sspec2],2);
temp=zeros(N,T+1);
temp(:,1)=sspec;
ss= mean(cat(3,spec1,spec2),3);
parfor i=1:T
    temp_spec1=zeros(N,size(originalsignal,3));
    temp_spec2=zeros(N,size(originalsignal,3));
    for j=1:size(originalsignal,3)
        rng shuffle
        idx1=randperm(24);
        idx2=randperm(24);
        tsignal=sortrows(originalsignal(:,:,j),[1 2 3]);
        [M,G]=grpstats(tsignal(:,end),tsignal(:,[1 2 3]),{'nanmean','gname'});
        tsignal=M;
        tsignal1=tsignal(49:72,:);%Ð´µÄºÃÆæ¹Ö°¡
        tsignal2=tsignal(73:96,:);%Ð´µÄºÃÆæ¹Ö°¡
        tsignal1(:,:)=tsignal1(idx1,:);
        tsignal2(:,:)=tsignal2(idx2,:);
        tsignal1=detrend(tsignal1,1);
        tsignal2=detrend(tsignal2,1);
        temp_FF1=fft(tsignal1,N);%²¹0
        temp_FF2=fft(tsignal2,N);%²¹0
        temp_spec1(:,j)=abs(temp_FF1)*2/N;%FFT·ùÖµ
        temp_spec2(:,j)=abs(temp_FF2)*2/N;%FFT·ùÖµ
%         temp_spec1(1,j)=temp_spec1(1,j)/2;%FFT·ùÖµ
%         temp_spec2(1,j)=temp_spec2(1,j)/2;%FFT·ùÖµ
    end
    temp_sspec1=mean(temp_spec1,2);
    temp_sspec2=mean(temp_spec2,2);
    temp_sspec=mean([temp_sspec1,temp_sspec2],2);
    temp(:,i+1)=temp_sspec;
end
temp=sort(temp,2);
temp=temp(:,round(T*(1-alpha)));
temp=max(temp);
flag=sspec>=temp;
f=f';
end
function [temp,ss,sspec,f,flag]=data_analysis1234(originalsignal,T)
fs=30;
% N=fs*0.8;
N=128;
f=(0:(N-1))*fs/N;
t=((1:N)/fs)'+0.2;
alpha=0.05;
spec1=zeros(N,size(originalsignal,3));
spec2=zeros(N,size(originalsignal,3));
spec3=zeros(N,size(originalsignal,3));
spec4=zeros(N,size(originalsignal,3));
parfor k=1:size(originalsignal,3)
    [M,G]=grpstats(originalsignal(:,end,k),originalsignal(:,[1 2 3],k),{'nanmean','gname'});
    signal=M;
    signal1=signal(1:24,:);%Ð´µÄºÃÆæ¹Ö°¡
    signal2=signal(25:48,:);
    signal3=signal(49:72,:);%Ð´µÄºÃÆæ¹Ö°¡
    signal4=signal(73:96,:);
    signal1=detrend(signal1,1);
    signal2=detrend(signal2,1);
    signal3=detrend(signal3,1);
    signal4=detrend(signal4,1);
    FF1=fft(signal1,N);%²¹0
    FF2=fft(signal2,N);
    FF3=fft(signal3,N);
    FF4=fft(signal4,N);
    spec1(:,k)=abs(FF1)*2/N;
    spec2(:,k)=abs(FF2)*2/N;
    spec3(:,k)=abs(FF3)*2/N;
    spec4(:,k)=abs(FF4)*2/N;
%     spec1(1,k)=spec1(1,k)/2;%FFT·ùÖµ
%     spec2(1,k)=spec2(1,k)/2;
%     spec3(1,k)=spec3(1,k)/2;%FFT·ùÖµ
%     spec4(1,k)=spec4(1,k)/2;
end
ss=mean(cat(3,spec1,spec2,spec3,spec4),3);
sspec1=mean(spec1,2);
sspec2=mean(spec2,2);
sspec3=mean(spec3,2);
sspec4=mean(spec4,2);
sspec=mean([sspec1,sspec2,sspec3,sspec4],2);
temp=zeros(N,T+1);
temp(:,1)=sspec;
parfor i=1:T
    temp_spec1=zeros(N,size(originalsignal,3));
    temp_spec2=zeros(N,size(originalsignal,3));
    temp_spec3=zeros(N,size(originalsignal,3));
    temp_spec4=zeros(N,size(originalsignal,3));
    for j=1:size(originalsignal,3)
        rng shuffle
        idx1=randperm(24);
        idx2=randperm(24);
        idx3=randperm(24);
        idx4=randperm(24);
        tsignal=sortrows(originalsignal(:,:,j),[1 2 3]);
        [M,G]=grpstats(tsignal(:,end),tsignal(:,[1 2 3]),{'nanmean','gname'});
        tsignal=M;
        tsignal1=tsignal(1:24,:);%Ð´µÄºÃÆæ¹Ö°¡
        tsignal2=tsignal(25:48,:);%Ð´µÄºÃÆæ¹Ö°¡
        tsignal3=tsignal(49:72,:);%Ð´µÄºÃÆæ¹Ö°¡
        tsignal4=tsignal(73:96,:);%Ð´µÄºÃÆæ¹Ö°¡
        tsignal1(:,:)=tsignal1(idx1,:);
        tsignal2(:,:)=tsignal2(idx2,:);
        tsignal3(:,:)=tsignal3(idx3,:);
        tsignal4(:,:)=tsignal4(idx4,:);
        tsignal1=detrend(tsignal1,1);
        tsignal2=detrend(tsignal2,1);
        tsignal3=detrend(tsignal3,1);
        tsignal4=detrend(tsignal4,1);
        temp_FF1=fft(tsignal1,N);%²¹0
        temp_FF2=fft(tsignal2,N);%²¹0
        temp_FF3=fft(tsignal3,N);%²¹0
        temp_FF4=fft(tsignal4,N);%²¹0
        temp_spec1(:,j)=abs(temp_FF1)*2/N;%FFT·ùÖµ
        temp_spec2(:,j)=abs(temp_FF2)*2/N;%FFT·ùÖµ
        temp_spec3(:,j)=abs(temp_FF3)*2/N;%FFT·ùÖµ
        temp_spec4(:,j)=abs(temp_FF4)*2/N;%FFT·ùÖµ
%         temp_spec1(1,j)=temp_spec1(1,j)/2;%FFT·ùÖµ
%         temp_spec2(1,j)=temp_spec2(1,j)/2;%FFT·ùÖµ
%         temp_spec3(1,j)=temp_spec3(1,j)/2;%FFT·ùÖµ
%         temp_spec4(1,j)=temp_spec4(1,j)/2;%FFT·ùÖµ
    end
    temp_sspec1=mean(temp_spec1,2);
    temp_sspec2=mean(temp_spec2,2);
    temp_sspec3=mean(temp_spec3,2);
    temp_sspec4=mean(temp_spec4,2);    
    temp_sspec=mean([temp_sspec1,temp_sspec2,temp_sspec3,temp_sspec4],2);
    temp(:,i+1)=temp_sspec;
end
temp=sort(temp,2);
temp=temp(:,round(T*(1-alpha)));
temp=max(temp);
flag=sspec>=temp;
f=f';
end