function [temp_temp,temp,f,flag]=data_analysis3(originalsignal,T,type1,type2)
%1是criteria
%2是sensitivity
alpha=0.05;
fs=30;

if(type2==1)
    startpoint=6;
    endpoint=12;
elseif(type2==2)
    startpoint=5;
    endpoint=9;
end
step=0.2;
total=(endpoint-startpoint)/step+1;
f=startpoint:step:endpoint;
coefficient=zeros(2,total,size(originalsignal,3));
num=0;
for frequency=startpoint:step:endpoint
    num=num+1;
    parfor k=1:size(originalsignal,3)
        [M,G]=grpstats(originalsignal(:,end,k),originalsignal(:,[1 2 3],k),{'nanmean','gname'});
        G=str2double(G);
        signal=[G,M];
        signal=signal(48*type1-47:48*type1,:);%写的好奇怪啊
        signal(:,3)=signal(:,3)*1/fs+0.2;
        
        ttt=signal(1:24,4);
        ttt=smoothdata(ttt,'movmean',3);
        signal(1:24,4)=ttt;
        ttt=signal(25:48,4);
        ttt=smoothdata(ttt,'movmean',3);
        signal(25:48,4)=ttt;
        
        signal(signal(:,2)==2,2)=-1;
        signal_mean=zeros(24,1);
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
        X=[sin(2*pi*frequency*signal(:,3)),cos(2*pi*frequency*signal(:,3)),signal(:,2)];
        mdl=fitlm(X(1:24,:),signal_mean');
        coefficient(:,num,k)=mdl.Coefficients.Estimate([2 3]);
    end
end
coefficient=nanmean(coefficient,3);

temp=zeros(2,total,T+1);
temp(:,:,1)=coefficient;

parfor i=1:T
    num=0;
    for frequency=startpoint:step:endpoint
        temp_coefficient=zeros(2,total,size(originalsignal,3));
        num=num+1;
        for j=1:size(originalsignal,3)
            rng shuffle
            idx=randperm(24);
            idxx=randperm(24)+24;
            tsignal=sortrows(originalsignal(:,:,j),[1 2 3]);
            tsignal=tsignal(480*type1-479:480*type1,:);
            [M,G]=grpstats(tsignal(:,end),tsignal(:,[1 2 3]),{'nanmean','gname'});
            G=str2double(G);
            tsignal=[G,M];
            temp_signal=zeros(48,4);
            temp_signal(1:24,:)=tsignal(idx,:);
            temp_signal(25:48,:)=tsignal(idxx,:);
            temp_signal(:,3)=tsignal(:,3)*1/fs+0.2;
            
            ttt=temp_signal(1:24,4);
            ttt=smoothdata(ttt,'movmean',3);
            temp_signal(1:24,4)=ttt;
            ttt=temp_signal(25:48,4);
            ttt=smoothdata(ttt,'movmean',3);
            temp_signal(25:48,4)=ttt;
            
            temp_signal(temp_signal(:,2)==2,2)=-1;

            temp_signal_mean=zeros(24,1);
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
            temp_X=[sin(2*pi*frequency*temp_signal(:,3)),cos(2*pi*frequency*temp_signal(:,3)),temp_signal(:,2)];
            temp_mdl=fitlm(temp_X(1:24,:),temp_signal_mean');
            temp_coefficient(:,num,j)=temp_mdl.Coefficients.Estimate([2 3]);
        end
    end
    temp_coefficient=nanmean(temp_coefficient,3);
    temp(:,:,i+1)=temp_coefficient;
end
%%
temp(3,:,:)=temp(1,:,:).^2+temp(2,:,:).^2;
temp_temp=temp(3,:,2:T+1);
temp_temp=squeeze(temp_temp);
temp_temp=sort(temp_temp,2);
temp_temp=temp_temp(:,round(T*(1-alpha)));
temp_temp=max(temp_temp);
%%
%
%
%
%%
flag=temp(3,:,1)>=temp_temp;
temp=temp(3,:,1);
f=f';
end
