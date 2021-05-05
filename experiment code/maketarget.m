function target = maketarget(randomv,r,orientation,sf,phase,contrast,rr,contrast2)
width=2*r;
sigema=rr/3;
[X,Y]=meshgrid(1:width);
x0=width/2;
y0=width/2;
target=(sin((sind(orientation)*X+cosd(orientation)*Y)*2*pi/sf+phase)*contrast+1)*0.5;
mask=((X-x0).^2+(Y-y0).^2)<r*r;
idx=~mask;
mask=double(mask);
target=target.*mask;
target(idx)=0.5;
rtarget=(r-rr)*randomv;
atarget=randomv*2*pi;
xtarget=rtarget*cos(atarget)+x0;
ytarget=rtarget*sin(atarget)+y0;
Ga=exp(-1/(sigema^2*2)*((X-xtarget).^2+(Y-ytarget).^2));
idxx=((X-xtarget).^2+(Y-ytarget).^2)<rr*rr;
idxx=~idxx;
Ga(idxx)=0;
Ga=1-contrast2*Ga;
target=target.*Ga;
target=repmat(target,1,1,3);
target=uint8(target*255);
end

