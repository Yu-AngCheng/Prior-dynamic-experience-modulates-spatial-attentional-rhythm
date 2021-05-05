% for j=1:size(tempsignal_correction,3)
figure
% tempsignal=tempsignal_correction(:,:,j);
tempsignal=tempsignal_correction;
[t,spec,f,flag]=data_analysis1(tempsignal,500,1,1);
subplot(2,2,1);
plot(f,spec);
hold on
plot(f,flag/20,'o');
[t,spec,f,flag]=data_analysis1(tempsignal,500,2,1);
subplot(2,2,2);
plot(f,spec);
hold on
plot(f,flag/20,'o');
[t,spec,f,flag]=data_analysis1(tempsignal,500,3,1);
subplot(2,2,3);
plot(f,spec);
hold on
plot(f,flag/20,'o');
[t,spec,f,flag]=data_analysis1(tempsignal,500,4,1);
subplot(2,2,4);
plot(f,spec);
hold on
plot(f,flag/20,'o');
hold off
% end