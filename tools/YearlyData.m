% Aggregate full year of data from monthly values

clc; clear all; close all;
addpath(genpath('C:\mfls\'));

%% Full 2014 Growing Season
% Define the data directories

DataDir15 = 'C:\jzr201\FluxData\BioCorr\2015\';
DataDir16 = 'C:\jzr201\FluxData\BioCorr\2016\';
OutDir = 'C:\jzr201\temp\Plots\SeasonalVCR\';

%% Plotting environment
dark2 = brewermap(8,'Dark2');
set2 = brewermap(8,'Set2');
TitleFontSize = 12; labelfontsz = 27; fontsz = 20;
NumTicks =7; FontWeight ='demi'; markersz = 10; L =20; H =18;
PlotLineWidth = 2; markeredge = 'Black'; 
plotheight=23;
plotwidth=30;
subplotsx=1;
subplotsy=3;
leftedge=1.4;
rightedge=3;
topedge=1;
bottomedge=2.5;
spacex=3.0;
spacey=0.7;
fontsize=16;
sub_pos=subplot_pos(plotwidth,plotheight,leftedge,rightedge,...
    bottomedge,topedge,subplotsx,subplotsy,spacex,spacey);
spacex=3.0;
spacey=1;
sub_pos2=subplot_pos(plotwidth,plotheight,leftedge,rightedge,...
    bottomedge,topedge,subplotsx,subplotsy,spacex,spacey);
patchcol = brewermap(13,'Blues'); patcol = patchcol(2,:);

%%  Load the monthly data
May15 = load([DataDir15 '05_Full']);
Jun15 = load([DataDir15 '06_FinalFull']); Jul15 = load([DataDir15 '07_FinalFull']);
Aug15 = load([DataDir15 '08_FinalFull']); Sep15 = load([DataDir15 '09_FinalFull']);
Oct15 = load([DataDir15 '10_FinalFull']); Nov15 = load([DataDir15 '11_FinalFull']);
Dec15 = load([DataDir15 '12_FinalFull']); Jan16 = load([DataDir16 '01_FinalFull']);
Feb16 = load([DataDir16 '02_FinalFull']); Mar16 = load([DataDir16 '03_FinalFull']);
Apr16 = load([DataDir16 '04_FinalFull']); May16 = load([DataDir16 '05_FinalFull']);
Jun16 = load([DataDir16 '06_FinalFull']); Jul16 = load([DataDir16 '07_FinalFull']);
Aug16 = load([DataDir16 '08_FinalFull']); Sep16 = load([DataDir16 '09_FinalFull']);
Oct16 = load([DataDir16 '10_FinalFull']);

% % % remove bad flux data
f=Jun15.FlxData(:,14)>-0.02 & Jun15.FlxData(:,14)<0.02;
Jun15.FlxData(f,14)=nan; Jun15.FlxData(f,28)=nan;
f=Jul15.FlxData(:,14)>-0.02 & Jul15.FlxData(:,14)<0.02;
Jul15.FlxData(f,14)=nan; Jul15.FlxData(f,28)=nan;
f=Aug15.FlxData(:,14)>-0.02 & Aug15.FlxData(:,14)<0.02;
Aug15.FlxData(f,14)=nan; Aug15.FlxData(f,28)=nan;
f=Sep15.FlxData(:,14)>-0.02 & Sep15.FlxData(:,14)<0.02;
Sep15.FlxData(f,14)=nan; Sep15.FlxData(f,28)=nan;

f=May16.FlxData(:,14)>-0.02 & May16.FlxData(:,14)<0.02;
May16.FlxData(f,14)=nan; May16.FlxData(f,28)=nan;
f=Jun16.FlxData(:,14)>-0.02 & Jun16.FlxData(:,14)<0.02;
Jun16.FlxData(f,14)=nan; Jun16.FlxData(f,28)=nan;
f=Jul16.FlxData(:,14)>-0.02 & Jul16.FlxData(:,14)<0.02;
Jul16.FlxData(f,14)=nan; Jul16.FlxData(f,28)=nan;
f=Aug16.FlxData(:,14)>-0.02 & Aug16.FlxData(:,14)<0.02;
Aug16.FlxData(f,14)=nan; Aug16.FlxData(f,28)=nan;
f=Sep16.FlxData(:,14)>-0.02 & Sep16.FlxData(:,14)<0.02;
Sep16.FlxData(f,14)=nan; Sep16.FlxData(f,28)=nan;

May15Fc = May15.FlxData(:,14)+May15.FlxData(:,28);
Jun15Fc = Jun15.FlxData(:,14)+Jun15.FlxData(:,28); 
Jul15Fc = Jul15.FlxData(:,14)+Jul15.FlxData(:,28);
Aug15Fc = Aug15.FlxData(:,14)+Aug15.FlxData(:,28); 
Sep15Fc = Sep15.FlxData(:,14)+Sep15.FlxData(:,28);
Oct15Fc = Oct15.FlxData(:,14)+Oct15.FlxData(:,28);
Nov15Fc = Nov15.FlxData(:,14)+Nov15.FlxData(:,28);
Dec15Fc = Dec15.FlxData(:,14)+Dec15.FlxData(:,28);
Jan16Fc = Jan16.FlxData(:,14)+Jan16.FlxData(:,28);
Feb16Fc = Feb16.FlxData(:,14)+Feb16.FlxData(:,28); 
Mar16Fc = Mar16.FlxData(:,14)+Mar16.FlxData(:,28);
Apr16Fc = Apr16.FlxData(:,14)+Apr16.FlxData(:,28);
May16Fc = May16.FlxData(:,14)+May16.FlxData(:,28);
Jun16Fc = Jun16.FlxData(:,14)+Jun16.FlxData(:,28);
Jul16Fc = Jul16.FlxData(:,14)+Jul16.FlxData(:,28);
Aug16Fc = Aug16.FlxData(:,14)+Aug16.FlxData(:,28);
Sep16Fc = Sep16.FlxData(:,14)+Sep16.FlxData(:,28);
Oct16Fc = Oct16.FlxData(:,14)+Oct16.FlxData(:,28);


May15LH = May15.FlxData(:,11);
Jun15LH = Jun15.FlxData(:,11); Jul15LH = Jul15.FlxData(:,11);
Aug15LH = Aug15.FlxData(:,11); Sep15LH = Sep15.FlxData(:,11);
Oct15LH = Oct15.FlxData(:,11); Nov15LH = Nov15.FlxData(:,11);
Dec15LH = Dec15.FlxData(:,11); Jan16LH = Jan16.FlxData(:,11);
Feb16LH = Feb16.FlxData(:,11); Mar16LH = Mar16.FlxData(:,11);
Apr16LH = Apr16.FlxData(:,11); May16LH = May16.FlxData(:,11);
Jun16LH = Jun16.FlxData(:,11); Jul16LH = Jul16.FlxData(:,11);
Aug16LH = Aug16.FlxData(:,11); Sep16LH = Sep16.FlxData(:,11);
Oct16LH = Oct16.FlxData(:,11);

May15VPD = May15.FlxData(:,68);
Jun15VPD = Jun15.FlxData(:,68); Jul15VPD = Jul15.FlxData(:,68);
Aug15VPD = Aug15.FlxData(:,68); Sep15VPD = Sep15.FlxData(:,68);
Oct15VPD = Oct15.FlxData(:,68); Nov15VPD = Nov15.FlxData(:,68);
Dec15VPD = Dec15.FlxData(:,68); Jan16VPD = Jan16.FlxData(:,68);
Feb16VPD = Feb16.FlxData(:,68); Mar16VPD = Mar16.FlxData(:,68);
Apr16VPD = Apr16.FlxData(:,68); May16VPD = May16.FlxData(:,68);
Jun16VPD = Jun16.FlxData(:,68); Jul16VPD = Jul16.FlxData(:,68);
Aug16VPD = Aug16.FlxData(:,68); Sep16VPD = Sep16.FlxData(:,68);
Oct16VPD = Oct16.FlxData(:,68);

May15H = May15.FlxData(:,8);
Jun15H = Jun15.FlxData(:,8); Jul15H = Jul15.FlxData(:,8);
Aug15H = Aug15.FlxData(:,8); Sep15H = Sep15.FlxData(:,8);
Oct15H = Oct15.FlxData(:,8); Nov15H = Nov15.FlxData(:,8);
Dec15H = Dec15.FlxData(:,8); Jan16H = Jan16.FlxData(:,8);
Feb16H = Feb16.FlxData(:,8); Mar16H = Mar16.FlxData(:,8);
Apr16H = Apr16.FlxData(:,8); May16H = May16.FlxData(:,8);
Jun16H = Jun16.FlxData(:,8); Jul16H = Jul16.FlxData(:,8);
Aug16H = Aug16.FlxData(:,8); Sep16H = Sep16.FlxData(:,8);
Oct16H = Oct16.FlxData(:,8);

May15RH = May15.FlxData(:,67);
Jun15RH = Jun15.FlxData(:,67); Jul15RH = Jul15.FlxData(:,67);
Aug15RH = Aug15.FlxData(:,67); Sep15RH = Sep15.FlxData(:,67);
Oct15RH = Oct15.FlxData(:,67); Nov15RH = Nov15.FlxData(:,67);
Dec15RH = Dec15.FlxData(:,67); Jan16RH = Jan16.FlxData(:,67);
Feb16RH = Feb16.FlxData(:,67); Mar16RH = Mar16.FlxData(:,67);
Apr16RH = Apr16.FlxData(:,67); May16RH = May16.FlxData(:,67);
Jun16RH = Jun16.FlxData(:,67); Jul16RH = Jul16.FlxData(:,67);
Aug16RH = Aug16.FlxData(:,67); Sep16RH = Sep16.FlxData(:,67);
Oct16RH = Oct16.FlxData(:,67);

May15DOY = May15.FlxData(:,1);
Jun15DOY = Jun15.FlxData(:,1); Jul15DOY = Jul15.FlxData(:,1);
Aug15DOY = Aug15.FlxData(:,1); Sep15DOY = Sep15.FlxData(:,1);
Oct15DOY = Oct15.FlxData(:,1); Nov15DOY = Nov15.FlxData(:,1);
Dec15DOY = Dec15.FlxData(:,1); Jan16DOY = Jan16.FlxData(:,1);
Feb16DOY = Feb16.FlxData(:,1); Mar16DOY = Mar16.FlxData(:,1);
Apr16DOY = Apr16.FlxData(:,1); May16DOY = May16.FlxData(:,1);
Jun16DOY = Jun16.FlxData(:,1); Jul16DOY = Jul16.FlxData(:,1);
Aug16DOY = Aug16.FlxData(:,1); Sep16DOY = Sep16.FlxData(:,1);
Oct16DOY = Oct16.FlxData(:,1);

May15DN = May15.FlxData(:,2);
Jun15DN = Jun15.FlxData(:,2); Jul15DN = Jul15.FlxData(:,2);
Aug15DN = Aug15.FlxData(:,2); Sep15DN = Sep15.FlxData(:,2);
Oct15DN = Oct15.FlxData(:,2); Nov15DN = Nov15.FlxData(:,2);
Dec15DN = Dec15.FlxData(:,2); Jan16DN = Jan16.FlxData(:,2);
Feb16DN = Feb16.FlxData(:,2); Mar16DN = Mar16.FlxData(:,2);
Apr16DN = Apr16.FlxData(:,2); May16DN = May16.FlxData(:,2);
Jun16DN = Jun16.FlxData(:,2); Jul16DN = Jul16.FlxData(:,2);
Aug16DN = Aug16.FlxData(:,2); Sep16DN = Sep16.FlxData(:,2);
Oct16DN = Oct16.FlxData(:,2);

Jun15Inun = Jun15.MetData(:,26); Jul15Inun = Jul15.MetData(:,26);
Aug15Inun = Aug15.MetData(:,26); Sep15Inun = Sep15.MetData(:,26);
Oct15Inun = Oct15.MetData(:,26); Nov15Inun = Nov15.MetData(:,26);
Dec15Inun = Dec15.MetData(:,26); Jan16Inun = Jan16.MetData(:,26);
Feb16Inun = Feb16.MetData(:,26); Mar16Inun = Mar16.MetData(:,26);
Apr16Inun = Apr16.MetData(:,26); May16Inun = May16.MetData(:,26);
Jun16Inun = Jun16.MetData(:,26); Jul16Inun = Jul16.MetData(:,26);
Aug16Inun = Aug16.MetData(:,26); Sep16Inun = Sep16.MetData(:,26);
Oct16Inun = Oct16.MetData(:,26);

Jun15Precip = Jun15.MetData(:,24); Jul15Precip = Jul15.MetData(:,24);
Aug15Precip = Aug15.MetData(:,24); Sep15Precip = Sep15.MetData(:,24);
Oct15Precip = Oct15.MetData(:,24); Nov15Precip = Nov15.MetData(:,24);
Dec15Precip = Dec15.MetData(:,24); Jan16Precip = Jan16.MetData(:,24);
Feb16Precip = Feb16.MetData(:,24); Mar16Precip = Mar16.MetData(:,24);
Apr16Precip = Apr16.MetData(:,24); May16Precip = May16.MetData(:,24); 
Jun16Precip = Jun16.MetData(:,24); Jul16Precip = Jul16.MetData(:,24);
Aug16Precip = Aug16.MetData(:,24); Sep16Precip = Sep16.MetData(:,24);
Oct16Precip = Oct16.MetData(:,24);

May15Us = May15.FlxData(:,82);
Jun15Us = Jun15.FlxData(:,82); Jul15Us = Jul15.FlxData(:,82);
Aug15Us = Aug15.FlxData(:,82); Sep15Us = Sep15.FlxData(:,82);
Oct15Us = Oct15.FlxData(:,82); Nov15Us = Nov15.FlxData(:,82);
Dec15Us = Dec15.FlxData(:,82); Jan16Us = Jan16.FlxData(:,82);
Feb16Us = Feb16.FlxData(:,82); Mar16Us = Mar16.FlxData(:,82);
Apr16Us = Apr16.FlxData(:,82); May16Us = May16.FlxData(:,82); 
Jun16Us = Jun16.FlxData(:,82); Jul16Us = Jul16.FlxData(:,82); 
Aug16Us = Aug16.FlxData(:,82); Sep16Us = Sep16.FlxData(:,82);
Oct16Us = Oct16.FlxData(:,82);

May15Si = May15.MetData(:,13);
Jun15Si = Jun15.MetData(:,15); Jul15Si = Jul15.MetData(:,15);
Aug15Si = Aug15.MetData(:,15); Sep15Si = Sep15.MetData(:,15);
Oct15Si = Oct15.MetData(:,15); Nov15Si = Nov15.MetData(:,15);
Dec15Si = Dec15.MetData(:,15); Jan16Si = Jan16.MetData(:,15);
Feb16Si = Feb16.MetData(:,15); Mar16Si = Mar16.MetData(:,15);
Apr16Si = Apr16.MetData(:,15); May16Si = May16.MetData(:,15); 
Jun16Si = Jun16.MetData(:,15); Jul16Si = Jul16.MetData(:,15); 
Aug16Si = Aug16.MetData(:,15); Sep16Si = Sep16.MetData(:,15);
Oct16Si = Oct16.MetData(:,15);

May15Sr = May15.MetData(:,14);
Jun15Sr = Jun15.MetData(:,16); Jul15Sr = Jul15.MetData(:,16);
Aug15Sr = Aug15.MetData(:,16); Sep15Sr = Sep15.MetData(:,16);
Oct15Sr = Oct15.MetData(:,16); Nov15Sr = Nov15.MetData(:,16);
Dec15Sr = Dec15.MetData(:,16); Jan16Sr = Jan16.MetData(:,16);
Feb16Sr = Feb16.MetData(:,16); Mar16Sr = Mar16.MetData(:,16);
Apr16Sr = Apr16.MetData(:,16); May16Sr = May16.MetData(:,16); 
Jun16Sr = Jun16.MetData(:,16); Jul16Sr = Jul16.MetData(:,16);
Aug16Sr = Aug16.MetData(:,16); Sep16Sr = Sep16.MetData(:,16);
Oct16Sr = Oct16.MetData(:,16); 

May15Rg = May15.MetData(:,18);
Jun15Rg = Jun15.MetData(:,20); Jul15Rg = Jul15.MetData(:,20);
Aug15Rg = Aug15.MetData(:,20); Sep15Rg = Sep15.MetData(:,20);
Oct15Rg = Oct15.MetData(:,20); Nov15Rg = Nov15.MetData(:,20);
Dec15Rg = Dec15.MetData(:,20); Jan16Rg = Jan16.MetData(:,20);
Feb16Rg = Feb16.MetData(:,20); Mar16Rg = Mar16.MetData(:,20);
Apr16Rg = Apr16.MetData(:,20); May16Rg = May16.MetData(:,20); 
Jun16Rg = Jun16.MetData(:,20); Jul16Rg = Jul16.MetData(:,20);
Aug16Rg = Aug16.MetData(:,20); Sep16Rg = Sep16.MetData(:,20);
Oct16Rg = Oct16.MetData(:,20); 

May15PARi = May15.MetData(:,15);
Jun15PARi = Jun15.MetData(:,17); Jul15PARi = Jul15.MetData(:,17);
Aug15PARi = Aug15.MetData(:,17); Sep15PARi = Sep15.MetData(:,17);
Oct15PARi = Oct15.MetData(:,17); Nov15PARi = Nov15.MetData(:,17);
Dec15PARi = Dec15.MetData(:,17); Jan16PARi = Jan16.MetData(:,17);
Feb16PARi = Feb16.MetData(:,17); Mar16PARi = Mar16.MetData(:,17);
Apr16PARi = Apr16.MetData(:,17); May16PARi = May16.MetData(:,17); 
Jun16PARi = Jun16.MetData(:,17); Jul16PARi = Jul16.MetData(:,17);
Aug16PARi = Aug16.MetData(:,17); Sep16PARi = Sep16.MetData(:,17);
Oct16PARi = Oct16.MetData(:,17);

May15PARr = May15.MetData(:,16);
Jun15PARr = Jun15.MetData(:,18); Jul15PARr = Jul15.MetData(:,18);
Aug15PARr = Aug15.MetData(:,18); Sep15PARr = Sep15.MetData(:,18);
Oct15PARr = Oct15.MetData(:,18); Nov15PARr = Nov15.MetData(:,18);
Dec15PARr = Dec15.MetData(:,18); Jan16PARr = Jan16.MetData(:,18);
Feb16PARr = Feb16.MetData(:,18); Mar16PARr = Mar16.MetData(:,18);
Apr16PARr = Apr16.MetData(:,18); May16PARr = May16.MetData(:,18);
Jun16PARr = Jun16.MetData(:,18); Jul16PARr = Jul16.MetData(:,18);
Aug16PARr = Aug16.MetData(:,18); Sep16PARr = Sep16.MetData(:,18);
Oct16PARr = Oct16.MetData(:,18);

May15q = May15.FlxData(:,66);
Jun15q = Jun15.FlxData(:,66); Jul15q = Jul15.FlxData(:,66);
Aug15q = Aug15.FlxData(:,66); Sep15q = Sep15.FlxData(:,66);
Oct15q = Oct15.FlxData(:,66); Nov15q = Nov15.FlxData(:,66);
Dec15q = Dec15.FlxData(:,66); Jan16q = Jan16.FlxData(:,66);
Feb16q = Feb16.FlxData(:,66); Mar16q = Mar16.FlxData(:,66);
Apr16q = Apr16.FlxData(:,66); May16q = May16.FlxData(:,66);
Jun16q = Jun16.FlxData(:,66); Jul16q = Jul16.FlxData(:,66);
Aug16q = Aug16.FlxData(:,66); Sep16q = Sep16.FlxData(:,66);
Oct16q = Oct16.FlxData(:,66);


May15Ts = May15.MetData(:,5);
Jun15Ts = Jun15.MetData(:,5); Jul15Ts = Jul15.MetData(:,5);
Aug15Ts = Aug15.MetData(:,5); Sep15Ts = Sep15.MetData(:,5);
Oct15Ts = Oct15.MetData(:,5); Nov15Ts = Nov15.MetData(:,5);
Dec15Ts = Dec15.MetData(:,5); Jan16Ts = Jan16.MetData(:,5);
Feb16Ts = Feb16.MetData(:,5); Mar16Ts = Mar16.MetData(:,5);
Apr16Ts = Apr16.MetData(:,5); May16Ts = May16.MetData(:,5);
Jun16Ts = Jun16.MetData(:,5); Jul16Ts = Jul16.MetData(:,5);
Aug16Ts = Aug16.MetData(:,5); Sep16Ts = Sep16.MetData(:,5);
Oct16Ts = Oct16.MetData(:,5);

% Remove physically unreasonable values
temp = Jul16.MetData(:,2);
temp(temp>312) = nan;
Jul16.MetData(:,2) = temp;

% May15Ta = nanmean([May15.MetData(:,2),May15.MetData(:,3),...
%     May15.FlxData(:,57)],2);
Jun15Ta = nanmean([Jun15.MetData(:,2),Jun15.MetData(:,3),...
    Jun15.FlxData(:,57)],2);
Jul15Ta = nanmean([Jul15.MetData(:,2),Jul15.MetData(:,3),...
    Jul15.FlxData(:,57)],2);
Aug15Ta = nanmean([Aug15.MetData(:,2),Aug15.MetData(:,3),...
    Aug15.FlxData(:,57)],2);
Sep15Ta = nanmean([Sep15.MetData(:,2),Sep15.MetData(:,3),...
    Sep15.FlxData(:,57)],2);
Oct15Ta = nanmean([Oct15.MetData(:,2),Oct15.MetData(:,3),...
    Oct15.FlxData(:,57)],2);
Nov15Ta = nanmean([Nov15.MetData(:,2),Nov15.MetData(:,3),...
    Nov15.FlxData(:,57)],2);
Dec15Ta = nanmean([Dec15.MetData(:,2),Dec15.MetData(:,3),...
    Dec15.FlxData(:,57)],2);
Jan16Ta = nanmean([Jan16.MetData(:,2),Jan16.MetData(:,3),...
    Jan16.FlxData(:,57)],2);
Feb16Ta = nanmean([Feb16.MetData(:,2),Feb16.MetData(:,3),...
    Feb16.FlxData(:,57)],2);
Mar16Ta = nanmean([Mar16.MetData(:,2),Mar16.MetData(:,3),...
    Mar16.FlxData(:,57)],2);
Apr16Ta = nanmean([Apr16.MetData(:,2),Apr16.MetData(:,3),...
    Apr16.FlxData(:,57)],2);
May16Ta = nanmean([May16.MetData(:,2),May16.MetData(:,3),...
    May16.FlxData(:,57)],2);
Jun16Ta = nanmean([Jun16.MetData(:,2),Jun16.MetData(:,3),...
    Jun16.FlxData(:,57)],2);
Jul16Ta = nanmean([Jul16.MetData(:,2),Jul16.MetData(:,3),...
    Jul16.FlxData(:,57)],2);
Aug16Ta = nanmean([Aug16.MetData(:,2),Aug16.MetData(:,3),...
    Aug16.FlxData(:,57)],2);
Sep16Ta = nanmean([Sep16.MetData(:,2),Sep16.MetData(:,3),...
    Sep16.FlxData(:,57)],2);
Oct16Ta = nanmean([Oct16.MetData(:,2),Oct16.MetData(:,3),...
    Oct16.FlxData(:,57)],2);


%% Agreggate the monthly data
FullTime = [Jun15.FlxESTTime;Jul15.FlxESTTime;...
    Aug15.FlxESTTime;Sep15.FlxESTTime;Oct15.FlxESTTime;Nov15.FlxESTTime;...
    Dec15.FlxESTTime;Jan16.FlxESTTime;Feb16.FlxESTTime;Mar16.FlxESTTime;...
    Apr16.FlxESTTime;May16.FlxESTTime;Jun16.FlxESTTime;Jul16.FlxESTTime;...
    Aug16.FlxESTTime;Sep16.FlxESTTime;Oct16.FlxESTTime];

FullSi = [Jun15Si;Jul15Si;Aug15Si;Sep15Si;Oct15Si;Nov15Si;Dec15Si;...
    Jan16Si;Feb16Si;Mar16Si;Apr16Si;May16Si;Jun16Si;Jul16Si;Aug16Si;...
    Sep16Si;Oct16Si];

Fullq = [Jun15q;Jul15q;Aug15q;Sep15q;Oct15q;Nov15q;Dec15q;...
    Jan16q;Feb16q;Mar16q;Apr16q;May16q;Jun16q;Jul16q;Aug16q;...
    Sep16q;Oct16q];

FullUs = [Jun15Us;Jul15Us;Aug15Us;Sep15Us;Oct15Us;Nov15Us;Dec15Us;...
    Jan16Us;Feb16Us;Mar16Us;Apr16Us;May16Us;Jun16Us;Jul16Us;Aug16Us;...
    Sep16Us;Oct16Us];

FullSr = [Jun15Sr;Jul15Sr;Aug15Sr;Sep15Sr;Oct15Sr;Nov15Sr;Dec15Sr;...
    Jan16Sr;Feb16Sr;Mar16Sr;Apr16Sr;May16Sr;Jun16Sr;Jul16Sr;Aug16Sr;...
    Sep16Sr;Oct16Sr];

FullRg = [Jun15Rg;Jul15Rg;Aug15Rg;Sep15Rg;Oct15Rg;Nov15Rg;Dec15Rg;...
    Jan16Rg;Feb16Rg;Mar16Rg;Apr16Rg;May16Rg;Jun16Rg;Jul16Rg;Aug16Rg;...
    Sep16Rg;Oct16Rg];

FullPARi = [Jun15PARi;Jul15PARi;Aug15PARi;Sep15PARi;Oct15PARi;Nov15PARi;...
    Dec15PARi;Jan16PARi;Feb16PARi;Mar16PARi;Apr16PARi;May16PARi;Jun16PARi;...
    Jul16PARi;Aug16PARi;Sep16PARi;Oct16PARi];

FullPARr = [Jun15PARr;Jul15PARr;Aug15PARr;Sep15PARr;Oct15PARr;Nov15PARr;...
    Dec15PARr;Jan16PARr;Feb16PARr;Mar16PARr;Apr16PARr;May16PARr;Jun16PARr;...
    Jul16PARr;Aug16PARr;Sep16PARr;Oct16PARr];

FullPrecip = [Jun15Precip;Jul15Precip;Aug15Precip;Sep15Precip;Oct15Precip;...
    Nov15Precip;Dec15Precip;Jan16Precip;Feb16Precip;Mar16Precip;...
    Apr16Precip;May16Precip;Jun16Precip;Jul16Precip;Aug16Precip;...
    Sep16Precip;Oct16Precip;];

FullInun = [Jun15Inun;Jul15Inun;Aug15Inun;Sep15Inun;Oct15Inun;...
    Nov15Inun;Dec15Inun;Jan16Inun;Feb16Inun;Mar16Inun;Apr16Inun;...
    May16Inun;Jun16Inun;Jul16Inun;Aug16Inun;Sep16Inun;Oct16Inun];

FullInun(FullInun<0.26)=nan; %FullInun = FullInun - 0.26;

FullFc = [Jun15Fc;Jul15Fc;Aug15Fc;Sep15Fc;Oct15Fc;Nov15Fc;Dec15Fc;...
    Jan16Fc;Feb16Fc;Mar16Fc;Apr16Fc;May16Fc;Jun16Fc;Jul16Fc;Aug16Fc;...
    Sep16Fc;Oct16Fc];

FullLH = [Jun15LH;Jul15LH;Aug15LH;Sep15LH;Oct15LH;Nov15LH;Dec15LH;...
    Jan16LH;Feb16LH;Mar16LH;Apr16LH;May16LH;Jun16LH;Jul16LH;Aug16LH;...
    Sep16LH;Oct16LH];

FullRH = [Jun15RH;Jul15RH;Aug15RH;Sep15RH;Oct15RH;Nov15RH;Dec15RH;...
    Jan16RH;Feb16RH;Mar16RH;Apr16RH;May16RH;Jun16RH;Jul16RH;Aug16RH;...
    Sep16RH;Oct16RH];

FullVPD = [Jun15VPD;Jul15VPD;Aug15VPD;Sep15VPD;Oct15VPD;Nov15VPD;Dec15VPD;...
    Jan16VPD;Feb16VPD;Mar16VPD;Apr16VPD;May16VPD;Jun16VPD;Jul16VPD;Aug16VPD;...
    Sep16VPD;Oct16VPD];

FullH = [Jun15H;Jul15H;Aug15H;Sep15H;Oct15H;Nov15H;Dec15H;...
    Jan16H;Feb16H;Mar16H;Apr16H;May16H;Jun16H;Jul16H;Aug16H;...
    Sep16H;Oct16H];

FullTa = [Jun15Ta;Jul15Ta;Aug15Ta;Sep15Ta;Oct15Ta;Nov15Ta;Dec15Ta;...
    Jan16Ta;Feb16Ta;Mar16Ta;Apr16Ta;May16Ta;Jun16Ta;Jul16Ta;Aug16Ta;...
    Sep16Ta;Oct16Ta];

VPD = vapor(FullTa,FullRH);

FullTs = [Jun15Ts;Jul15Ts;Aug15Ts;Sep15Ts;Oct15Ts;Nov15Ts;Dec15Ts;...
    Jan16Ts;Feb16Ts;Mar16Ts;Apr16Ts;May16Ts;Jun16Ts;Jul16Ts;Aug16Ts;...
    Sep16Ts;Oct16Ts];

FullDOY = [Jun15DOY;Jul15DOY;Aug15DOY;Sep15DOY;Oct15DOY;Nov15DOY;Dec15DOY;...
    Jan16DOY;Feb16DOY;Mar16DOY;Apr16DOY;May16DOY;Jun16DOY;Jul16DOY;...
    Aug16DOY;Sep16DOY;Oct16DOY];

FullDN = [Jun15DN;Jul15DN;Aug15DN;Sep15DN;Oct15DN;Nov15DN;Dec15DN;...
    Jan16DN;Feb16DN;Mar16DN;Apr16DN;May16DN;Jun16DN;Jul16DN;...
    Aug16DN;Sep16DN;Oct16DN];

[FullNDVI, FullEVI] = VI(FullSr,FullSi,FullPARr,FullPARi);
FullfPAR = (FullPARi-FullPARr)./FullPARi;

% return;

% Remove physically unreasonable values
FullFc(FullFc>10 | FullFc<-20 ) = nan;
FullFc(FullPARi < 50) = nan;
FullLH(FullLH>600 | FullLH<-100) = nan;
FullRH(FullRH<10) = nan;


%% Low Tide data

FullInun = FullInun - 0.26; % offset from height above the marsh

%% PAR influence on NEE
BegPARi = [May15PARi;May16PARi]; 
BegDN = [May16DN]; BegInun = [May16Inun]; 
BegFc = [May15Fc;May16Fc];
BegPrecip = [May16Precip];

BegFc(BegInun>0.3) = nan; BegPARi(BegInun>0.3) = nan;
BegFc(BegPrecip > 1) = nan; BegPARi(BegPrecip > 1) = nan;  
BegFc(BegPARi < 50) = nan; BegFc(BegDN<1)=nan;
BegFc(BegFc>5 | BegFc<-15 ) = nan;


MidPARi = [Jun15PARi;Jul15PARi;Jun16PARi;Jul16PARi]; 
MidDN = [Jun15DN;Jul15DN;Jun16DN;Jul16DN]; 
MidInun = [Jun15Inun;Jul15Inun;Jun16Inun;Jul16Inun]; 
MidFc = [Jun15Fc;Jul15Fc;Jun16Fc;Jul16Fc]; 
MidPrecip = [Jun15Precip;Jul15Precip;Jun16Precip;Jul16Precip;];

MidFc(MidInun>0.3) = nan; MidPARi(MidInun>0.3) = nan;
MidFc(MidPrecip > 1) = nan; MidPARi(MidPrecip > 1) = nan;  
MidFc(MidPARi < 50) = nan; MidFc(MidDN<1)=nan;
MidFc(MidFc>5 | MidFc<-15 ) = nan;


EndPARi = [Aug15PARi;Sep15PARi;Aug16PARi;Sep16PARi]; 
EndDN = [Aug15DN;Sep15DN;Aug16DN;Sep16DN]; 
EndInun = [Aug15Inun;Sep15Inun;Aug16Inun;Sep16Inun]; 
EndFc = [Aug15Fc;Sep15Fc;Aug16Fc;Sep16Fc]; 
EndPrecip = [Aug15Precip;Sep15Precip;Aug16Precip;Sep16Precip];

EndFc(EndInun>0.3) = nan; EndPARi(EndInun>0.3) = nan;
EndFc(EndPrecip > 1) = nan; EndPARi(EndPrecip > 1) = nan;  
EndFc(EndPARi < 50) = nan; EndFc(EndDN<1)=nan;
EndFc(EndFc>5 | EndFc<-15 ) = nan;


PARFig=figure('visible','on');
clf(PARFig);
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [plotwidth plotheight]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [2 0.25 plotwidth plotheight]); 


ax=axes('position',sub_pos{1,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
f = plot(BegPARi,BegFc,'o');
set(f,'LineWidth',PlotLineWidth,'MarkerSize',markersz,...
    'MarkerFaceColor',set2(1,:),'MarkerEdgeColor',dark2(1,:));
ylim([-15 6]);  %yh = ylabel('NEE (\mumol m^{-2} s^{-1})');
th = text(2090,3,'A');
set(gca,'Box','on','XTick',...
    linspace(0,2100,NumTicks),...
    'YTick',-15:5:6,'fontsize',fontsz,...
    'fontweight','bold','linewidth',2);
set([th],'Fontsize',labelfontsz,'Fontname','Timesnewroman',...
    'FontWeight','bold'); 
xlim([0 2200]);
set(gca,'XTickLabel',[]); 

ax=axes('position',sub_pos{1,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
f = plot(MidPARi,MidFc,'o');
set(f,'LineWidth',PlotLineWidth,'MarkerSize',markersz,...
    'MarkerFaceColor',set2(2,:),'MarkerEdgeColor',dark2(2,:));
ylim([-15 6]);  yh = ylabel('NEE (\mumol m^{-2} s^{-1})');
th = text(2090,3,'B');
set(gca,'Box','on','XTick',...
    linspace(0,2100,NumTicks),...
    'YTick',-15:5:6,'fontsize',fontsz,...
    'fontweight','bold','linewidth',2);
set([th yh],'Fontsize',labelfontsz,'Fontname','Timesnewroman',...
    'FontWeight','bold'); xlim([0 2200]);
set(gca,'XTickLabel',[]);

ax=axes('position',sub_pos{1,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
f = plot(EndPARi,EndFc,'o');
set(f,'LineWidth',PlotLineWidth,'MarkerSize',markersz,...
    'MarkerFaceColor',set2(3,:),'MarkerEdgeColor',dark2(3,:));
ylim([-15 6]);  %yh = ylabel('NEE (\mumol m^{-2} s^{-1})');
xh = xlabel('PAR (\mumol m^{-2}s^{-1})');
th = text(2090,3,'C');
set(gca,'Box','on','XTick',...
    linspace(0,2100,NumTicks),...
    'YTick',-15:5:6,'fontsize',fontsz,...
    'fontweight','bold','linewidth',2);
set([xh yh th],'Fontsize',labelfontsz,'Fontname','Timesnewroman',...
    'FontWeight','bold'); xlim([0 2200]);

% PName = ['NEEPar'];
% makeplot(PARFig,OutDir,PName);






return;
% 
% figure;plot(Jul16.FlxESTTime,Jul16.FlxData(:,14));datetick('x','dd');
% xlim([StartTime EndTime])

%%
save(OutFile,'May15Fc','Jun15Fc','Jul15Fc','Aug15Fc','FullDN',...
    'FullFc','FullInun','FullPARi','FullPARr','Fullq',...
    'FullPrecip','FullSi','FullSr','FullTa','FullTime','-v7.3');


OutFile = ['F:\jzr201\FluxData\' 'VCRFull.mat'];
save(OutFile,'FullDOY','FullEVI','FullNDVI','FullfPAR','FullDN',...
    'FullFc','FullInun','FullPARi','FullPARr','Fullq',...
    'FullPrecip','FullSi','FullSr','FullTa','FullTime','-v7.3');