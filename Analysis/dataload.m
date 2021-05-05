%% importdata data
clear
preorpost="pre";
if(preorpost=="pre")
    tall_pretest=[];
    width_pretest=[];
    for subjects=100:998
        filename=num2str(subjects)+"_pretest.mat";
        if(exist(filename,'file'))
            file=importdata(filename);
            tall_pretest=cat(1,tall_pretest,file);
            width_pretest=cat(3,width_pretest,file);
            clear file;
        end
    end
elseif(preorpost=="post")
    tall_posttest=[];
    width_posttest=[];
    for subjects=100:998
        filename1=num2str(subjects)+"_posttest1.mat";
        filename2=num2str(subjects)+"_posttest1.mat";
        if(exist(filename1,'file')&&exist(filename2,'file'))
            file1=importdata(filename1);
            file2=importdata(filename2);
            file=[file1;file2];
            clear file1 file2;
            tall_posttest=cat(1,tall_posttest,file);
            width_posttest=cat(3,width_posttest,file);
            clear file;
        end  
    end
end