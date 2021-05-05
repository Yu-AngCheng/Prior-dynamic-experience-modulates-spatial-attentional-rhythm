%%
%��ʼ��
clear all;                                                                  %#ok<*CLALL> %ȫ�����
KbName('UnifyKeyNames');                                                    %���̱�׼��
Screen('Preference','SkipSyncTests',1);                                     %�����Լ�
Screen('Preference','TextEncodingLocale','UTF-8');                          %encode����
%%
%��Ϣ¼��
prompt={'ID','Age','Handness','Gender'};
title='Subject Information';
dims=[1,55];
defineput={'999','999','999','999','999'};
SubjectInfo = inputdlg(prompt,title,dims,defineput,'on');
ID=str2double(SubjectInfo{1});
%%
%�������ͼ���
ListenChar(2);
HideCursor;
%%
%��ʽ����
try
    %%
    %��ʼ��Screen
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
    %����ָ����
    DrawTextAt(win,'��Ļ�Ͻ���������ͼ��������������ֻҵ�������һ��ͼ����',cx,cy-160,white)
    DrawTextAt(win,'�뱣�����߾۽�������ע�ӵ㣬�жϻҵ��������һ��ͼ����',cx,cy-80,white)
    DrawTextAt(win,'������밴z���ұ��밴m�����ֿ���׼���з�Ӧ',cx,cy,white)
    DrawTextAt(win,'��z��m��ʼʵ��',cx,cy+80',white)
    DrawTextAt(win,'�뱣��ע��������',cx,cy+160,white)
    Screen('Flip',win);
    %%
    %��z��m���� 
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
    %��ʼ����С
    INCH=15.6;                                                             %����͵����й�ϵ!!!
    VDIST=57;
    PWIDTH=wx;
    ECC=deg2pix(5,INCH,PWIDTH,VDIST);
    Rgrating=deg2pix(2,INCH,PWIDTH,VDIST);
    Rfocus=deg2pix(0.25,INCH,PWIDTH,VDIST);
    Redge=deg2pix(3.5,INCH,PWIDTH,VDIST);
    Rdecrement=deg2pix(0.5,INCH,PWIDTH,VDIST);
    sf=deg2pix(1/1.4,INCH,PWIDTH,VDIST);
    initial_contrast=0.8;                                                             %���׵�����ʲô
    %% Staircase Parameters
    pStaircase.nUps=1;                   %3-> ~80% success 2->~70% success 1->~50% ssuccess
    pStaircase.initStep =2;              % calculated from after Inital steps dropped
    pStaircase.nChanges=2;               % Num. of reversals after which the step size changes to 1.
    pStaircase.nPractice=3;
    pStaircase.conditionScale = 1;       % This identifies the type of the scale of conditions vector, 0 for linear; 1 for logarithm scale.
    pStaircase.nReversals=10;            % Num. of reversals to end the staircase
    pStaircase.nCalc =6;                 % Num. of reversals used for computing final threshold
    pStaircase.initSetup=initial_contrast;
    pStaircase.testCondition=10.^(-2:0.05:0);  % �����������Ҫ����
    pStaircase.step=pStaircase.testCondition(2)/pStaircase.testCondition(1);
    % Record the results of current data
    initValueIndex=find(pStaircase.testCondition>=(pStaircase.initSetup));
    history.testValue=pStaircase.testCondition(initValueIndex(1));
    history.isReversal=0;       % whether is a reversal
    history.correct=[];           % correct or not in this trial
    history.nUp=1;              % how many trials is accumulated to be correct
    history.UpOrDown=[];          % the trend of the psychometrics is up or down , only to calculate the reversals
    trial=0;
    reversal=0;
    correctSum=0;
    %%
    %��ʽtrial
    focuspic=makefocus(Rfocus);
    focus=Screen('MakeTexture',win,focuspic);
    while reversal<pStaircase.nReversals
        [keyisDown,~,keyCode]=KbCheck();
        if keyCode(escape)
            break;
        end
        trial=trial+1;
        currentContrast=history.testValue(trial);
        %Stage 1
        Screen('DrawTexture',win,focus);
        vbl=Screen('Flip',win);
        rng shuffle;duration1=(1000+200*rand)/1000;
        %Stage 2
        rng shuffle;
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
        rng shuffle;duration2=(1250+1250*rand)/1000;
        while((GetSecs()-tphase0)<=duration2)
            phaseleft=phaseleft0+0.7*2*pi*(GetSecs()-tphase0+refresh);%���ܻ�������
            phaseright=phaseright0+0.7*2*pi*(GetSecs()-tphase0+refresh);
            lgratingpic=makegrating(Rgrating,orientationleft,sf,phaseleft,1);
            rgratingpic=makegrating(Rgrating,orientationright,sf,phaseright,1);
            lgrating=Screen('MakeTexture',win,lgratingpic);
            rgrating=Screen('MakeTexture',win,rgratingpic);
            Screen('DrawTexture',win,lgrating,[],lRect);
            Screen('DrawTexture',win,rgrating,[],rRect);
            Screen('DrawTexture',win,focus);
            vbl=Screen('Flip',win,vbl+refresh-slack);
            Screen('Close',lgrating);
            Screen('Close',rgrating)
        end
        %Stage 5
        rng shuffle          %����������
        isleft=round(rand());    %����������
        if(isleft)
            phaseleft=phaseleft0+0.7*2*pi*(GetSecs()-tphase0+refresh);%���ܻ�������
            phaseright=phaseright0+0.7*2*pi*(GetSecs()-tphase0+refresh);
            rng shuffle
            randomv=rand;
            ltargetpic=maketarget(randomv,Rgrating,orientationleft,sf,phaseleft,1,Rdecrement,currentContrast);
            rgratingpic=makegrating(Rgrating,orientationright,sf,phaseright,1);
            ltarget=Screen('MakeTexture',win,ltargetpic);
            rgrating=Screen('MakeTexture',win,rgratingpic);
            Screen('DrawTexture',win,ltarget,[],lRect);
            Screen('DrawTexture',win,rgrating,[],rRect);
            Screen('DrawTexture',win,focus);
            vbl=Screen('Flip',win,vbl-slack);
            Screen('Close',ltarget);
            Screen('Close',rgrating);
            phaseleft=phaseleft0+0.7*2*pi*(GetSecs()-tphase0+refresh);%���ܻ�������
            phaseright=phaseright0+0.7*2*pi*(GetSecs()-tphase0+refresh);
            ltargetpic=maketarget(randomv,Rgrating,orientationleft,sf,phaseleft,1,Rdecrement,currentContrast);
            rgratingpic=makegrating(Rgrating,orientationright,sf,phaseright,1);
            ltarget=Screen('MakeTexture',win,ltargetpic);
            rgrating=Screen('MakeTexture',win,rgratingpic);
            Screen('DrawTexture',win,ltarget,[],lRect);
            Screen('DrawTexture',win,rgrating,[],rRect);
            Screen('DrawTexture',win,focus);
            duration5=(16.7)/1000;
            vbl=Screen('Flip',win,vbl+duration5-slack);
            Screen('Close',ltarget);
            Screen('Close',rgrating);
        else
            phaseleft=phaseleft0+0.7*2*pi*(GetSecs()-tphase0+refresh);%���ܻ�������
            phaseright=phaseright0+0.7*2*pi*(GetSecs()-tphase0+refresh);
            rng shuffle
            randomv=rand;
            lgratingpic=makegrating(Rgrating,orientationleft,sf,phaseleft,1);
            rtargetpic=maketarget(randomv,Rgrating,orientationright,sf,phaseright,1,Rdecrement,currentContrast);
            lgrating=Screen('MakeTexture',win,lgratingpic);
            rtarget=Screen('MakeTexture',win,rtargetpic);
            Screen('DrawTexture',win,lgrating,[],lRect);
            Screen('DrawTexture',win,rtarget,[],rRect);
            Screen('DrawTexture',win,focus);
            vbl=Screen('Flip',win,vbl-slack);
            Screen('Close',lgrating);
            Screen('Close',rtarget);
            phaseleft=phaseleft0+0.7*2*pi*(GetSecs()-tphase0+refresh);%���ܻ�������
            phaseright=phaseright0+0.7*2*pi*(GetSecs()-tphase0+refresh);
            lgratingpic=makegrating(Rgrating,orientationleft,sf,phaseleft,1);
            rtargetpic=maketarget(randomv,Rgrating,orientationright,sf,phaseright,1,Rdecrement,currentContrast);
            lgrating=Screen('MakeTexture',win,lgratingpic);
            rtarget=Screen('MakeTexture',win,rtargetpic);
            Screen('DrawTexture',win,lgrating,[],lRect);
            Screen('DrawTexture',win,rtarget,[],rRect);
            Screen('DrawTexture',win,focus);
            duration5=(16.7)/1000;
            vbl=Screen('Flip',win,vbl+duration5-slack);
            Screen('Close',lgrating);
            Screen('Close',rtarget);
        end
        %Stage6
        phaseleft=phaseleft0+0.7*2*pi*(GetSecs()-tphase0+refresh);%���ܻ�������
        phaseright=phaseright0+0.7*2*pi*(GetSecs()-tphase0+refresh);
        lgratingpic=makegrating(Rgrating,orientationleft,sf,phaseleft,1);
        rgratingpic=makegrating(Rgrating,orientationright,sf,phaseright,1);
        lgrating=Screen('MakeTexture',win,lgratingpic);
        rgrating=Screen('MakeTexture',win,rgratingpic);
        Screen('DrawTexture',win,lgrating,[],lRect);
        Screen('DrawTexture',win,rgrating,[],rRect);
        Screen('DrawTexture',win,focus);
        vbl=Screen('Flip',win,vbl+duration5-slack);
        Screen('Close',lgrating);
        Screen('Close',rgrating);
        while(1)
            %��׽������Ӧ isleft
            [~,secs,keyCode]=KbCheck();
            if ((keyCode(keyz))&&(isleft))||((keyCode(keym))&&(~isleft))
                thisCorrect=1;
                correctSum=correctSum+1;
                history.correct=[history.correct thisCorrect];
                history=staircaseUpdate(history, pStaircase, trial);
                reversal=sum(history.isReversal);
                break;
            elseif ((keyCode(keyz))&&(~isleft))||((keyCode(keym))&&(isleft))
                thisCorrect=0;
                history.correct=[history.correct thisCorrect];
                history=staircaseUpdate(history, pStaircase, trial);
                reversal=sum(history.isReversal);
                break;
            end
            phaseleft=phaseleft0+0.7*2*pi*(GetSecs()-tphase0+refresh);%���ܻ�������
            phaseright=phaseright0+0.7*2*pi*(GetSecs()-tphase0+refresh);
            lgratingpic=makegrating(Rgrating,orientationleft,sf,phaseleft,1);
            rgratingpic=makegrating(Rgrating,orientationright,sf,phaseright,1);
            lgrating=Screen('MakeTexture',win,lgratingpic);
            rgrating=Screen('MakeTexture',win,rgratingpic);
            Screen('DrawTexture',win,lgrating,[],lRect);
            Screen('DrawTexture',win,rgrating,[],rRect);
            Screen('DrawTexture',win,focus);
            vbl=Screen('Flip',win,vbl+refresh-slack);
            Screen('Close',lgrating);
            Screen('Close',rgrating);
        end
        Screen('Flip',win);
       
    end
    %%
    %��ʽ�����ֹ
    RevIndex=find(history.isReversal==1);
    RevValue=history.testValue(RevIndex);
    nRev=size(RevIndex,2);
    nCalc=nRev-6;
    if nRev>=10
        RevCalc=RevValue(end-nCalc+1:end);
    else
        RevCalc=RevValue(end-ceil(nRev*2/3)+1:end);
    end
    threshold = geomean(RevCalc);
    cd data;
    save(strcat(SubjectInfo{1},'_threshold.mat'),'threshold');                       %Ҫ��Ҫ��ô������
    cd ..;
    sca;
    ListenChar(0);
    ShowCursor;
catch ME
    sca;
    ListenChar(0);
    ShowCursor;
    rethrow(ME);
end
