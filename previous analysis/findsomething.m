% tempsignal_correction=tempsignal_correction_even;
[spec_left,spec,f]=data_analysis12(tempsignal_correction,500);
[spec_right,spec,f]=data_analysis34(tempsignal_correction,500); %#ok<*ASGLU>


function [ss,sspec,f]=data_analysis12(originalsignal,T)
fs=30;
% N=fs*0.8;
N=128;
f=(0:(N-1))*fs/N;
t=((1:N)/fs)'+0.2;
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
ss=mean(cat(3,spec1,spec2),3);
f=f';
end
function [ss,sspec,f]=data_analysis34(originalsignal,T)
fs=30;
% N=fs*0.8;
N=128;
f=(0:(N-1))*fs/N;
t=((1:N)/fs)'+0.2;
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
ss= mean(cat(3,spec1,spec2),3);
f=f';
end