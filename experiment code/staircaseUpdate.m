function history=staircaseUpdate(history, pStaircase, nTrials)

x=pStaircase.conditionScale;% x==0,linear; x==1,log;
a=pStaircase.step;

if nTrials>pStaircase.nPractice
    if sum(history.isReversal)>=pStaircase.nChanges
        thisStep=1;
    else
        thisStep=pStaircase.initStep;
    end

    if history.correct(nTrials)==1
        if history.nUp(nTrials) >= pStaircase.nUps
            history.nUp = [history.nUp 1];
            history.UpOrDown=[history.UpOrDown -1];
            nextTestValue=history.testValue(nTrials)/a^(x*thisStep)-a*(1-x)*thisStep;
        else
            history.nUp=[history.nUp history.nUp(nTrials)+1];
            nextTestValue = history.testValue(nTrials);
            if nTrials==pStaircase.nPractice+1
                history.UpOrDown=[history.UpOrDown 0];
            else
                history.UpOrDown=[history.UpOrDown history.UpOrDown(nTrials-1)];
            end
        end

    else
        history.nUp = [history.nUp 1];
        nextTestValue=history.testValue(nTrials)*a^(x*thisStep)+a*(1-x)*thisStep;
        history.UpOrDown=[history.UpOrDown 1];
    end

    %     history.isReversal(1)=0;
    if  nTrials~=pStaircase.nPractice+1
        if (history.UpOrDown(nTrials-1)+history.UpOrDown(nTrials)==0)&(history.UpOrDown(nTrials)~=0)
            history.isReversal=[history.isReversal 1];
        else
            history.isReversal=[history.isReversal 0];
        end
    end

else
    history.nUp = [history.nUp 1];
    history.UpOrDown=[history.UpOrDown 0];
    history.isReversal=[history.isReversal 0];
    nextTestValue = history.testValue(nTrials);

end

history.testValue=[history.testValue nextTestValue];
