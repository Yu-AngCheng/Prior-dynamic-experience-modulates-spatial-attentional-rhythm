function [temp,sspec,f,flag]=data_analysis2(originalsignal,T,type1,type2)
%1是criteria
%2是sensitivity
fs=30;
N=128;
f=(0:(N-1))*fs/N;
t=((1:N)/fs)'+0.2;
alpha=0.05;
spec=zeros(N,size(originalsignal,3));
for k=1:size(originalsignal,3)
    [M,G]=grpstats(originalsignal(:,end,k),originalsignal(:,[1 2 3],k),{'nanmean','gname'});
    G=str2double(G);
    signal=[G,M];
    signal=signal(48*type1-47:48*type1,:);%写的好奇怪啊
    signal(:,3)=signal(:,3)*1/fs+0.2;
    ttt=signal(1:24,4);
%     ttt=smoothdata(ttt,'movmean',3);
    signal(1:24,4)=ttt;
    ttt=signal(25:48,4);
%     ttt=smoothdata(ttt,'movmean',3);
    signal(25:48,4)=ttt;
    if(type2==1)
        for z=1:24
            a=norminv(signal(z,4));
            if(a==Inf)
                a=3;
            elseif(a==-Inf)
                a=-3;
            end
            b=norminv(signal(z+24,4));
            if(b==Inf)
                b=3;
            elseif(b==-Inf)
                b=-3;
            end
            signal_mean(z)=-0.5*(a+b);
        end
    elseif(type2==2)
        for z=1:24
            a=norminv(signal(z,4));
            if(a==Inf)
                a=3;
            elseif(a==-Inf)
                a=-3;
            end
            b=norminv(signal(z+24,4));
            if(b==Inf)
                b=3;
            elseif(b==-Inf)
                b=-3;
            end
            signal_mean(z)=(a-b)/sqrt(2);
        end
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
    temp_spec=zeros(N,size(originalsignal,3));
    for j=1:size(originalsignal,3)
        rng shuffle
        idx=randperm(24);
        idxx=randperm(24)+24;
        tsignal=sortrows(originalsignal(:,:,j),[1 2 3]);
        tsignal=tsignal(480*type1-479:480*type1,:);
        [M,G]=grpstats(tsignal(:,end),tsignal(:,[1 2 3]),{'nanmean','gname'});
        G=str2double(G);
        tsignal=[G,M];
        temp_signal(1:24,:)=tsignal(idx,:);
        temp_signal(25:48,:)=tsignal(idxx,:);
        temp_signal(:,3)=tsignal(:,3);
        ttt=temp_signal(1:24,4);
%         ttt=smoothdata(ttt,'movmean',3);
        temp_signal(1:24,4)=ttt;
        ttt=temp_signal(25:48,4);
%         ttt=smoothdata(ttt,'movmean',3);
        temp_signal(25:48,4)=ttt;
        if(type2==1)
            for z=1:24
                a=norminv(temp_signal(z,4));
                if(a==Inf)
                    a=3;
                elseif(a==-Inf)
                    a=-3;
                end
                b=norminv(temp_signal(z+24,4));
                if(b==Inf)
                    b=3;
                elseif(b==-Inf)
                    b=-3;
                end
                temp_signal_mean(z)=-0.5*(a+b);
            end
        elseif(type2==2)
            for z=1:24
                a=norminv(temp_signal(z,4));
                if(a==Inf)
                    a=3;
                elseif(a==-Inf)
                    a=-3;
                end
                b=norminv(temp_signal(z+24,4));
                if(b==Inf)
                    b=3;
                elseif(b==-Inf)
                    b=-3;
                end
                temp_signal_mean(z)=(a-b)/sqrt(2);
            end
        end
        temp_signal_mean=detrend(temp_signal_mean,1);
        temp_FF=fft(temp_signal_mean,N);%补0
        temp_spec(:,j)=abs(temp_FF)*2/N;%FFT幅值
        temp_spec(1,j)=temp_spec(1,j)/2;%FFT幅值
    end
        temp_sspec=nanmean(temp_spec,2);
        temp(:,i+1)=temp_sspec;
end
%%
temp=sort(temp,2);
temp=temp(:,round(T*(1-alpha)));
temp=max(temp);
%%
% temp=max(temp);
% temp=sort(temp);
% temp=temp(:,round(T*(1-alpha)));
%%
flag=sspec>=temp;
f=f';
end
