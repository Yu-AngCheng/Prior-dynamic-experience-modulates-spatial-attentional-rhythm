function pixs=deg2pix(Degree,Inch,Pwidth,Vdist)
    ScreenWidth=Inch*2.54/5*4;
    Pixpercm=Pwidth/ScreenWidth;
    pixs=2*tand(Degree/2)*Vdist*Pixpercm;
    pixs=round(pixs);
end