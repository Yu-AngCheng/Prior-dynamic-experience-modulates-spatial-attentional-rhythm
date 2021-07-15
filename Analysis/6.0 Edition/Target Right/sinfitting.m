function [rsquare,fitObj] = sinfitting(x,y,f)
    for iRun = 1:100
        fo = fitoptions('Method','LinearLeastSquares',...
                'Lower', [0, -1, -1],...
                'Upper', [1,  1, 1]);
        ft = fittype('c+a*sin(f*x)+b*cos(f*x)', 'options', fo,...
            'independent', 'x','dependent','y','problem','f');
        [fitObj_tmp{iRun}, gof] = fit(x, y, ft);
        rsquare_temp(iRun) = gof.rsquare;
    end
    [rsquare, idx_opt] = max(rsquare_temp);fitObj = fitObj_tmp{idx_opt};
end

