figure
set (gcf,'position',[100,100,400,200] )
time_interval = (200+100/3:100/3:1000)./1000;
y = ones(size(time_interval));
bar(time_interval,y,0.5,'EdgeColor','None','FaceColor',[1.0,0.6,0.6]);
xlabel('SOA (s)')
box off;
yticks([])
ylim([0,10])
xx = linspace(0.2,1.02);
f = 3;
phase = pi/2 - 2*pi*f*time_interval(1);
y = 2*sin(2*pi*f*xx+phase)+5;
hold on;
plot(xx,y,'k','LineWidth',1);
xlim([0.15,1.1])