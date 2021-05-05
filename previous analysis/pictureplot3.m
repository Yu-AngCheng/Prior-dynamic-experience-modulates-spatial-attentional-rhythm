figure
tic
[criterion,Amplitude,f,flag]=data_analysis3(tempsignal,1,1,1); %#ok<*ASGLU>
toc
subplot(2,2,1);
plot(f,Amplitude);
hold on
plot(f,repmat(criterion,size(f,1),1));
% plot(f,flag/10,'o');
[criterion,Amplitude,f,flag]=data_analysis3(tempsignal,1,2,1);
subplot(2,2,2);
plot(f,Amplitude);
hold on
plot(f,repmat(criterion,size(f,1),1));
% plot(f,flag/10,'o');
hold off
figure
[criterion,Amplitude,f,flag]=data_analysis3(tempsignal,1,1,2);
subplot(2,2,1);
plot(f,Amplitude);
hold on
plot(f,repmat(criterion,size(f,1),1));
% plot(f,flag/10,'o');
[criterion,Amplitude,f,flag]=data_analysis3(tempsignal,1,2,2);
subplot(2,2,2);
plot(f,Amplitude);
hold on
plot(f,repmat(criterion,size(f,1),1));
% plot(f,flag/10,'o');
hold off
