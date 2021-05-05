%%
%初始化
clear all;                                                                  %#ok<*CLALL> %全部清空
KbName('UnifyKeyNames');                                                    %键盘标准化
Screen('Preference','SkipSyncTests',1);                                     %跳过自检
Screen('Preference','TextEncodingLocale','UTF-8');                          %encode中文
%%
%信息录入
prompt={'ID','Age','Handness','Gender'};
title='Subject Information';
dims=[1,55];
defineput={'999','999','999','999','999'};
SubjectInfo = inputdlg(prompt,title,dims,defineput,'on');
ID=str2double(SubjectInfo{1});
%%
%控制鼠标和键盘
ListenChar(2);
HideCursor;
%%
%尾号为奇数的被试做3Hz的，偶数做5Hz的
if(mod(ID,2))
    frequency=3;
else
    frequency=5;
end
blocktime=15;
%正式程序
try
    %%
    %初始化Screen
    screens=Screen('Screens');
    ScreenNum=max(screens);
    [win,rect]=Screen('OpenWindow',ScreenNum);
    Screen('TextFont',win,'-:lang=zh-cn');
    refresh=Screen('GetFlipInterval',win);
    slack=refresh/2;
    wx=rect(3);
    wy=rect(4);
    cx=wx/2;
    cy=wy/2;
    black=[0,0,0];
    white=[255,255,255];
    gray=[128 128 128];
    Screen('FillRect',win,gray);
    %%
    %呈现指导语
    DrawTextAt(win,'屏幕上将呈现两个图案，接下来灰点会交替出现在两个图案上',cx,cy-160,white)
    DrawTextAt(win,'请保持视线聚焦在中央注视点，对灰点出现的次数进行计数',cx,cy-80,white)
    DrawTextAt(win,'在一定时间后，会要求你对于灰点出现的次数进行口头报告，报告结果将影响被试费',cx,cy,white)
    DrawTextAt(win,'你可以采用打拍子或默念的方法辅助计数',cx,cy+80',white)
    DrawTextAt(win,'按z或m开始实验，请保持注意力集中',cx,cy+160,white)
    Screen('Flip',win);
    %按z或m继续
    keyz=KbName('z');
    keym=KbName('m');
    escape=KbName('escape');
    while 1
        [keyisDown,~,keyCode]=KbCheck();
        if keyCode(keyz)||keyCode(keym)
            break;
        end
    end
    %%
    %初始化大小
    INCH=15.6;                                                             %这个和电脑有关系!!!
    VDIST=57;
    PWIDTH=wx;
    ECC=deg2pix(5,INCH,PWIDTH,VDIST);
    Rgrating=deg2pix(2,INCH,PWIDTH,VDIST);
    Rfocus=deg2pix(0.25,INCH,PWIDTH,VDIST);
    Redge=deg2pix(3.5,INCH,PWIDTH,VDIST);
    Rdecrement=deg2pix(0.5,INCH,PWIDTH,VDIST);
    sf=deg2pix(1/1.4,INCH,PWIDTH,VDIST);
    contrast=1;
    correct=0;
    %%
    %正式trial
    focuspic=makefocus(Rfocus);
    focus=Screen('MakeTexture',win,focuspic);
    for i=1:20
%         catchtrail=round(round(rand(1,5)*blocktime*frequency*2)+1);
%         focusredpic=focuspic;
%         focusredpic(:,:,2)=0;
%         focusredpic(:,:,3)=0;
%         focusred=Screen('MakeTexture',win,focusredpic);
        Screen('DrawTexture',win,focus);
        vbl=Screen('Flip',win);
        rng shuffle;
        duration1=(1000+200*rand)/1000;
        orientationleft=rand*360;
        orientationright=rand*360;
        phaseleft0=rand*2*pi;
        phaseright0=rand*2*pi;
        lgratingpic=makegrating(Rgrating,orientationleft,sf,phaseleft0,1);
        rgratingpic=makegrating(Rgrating,orientationright,sf,phaseright0,1);
        lgrating=Screen('MakeTexture',win,lgratingpic);
        rgrating=Screen('MakeTexture',win,rgratingpic);
        grect=[0,0,2*Rgrating,2*Rgrating];
        lRect=CenterRectOnPoint(grect,cx-ECC,cy);
        rRect=CenterRectOnPoint(grect,cx+ECC,cy);
        Screen('DrawTexture',win,lgrating,[],lRect);
        Screen('DrawTexture',win,rgrating,[],rRect);
        Screen('DrawTexture',win,focus);
        vbl=Screen('Flip',win,vbl+duration1-slack);
        Screen('Close',lgrating);
        Screen('Close',rgrating);
        tphase0=GetSecs();
        for j=1:blocktime*frequency*2
            [keyisDown,~,keyCode]=KbCheck(); %#ok<*ASGLU>
            if keyCode(escape)
                break;
            end
%             idx=catchtrail==j;
%             flag=any(idx);
%             tempflag=0;
            if(mod(j,2))
                rng shuffle
                randomv=rand;
                phaseleft=phaseleft0+0.7*2*pi*(GetSecs()-tphase0+refresh);%可能会有问题
                phaseright=phaseright0+0.7*2*pi*(GetSecs()-tphase0+refresh);
                ltargetpic=maketarget(randomv,Rgrating,orientationleft,sf,phaseleft,1,Rdecrement,contrast);
                rgratingpic=makegrating(Rgrating,orientationright,sf,phaseright,1);
                ltarget=Screen('MakeTexture',win,ltargetpic);
                rgrating=Screen('MakeTexture',win,rgratingpic);
                Screen('DrawTexture',win,ltarget,[],lRect);
                Screen('DrawTexture',win,rgrating,[],rRect);
%                 if(flag)
%                     Screen('DrawTexture',win,focusred);
%                 else
                    Screen('DrawTexture',win,focus);
%                 end
                vbl=Screen('Flip',win,vbl-slack);
                Screen('Close',ltarget);
                Screen('Close',rgrating);
%                 [~,secs,keyCode]=KbCheck();
%                 if (keyCode(keyz))&&(flag)&&(tempflag==0)
%                     correct=correct+1;
%                     tempflag=1;
%                 end
                for k=1:4   %这个根据任务难度调一下,the other below
                    phaseleft=phaseleft0+0.7*2*pi*(GetSecs()-tphase0+refresh);
                    phaseright=phaseright0+0.7*2*pi*(GetSecs()-tphase0+refresh);
                    ltargetpic=maketarget(randomv,Rgrating,orientationleft,sf,phaseleft,1,Rdecrement,contrast);
                    rgratingpic=makegrating(Rgrating,orientationright,sf,phaseright,1);
                    ltarget=Screen('MakeTexture',win,ltargetpic);
                    rgrating=Screen('MakeTexture',win,rgratingpic);
                    Screen('DrawTexture',win,ltarget,[],lRect);
                    Screen('DrawTexture',win,rgrating,[],rRect);
%                     if(flag)
%                         Screen('DrawTexture',win,focusred);
%                     else
                        Screen('DrawTexture',win,focus);
%                     end
                    duration5=(16.7)/1000;
                    vbl=Screen('Flip',win,vbl+duration5-slack);
                    Screen('Close',ltarget);
                    Screen('Close',rgrating);
%                     [~,secs,keyCode]=KbCheck();
%                     if (keyCode(keyz))&&(flag)&&(tempflag==0)
%                         correct=correct+1;
%                         tempflag=1;
%                     end
                end
                tempt=GetSecs();
            else
                phaseleft=phaseleft0+0.7*2*pi*(GetSecs()-tphase0+refresh);%可能会有问题
                phaseright=phaseright0+0.7*2*pi*(GetSecs()-tphase0+refresh);
                rng shuffle
                randomv=rand;
                lgratingpic=makegrating(Rgrating,orientationleft,sf,phaseleft,1);
                rtargetpic=maketarget(randomv,Rgrating,orientationright,sf,phaseright,1,Rdecrement,contrast);
                lgrating=Screen('MakeTexture',win,lgratingpic);
                rtarget=Screen('MakeTexture',win,rtargetpic);
                Screen('DrawTexture',win,lgrating,[],lRect);
                Screen('DrawTexture',win,rtarget,[],rRect);
%                 if(flag)
%                     Screen('DrawTexture',win,focusred);
%                 else
                    Screen('DrawTexture',win,focus);
%                 end
                vbl=Screen('Flip',win,vbl-slack);
                Screen('Close',lgrating);
                Screen('Close',rtarget);
%                 [~,secs,keyCode]=KbCheck();
%                 if (keyCode(keym))&&(flag)&&(tempflag==0)
%                     correct=correct+1;
%                     tempflag=1;
%                 end
                for k=1:4
                    phaseleft=phaseleft0+0.7*2*pi*(GetSecs()-tphase0+refresh);%可能会有问题
                    phaseright=phaseright0+0.7*2*pi*(GetSecs()-tphase0+refresh);
                    lgratingpic=makegrating(Rgrating,orientationleft,sf,phaseleft,1);
                    rtargetpic=maketarget(randomv,Rgrating,orientationright,sf,phaseright,1,Rdecrement,contrast);
                    lgrating=Screen('MakeTexture',win,lgratingpic);
                    rtarget=Screen('MakeTexture',win,rtargetpic);
                    Screen('DrawTexture',win,lgrating,[],lRect);
                    Screen('DrawTexture',win,rtarget,[],rRect);
%                     if(flag)
%                         Screen('DrawTexture',win,focusred);
%                     else
                        Screen('DrawTexture',win,focus);
%                     end
                    duration5=(16.7)/1000;
                    vbl=Screen('Flip',win,vbl+duration5-slack);
                    Screen('Close',lgrating);
                    Screen('Close',rtarget);
%                     [~,secs,keyCode]=KbCheck();
%                     if (keyCode(keym))&&(flag)&&(tempflag==0)
%                         correct=correct+1;
%                         tempflag=1;
%                     end
                end
                tempt=GetSecs();
            end
            while((GetSecs()-tempt)<=(1/(2*frequency)))
                phaseleft=phaseleft0+0.7*2*pi*(GetSecs()-tphase0+refresh);%可能会有问题
                phaseright=phaseright0+0.7*2*pi*(GetSecs()-tphase0+refresh);
                lgratingpic=makegrating(Rgrating,orientationleft,sf,phaseleft,1);
                rgratingpic=makegrating(Rgrating,orientationright,sf,phaseright,1);
                lgrating=Screen('MakeTexture',win,lgratingpic);
                rgrating=Screen('MakeTexture',win,rgratingpic);
                Screen('DrawTexture',win,lgrating,[],lRect);
                Screen('DrawTexture',win,rgrating,[],rRect);
%                 if(flag)
%                     Screen('DrawTexture',win,focusred);
%                 else
                    Screen('DrawTexture',win,focus);
%                 end
                vbl=Screen('Flip',win,vbl+refresh-slack);
                Screen('Close',lgrating);
                Screen('Close',rgrating);
%                 if (keyCode(keym))&&(flag)&&(tempflag==0)&&(mod(j,2)==0)
%                     correct=correct+1;
%                     tempflag=1;
%                 elseif (keyCode(keym))&&(flag)&&(tempflag==0)&&(mod(j,2)==1)
%                     correct=correct+1;
%                     tempflag=1;
%                 end
            end
        end
        WaitSecs(0.5+rand());
        DrawTextAt(win,'Please Report',cx,cy-80,white)
        DrawTextAt(win,'Press z or m to continue，Attention!',cx,cy,white)
        Screen('Flip',win);
        while 1
            [keyisDown,~,keyCode]=KbCheck(); %#ok<ASGLU>
            if keyCode(keyz)||keyCode(keym)
                break;
            end
        end
        [keyisDown,~,keyCode]=KbCheck();
        if keyCode(escape)
            break;
        end
    end
    %%
    %正式程序截止
%     ACC=correct/100;
    sca;
    ListenChar(0);
    ShowCursor;
catch ME
    sca;
    ListenChar(0);
    ShowCursor;
    rethrow(ME);
end
