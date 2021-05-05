function focus = makefocus(r)
width=2*r;
[X,Y]=meshgrid(1:width);
x0=width/2;
y0=width/2;
sigema=r/3;
focus=(exp(-1/(sigema^2*2)*((X-x0).^2+(Y-y0).^2))+1)/2;
focus=repmat(focus,1,1,3);
focus=uint8(focus*255);
end

