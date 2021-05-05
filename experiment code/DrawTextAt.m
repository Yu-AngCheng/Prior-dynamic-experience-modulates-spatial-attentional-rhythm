function DrawTextAt(win,str,x,y,color)
width=Screen('TextBounds',win,str);
Screen('DrawText',win,double(str),x-width(3)/2,y-width(4)/2,color);
end

