% for j=1:size(tempsignal,3)
%     figure
%     ttempsignal=tempsignal(:,:,j);
%     [t,spec,f,flag]=data_analysis2(ttempsignal,500,1);
%     subplot(2,2,1);
%     plot(f,spec);
%     hold on
%     plot(f,flag/20,'o');
%     [t,spec,f,flag]=data_analysis2(ttempsignal,500,2);
%     subplot(2,2,2);
%     plot(f,spec);
%     hold on
%     plot(f,flag/20,'o');
%     hold off
% end
figure
[temp,spec,f,flag]=data_analysis2(tempsignal,500,1,1);
subplot(2,2,1);
plot(f,spec);
hold on
plot(f,repmat(temp,size(f,1),1));
% plot(f,flag/10,'o');
[temp,spec,f,flag]=data_analysis2(tempsignal,500,2,1);
subplot(2,2,2);
plot(f,spec);
hold on
plot(f,repmat(temp,size(f,1),1));
% plot(f,flag/10,'o');
hold off
figure
[temp,spec,f,flag]=data_analysis2(tempsignal,500,1,2);
subplot(2,2,1);
plot(f,spec);
hold on
plot(f,repmat(temp,size(f,1),1));
% plot(f,flag/10,'o');
[temp,spec,f,flag]=data_analysis2(tempsignal,500,2,2);
subplot(2,2,2);
plot(f,spec);
hold on
plot(f,repmat(temp,size(f,1),1));
% plot(f,flag/10,'o');
hold off
