%This checks the relationships between overall activity (i.e. is it going up of down) between our components. You
%will need to create The 'Linear DR Relationships' folder yourself and also the subfolder containing the pre-sorted, 
%correctly sourced DR1 files. i.e. Take the DR1 files from the dual regression PL folder, files
% 49:64 ! 


cd  /Users/joshuamarden/University_Work/4th_Year_Neuroscience/Research_Project/Data/BRCOPT_preprocessed_Working/Linear_DR_Relationships/DR_PL


    % Change the cd dir by hand to run for NB, IV and IN

    %Group = 1:16 IN
    %Group2 = 17:32 IV
    %Group3 = 33:48 NB
    %Group4 = 49:64 PL


folderInfo=dir('dr_stage1*.txt'); % find all timecourse files within this directory
for i=1:size(folderInfo,1)  %Loop through each subject/condition
    tempData=load(folderInfo(i).name); %Load the timecourse data for each 64 subject/condition
    
    constantDesign=ones(40,1);
    linearDesign=zscore([1:40]');
    quadDesign=zscore([-19:20]'.^2);
    %stepDesign=[zeros(1,20) ones(1,20)];
    DesignMatrix=[constantDesign linearDesign quadDesign];
    for j=1:6
        b=regress(tempData(:,j) , DesignMatrix);
        LinearBeta(i,j)=b(2);
        QuadBeta(i,j)=b(3);
        
    end    
end


%All subjects/conditions stats for linear relationship
[aa,bb,cc,dd]=ttest(ConstantBeta);
AllSubConConstantRelationshipTStat=dd.tstat
AllSubConConstantRelationshipPStatNonC=bb

[aa,bb,cc,dd]=ttest(LinearBeta);
AllSubConLinearRelationshipTStat=dd.tstat
AllSubConLinearRelationshipPStatNonC=bb

[aa,bb,cc,dd]=ttest(QuadBeta);
AllSubConQuadRelationshipTStat=dd.tstat
AllSubConQuadRelationshipPStatNonC=bb


%All subjects/conditions stats for linear relationship



Conditions = {'PL', 'IV', 'IN', 'NB'} ;
%ConditionNumbers = {'49:64', '17:32', '1:16', '33:48'}

SourceDir = '/Users/joshuamarden/University_Work/4th_Year_Neuroscience/Research_Project/Data/BRCOPT_preprocessed_Working/Linear_DR_Relationships' ;

for Condition = 1:length(Conditions)

    mkdir([SourceDir, '/Base_Files']) 
end

%----------------------------------------
%     Linear Trends PL vs ...
%----------------------------------------


OutputDir = ([SourceDir, '/Base_Files'])

%-------vsPL


[aa,bb,cc,dd]=ttest2(LinearBeta(49:64,:),(LinearBeta(49:64,:)));
PLVersusPLSubConLinearRelationshipTStat=dd.tstat
PLVersusPLSubConLinearRelationshipPStatNonC=bb
PLVersusPLSubConLinearRelationshipPStatBFC=bb*15


csvwrite([OutputDir, '/PLVersusPLSubConLinearRelationshipTStat.csv'],PLVersusPLSubConLinearRelationshipTStat);
csvwrite([OutputDir, '/PLVersusPLSubConLinearRelationshipPStatNonC.csv'],PLVersusPLSubConLinearRelationshipPStatNonC);
csvwrite([OutputDir, '/PLVersusPLSubConLinearRelationshipPStatBFC.csv'],PLVersusPLSubConLinearRelationshipPStatBFC);


%-------vsIV

[aa,bb,cc,dd]=ttest2(LinearBeta(49:64,:),(LinearBeta(17:32,:)));
PLVersusIVSubConLinearRelationshipTStat=dd.tstat
PLVersusIVSubConLinearRelationshipPStatNonC=bb
PLVersusIVSubConLinearRelationshipPStatBFC=bb*15


csvwrite([OutputDir, '/PLVersusIVSubConLinearRelationshipTStat.csv'],PLVersusIVSubConLinearRelationshipTStat);
csvwrite([OutputDir, '/PLVersusIVSubConLinearRelationshipPStatNonC.csv'],PLVersusIVSubConLinearRelationshipPStatNonC);
csvwrite([OutputDir, '/PLVersusIVSubConLinearRelationshipPStatBFC.csv'],PLVersusIVSubConLinearRelationshipPStatBFC);


%-------vsIN

[aa,bb,cc,dd]=ttest2(LinearBeta(49:64,:),(LinearBeta(1:16,:)));
PLVersusINSubConLinearRelationshipTStat=dd.tstat
PLVersusINSubConLinearRelationshipPStatNonC=bb
PLVersusINSubConLinearRelationshipPStatBFC=bb*15


csvwrite([OutputDir, '/PLVersusINSubConLinearRelationshipTStat.csv'],PLVersusINSubConLinearRelationshipTStat);
csvwrite([OutputDir, '/PLVersusINSubConLinearRelationshipPStatNonC.csv'],PLVersusINSubConLinearRelationshipPStatNonC);
csvwrite([OutputDir, '/PLVersusINSubConLinearRelationshipPStatBFC.csv'],PLVersusINSubConLinearRelationshipPStatBFC);


%-------vsNB

[aa,bb,cc,dd]=ttest2(LinearBeta(49:64,:),(LinearBeta(33:48,:)));
PLVersusNBSubConLinearRelationshipTStat=dd.tstat
PLVersusNBSubConLinearRelationshipPStatNonC=bb
PLVersusNBSubConLinearRelationshipPStatBFC=bb*15


csvwrite([OutputDir, '/PLVersusNBSubConLinearRelationshipTStat.csv'],PLVersusNBSubConLinearRelationshipTStat);
csvwrite([OutputDir, '/PLVersusNBSubConLinearRelationshipPStatNonC.csv'],PLVersusNBSubConLinearRelationshipPStatNonC);
csvwrite([OutputDir, '/PLVersusNBSubConLinearRelationshipPStatBFC.csv'],PLVersusNBSubConLinearRelationshipPStatBFC);


%----------------------------------------
%      Linear Trends IV vs ...
%----------------------------------------



OutputDir = ([SourceDir, '/Base_Files'])

%-------vsPL


[aa,bb,cc,dd]=ttest2(LinearBeta(17:32,:),(LinearBeta(49:64,:)));
IVVersusPLSubConLinearRelationshipTStat=dd.tstat
IVVersusPLSubConLinearRelationshipPStatNonC=bb
IVVersusPLSubConLinearRelationshipPStatBFC=bb*15


csvwrite([OutputDir, '/IVVersusPLSubConLinearRelationshipTStat.csv'],IVVersusPLSubConLinearRelationshipTStat);
csvwrite([OutputDir, '/IVVersusPLSubConLinearRelationshipPStatNonC.csv'],IVVersusPLSubConLinearRelationshipPStatNonC);
csvwrite([OutputDir, '/IVVersusPLSubConLinearRelationshipPStatBFC.csv'],IVVersusPLSubConLinearRelationshipPStatBFC);


%-------vsIV

[aa,bb,cc,dd]=ttest2(LinearBeta(17:32,:),(LinearBeta(17:32,:)));
IVVersusIVSubConLinearRelationshipTStat=dd.tstat
IVVersusIVSubConLinearRelationshipPStatNonC=bb
IVVersusIVSubConLinearRelationshipPStatBFC=bb*15



csvwrite([OutputDir, '/IVVersusIVSubConLinearRelationshipTStat.csv'],IVVersusIVSubConLinearRelationshipTStat);
csvwrite([OutputDir, '/IVVersusIVSubConLinearRelationshipPStatNonC.csv'],IVVersusIVSubConLinearRelationshipPStatNonC);
csvwrite([OutputDir, '/IVVersusIVSubConLinearRelationshipPStatBFC.csv'],IVVersusIVSubConLinearRelationshipPStatBFC);


%-------vsIN

[aa,bb,cc,dd]=ttest2(LinearBeta(17:32,:),(LinearBeta(1:16,:)));
IVVersusINSubConLinearRelationshipTStat=dd.tstat
IVVersusINSubConLinearRelationshipPStatNonC=bb
IVVersusINSubConLinearRelationshipPStatBFC=bb*15


csvwrite([OutputDir, '/IVVersusINSubConLinearRelationshipTStat.csv'],IVVersusINSubConLinearRelationshipTStat);
csvwrite([OutputDir, '/IVVersusINSubConLinearRelationshipPStatNonC.csv'],IVVersusINSubConLinearRelationshipPStatNonC);
csvwrite([OutputDir, '/IVVersusINSubConLinearRelationshipPStatBFC.csv'],IVVersusINSubConLinearRelationshipPStatBFC);


%-------vsNB

[aa,bb,cc,dd]=ttest2(LinearBeta(17:32,:),(LinearBeta(33:48,:)));
IVVersusNBSubConLinearRelationshipTStat=dd.tstat
IVVersusNBSubConLinearRelationshipPStatNonC=bb
IVVersusNBSubConLinearRelationshipPStatBFC=bb*15


csvwrite([OutputDir, '/IVVersusNBSubConLinearRelationshipTStat.csv'],IVVersusNBSubConLinearRelationshipTStat);
csvwrite([OutputDir, '/IVVersusNBSubConLinearRelationshipPStatNonC.csv'],IVVersusNBSubConLinearRelationshipPStatNonC);
csvwrite([OutputDir, '/IVVersusNBSubConLinearRelationshipPStatBFC.csv'],IVVersusNBSubConLinearRelationshipPStatBFC);



%----------------------------------------
%     Linear Trends IN vs ...
%----------------------------------------


OutputDir = ([SourceDir, '/Base_Files'])

%-------vsPL


[aa,bb,cc,dd]=ttest2(LinearBeta(1:16,:),(LinearBeta(49:64,:)));
INVersusPLSubConLinearRelationshipTStat=dd.tstat
INVersusPLSubConLinearRelationshipPStatNonC=bb
INVersusPLSubConLinearRelationshipPStatBFC=bb*15


csvwrite([OutputDir, '/INVersusPLSubConLinearRelationshipTStat.csv'],INVersusPLSubConLinearRelationshipTStat);
csvwrite([OutputDir, '/INVersusPLSubConLinearRelationshipPStatNonC.csv'],INVersusPLSubConLinearRelationshipPStatNonC);
csvwrite([OutputDir, '/INVersusPLSubConLinearRelationshipPStatBFC.csv'],INVersusPLSubConLinearRelationshipPStatBFC);


%-------vsIV

[aa,bb,cc,dd]=ttest2(LinearBeta(1:16,:),(LinearBeta(17:32,:)));
INVersusIVSubConLinearRelationshipTStat=dd.tstat
INVersusIVSubConLinearRelationshipPStatNonC=bb
INVersusIVSubConLinearRelationshipPStatBFC=bb*15


csvwrite([OutputDir, '/INVersusIVSubConLinearRelationshipTStat.csv'],INVersusIVSubConLinearRelationshipTStat);
csvwrite([OutputDir, '/INVersusIVSubConLinearRelationshipPStatNonC.csv'],INVersusIVSubConLinearRelationshipPStatNonC);
csvwrite([OutputDir, '/INVersusIVSubConLinearRelationshipPStatBFC.csv'],INVersusIVSubConLinearRelationshipPStatBFC);


%-------vsIN

[aa,bb,cc,dd]=ttest2(LinearBeta(1:16,:),(LinearBeta(1:16,:)));
INVersusINSubConLinearRelationshipTStat=dd.tstat
INVersusINSubConLinearRelationshipPStatNonC=bb
INVersusINSubConLinearRelationshipPStatBFC=bb*15


csvwrite([OutputDir, '/INVersusINSubConLinearRelationshipTStat.csv'],INVersusINSubConLinearRelationshipTStat);
csvwrite([OutputDir, '/INVersusINSubConLinearRelationshipPStatNonC.csv'],INVersusINSubConLinearRelationshipPStatNonC);
csvwrite([OutputDir, '/INVersusINSubConLinearRelationshipPStatBFC.csv'],INVersusINSubConLinearRelationshipPStatBFC);


%-------vsNB

[aa,bb,cc,dd]=ttest2(LinearBeta(1:16,:),(LinearBeta(33:48,:)));
INVersusNBSubConLinearRelationshipTStat=dd.tstat
INVersusNBSubConLinearRelationshipPStatNonC=bb
INVersusNBSubConLinearRelationshipPStatBFC=bb*15


csvwrite([OutputDir, '/INVersusNBSubConLinearRelationshipTStat.csv'],INVersusNBSubConLinearRelationshipTStat);
csvwrite([OutputDir, '/INVersusNBSubConLinearRelationshipPStatNonC.csv'],INVersusNBSubConLinearRelationshipPStatNonC);
csvwrite([OutputDir, '/INVersusNBSubConLinearRelationshipPStatBFC.csv'],INVersusNBSubConLinearRelationshipPStatBFC);


%----------------------------------------
%     Linear Trends NB vs ...
%----------------------------------------


OutputDir = ([SourceDir, '/Base_Files'])

%-------vsPL


[aa,bb,cc,dd]=ttest2(LinearBeta(33:48,:),(LinearBeta(49:64,:)));
NBVersusPLSubConLinearRelationshipTStat=dd.tstat
NBVersusPLSubConLinearRelationshipPStatNonC=bb
NBVersusPLSubConLinearRelationshipPStatBFC=bb*15

csvwrite([OutputDir, '/NBVersusPLSubConLinearRelationshipTStat.csv'],NBVersusPLSubConLinearRelationshipTStat);
csvwrite([OutputDir, '/NBVersusPLSubConLinearRelationshipPStatNonC.csv'],NBVersusPLSubConLinearRelationshipPStatNonC);
csvwrite([OutputDir, '/NBVersusPLSubConLinearRelationshipPStatBFC.csv'],NBVersusPLSubConLinearRelationshipPStatBFC);


%-------vsIV

[aa,bb,cc,dd]=ttest2(LinearBeta(33:48,:),(LinearBeta(17:32,:)));
NBVersusIVSubConLinearRelationshipTStat=dd.tstat
NBVersusIVSubConLinearRelationshipPStatNonC=bb
NBVersusIVSubConLinearRelationshipPStatBFC=bb*15


csvwrite([OutputDir, '/NBVersusIVSubConLinearRelationshipTStat.csv'],NBVersusIVSubConLinearRelationshipTStat);
csvwrite([OutputDir, '/NBVersusIVSubConLinearRelationshipPStatNonC.csv'],NBVersusIVSubConLinearRelationshipPStatNonC);
csvwrite([OutputDir, '/NBVersusIVSubConLinearRelationshipPStatBFC.csv'],NBVersusIVSubConLinearRelationshipPStatBFC);


%-------vsIN

[aa,bb,cc,dd]=ttest2(LinearBeta(33:48,:),(LinearBeta(1:16,:)));
NBVersusINSubConLinearRelationshipTStat=dd.tstat
NBVersusINSubConLinearRelationshipPStatNonC=bb
NBVersusINSubConLinearRelationshipPStatBFC=bb*15


csvwrite([OutputDir, '/NBVersusINSubConLinearRelationshipTStat.csv'],NBVersusINSubConLinearRelationshipTStat);
csvwrite([OutputDir, '/NBVersusINSubConLinearRelationshipPStatNonC.csv'],NBVersusINSubConLinearRelationshipPStatNonC);
csvwrite([OutputDir, '/NBVersusINSubConLinearRelationshipPStatBFC.csv'],NBVersusINSubConLinearRelationshipPStatBFC);


%-------vsNB

[aa,bb,cc,dd]=ttest2(LinearBeta(33:48,:),(LinearBeta(33:48,:)));
NBVersusNBSubConLinearRelationshipTStat=dd.tstat
NBVersusNBSubConLinearRelationshipPStatNonC=bb
NBVersusNBSubConLinearRelationshipPStatBFC=bb*15


csvwrite([OutputDir, '/NBVersusNBSubConLinearRelationshipTStat.csv'],NBVersusNBSubConLinearRelationshipTStat);
csvwrite([OutputDir, '/NBVersusNBSubConLinearRelationshipPStatNonC.csv'],NBVersusNBSubConLinearRelationshipPStatNonC);
csvwrite([OutputDir, '/NBVersusNBSubConLinearRelationshipPStatBFC.csv'],NBVersusNBSubConLinearRelationshipPStatBFC);




