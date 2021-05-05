function pic = makegrating(r,orientation,sf,phase,contrast)
width=2*r;
[X,Y]=meshgrid(1:width);
x0=width/2;
y0=width/2;
pic=(sin((sind(orientation)*X+cosd(orientation)*Y)*2*pi/sf+phase)*contrast+1)*0.5;
mask=((X-x0).^2+(Y-y0).^2)<r*r;
idx=~mask;
mask=double(mask);
pic=pic.*mask;
pic(idx)=0.5;
pic=repmat(pic,1,1,3);
pic=uint8(pic*255);
end

