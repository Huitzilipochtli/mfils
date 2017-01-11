% clear all; close all;  clc;

function [BioMetFile] = BioMet2(StartDate, EndDate)

% Monthly Biomet Data for full month to be used in eddypro
% % StartDate = '2015-06-05 00:00'; %pick a day before
% % EndDate = '2015-07-08 00:00';   %pick a day after
Dform = 'yyyy-mm-dd HH:MM';
newinstr = datenum('06-04-2015 10:00:00','mm-dd-yyyy HH:MM:SS'); %added

DataDir = 'C:\scratch\jzr201\RawData\TOWERSYNCH\MetData\';
ProcessedDir = 'F:\jzr201\ProcessedData\MetData\';
% DataDir = 'F:\jzr201\RawData\TOWERSYNCH\MetData\';
% ProcessedDir = 'F:\jzr201\ProcessedData\MetData\';
addpath(genpath('V:\Micrometeorology\mfiles\'));
CRFileExt = '*.dat';
CRFileType = 'CR3000_HR*';

%include the tide data from OYST station
% load 'F:\jzr201\VCRData\OYST2014.mat';
% tvec = datevec(OYST2014Time);
% [unHours, ~, subs] = unique(tvec(:,2:3),'rows');

%make the BioMetFile with Header and Unit information
BioMetData = []; BioMetTime = [];
BioMetName = datestr(StartDate,'yyyy_mm_dd_HH');
BioMetFile = [ProcessedDir 'BioMET_' BioMetName '.csv'];
Ta1 = 'Ta_1_1_1,';  Ta2 = 'Ta_1_2_1,'; Ta3 = 'Ta_1_3_1,';
RH1 = 'RH_1_1_1,';  RH2 = 'RH_1_2_1,'; NetRad = 'Rn_1_1_1,';
LWin = 'LWin_1_1_1,'; LWout = 'LWout_1_1_1,'; Pa = 'Pa_1_1_1,';
SWin = 'SWin_1_1_1,'; SWout = 'SWout_1_1_1,'; PARin = 'PPFD_1_1_1,';
Ts1 = 'Ts_1_1_1,'; Ts2 = 'Ts_2_1_1,'; Ts3 = 'Ts_3_1_1,';
PARout = 'PPFDr_1_1_1,'; WDrmy = 'WD_1_1_1\n'; StrDate ='TIMESTAMP_1,';
TimeStr ='TIMESTAMP_2,'; Alb = 'Alb_1_1_1,' ; WSrmy = 'WSrmy_1_1_1,';
SH1 = 'SHFLX_1_1_1,'; SH2 = 'SHFLX_1_2_1,'; Rg = 'Rg_1_1_1,';
RMYu = 'RMYu_1_1_1,'; RMYv = 'RMYv_1_1_1,';

if (datenum(StartDate,'yyyy-mm-dd HH:MM') >= newinstr)
    P = 'P_1_1_1,'; Tw1 = 'Tw_1_1_1,'; sal = 'X_1_1_1,'; 
    Tide = 'Lev_1_1_1,'; Tw2 = 'Tw_1_2_1,';
    HeaderInfo = [StrDate TimeStr Ta1 Ta2 Ta3 Ts1 Ts2 Ts3 Tw1 Tw2 RH1 RH2...
        NetRad LWin LWout SWin SWout PARin PARout Alb Rg WSrmy RMYu RMYv...
        SH1 SH2 P sal Tide WDrmy];
    HeaderUnits = ['yyyy-mm-dd,' 'HH:MM,' 'C,' 'C,' 'C,' 'C,' 'C,' 'C,' 'C,'...
        'C,' '%%,' '%%,' 'W+1m-2,' 'W+1m-2,' 'W+1m-2,' 'W+1m-2,' 'W+1m-2,'...
        'µmol+1m-2s-1,' 'µmol+1m-2s-1,' 'none,' 'W+1m-2,' 'm+1s-1,'...
        'm+1s-1,' 'm+1s-1,' 'W+1m-2,' 'W+1m-2,' 'mm,' 'mScm-1,' 'm,'...
        'degrees\n'];
    clear DateStr TimeStr Ta1 Ta2 Ta3 Ts1 Ts2 Ts3 RH1 RH2 NetRad LWin...
        LWout Pa SWin SWout PARin PARout WD Alb WSrmy SH1 SH2 Rg P Tw1 Tw2...
        sal Tide RMYu RMYv
else
     HeaderInfo = [StrDate TimeStr Ta1 Ta2 Ta3 Ts1 Ts2 Ts3 RH1 RH2 NetRad...
        LWin LWout SWin SWout PARin PARout Alb Rg WSrmy RMYu RMYv SH1 SH2 WDrmy];
    HeaderUnits = ['yyyy-mm-dd,' 'HH:MM,' 'C,' 'C,' 'C,' 'C,' 'C,' 'C,' '%%,'...
        '%%,' 'W+1m-2,' 'W+1m-2,' 'W+1m-2,' 'W+1m-2,' 'W+1m-2,'...
        'µmol+1m-2s-1,' 'µmol+1m-2s-1,' 'none,' 'W+1m-2,' 'm+1s-1,'...
        'm+1s-1,' 'm+1s-1,' 'W+1m-2,' 'W+1m-2,' 'degrees\n'];
    clear DateStr TimeStr Ta1 Ta2 Ta3 Ts1 Ts2 Ts3 RH1 RH2 NetRad LWin...
        LWout Pa SWin SWout PARin PARout WD Alb WSrmy SH1 SH2 Rg RMYu RMYv
end

for Date = datenum(StartDate,Dform):datenum(EndDate,Dform);
    DatTodayStr = datestr(Date,'yyyy_mm_dd'); 

% %     indx = OYST2014Time >= Date & OYST2014Time < FlxESTTime(end);
% %     REDBTime = OYST2014Time(indx); REDBTide = OYST2014Tide(indx);
% %     [LowFlxTime, LowFlxInd, LowTideInd] = intersect(Date,LowTideTime);
% %     
% %     Tmp = accumarray(subs, OYST2014, [], @nanmean);
    
    %read the files within the specified StartDate and EndDate
    CRFiles = dir([DataDir CRFileType DatTodayStr CRFileExt]);
    for i=1:length(CRFiles);
        CRFileName = [DataDir CRFiles(i).name];
        disp(['MET file === ' CRFileName]);
        [MSdata] = read_cr3000(CRFileName);
        
        MetData = cell2mat(MSdata(:,2:length(MSdata)));
        SWin = MetData(:,2);  SWout = MetData(:,3); NetRad = MetData(:,13);
        LWin = MetData(:,14); LWout = MetData(:,15); Pa = MetData(:,16);
        WDrmy = MetData(:,19); PARin = MetData(:,20);
        PARout = MetData(:,22); Ta1 = MetData(:,24); RH1 = MetData(:,25);
        Ta2 = MetData(:,26); Ta3 = MetData(:,27); RH2 = MetData(:,28);
        Ts1 = MetData(:,29); Ts2 = MetData(:,30); Ts3 = MetData(:,31);
        Alb = MetData(:,10); WSrmy =  MetData(:,18);  SH1 = MetData(:,32);
        SH2 = MetData(:,33); Rg = SWin;               
        
        RMYu = []; RMYv = [];
        for k = 1:length(WSrmy);
        [WDrmy(k),WSrmy(k),RMYu(k),RMYv(k)] = wndmean(WDrmy(k),WSrmy(k));
        end
        RMYu = transpose(RMYu); RMYv = transpose(RMYv);
        
        MetTime = datenum(MSdata{1},'"yyyy-mm-dd HH:MM:SS"');
        if (MetTime < datenum('18/08/2014 19:50','dd/mm/yyyy HH:MM'));
            MetTime = datenum(MSdata{1},'"yyyy-mm-dd HH:MM:SS"') + 4/24;
        end
        
        if (Date >= newinstr)
            P = MetData(:,39); Tw1 = MetData(:,37); sal = MetData(:,38);
            Tide = MetData(:,34); Tw2 = MetData(:,35);
            MetData = [Ta1 Ta2 Ta3 Ts1 Ts2 Ts3 Tw1 Tw2 RH1 RH2 NetRad...
                LWin LWout SWin SWout PARin PARout Alb Rg WSrmy RMYu RMYv...
                SH1 SH2 P sal Tide WDrmy];
        else
            MetData = [Ta1 Ta2 Ta3 Ts1 Ts2 Ts3 RH1 RH2 NetRad LWin...
                LWout SWin SWout PARin PARout Alb Rg WSrmy RMYu RMYv...
                SH1 SH2 WDrmy];
        end
        
        [MetTime,ind] = sort(MetTime); MetData = MetData(ind,:);
        BioMetData = [BioMetData;MetData];
        BioMetTime = [BioMetTime;MetTime];
    end
    
    % % % %     figure(1);
    % % % %     plot(BioMetTime,BioMetData(:,1:6));title('Temperature');
    % % % %     datetick('x','dd HH:MM');grid on;
    % % % %
    % % % %     figure(2);
    % % % %     plot(BioMetTime,BioMetData(:,7:8));title('Relative Humidity');
    % % % %     datetick('x','dd HH:MM');grid on;
    % % % %
    % % % %     figure(3);
    % % % %     plot(BioMetTime,BioMetData(:,9:15));title('Radiation');
    % % % %     datetick('x','dd HH:MM');grid on;
    %
    for iTime = 1:length(BioMetTime)
        BioMetYY{iTime} = datestr(BioMetTime(iTime), 'yyyy-mm-dd') ;
        BioMetHH{iTime} = datestr(BioMetTime(iTime), 'HH:MM');
    end
    
    % Fill the BioMet File
    FileID = fopen(BioMetFile,'wt');
    fprintf(FileID,HeaderInfo);
    fprintf(FileID,HeaderUnits);
    for iLine = 1:size(BioMetData, 1) % Loop through each time/value row
        fprintf(FileID, '%s,', BioMetYY{iLine}) ;
        fprintf(FileID, '%s,', BioMetHH{iLine}) ;% Print the time string
        if (Date >= newinstr)
            fprintf(FileID, [repmat('%6.3f,',1,10) repmat('%8.5f,',1,17) '%8.5f\n'],...
                BioMetData(iLine, 1:end)) ; % Print the data values
        else
            fprintf(FileID, [repmat('%6.3f,',1,8) repmat('%8.5f,',1,14) '%8.5f\n'],...
                BioMetData(iLine, 1:end)) ; % Print the data values
        end
    end
    fclose(FileID);
    
end
disp(['BioMet file completed ------' BioMetFile]);
end