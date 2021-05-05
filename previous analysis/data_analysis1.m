function [t,sspec,f,flag]=data_analysis1(originalsignal,T,type1,type2)
%signal为columns,第一列为时间（记得要排序），
%这里有问题，没有取从0到1的，还是要调整
%第二列为正确或错误，same or opposite的数据分别计入
%每一页是一个被试
%已经采用了Bonferroni correction
fs=30;
% N=fs*0.8;
N=64;
f=(0:(N-1))*fs/N;
t=((1:N)/fs)'+0.2;
alpha=0.05;
spec=zeros(N,size(originalsignal,3));
for k=1:size(originalsignal,3)
    [M,G]=grpstats(originalsignal(:,end,k),originalsignal(:,[1 2 3],k),{'nanmean','gname'});
    G=str2double(G);
    signal=[G,M];
    signal=signal(24*type1-23:24*type1,:);%写的好奇怪啊
    signal(:,3)=signal(:,3)*1/fs+0.2;
    signal_mean=signal(:,4);
    signal_mean=smoothdata(signal_mean,'movmean',3);
    if(type2==2)
        signal_mean=norminv(signal_mean)*sqrt(2);
    end
    signal_mean=detrend(signal_mean,1);
    FF=fft(signal_mean,N);%补0
    spec(:,k)=abs(FF)*2/N;
    spec(1,k)=spec(1,k)/2;%FFT幅值
end
% signal=mean(signal,3);
% alpha=0.05/N;
% w = hanning (N,'periodic');
% signal_mean=mean(signal,3);
% signal_hanning = w.*(signal_mean(:,2));%加汉宁窗
sspec=nanmean(spec,2);
temp=zeros(N,T+1);
temp(:,1)=sspec;
for i=1:T
%     temp_signal=zeros(N,4,size(originalsignal,3));
    temp_spec=zeros(N,size(originalsignal,3));
    for j=1:size(originalsignal,3)
        rng shuffle
        idx=randperm(24);
        tsignal=sortrows(originalsignal(:,:,j),[1 2 3]);
        tsignal=tsignal(240*type1-239:240*type1,:);
        [M,G]=grpstats(tsignal(:,end),tsignal(:,[1 2 3]),{'nanmean','gname'});
        G=str2double(G);
        tsignal=[G,M];
        temp_signal(:,:)=tsignal(idx,:);
        temp_signal(:,3)=tsignal(:,3);
        temp_signal_mean=temp_signal(:,4);
        temp_signal_mean=smoothdata(temp_signal_mean,'movmean',3);
        if(type2==2)
            temp_signal_mean=norminv(temp_signal_mean)*sqrt(2);
        end
        temp_signal_mean=detrend(temp_signal_mean,1);
        temp_FF=fft(temp_signal_mean,N);%补0
        temp_spec(:,j)=abs(temp_FF)*2/N;%FFT幅值
        temp_spec(1,j)=temp_spec(1,j)/2;%FFT幅值
    end
%     temp_signal_mean=mean(temp_signal,3);
        temp_sspec=nanmean(temp_spec,2);
        temp(:,i+1)=temp_sspec;
end
% temp=temp(:);
% temp=sort(temp);
% flag=sspec>=temp(round(size(temp,1)*(1-alpha)));
temp=sort(temp,2);
temp=max(temp(:,round(T*(1-alpha))));
flag=sspec>=temp;
f=f';
end
