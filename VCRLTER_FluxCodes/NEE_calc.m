% Diurnal averages per month

clc; clear all; close all;
addpath(genpath('C:\Users\Jesus\Box Sync\mfls\'));
dform = 'yyyy-mm';

Month = datenum('2016-05','yyyy-mm');

%load the 2014 VCR REDB tide data
%load 'C:\scratch\jzr201\VCRData\REDB2014.mat';
%load the 2014 VCR OYST tide data
% load 'F:\jzr201\VCRData\OYST2014.mat';
%% Compile the processed data

OutputPlotDir = ['F:\jzr201\FluxData\BioCorr\' datestr(Month,'yyyy') '\'];
DataDir = ['F:\jzr201\FluxData\BioCorr\' datestr(Month,'yyyy') '\'];
[MetData, FlxData, FlxESTTime] = hourly(DataDir, OutputPlotDir, Month);
[MetData, FlxData, FlxESTTime] = finalfull(DataDir, OutputPlotDir, Month);
[MetData,FlxData,FlxESTTime,HourlyTime]= ...
    HourlySummary(FlxESTTime,FlxData,MetData,OutputPlotDir);

return;


%% January
Month = datenum('2015-01','yyyy-mm');
FolderStr = datestr(Month,'mm');
    
FullOutFile = dir([DataDir FolderStr '\' csvFileType csvFileExt]);   
MetOutFile = dir([DataDir FolderStr '\' metFileType csvFileExt]);

[FlxESTTime, FlxData] = read_fulloutput([DataDir FolderStr '\' FullOutFile.name]);
[MetESTTime, MetData] = read_fullmet([DataDir FolderStr '\' MetOutFile.name]);

FlxESTTimeStr = datestr(FlxESTTime,'yyyy-mm-dd HH:MM:SS'); 
FlxESTTime = datenum(FlxESTTimeStr,'yyyy-mm-dd HH:MM:SS');
MetESTTimeStr = datestr(MetESTTime,'yyyy-mm-dd HH:MM:SS'); 
MetESTTime = datenum(MetESTTimeStr,'yyyy-mm-dd HH:MM:SS');
%remove the points where Fluxes aren't calculated to get the same array
%sizes
[MetESTTime,MetIndx,FlxIndx] = intersect(MetESTTime,FlxESTTime); 
MetData = MetData(MetIndx,:); FlxData = FlxData(FlxIndx,:);
FlxESTTime = FlxESTTime(FlxIndx,:);
%cleanup data
FlxData=cleanup(FlxData);
[RE, GPP] = respiration(FlxData,MetData);

FlxESTHour = datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM');

tvec = datevec(FlxESTTime);
[PARf, PARd, kt] = splitPAR(MetESTTime,MetData);
[unHours, ~, subs] = unique(tvec(:,4:5),'rows');
HourlyTime = unique(datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM'));

id.PAR = 15;
id.Ta = 2;
id.Ts = 5;
if (MetESTTime(1) >= newinstr)
id.PAR = 17;
end 

HourlyParfAvg = accumarray(subs,PARf,[],@nanmean);
HourlyParfSTD = accumarray(subs,PARf,[],@nanstd);
HourlyPardAvg = accumarray(subs,PARd,[],@nanmean);
HourlyPardSTD = accumarray(subs,PARd,[],@nanstd);
HourlyParAvg = accumarray(subs, MetData(:,id.PAR), [], @nanmean);
HourlyParSTD = accumarray(subs, MetData(:,id.PAR), [], @nanstd);
HourlyTsAvg = accumarray(subs, MetData(:,id.Ts), [], @nanmean);
HourlyTsSTD = accumarray(subs, MetData(:,id.Ts), [], @nanstd);
HourlyTaAvg = accumarray(subs, MetData(:,id.Ta), [], @nanmean);
HourlyTaSTD = accumarray(subs, MetData(:,id.Ta), [], @nanstd);
HourlyqAvg = accumarray(subs, FlxData(:,66)*1000, [], @nanmean);
HourlyqSTD = accumarray(subs, FlxData(:,66)*1000, [], @nanstd);
HourlyNEEAvg = accumarray(subs, FlxData(:,14), [], @nanmean);
HourlyNEESTD = accumarray(subs, FlxData(:,14), [], @nanstd);
HourlyVPDAvg = accumarray(subs, FlxData(:,68), [], @nanmean);
HourlyVPDSTD = accumarray(subs, FlxData(:,68), [], @nanstd);
HourlyGPPAvg = accumarray(subs, GPP, [], @nanmean);
HourlyGPPSTD = accumarray(subs, GPP, [], @nanstd);
HourlyREAvg = accumarray(subs, RE, [], @nanmean);
HourlyRESTD = accumarray(subs, RE, [], @nanstd);
HourlyLAvg = accumarray(subs, FlxData(:,84), [], @nanmean);
HourlyLSTD = accumarray(subs, FlxData(:,84), [], @nanstd);
CarbGPP = nansum(HourlyGPPAvg)*0.0216; % umol m-2 s-1 CO2 to gC m-2 
CarbRE = nansum(HourlyREAvg)*0.0216;
CarbNEE = nansum(HourlyNEEAvg)*0.0216;

MatFile = [DataDir datestr(Month,'mm') '_HourlyFull.mat'];
save(MatFile,'FlxData','FlxESTTime','MetData','MetESTTime','HourlyTime',...
    'HourlyParAvg','HourlyParSTD','HourlyParfAvg','HourlyParfSTD',...
    'HourlyPardAvg','HourlyPardSTD','HourlyTsAvg','HourlyTsSTD',...
    'HourlyTaAvg','HourlyTaSTD','HourlyqAvg','HourlyqSTD','FlxESTHour',...
    'HourlyVPDSTD','HourlyVPDAvg','HourlyNEEAvg','HourlyNEESTD',...
    'HourlyGPPAvg','HourlyGPPSTD','HourlyREAvg','HourlyRESTD',...
    'HourlyLAvg','HourlyLSTD','CarbGPP','CarbRE','CarbNEE','-v7.3');

Hourly=figure('visible','on');
clf(Hourly);
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [plotwidth plotheight]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [2 0.25 plotwidth plotheight]);

ax=axes('position',sub_pos{1,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,[HourlyParAvg, HourlyParfAvg, HourlyPardAvg],'.'); 
yh = ylabel('PAR (\mumol m^{-2} s^{-1})');
ylim([0 2300]); 
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');
legend('PARt','PARf','PARd','Location','NW')
set(ax,'xticklabel',[]);
title([datestr(MetESTTime(10),'yyyy mmm')],'fontweight','bold','fontsize',14);


ax=axes('position',sub_pos{1,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight',...
    'bold');
o = plot(HourlyTime,HourlyVPDAvg,'.'); 
yh = ylabel('VPD ( Pa )');
ylim([0 3200]);
set(gca,'fontsize',14,'fontweight','bold');
set(ax,'xticklabel',[]);
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); 

ax=axes('position',sub_pos{1,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,HourlyNEEAvg,'*'); 
yh = ylabel('NEE (\mumol m^{-2} s^{-1})');
xh = xlabel('Time of Day [HH]');
ylim([-20 10]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')

ax=axes('position',sub_pos{2,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyTaAvg-273.15,'^'); 
set(ax,'xticklabel',[]);
yh = ylabel('Air Temperature (C)');
ylim([0 35]);
set(gca,'fontsize',14,'fontweight','bold');
t = title([datestr(MetESTTime(10),'yyyy mmm')]);
set([t yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');


ax=axes('position',sub_pos{2,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,HourlyTsAvg-273.15,'+'); 
yh = ylabel('Soil Temperature (C)');
set(ax,'xticklabel',[]); ylim([0 35]);
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{2,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyqAvg,'v'); 
yh = ylabel('q ( g kg^{-1})');
xh = xlabel('Time of Day [HH]');
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')


ax=axes('position',sub_pos{3,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyGPPAvg,'o'); 
yh = ylabel('GPP (\mumol m^{-2} s^{-1})');
set(ax,'xticklabel',[]);
set(gca,'fontsize',14,'fontweight','bold');
t = title([datestr(MetESTTime(10),'yyyy mmm')]);
set([t yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{3,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyREAvg,'.'); 
yh = ylabel('RE (\mumol m^{-2} s^{-1})');
set(ax,'xticklabel',[]);
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{3,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyLAvg,'.'); 
yh = ylabel('L ( m )'); ylim([-200 200]);
xh = xlabel('Time of Day [HH]'); datetick('x','HH')
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');


PlotHourlyDir=[OutputPlotDir datestr(MetESTTime(10),'yyyymm') '_Diel'];
print(Hourly, '-depsc2','-loose',[PlotHourlyDir,'.eps']);
system(['epstopdf ',PlotHourlyDir,'.eps']);
system(['convert -density 300 ',PlotHourlyDir,'.eps ',PlotHourlyDir,'.png']);

clear HourlyTime HourlyqAvg HourlyTsAvg HourlyTaAvg HourlyNEEAvg...
    HoulyVPDAvg HourlyParAvg HourlyParfAvg HourlyPardAvg MetESTTime...
    FlxESTTime FlxData MetData Hourly HourlyNEESTD HourlyGPPAvg ...
    HourlyGPPSTD HourlyREAvg HourlyRESTD HourlyLAvg HourlyLSTD

%% February
Month = datenum('2015-02','yyyy-mm');
FolderStr = datestr(Month,'mm');
    
FullOutFile = dir([DataDir FolderStr '\' csvFileType csvFileExt]);   
MetOutFile = dir([DataDir FolderStr '\' metFileType csvFileExt]);

[FlxESTTime, FlxData] = read_fulloutput([DataDir FolderStr '\' FullOutFile.name]);
[MetESTTime, MetData] = read_fullmet([DataDir FolderStr '\' MetOutFile.name]);

FlxESTTimeStr = datestr(FlxESTTime,'yyyy-mm-dd HH:MM:SS'); 
FlxESTTime = datenum(FlxESTTimeStr,'yyyy-mm-dd HH:MM:SS');
MetESTTimeStr = datestr(MetESTTime,'yyyy-mm-dd HH:MM:SS'); 
MetESTTime = datenum(MetESTTimeStr,'yyyy-mm-dd HH:MM:SS');
%remove the points where Fluxes aren't calculated to get the same array
%sizes
[MetESTTime,MetIndx,FlxIndx] = intersect(MetESTTime,FlxESTTime); 
MetData = MetData(MetIndx,:); FlxData = FlxData(FlxIndx,:);
FlxESTTime = FlxESTTime(FlxIndx,:);
%cleanup data
FlxData=cleanup(FlxData);
[RE, GPP] = respiration(FlxData,MetData);

FlxESTHour = datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM');

tvec = datevec(FlxESTTime);
[PARf, PARd, kt] = splitPAR(MetESTTime,MetData);
[unHours, ~, subs] = unique(tvec(:,4:5),'rows');
HourlyTime = unique(datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM'));

id.PAR = 15;
id.Ta = 3;
id.Ts = 5;
if (MetESTTime(1) >= newinstr)
id.PAR = 17;
end 

HourlyParfAvg = accumarray(subs,PARf,[],@nanmean);
HourlyParfSTD = accumarray(subs,PARf,[],@nanstd);
HourlyPardAvg = accumarray(subs,PARd,[],@nanmean);
HourlyPardSTD = accumarray(subs,PARd,[],@nanstd);
HourlyParAvg = accumarray(subs, MetData(:,id.PAR), [], @nanmean);
HourlyParSTD = accumarray(subs, MetData(:,id.PAR), [], @nanstd);
HourlyTsAvg = accumarray(subs, MetData(:,id.Ts), [], @nanmean);
HourlyTsSTD = accumarray(subs, MetData(:,id.Ts), [], @nanstd);
HourlyTaAvg = accumarray(subs, MetData(:,id.Ta), [], @nanmean);
HourlyTaSTD = accumarray(subs, MetData(:,id.Ta), [], @nanstd);
HourlyqAvg = accumarray(subs, FlxData(:,66)*1000, [], @nanmean);
HourlyqSTD = accumarray(subs, FlxData(:,66)*1000, [], @nanstd);
HourlyNEEAvg = accumarray(subs, FlxData(:,14), [], @nanmean);
HourlyNEESTD = accumarray(subs, FlxData(:,14), [], @nanstd);
HourlyVPDAvg = accumarray(subs, FlxData(:,68), [], @nanmean);
HourlyVPDSTD = accumarray(subs, FlxData(:,68), [], @nanstd);
HourlyGPPAvg = accumarray(subs, GPP, [], @nanmean);
HourlyGPPSTD = accumarray(subs, GPP, [], @nanstd);
HourlyREAvg = accumarray(subs, RE, [], @nanmean);
HourlyRESTD = accumarray(subs, RE, [], @nanstd);
HourlyLAvg = accumarray(subs, FlxData(:,84), [], @nanmean);
HourlyLSTD = accumarray(subs, FlxData(:,84), [], @nanstd);
CarbGPP = nansum(HourlyGPPAvg)*0.0216; % umol m-2 s-1 CO2 to gC m-2 
CarbRE = nansum(HourlyREAvg)*0.0216;
CarbNEE = nansum(HourlyNEEAvg)*0.0216;

MatFile = [DataDir datestr(Month,'mm') '_HourlyFull.mat'];
save(MatFile,'FlxData','FlxESTTime','MetData','MetESTTime','HourlyTime',...
    'HourlyParAvg','HourlyParSTD','HourlyParfAvg','HourlyParfSTD',...
    'HourlyPardAvg','HourlyPardSTD','HourlyTsAvg','HourlyTsSTD',...
    'HourlyTaAvg','HourlyTaSTD','HourlyqAvg','HourlyqSTD','FlxESTHour',...
    'HourlyVPDSTD','HourlyVPDAvg','HourlyNEEAvg','HourlyNEESTD',...
    'HourlyGPPAvg','HourlyGPPSTD','HourlyREAvg','HourlyRESTD',...
    'HourlyLAvg','HourlyLSTD','CarbGPP','CarbRE','CarbNEE','-v7.3');

Hourly=figure('visible','on');
clf(Hourly);
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [plotwidth plotheight]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [2 0.25 plotwidth plotheight]);

ax=axes('position',sub_pos{1,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,[HourlyParAvg, HourlyParfAvg, HourlyPardAvg],'.'); 
yh = ylabel('PAR (\mumol m^{-2} s^{-1})');
ylim([0 2300]); 
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');
legend('PARt','PARf','PARd','Location','NW')
set(ax,'xticklabel',[]);
title([datestr(MetESTTime(10),'yyyy mmm')],'fontweight','bold','fontsize',14);


ax=axes('position',sub_pos{1,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight',...
    'bold');
o = plot(HourlyTime,HourlyVPDAvg,'.'); 
yh = ylabel('VPD ( Pa )');
ylim([0 3200]);
set(gca,'fontsize',14,'fontweight','bold');
set(ax,'xticklabel',[]);
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); 

ax=axes('position',sub_pos{1,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,HourlyNEEAvg,'*'); 
yh = ylabel('NEE (\mumol m^{-2} s^{-1})');
xh = xlabel('Time of Day [HH]');
ylim([-20 10]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')

ax=axes('position',sub_pos{2,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyTaAvg-273.15,'^'); 
set(ax,'xticklabel',[]);
yh = ylabel('Air Temperature (C)');
ylim([0 35]);
set(gca,'fontsize',14,'fontweight','bold');
t = title([datestr(MetESTTime(10),'yyyy mmm')]);
set([t yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');


ax=axes('position',sub_pos{2,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,HourlyTsAvg-273.15,'+'); 
yh = ylabel('Soil Temperature (C)');
set(ax,'xticklabel',[]); ylim([0 35]);
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{2,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyqAvg,'v'); 
yh = ylabel('q ( g kg^{-1})');
xh = xlabel('Time of Day [HH]');
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')


ax=axes('position',sub_pos{3,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyGPPAvg,'o'); 
yh = ylabel('GPP (\mumol m^{-2} s^{-1})');
set(ax,'xticklabel',[]);
set(gca,'fontsize',14,'fontweight','bold');
t = title([datestr(MetESTTime(10),'yyyy mmm')]);
set([t yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{3,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyREAvg,'.'); 
yh = ylabel('RE (\mumol m^{-2} s^{-1})');
set(ax,'xticklabel',[]);
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{3,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyLAvg,'.'); 
yh = ylabel('L ( m )'); ylim([-200 200]);
xh = xlabel('Time of Day [HH]'); datetick('x','HH')
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');


PlotHourlyDir=[OutputPlotDir datestr(MetESTTime(10),'yyyymm') '_Diel'];
print(Hourly, '-depsc2','-loose',[PlotHourlyDir,'.eps']);
system(['epstopdf ',PlotHourlyDir,'.eps']);
system(['convert -density 300 ',PlotHourlyDir,'.eps ',PlotHourlyDir,'.png']);

clear HourlyTime HourlyqAvg HourlyTsAvg HourlyTaAvg HourlyNEEAvg...
    HoulyVPDAvg HourlyParAvg HourlyParfAvg HourlyPardAvg MetESTTime...
    FlxESTTime FlxData MetData Hourly HourlyNEESTD HourlyGPPAvg ...
    HourlyGPPSTD HourlyREAvg HourlyRESTD HourlyLAvg HourlyLSTD


%% March
Month = datenum('2015-03','yyyy-mm');
FolderStr = datestr(Month,'mm');
    
FullOutFile = dir([DataDir FolderStr '\' csvFileType csvFileExt]);   
MetOutFile = dir([DataDir FolderStr '\' metFileType csvFileExt]);

[FlxESTTime, FlxData] = read_fulloutput([DataDir FolderStr '\' FullOutFile.name]);
[MetESTTime, MetData] = read_fullmet([DataDir FolderStr '\' MetOutFile.name]);

FlxESTTimeStr = datestr(FlxESTTime,'yyyy-mm-dd HH:MM:SS'); 
FlxESTTime = datenum(FlxESTTimeStr,'yyyy-mm-dd HH:MM:SS');
MetESTTimeStr = datestr(MetESTTime,'yyyy-mm-dd HH:MM:SS'); 
MetESTTime = datenum(MetESTTimeStr,'yyyy-mm-dd HH:MM:SS');
%remove the points where Fluxes aren't calculated to get the same array
%sizes
[MetESTTime,MetIndx,FlxIndx] = intersect(MetESTTime,FlxESTTime); 
MetData = MetData(MetIndx,:); FlxData = FlxData(FlxIndx,:);
FlxESTTime = FlxESTTime(FlxIndx,:);
%cleanup data
FlxData=cleanup(FlxData);
[RE, GPP] = respiration(FlxData,MetData);

FlxESTHour = datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM');

tvec = datevec(FlxESTTime);
[PARf, PARd, kt] = splitPAR(MetESTTime,MetData);
[unHours, ~, subs] = unique(tvec(:,4:5),'rows');
HourlyTime = unique(datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM'));

id.PAR = 15;
id.Ta = 3;
id.Ts = 5;
if (MetESTTime(1) >= newinstr)
id.PAR = 17;
end 

HourlyParfAvg = accumarray(subs,PARf,[],@nanmean);
HourlyParfSTD = accumarray(subs,PARf,[],@nanstd);
HourlyPardAvg = accumarray(subs,PARd,[],@nanmean);
HourlyPardSTD = accumarray(subs,PARd,[],@nanstd);
HourlyParAvg = accumarray(subs, MetData(:,id.PAR), [], @nanmean);
HourlyParSTD = accumarray(subs, MetData(:,id.PAR), [], @nanstd);
HourlyTsAvg = accumarray(subs, MetData(:,id.Ts), [], @nanmean);
HourlyTsSTD = accumarray(subs, MetData(:,id.Ts), [], @nanstd);
HourlyTaAvg = accumarray(subs, MetData(:,id.Ta), [], @nanmean);
HourlyTaSTD = accumarray(subs, MetData(:,id.Ta), [], @nanstd);
HourlyqAvg = accumarray(subs, FlxData(:,66)*1000, [], @nanmean);
HourlyqSTD = accumarray(subs, FlxData(:,66)*1000, [], @nanstd);
HourlyNEEAvg = accumarray(subs, FlxData(:,14), [], @nanmean);
HourlyNEESTD = accumarray(subs, FlxData(:,14), [], @nanstd);
HourlyVPDAvg = accumarray(subs, FlxData(:,68), [], @nanmean);
HourlyVPDSTD = accumarray(subs, FlxData(:,68), [], @nanstd);
HourlyGPPAvg = accumarray(subs, GPP, [], @nanmean);
HourlyGPPSTD = accumarray(subs, GPP, [], @nanstd);
HourlyREAvg = accumarray(subs, RE, [], @nanmean);
HourlyRESTD = accumarray(subs, RE, [], @nanstd);
HourlyLAvg = accumarray(subs, FlxData(:,84), [], @nanmean);
HourlyLSTD = accumarray(subs, FlxData(:,84), [], @nanstd);
CarbGPP = nansum(HourlyGPPAvg)*0.0216; % umol m-2 s-1 CO2 to gC m-2 
CarbRE = nansum(HourlyREAvg)*0.0216;
CarbNEE = nansum(HourlyNEEAvg)*0.0216;

MatFile = [DataDir datestr(Month,'mm') '_HourlyFull.mat'];
save(MatFile,'FlxData','FlxESTTime','MetData','MetESTTime','HourlyTime',...
    'HourlyParAvg','HourlyParSTD','HourlyParfAvg','HourlyParfSTD',...
    'HourlyPardAvg','HourlyPardSTD','HourlyTsAvg','HourlyTsSTD',...
    'HourlyTaAvg','HourlyTaSTD','HourlyqAvg','HourlyqSTD','FlxESTHour',...
    'HourlyVPDSTD','HourlyVPDAvg','HourlyNEEAvg','HourlyNEESTD',...
    'HourlyGPPAvg','HourlyGPPSTD','HourlyREAvg','HourlyRESTD',...
    'HourlyLAvg','HourlyLSTD','CarbGPP','CarbRE','CarbNEE','-v7.3');

Hourly=figure('visible','on');
clf(Hourly);
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [plotwidth plotheight]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [2 0.25 plotwidth plotheight]);

ax=axes('position',sub_pos{1,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,[HourlyParAvg, HourlyParfAvg, HourlyPardAvg],'.'); 
yh = ylabel('PAR (\mumol m^{-2} s^{-1})');
ylim([0 2300]); 
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');
legend('PARt','PARf','PARd','Location','NW')
set(ax,'xticklabel',[]);
title([datestr(MetESTTime(10),'yyyy mmm')],'fontweight','bold','fontsize',14);


ax=axes('position',sub_pos{1,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight',...
    'bold');
o = plot(HourlyTime,HourlyVPDAvg,'.'); 
yh = ylabel('VPD ( Pa )');
ylim([0 3200]);
set(gca,'fontsize',14,'fontweight','bold');
set(ax,'xticklabel',[]);
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); 

ax=axes('position',sub_pos{1,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,HourlyNEEAvg,'*'); 
yh = ylabel('NEE (\mumol m^{-2} s^{-1})');
xh = xlabel('Time of Day [HH]');
ylim([-20 10]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')

ax=axes('position',sub_pos{2,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyTaAvg-273.15,'^'); 
set(ax,'xticklabel',[]);
yh = ylabel('Air Temperature (C)');
ylim([0 35]);
set(gca,'fontsize',14,'fontweight','bold');
t = title([datestr(MetESTTime(10),'yyyy mmm')]);
set([t yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');


ax=axes('position',sub_pos{2,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,HourlyTsAvg-273.15,'+'); 
yh = ylabel('Soil Temperature (C)');
set(ax,'xticklabel',[]); ylim([0 35]);
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{2,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyqAvg,'v'); 
yh = ylabel('q ( g kg^{-1})');
xh = xlabel('Time of Day [HH]');
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')


ax=axes('position',sub_pos{3,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyGPPAvg,'o'); 
yh = ylabel('GPP (\mumol m^{-2} s^{-1})');
set(ax,'xticklabel',[]);
set(gca,'fontsize',14,'fontweight','bold');
t = title([datestr(MetESTTime(10),'yyyy mmm')]);
set([t yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{3,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyREAvg,'.'); 
yh = ylabel('RE (\mumol m^{-2} s^{-1})');
set(ax,'xticklabel',[]);
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{3,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyLAvg,'.'); 
yh = ylabel('L ( m )'); ylim([-200 200]);
xh = xlabel('Time of Day [HH]'); datetick('x','HH')
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');


PlotHourlyDir=[OutputPlotDir datestr(MetESTTime(10),'yyyymm') '_Diel'];
print(Hourly, '-depsc2','-loose',[PlotHourlyDir,'.eps']);
system(['epstopdf ',PlotHourlyDir,'.eps']);
system(['convert -density 300 ',PlotHourlyDir,'.eps ',PlotHourlyDir,'.png']);

clear HourlyTime HourlyqAvg HourlyTsAvg HourlyTaAvg HourlyNEEAvg...
    HoulyVPDAvg HourlyParAvg HourlyParfAvg HourlyPardAvg MetESTTime...
    FlxESTTime FlxData MetData Hourly HourlyNEESTD HourlyGPPAvg ...
    HourlyGPPSTD HourlyREAvg HourlyRESTD HourlyLAvg HourlyLSTD


%% April
Month = datenum('2015-04','yyyy-mm');
FolderStr = datestr(Month,'mm');
    
FullOutFile = dir([DataDir FolderStr '\' csvFileType csvFileExt]);   
MetOutFile = dir([DataDir FolderStr '\' metFileType csvFileExt]);

[FlxESTTime, FlxData] = read_fulloutput([DataDir FolderStr '\' FullOutFile.name]);
[MetESTTime, MetData] = read_fullmet([DataDir FolderStr '\' MetOutFile.name]);

FlxESTTimeStr = datestr(FlxESTTime,'yyyy-mm-dd HH:MM:SS'); 
FlxESTTime = datenum(FlxESTTimeStr,'yyyy-mm-dd HH:MM:SS');
MetESTTimeStr = datestr(MetESTTime,'yyyy-mm-dd HH:MM:SS'); 
MetESTTime = datenum(MetESTTimeStr,'yyyy-mm-dd HH:MM:SS');
%remove the points where Fluxes aren't calculated to get the same array
%sizes
[MetESTTime,MetIndx,FlxIndx] = intersect(MetESTTime,FlxESTTime); 
MetData = MetData(MetIndx,:); FlxData = FlxData(FlxIndx,:);
FlxESTTime = FlxESTTime(FlxIndx,:);
%cleanup data
FlxData=cleanup(FlxData);
[RE, GPP] = respiration(FlxData,MetData);

FlxESTHour = datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM');

tvec = datevec(FlxESTTime);
[PARf, PARd, kt] = splitPAR(MetESTTime,MetData);
[unHours, ~, subs] = unique(tvec(:,4:5),'rows');
HourlyTime = unique(datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM'));

id.PAR = 15;
id.Ta = 3;
id.Ts = 5;
if (MetESTTime(1) >= newinstr)
id.PAR = 17;
end 

HourlyParfAvg = accumarray(subs,PARf,[],@nanmean);
HourlyParfSTD = accumarray(subs,PARf,[],@nanstd);
HourlyPardAvg = accumarray(subs,PARd,[],@nanmean);
HourlyPardSTD = accumarray(subs,PARd,[],@nanstd);
HourlyParAvg = accumarray(subs, MetData(:,id.PAR), [], @nanmean);
HourlyParSTD = accumarray(subs, MetData(:,id.PAR), [], @nanstd);
HourlyTsAvg = accumarray(subs, MetData(:,id.Ts), [], @nanmean);
HourlyTsSTD = accumarray(subs, MetData(:,id.Ts), [], @nanstd);
HourlyTaAvg = accumarray(subs, MetData(:,id.Ta), [], @nanmean);
HourlyTaSTD = accumarray(subs, MetData(:,id.Ta), [], @nanstd);
HourlyqAvg = accumarray(subs, FlxData(:,66)*1000, [], @nanmean);
HourlyqSTD = accumarray(subs, FlxData(:,66)*1000, [], @nanstd);
HourlyNEEAvg = accumarray(subs, FlxData(:,14), [], @nanmean);
HourlyNEESTD = accumarray(subs, FlxData(:,14), [], @nanstd);
HourlyVPDAvg = accumarray(subs, FlxData(:,68), [], @nanmean);
HourlyVPDSTD = accumarray(subs, FlxData(:,68), [], @nanstd);
HourlyGPPAvg = accumarray(subs, GPP, [], @nanmean);
HourlyGPPSTD = accumarray(subs, GPP, [], @nanstd);
HourlyREAvg = accumarray(subs, RE, [], @nanmean);
HourlyRESTD = accumarray(subs, RE, [], @nanstd);
HourlyLAvg = accumarray(subs, FlxData(:,84), [], @nanmean);
HourlyLSTD = accumarray(subs, FlxData(:,84), [], @nanstd);
CarbGPP = nansum(HourlyGPPAvg)*0.0216; % umol m-2 s-1 CO2 to gC m-2 
CarbRE = nansum(HourlyREAvg)*0.0216;
CarbNEE = nansum(HourlyNEEAvg)*0.0216;

MatFile = [DataDir datestr(Month,'mm') '_HourlyFull.mat'];
save(MatFile,'FlxData','FlxESTTime','MetData','MetESTTime','HourlyTime',...
    'HourlyParAvg','HourlyParSTD','HourlyParfAvg','HourlyParfSTD',...
    'HourlyPardAvg','HourlyPardSTD','HourlyTsAvg','HourlyTsSTD',...
    'HourlyTaAvg','HourlyTaSTD','HourlyqAvg','HourlyqSTD','FlxESTHour',...
    'HourlyVPDSTD','HourlyVPDAvg','HourlyNEEAvg','HourlyNEESTD',...
    'HourlyGPPAvg','HourlyGPPSTD','HourlyREAvg','HourlyRESTD',...
    'HourlyLAvg','HourlyLSTD','CarbGPP','CarbRE','CarbNEE','-v7.3');

Hourly=figure('visible','on');
clf(Hourly);
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [plotwidth plotheight]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [2 0.25 plotwidth plotheight]);

ax=axes('position',sub_pos{1,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,[HourlyParAvg, HourlyParfAvg, HourlyPardAvg],'.'); 
yh = ylabel('PAR (\mumol m^{-2} s^{-1})');
ylim([0 2300]); 
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');
legend('PARt','PARf','PARd','Location','NW')
set(ax,'xticklabel',[]);
title([datestr(MetESTTime(10),'yyyy mmm')],'fontweight','bold','fontsize',14);


ax=axes('position',sub_pos{1,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight',...
    'bold');
o = plot(HourlyTime,HourlyVPDAvg,'.'); 
yh = ylabel('VPD ( Pa )');
ylim([0 3200]);
set(gca,'fontsize',14,'fontweight','bold');
set(ax,'xticklabel',[]);
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); 

ax=axes('position',sub_pos{1,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,HourlyNEEAvg,'*'); 
yh = ylabel('NEE (\mumol m^{-2} s^{-1})');
xh = xlabel('Time of Day [HH]');
ylim([-20 10]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')

ax=axes('position',sub_pos{2,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyTaAvg-273.15,'^'); 
set(ax,'xticklabel',[]);
yh = ylabel('Air Temperature (C)');
ylim([0 35]);
set(gca,'fontsize',14,'fontweight','bold');
t = title([datestr(MetESTTime(10),'yyyy mmm')]);
set([t yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');


ax=axes('position',sub_pos{2,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,HourlyTsAvg-273.15,'+'); 
yh = ylabel('Soil Temperature (C)');
set(ax,'xticklabel',[]); ylim([0 35]);
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{2,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyqAvg,'v'); 
yh = ylabel('q ( g kg^{-1})');
xh = xlabel('Time of Day [HH]');
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')


ax=axes('position',sub_pos{3,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyGPPAvg,'o'); 
yh = ylabel('GPP (\mumol m^{-2} s^{-1})');
set(ax,'xticklabel',[]);
set(gca,'fontsize',14,'fontweight','bold');
t = title([datestr(MetESTTime(10),'yyyy mmm')]);
set([t yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{3,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyREAvg,'.'); 
yh = ylabel('RE (\mumol m^{-2} s^{-1})');
set(ax,'xticklabel',[]);
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{3,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyLAvg,'.'); 
yh = ylabel('L ( m )'); ylim([-200 200]);
xh = xlabel('Time of Day [HH]'); datetick('x','HH')
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');


PlotHourlyDir=[OutputPlotDir datestr(MetESTTime(10),'yyyymm') '_Diel'];
print(Hourly, '-depsc2','-loose',[PlotHourlyDir,'.eps']);
system(['epstopdf ',PlotHourlyDir,'.eps']);
system(['convert -density 300 ',PlotHourlyDir,'.eps ',PlotHourlyDir,'.png']);

clear HourlyTime HourlyqAvg HourlyTsAvg HourlyTaAvg HourlyNEEAvg...
    HoulyVPDAvg HourlyParAvg HourlyParfAvg HourlyPardAvg MetESTTime...
    FlxESTTime FlxData MetData Hourly HourlyNEESTD HourlyGPPAvg ...
    HourlyGPPSTD HourlyREAvg HourlyRESTD HourlyLAvg HourlyLSTD


%% May
Month = datenum('2015-05','yyyy-mm');
FolderStr = datestr(Month,'mm');
    
FullOutFile = dir([DataDir FolderStr '\' csvFileType csvFileExt]);   
MetOutFile = dir([DataDir FolderStr '\' metFileType csvFileExt]);

[FlxESTTime, FlxData] = read_fulloutput([DataDir FolderStr '\' FullOutFile.name]);
[MetESTTime, MetData] = read_fullmet([DataDir FolderStr '\' MetOutFile.name]);

FlxESTTimeStr = datestr(FlxESTTime,'yyyy-mm-dd HH:MM:SS'); 
FlxESTTime = datenum(FlxESTTimeStr,'yyyy-mm-dd HH:MM:SS');
MetESTTimeStr = datestr(MetESTTime,'yyyy-mm-dd HH:MM:SS'); 
MetESTTime = datenum(MetESTTimeStr,'yyyy-mm-dd HH:MM:SS');
%remove the points where Fluxes aren't calculated to get the same array
%sizes
[MetESTTime,MetIndx,FlxIndx] = intersect(MetESTTime,FlxESTTime); 
MetData = MetData(MetIndx,:); FlxData = FlxData(FlxIndx,:);
FlxESTTime = FlxESTTime(FlxIndx,:);
%cleanup data
FlxData=cleanup(FlxData);
[RE, GPP] = respiration(FlxData,MetData);

FlxESTHour = datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM');

tvec = datevec(FlxESTTime);
[PARf, PARd, kt] = splitPAR(MetESTTime,MetData);
[unHours, ~, subs] = unique(tvec(:,4:5),'rows');
HourlyTime = unique(datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM'));

id.PAR = 15;
id.Ta = 3;
id.Ts = 5;
if (MetESTTime(1) >= newinstr)
id.PAR = 17;
end 

HourlyParfAvg = accumarray(subs,PARf,[],@nanmean);
HourlyParfSTD = accumarray(subs,PARf,[],@nanstd);
HourlyPardAvg = accumarray(subs,PARd,[],@nanmean);
HourlyPardSTD = accumarray(subs,PARd,[],@nanstd);
HourlyParAvg = accumarray(subs, MetData(:,id.PAR), [], @nanmean);
HourlyParSTD = accumarray(subs, MetData(:,id.PAR), [], @nanstd);
HourlyTsAvg = accumarray(subs, MetData(:,id.Ts), [], @nanmean);
HourlyTsSTD = accumarray(subs, MetData(:,id.Ts), [], @nanstd);
HourlyTaAvg = accumarray(subs, MetData(:,id.Ta), [], @nanmean);
HourlyTaSTD = accumarray(subs, MetData(:,id.Ta), [], @nanstd);
HourlyqAvg = accumarray(subs, FlxData(:,66)*1000, [], @nanmean);
HourlyqSTD = accumarray(subs, FlxData(:,66)*1000, [], @nanstd);
HourlyNEEAvg = accumarray(subs, FlxData(:,14), [], @nanmean);
HourlyNEESTD = accumarray(subs, FlxData(:,14), [], @nanstd);
HourlyVPDAvg = accumarray(subs, FlxData(:,68), [], @nanmean);
HourlyVPDSTD = accumarray(subs, FlxData(:,68), [], @nanstd);
HourlyGPPAvg = accumarray(subs, GPP, [], @nanmean);
HourlyGPPSTD = accumarray(subs, GPP, [], @nanstd);
HourlyREAvg = accumarray(subs, RE, [], @nanmean);
HourlyRESTD = accumarray(subs, RE, [], @nanstd);
HourlyLAvg = accumarray(subs, FlxData(:,84), [], @nanmean);
HourlyLSTD = accumarray(subs, FlxData(:,84), [], @nanstd);
CarbGPP = nansum(HourlyGPPAvg)*0.0216; % umol m-2 s-1 CO2 to gC m-2 
CarbRE = nansum(HourlyREAvg)*0.0216;
CarbNEE = nansum(HourlyNEEAvg)*0.0216;

MatFile = [DataDir datestr(Month,'mm') '_HourlyFull.mat'];
save(MatFile,'FlxData','FlxESTTime','MetData','MetESTTime','HourlyTime',...
    'HourlyParAvg','HourlyParSTD','HourlyParfAvg','HourlyParfSTD',...
    'HourlyPardAvg','HourlyPardSTD','HourlyTsAvg','HourlyTsSTD',...
    'HourlyTaAvg','HourlyTaSTD','HourlyqAvg','HourlyqSTD','FlxESTHour',...
    'HourlyVPDSTD','HourlyVPDAvg','HourlyNEEAvg','HourlyNEESTD',...
    'HourlyGPPAvg','HourlyGPPSTD','HourlyREAvg','HourlyRESTD',...
    'HourlyLAvg','HourlyLSTD','CarbGPP','CarbRE','CarbNEE','-v7.3');

Hourly=figure('visible','on');
clf(Hourly);
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [plotwidth plotheight]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [2 0.25 plotwidth plotheight]);

ax=axes('position',sub_pos{1,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,[HourlyParAvg, HourlyParfAvg, HourlyPardAvg],'.'); 
yh = ylabel('PAR (\mumol m^{-2} s^{-1})');
ylim([0 2300]); 
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');
legend('PARt','PARf','PARd','Location','NW')
set(ax,'xticklabel',[]);
title([datestr(MetESTTime(10),'yyyy mmm')],'fontweight','bold','fontsize',14);


ax=axes('position',sub_pos{1,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight',...
    'bold');
o = plot(HourlyTime,HourlyVPDAvg,'.'); 
yh = ylabel('VPD ( Pa )');
ylim([0 3200]);
set(gca,'fontsize',14,'fontweight','bold');
set(ax,'xticklabel',[]);
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); 

ax=axes('position',sub_pos{1,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,HourlyNEEAvg,'*'); 
yh = ylabel('NEE (\mumol m^{-2} s^{-1})');
xh = xlabel('Time of Day [HH]');
ylim([-20 10]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')

ax=axes('position',sub_pos{2,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyTaAvg-273.15,'^'); 
set(ax,'xticklabel',[]);
yh = ylabel('Air Temperature (C)');
ylim([0 35]);
set(gca,'fontsize',14,'fontweight','bold');
t = title([datestr(MetESTTime(10),'yyyy mmm')]);
set([t yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');


ax=axes('position',sub_pos{2,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,HourlyTsAvg-273.15,'+'); 
yh = ylabel('Soil Temperature (C)');
set(ax,'xticklabel',[]); ylim([0 35]);
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{2,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyqAvg,'v'); 
yh = ylabel('q ( g kg^{-1})');
xh = xlabel('Time of Day [HH]');
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')


ax=axes('position',sub_pos{3,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyGPPAvg,'o'); 
yh = ylabel('GPP (\mumol m^{-2} s^{-1})');
set(ax,'xticklabel',[]);
set(gca,'fontsize',14,'fontweight','bold');
t = title([datestr(MetESTTime(10),'yyyy mmm')]);
set([t yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{3,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyREAvg,'.'); 
yh = ylabel('RE (\mumol m^{-2} s^{-1})');
set(ax,'xticklabel',[]);
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{3,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyLAvg,'.'); 
yh = ylabel('L ( m )'); ylim([-200 200]);
xh = xlabel('Time of Day [HH]'); datetick('x','HH')
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');


PlotHourlyDir=[OutputPlotDir datestr(MetESTTime(10),'yyyymm') '_Diel'];
print(Hourly, '-depsc2','-loose',[PlotHourlyDir,'.eps']);
system(['epstopdf ',PlotHourlyDir,'.eps']);
system(['convert -density 300 ',PlotHourlyDir,'.eps ',PlotHourlyDir,'.png']);

clear HourlyTime HourlyqAvg HourlyTsAvg HourlyTaAvg HourlyNEEAvg...
    HoulyVPDAvg HourlyParAvg HourlyParfAvg HourlyPardAvg MetESTTime...
    FlxESTTime FlxData MetData Hourly HourlyNEESTD HourlyGPPAvg ...
    HourlyGPPSTD HourlyREAvg HourlyRESTD HourlyLAvg HourlyLSTD


%% June
Month = datenum('2015-06','yyyy-mm');
FolderStr = datestr(Month,'mm');
    
FullOutFile = dir([DataDir FolderStr '\' csvFileType csvFileExt]);   
MetOutFile = dir([DataDir FolderStr '\' metFileType csvFileExt]);

[FlxESTTime, FlxData] = read_fulloutput([DataDir FolderStr '\' FullOutFile.name]);
[MetESTTime, MetData] = read_fullmet([DataDir FolderStr '\' MetOutFile.name]);

FlxESTTimeStr = datestr(FlxESTTime,'yyyy-mm-dd HH:MM:SS'); 
FlxESTTime = datenum(FlxESTTimeStr,'yyyy-mm-dd HH:MM:SS');
MetESTTimeStr = datestr(MetESTTime,'yyyy-mm-dd HH:MM:SS'); 
MetESTTime = datenum(MetESTTimeStr,'yyyy-mm-dd HH:MM:SS');
%remove the points where Fluxes aren't calculated to get the same array
%sizes
[MetESTTime,MetIndx,FlxIndx] = intersect(MetESTTime,FlxESTTime); 
MetData = MetData(MetIndx,:); FlxData = FlxData(FlxIndx,:);
FlxESTTime = FlxESTTime(FlxIndx,:);
%cleanup data
FlxData=cleanup(FlxData);
[RE, GPP] = respiration(FlxData,MetData);

FlxESTHour = datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM');

tvec = datevec(FlxESTTime);
[PARf, PARd, kt] = splitPAR(MetESTTime,MetData);
[unHours, ~, subs] = unique(tvec(:,4:5),'rows');
HourlyTime = unique(datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM'));


id.Ta = 2;
id.Ts = 5;
id.PAR = 17;

HourlyParfAvg = accumarray(subs,PARf,[],@nanmean);
HourlyParfSTD = accumarray(subs,PARf,[],@nanstd);
HourlyPardAvg = accumarray(subs,PARd,[],@nanmean);
HourlyPardSTD = accumarray(subs,PARd,[],@nanstd);
HourlyParAvg = accumarray(subs, MetData(:,id.PAR), [], @nanmean);
HourlyParSTD = accumarray(subs, MetData(:,id.PAR), [], @nanstd);
HourlyTsAvg = accumarray(subs, MetData(:,id.Ts), [], @nanmean);
HourlyTsSTD = accumarray(subs, MetData(:,id.Ts), [], @nanstd);
HourlyTaAvg = accumarray(subs, MetData(:,id.Ta), [], @nanmean);
HourlyTaSTD = accumarray(subs, MetData(:,id.Ta), [], @nanstd);
HourlyqAvg = accumarray(subs, FlxData(:,66)*1000, [], @nanmean);
HourlyqSTD = accumarray(subs, FlxData(:,66)*1000, [], @nanstd);
HourlyNEEAvg = accumarray(subs, FlxData(:,14), [], @nanmean);
HourlyNEESTD = accumarray(subs, FlxData(:,14), [], @nanstd);
HourlyVPDAvg = accumarray(subs, FlxData(:,68), [], @nanmean);
HourlyVPDSTD = accumarray(subs, FlxData(:,68), [], @nanstd);
HourlyGPPAvg = accumarray(subs, GPP, [], @nanmean);
HourlyGPPSTD = accumarray(subs, GPP, [], @nanstd);
HourlyREAvg = accumarray(subs, RE, [], @nanmean);
HourlyRESTD = accumarray(subs, RE, [], @nanstd);
HourlyLAvg = accumarray(subs, FlxData(:,84), [], @nanmean);
HourlyLSTD = accumarray(subs, FlxData(:,84), [], @nanstd);
CarbGPP = nansum(HourlyGPPAvg)*0.0216; % umol m-2 s-1 CO2 to gC m-2 
CarbRE = nansum(HourlyREAvg)*0.0216;
CarbNEE = nansum(HourlyNEEAvg)*0.0216;

MatFile = [DataDir datestr(Month,'mm') '_HourlyFull.mat'];
save(MatFile,'FlxData','FlxESTTime','MetData','MetESTTime','HourlyTime',...
    'HourlyParAvg','HourlyParSTD','HourlyParfAvg','HourlyParfSTD',...
    'HourlyPardAvg','HourlyPardSTD','HourlyTsAvg','HourlyTsSTD',...
    'HourlyTaAvg','HourlyTaSTD','HourlyqAvg','HourlyqSTD','FlxESTHour',...
    'HourlyVPDSTD','HourlyVPDAvg','HourlyNEEAvg','HourlyNEESTD',...
    'HourlyGPPAvg','HourlyGPPSTD','HourlyREAvg','HourlyRESTD',...
    'HourlyLAvg','HourlyLSTD','CarbGPP','CarbRE','CarbNEE','-v7.3');

Hourly=figure('visible','on');
clf(Hourly);
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [plotwidth plotheight]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [2 0.25 plotwidth plotheight]);

ax=axes('position',sub_pos{1,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,[HourlyParAvg, HourlyParfAvg, HourlyPardAvg],'.'); 
yh = ylabel('PAR (\mumol m^{-2} s^{-1})');
ylim([0 2300]); 
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');
legend('PARt','PARf','PARd','Location','NW')
set(ax,'xticklabel',[]);
title([datestr(MetESTTime(10),'yyyy mmm')],'fontweight','bold','fontsize',14);


ax=axes('position',sub_pos{1,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight',...
    'bold');
o = plot(HourlyTime,HourlyVPDAvg,'.'); 
yh = ylabel('VPD ( Pa )');
ylim([0 3200]);
set(gca,'fontsize',14,'fontweight','bold');
set(ax,'xticklabel',[]);
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); 

ax=axes('position',sub_pos{1,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,HourlyNEEAvg,'*'); 
yh = ylabel('NEE (\mumol m^{-2} s^{-1})');
xh = xlabel('Time of Day [HH]');
ylim([-20 10]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')

ax=axes('position',sub_pos{2,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyTaAvg-273.15,'^'); 
set(ax,'xticklabel',[]);
yh = ylabel('Air Temperature (C)');
ylim([0 35]);
set(gca,'fontsize',14,'fontweight','bold');
t = title([datestr(MetESTTime(10),'yyyy mmm')]);
set([t yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');


ax=axes('position',sub_pos{2,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,HourlyTsAvg-273.15,'+'); 
yh = ylabel('Soil Temperature (C)');
set(ax,'xticklabel',[]); ylim([0 35]);
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{2,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyqAvg,'v'); 
yh = ylabel('q ( g kg^{-1})');
xh = xlabel('Time of Day [HH]');
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')


ax=axes('position',sub_pos{3,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyGPPAvg,'o'); 
yh = ylabel('GPP (\mumol m^{-2} s^{-1})');
set(ax,'xticklabel',[]);
set(gca,'fontsize',14,'fontweight','bold');
t = title([datestr(MetESTTime(10),'yyyy mmm')]);
set([t yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{3,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyREAvg,'.'); 
yh = ylabel('RE (\mumol m^{-2} s^{-1})');
set(ax,'xticklabel',[]);
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{3,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyLAvg,'.'); 
yh = ylabel('L ( m )'); ylim([-200 200]);
xh = xlabel('Time of Day [HH]'); datetick('x','HH')
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');


PlotHourlyDir=[OutputPlotDir datestr(MetESTTime(10),'yyyymm') '_Diel'];
print(Hourly, '-depsc2','-loose',[PlotHourlyDir,'.eps']);
system(['epstopdf ',PlotHourlyDir,'.eps']);
system(['convert -density 300 ',PlotHourlyDir,'.eps ',PlotHourlyDir,'.png']);

clear HourlyTime HourlyqAvg HourlyTsAvg HourlyTaAvg HourlyNEEAvg...
    HoulyVPDAvg HourlyParAvg HourlyParfAvg HourlyPardAvg MetESTTime...
    FlxESTTime FlxData MetData Hourly HourlyNEESTD HourlyGPPAvg ...
    HourlyGPPSTD HourlyREAvg HourlyRESTD HourlyLAvg HourlyLSTD


%% July
Month = datenum('2015-07','yyyy-mm');
FolderStr = datestr(Month,'mm');
    
FullOutFile = dir([DataDir FolderStr '\' csvFileType csvFileExt]);   
MetOutFile = dir([DataDir FolderStr '\' metFileType csvFileExt]);

[FlxESTTime, FlxData] = read_fulloutput([DataDir FolderStr '\' FullOutFile.name]);
[MetESTTime, MetData] = read_fullmet([DataDir FolderStr '\' MetOutFile.name]);

FlxESTTimeStr = datestr(FlxESTTime,'yyyy-mm-dd HH:MM:SS'); 
FlxESTTime = datenum(FlxESTTimeStr,'yyyy-mm-dd HH:MM:SS');
MetESTTimeStr = datestr(MetESTTime,'yyyy-mm-dd HH:MM:SS'); 
MetESTTime = datenum(MetESTTimeStr,'yyyy-mm-dd HH:MM:SS');
%remove the points where Fluxes aren't calculated to get the same array
%sizes
[MetESTTime,MetIndx,FlxIndx] = intersect(MetESTTime,FlxESTTime); 
MetData = MetData(MetIndx,:); FlxData = FlxData(FlxIndx,:);
FlxESTTime = FlxESTTime(FlxIndx,:);
%cleanup data
FlxData=cleanup(FlxData);
[RE, GPP] = respiration(FlxData(:,14),MetData(:,5));

FlxESTHour = datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM');

tvec = datevec(FlxESTTime);
[PARf, PARd, kt] = splitPAR(MetESTTime,...
    MetData(:,17),MetData(:,20),MetData(:,4),MetData(:,11));
[unHours, ~, subs] = unique(tvec(:,4:5),'rows');
HourlyTime = unique(datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM'));

id.Ta = 2;
id.Ts = 5;
id.PAR = 17; 
id.G = 24;

HourlyParfAvg = accumarray(subs,PARf,[],@nanmean);
HourlyParfSTD = accumarray(subs,PARf,[],@nanstd);
HourlyPardAvg = accumarray(subs,PARd,[],@nanmean);
HourlyPardSTD = accumarray(subs,PARd,[],@nanstd);
HourlyParAvg = accumarray(subs, MetData(:,id.PAR), [], @nanmean);
HourlyParSTD = accumarray(subs, MetData(:,id.PAR), [], @nanstd);
HourlyTsAvg = accumarray(subs, MetData(:,id.Ts), [], @nanmean);
HourlyTsSTD = accumarray(subs, MetData(:,id.Ts), [], @nanstd);
HourlyTaAvg = accumarray(subs, MetData(:,id.Ta), [], @nanmean);
HourlyTaSTD = accumarray(subs, MetData(:,id.Ta), [], @nanstd);
HourlyqAvg = accumarray(subs, FlxData(:,66)*1000, [], @nanmean);
HourlyqSTD = accumarray(subs, FlxData(:,66)*1000, [], @nanstd);
HourlyNEEAvg = accumarray(subs, FlxData(:,14), [], @nanmean);
HourlyNEESTD = accumarray(subs, FlxData(:,14), [], @nanstd);
HourlyVPDAvg = accumarray(subs, FlxData(:,68), [], @nanmean);
HourlyVPDSTD = accumarray(subs, FlxData(:,68), [], @nanstd);
HourlyGPPAvg = accumarray(subs, GPP, [], @nanmean);
HourlyGPPSTD = accumarray(subs, GPP, [], @nanstd);
HourlyREAvg = accumarray(subs, RE, [], @nanmean);
HourlyRESTD = accumarray(subs, RE, [], @nanstd);
HourlyLAvg = accumarray(subs, FlxData(:,84), [], @nanmean);
HourlyLSTD = accumarray(subs, FlxData(:,84), [], @nanstd);
HourlyHAvg = accumarray(subs, FlxData(:,8), [], @nanmean);
HourlyHSTD = accumarray(subs, FlxData(:,8), [], @nanstd);
HourlyLEAvg = accumarray(subs, FlxData(:,11), [], @nanmean);
HourlyLESTD = accumarray(subs, FlxData(:,11), [], @nanstd);
HourlyGAvg = accumarray(subs, MetData(:,id.G), [], @nanmean);
HourlyGSTD = accumarray(subs, MetData(:,id.G), [], @nanstd);
HourlyUstrAvg = accumarray(subs, FlxData(:,82), [], @nanmean);
HourlyUstrSTD = accumarray(subs, FlxData(:,82), [], @nanstd);
HourlyRnAvg = accumarray(subs, MetData(:,12), [], @nanmean);
HourlyRnSTD = accumarray(subs, MetData(:,12), [], @nanstd);
HourlyFootAvg = accumarray(subs, FlxData(:,89), [], @nanmean);
HourlyFootSTD = accumarray(subs, FlxData(:,89), [], @nanstd);
HourlyWDAvg = accumarray(subs, MetData(:,29), [], @nanmean);
HourlyWDSTD = accumarray(subs, MetData(:,29), [], @nanstd);
CarbGPP = nansum(HourlyGPPAvg)*0.0216; % umol m-2 s-1 CO2 to gC m-2 
CarbRE = nansum(HourlyREAvg)*0.0216;
CarbNEE = nansum(HourlyNEEAvg)*0.0216;


MatFile = [DataDir datestr(Month,'mm') '_HourlyFull.mat'];
save(MatFile,'FlxData','FlxESTTime','MetData','MetESTTime','HourlyTime',...
    'HourlyParAvg','HourlyParSTD','HourlyParfAvg','HourlyParfSTD',...
    'HourlyPardAvg','HourlyPardSTD','HourlyTsAvg','HourlyTsSTD',...
    'HourlyTaAvg','HourlyTaSTD','HourlyqAvg','HourlyqSTD','FlxESTHour',...
    'HourlyVPDSTD','HourlyVPDAvg','HourlyNEEAvg','HourlyNEESTD',...
    'HourlyHAvg','HourlyHSTD','HourlyLEAvg','HourlyLESTD',...
    'HourlyGAvg','HourlyGSTD','HourlyUstrAvg','HourlyUstrSTD',...
    'HourlyRnAvg','HourlyRnSTD','HourlyFootAvg','HourlyFootSTD',...
    'HourlyWDAvg','HourlyWDSTD',...
    'HourlyGPPAvg','HourlyGPPSTD','HourlyREAvg','HourlyRESTD',...
    'HourlyLAvg','HourlyLSTD','CarbGPP','CarbRE','CarbNEE','-v7.3');

Hourly=figure('visible','on');
clf(Hourly);
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [plotwidth plotheight]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [2 0.25 plotwidth plotheight]);

ax=axes('position',sub_pos{1,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,[HourlyParAvg, HourlyParfAvg, HourlyPardAvg],'.'); 
yh = ylabel('PAR (\mumol m^{-2} s^{-1})');
ylim([0 2300]); 
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');
legend('PARt','PARf','PARd','Location','NW')
set(ax,'xticklabel',[]);
title([datestr(MetESTTime(10),'yyyy mmm')],'fontweight','bold','fontsize',14);


ax=axes('position',sub_pos{1,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight',...
    'bold');
o = plot(HourlyTime,HourlyVPDAvg,'.'); 
yh = ylabel('VPD ( Pa )');
ylim([0 3200]);
set(gca,'fontsize',14,'fontweight','bold');
set(ax,'xticklabel',[]);
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); 

ax=axes('position',sub_pos{1,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,HourlyNEEAvg,'*'); 
yh = ylabel('NEE (\mumol m^{-2} s^{-1})');
xh = xlabel('Time of Day [HH]');
ylim([-20 10]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')

ax=axes('position',sub_pos{2,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyTaAvg-273.15,'^'); 
set(ax,'xticklabel',[]);
yh = ylabel('Air Temperature (C)');
ylim([0 35]);
set(gca,'fontsize',14,'fontweight','bold');
t = title([datestr(MetESTTime(10),'yyyy mmm')]);
set([t yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');


ax=axes('position',sub_pos{2,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,HourlyTsAvg-273.15,'+'); 
yh = ylabel('Soil Temperature (C)');
set(ax,'xticklabel',[]); ylim([0 35]);
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{2,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyqAvg,'v'); 
yh = ylabel('q ( g kg^{-1})');
xh = xlabel('Time of Day [HH]');
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')


ax=axes('position',sub_pos{3,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyGPPAvg,'o'); 
yh = ylabel('GPP (\mumol m^{-2} s^{-1})');
set(ax,'xticklabel',[]);
set(gca,'fontsize',14,'fontweight','bold');
t = title([datestr(MetESTTime(10),'yyyy mmm')]);
set([t yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{3,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyREAvg,'.'); 
yh = ylabel('RE (\mumol m^{-2} s^{-1})');
set(ax,'xticklabel',[]);
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{3,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyLAvg,'.'); 
yh = ylabel('L ( m )'); ylim([-200 200]);
xh = xlabel('Time of Day [HH]'); datetick('x','HH')
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');


PlotHourlyDir=[OutputPlotDir datestr(MetESTTime(10),'yyyymm') '_Diel'];
print(Hourly, '-depsc2','-loose',[PlotHourlyDir,'.eps']);
system(['epstopdf ',PlotHourlyDir,'.eps']);
system(['convert -density 300 ',PlotHourlyDir,'.eps ',PlotHourlyDir,'.png']);

clear HourlyTime HourlyqAvg HourlyTsAvg HourlyTaAvg HourlyNEEAvg...
    HoulyVPDAvg HourlyParAvg HourlyParfAvg HourlyPardAvg MetESTTime...
    FlxESTTime FlxData MetData Hourly HourlyNEESTD HourlyGPPAvg ...
    HourlyGPPSTD HourlyREAvg HourlyRESTD HourlyLAvg HourlyLSTD


%% August
Month = datenum('2015-08','yyyy-mm');
FolderStr = datestr(Month,'mm');
    
FullOutFile = dir([DataDir FolderStr '\' csvFileType csvFileExt]);   
MetOutFile = dir([DataDir FolderStr '\' metFileType csvFileExt]);

[FlxESTTime, FlxData] = read_fulloutput([DataDir FolderStr '\' FullOutFile.name]);
[MetESTTime, MetData] = read_fullmet([DataDir FolderStr '\' MetOutFile.name]);

FlxESTTimeStr = datestr(FlxESTTime,'yyyy-mm-dd HH:MM:SS'); 
FlxESTTime = datenum(FlxESTTimeStr,'yyyy-mm-dd HH:MM:SS');
MetESTTimeStr = datestr(MetESTTime,'yyyy-mm-dd HH:MM:SS'); 
MetESTTime = datenum(MetESTTimeStr,'yyyy-mm-dd HH:MM:SS');
%remove the points where Fluxes aren't calculated to get the same array
%sizes
[MetESTTime,MetIndx,FlxIndx] = intersect(MetESTTime,FlxESTTime); 
MetData = MetData(MetIndx,:); FlxData = FlxData(FlxIndx,:);
FlxESTTime = FlxESTTime(FlxIndx,:);
%cleanup data
FlxData=cleanup(FlxData);
[RE, GPP] = respiration(FlxData(:,14),MetData(:,5));

FlxESTHour = datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM');

tvec = datevec(FlxESTTime);
[PARf, PARd, kt] = splitPAR(MetESTTime,...
    MetData(:,17),MetData(:,20),MetData(:,4),MetData(:,11));
[unHours, ~, subs] = unique(tvec(:,4:5),'rows');
HourlyTime = unique(datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM'));

id.Ta = 2;
id.Ts = 5;
id.PAR = 17; 
id.G = 24;

HourlyParfAvg = accumarray(subs,PARf,[],@nanmean);
HourlyParfSTD = accumarray(subs,PARf,[],@nanstd);
HourlyPardAvg = accumarray(subs,PARd,[],@nanmean);
HourlyPardSTD = accumarray(subs,PARd,[],@nanstd);
HourlyParAvg = accumarray(subs, MetData(:,id.PAR), [], @nanmean);
HourlyParSTD = accumarray(subs, MetData(:,id.PAR), [], @nanstd);
HourlyTsAvg = accumarray(subs, MetData(:,id.Ts), [], @nanmean);
HourlyTsSTD = accumarray(subs, MetData(:,id.Ts), [], @nanstd);
HourlyTaAvg = accumarray(subs, MetData(:,id.Ta), [], @nanmean);
HourlyTaSTD = accumarray(subs, MetData(:,id.Ta), [], @nanstd);
HourlyqAvg = accumarray(subs, FlxData(:,66)*1000, [], @nanmean);
HourlyqSTD = accumarray(subs, FlxData(:,66)*1000, [], @nanstd);
HourlyNEEAvg = accumarray(subs, FlxData(:,14), [], @nanmean);
HourlyNEESTD = accumarray(subs, FlxData(:,14), [], @nanstd);
HourlyVPDAvg = accumarray(subs, FlxData(:,68), [], @nanmean);
HourlyVPDSTD = accumarray(subs, FlxData(:,68), [], @nanstd);
HourlyGPPAvg = accumarray(subs, GPP, [], @nanmean);
HourlyGPPSTD = accumarray(subs, GPP, [], @nanstd);
HourlyREAvg = accumarray(subs, RE, [], @nanmean);
HourlyRESTD = accumarray(subs, RE, [], @nanstd);
HourlyLAvg = accumarray(subs, FlxData(:,84), [], @nanmean);
HourlyLSTD = accumarray(subs, FlxData(:,84), [], @nanstd);
HourlyHAvg = accumarray(subs, FlxData(:,8), [], @nanmean);
HourlyHSTD = accumarray(subs, FlxData(:,8), [], @nanstd);
HourlyLEAvg = accumarray(subs, FlxData(:,11), [], @nanmean);
HourlyLESTD = accumarray(subs, FlxData(:,11), [], @nanstd);
HourlyGAvg = accumarray(subs, MetData(:,id.G), [], @nanmean);
HourlyGSTD = accumarray(subs, MetData(:,id.G), [], @nanstd);
HourlyUstrAvg = accumarray(subs, FlxData(:,82), [], @nanmean);
HourlyUstrSTD = accumarray(subs, FlxData(:,82), [], @nanstd);
HourlyRnAvg = accumarray(subs, MetData(:,12), [], @nanmean);
HourlyRnSTD = accumarray(subs, MetData(:,12), [], @nanstd);
HourlyFootAvg = accumarray(subs, FlxData(:,89), [], @nanmean);
HourlyFootSTD = accumarray(subs, FlxData(:,89), [], @nanstd);
HourlyWDAvg = accumarray(subs, MetData(:,29), [], @nanmean);
HourlyWDSTD = accumarray(subs, MetData(:,29), [], @nanstd);
CarbGPP = nansum(HourlyGPPAvg)*0.0216; % umol m-2 s-1 CO2 to gC m-2 
CarbRE = nansum(HourlyREAvg)*0.0216;
CarbNEE = nansum(HourlyNEEAvg)*0.0216;


MatFile = [DataDir datestr(Month,'mm') '_HourlyFull.mat'];
save(MatFile,'FlxData','FlxESTTime','MetData','MetESTTime','HourlyTime',...
    'HourlyParAvg','HourlyParSTD','HourlyParfAvg','HourlyParfSTD',...
    'HourlyPardAvg','HourlyPardSTD','HourlyTsAvg','HourlyTsSTD',...
    'HourlyTaAvg','HourlyTaSTD','HourlyqAvg','HourlyqSTD','FlxESTHour',...
    'HourlyVPDSTD','HourlyVPDAvg','HourlyNEEAvg','HourlyNEESTD',...
    'HourlyHAvg','HourlyHSTD','HourlyLEAvg','HourlyLESTD',...
    'HourlyGAvg','HourlyGSTD','HourlyUstrAvg','HourlyUstrSTD',...
    'HourlyRnAvg','HourlyRnSTD','HourlyFootAvg','HourlyFootSTD',...
    'HourlyWDAvg','HourlyWDSTD',...
    'HourlyGPPAvg','HourlyGPPSTD','HourlyREAvg','HourlyRESTD',...
    'HourlyLAvg','HourlyLSTD','CarbGPP','CarbRE','CarbNEE','-v7.3');

Hourly=figure('visible','on');
clf(Hourly);
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [plotwidth plotheight]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [2 0.25 plotwidth plotheight]);

ax=axes('position',sub_pos{1,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,[HourlyParAvg, HourlyParfAvg, HourlyPardAvg],'.'); 
yh = ylabel('PAR (\mumol m^{-2} s^{-1})');
ylim([0 2300]); 
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');
legend('PARt','PARf','PARd','Location','NW')
set(ax,'xticklabel',[]);
title([datestr(MetESTTime(10),'yyyy mmm')],'fontweight','bold','fontsize',14);


ax=axes('position',sub_pos{1,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight',...
    'bold');
o = plot(HourlyTime,HourlyVPDAvg,'.'); 
yh = ylabel('VPD ( Pa )');
ylim([0 3200]);
set(gca,'fontsize',14,'fontweight','bold');
set(ax,'xticklabel',[]);
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); 

ax=axes('position',sub_pos{1,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,HourlyNEEAvg,'*'); 
yh = ylabel('NEE (\mumol m^{-2} s^{-1})');
xh = xlabel('Time of Day [HH]');
ylim([-20 10]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')

ax=axes('position',sub_pos{2,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyTaAvg-273.15,'^'); 
set(ax,'xticklabel',[]);
yh = ylabel('Air Temperature (C)');
ylim([0 35]);
set(gca,'fontsize',14,'fontweight','bold');
t = title([datestr(MetESTTime(10),'yyyy mmm')]);
set([t yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');


ax=axes('position',sub_pos{2,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,HourlyTsAvg-273.15,'+'); 
yh = ylabel('Soil Temperature (C)');
set(ax,'xticklabel',[]); ylim([0 35]);
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{2,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyqAvg,'v'); 
yh = ylabel('q ( g kg^{-1})');
xh = xlabel('Time of Day [HH]');
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')


ax=axes('position',sub_pos{3,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyGPPAvg,'o'); 
yh = ylabel('GPP (\mumol m^{-2} s^{-1})');
set(ax,'xticklabel',[]);
set(gca,'fontsize',14,'fontweight','bold');
t = title([datestr(MetESTTime(10),'yyyy mmm')]);
set([t yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{3,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyREAvg,'.'); 
yh = ylabel('RE (\mumol m^{-2} s^{-1})');
set(ax,'xticklabel',[]);
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{3,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyLAvg,'.'); 
yh = ylabel('L ( m )'); ylim([-200 200]);
xh = xlabel('Time of Day [HH]'); datetick('x','HH')
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');


PlotHourlyDir=[OutputPlotDir datestr(MetESTTime(10),'yyyymm') '_Diel'];
print(Hourly, '-depsc2','-loose',[PlotHourlyDir,'.eps']);
system(['epstopdf ',PlotHourlyDir,'.eps']);
system(['convert -density 300 ',PlotHourlyDir,'.eps ',PlotHourlyDir,'.png']);

clear HourlyTime HourlyqAvg HourlyTsAvg HourlyTaAvg HourlyNEEAvg...
    HoulyVPDAvg HourlyParAvg HourlyParfAvg HourlyPardAvg MetESTTime...
    FlxESTTime FlxData MetData Hourly HourlyNEESTD HourlyGPPAvg ...
    HourlyGPPSTD HourlyREAvg HourlyRESTD HourlyLAvg HourlyLSTD

%% September
Month = datenum('2015-09','yyyy-mm');
FolderStr = datestr(Month,'mm');
    
FullOutFile = dir([DataDir FolderStr '\' csvFileType csvFileExt]);   
MetOutFile = dir([DataDir FolderStr '\' metFileType csvFileExt]);

[FlxESTTime, FlxData] = read_fulloutput([DataDir FolderStr '\' FullOutFile.name]);
[MetESTTime, MetData] = read_fullmet([DataDir FolderStr '\' MetOutFile.name]);

FlxESTTimeStr = datestr(FlxESTTime,'yyyy-mm-dd HH:MM:SS'); 
FlxESTTime = datenum(FlxESTTimeStr,'yyyy-mm-dd HH:MM:SS');
MetESTTimeStr = datestr(MetESTTime,'yyyy-mm-dd HH:MM:SS'); 
MetESTTime = datenum(MetESTTimeStr,'yyyy-mm-dd HH:MM:SS');
%remove the points where Fluxes aren't calculated to get the same array
%sizes
[MetESTTime,MetIndx,FlxIndx] = intersect(MetESTTime,FlxESTTime); 
MetData = MetData(MetIndx,:); FlxData = FlxData(FlxIndx,:);
FlxESTTime = FlxESTTime(FlxIndx,:);
%cleanup data
FlxData=cleanup(FlxData);
[RE, GPP] = respiration(FlxData(:,14),MetData(:,5));

FlxESTHour = datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM');

tvec = datevec(FlxESTTime);
[PARf, PARd, kt] = splitPAR(MetESTTime,...
    MetData(:,17),MetData(:,20),MetData(:,4),MetData(:,11));
[unHours, ~, subs] = unique(tvec(:,4:5),'rows');
HourlyTime = unique(datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM'));

id.Ta = 2;
id.Ts = 5;
id.PAR = 17; 
id.G = 24;

HourlyParfAvg = accumarray(subs,PARf,[],@nanmean);
HourlyParfSTD = accumarray(subs,PARf,[],@nanstd);
HourlyPardAvg = accumarray(subs,PARd,[],@nanmean);
HourlyPardSTD = accumarray(subs,PARd,[],@nanstd);
HourlyParAvg = accumarray(subs, MetData(:,id.PAR), [], @nanmean);
HourlyParSTD = accumarray(subs, MetData(:,id.PAR), [], @nanstd);
HourlyTsAvg = accumarray(subs, MetData(:,id.Ts), [], @nanmean);
HourlyTsSTD = accumarray(subs, MetData(:,id.Ts), [], @nanstd);
HourlyTaAvg = accumarray(subs, MetData(:,id.Ta), [], @nanmean);
HourlyTaSTD = accumarray(subs, MetData(:,id.Ta), [], @nanstd);
HourlyqAvg = accumarray(subs, FlxData(:,66)*1000, [], @nanmean);
HourlyqSTD = accumarray(subs, FlxData(:,66)*1000, [], @nanstd);
HourlyNEEAvg = accumarray(subs, FlxData(:,14), [], @nanmean);
HourlyNEESTD = accumarray(subs, FlxData(:,14), [], @nanstd);
HourlyVPDAvg = accumarray(subs, FlxData(:,68), [], @nanmean);
HourlyVPDSTD = accumarray(subs, FlxData(:,68), [], @nanstd);
HourlyGPPAvg = accumarray(subs, GPP, [], @nanmean);
HourlyGPPSTD = accumarray(subs, GPP, [], @nanstd);
HourlyREAvg = accumarray(subs, RE, [], @nanmean);
HourlyRESTD = accumarray(subs, RE, [], @nanstd);
HourlyLAvg = accumarray(subs, FlxData(:,84), [], @nanmean);
HourlyLSTD = accumarray(subs, FlxData(:,84), [], @nanstd);
HourlyHAvg = accumarray(subs, FlxData(:,8), [], @nanmean);
HourlyHSTD = accumarray(subs, FlxData(:,8), [], @nanstd);
HourlyLEAvg = accumarray(subs, FlxData(:,11), [], @nanmean);
HourlyLESTD = accumarray(subs, FlxData(:,11), [], @nanstd);
HourlyGAvg = accumarray(subs, MetData(:,id.G), [], @nanmean);
HourlyGSTD = accumarray(subs, MetData(:,id.G), [], @nanstd);
HourlyUstrAvg = accumarray(subs, FlxData(:,82), [], @nanmean);
HourlyUstrSTD = accumarray(subs, FlxData(:,82), [], @nanstd);
HourlyRnAvg = accumarray(subs, MetData(:,12), [], @nanmean);
HourlyRnSTD = accumarray(subs, MetData(:,12), [], @nanstd);
HourlyFootAvg = accumarray(subs, FlxData(:,89), [], @nanmean);
HourlyFootSTD = accumarray(subs, FlxData(:,89), [], @nanstd);
HourlyWDAvg = accumarray(subs, MetData(:,29), [], @nanmean);
HourlyWDSTD = accumarray(subs, MetData(:,29), [], @nanstd);
CarbGPP = nansum(HourlyGPPAvg)*0.0216; % umol m-2 s-1 CO2 to gC m-2 
CarbRE = nansum(HourlyREAvg)*0.0216;
CarbNEE = nansum(HourlyNEEAvg)*0.0216;


MatFile = [DataDir datestr(Month,'mm') '_HourlyFull.mat'];
save(MatFile,'FlxData','FlxESTTime','MetData','MetESTTime','HourlyTime',...
    'HourlyParAvg','HourlyParSTD','HourlyParfAvg','HourlyParfSTD',...
    'HourlyPardAvg','HourlyPardSTD','HourlyTsAvg','HourlyTsSTD',...
    'HourlyTaAvg','HourlyTaSTD','HourlyqAvg','HourlyqSTD','FlxESTHour',...
    'HourlyVPDSTD','HourlyVPDAvg','HourlyNEEAvg','HourlyNEESTD',...
    'HourlyHAvg','HourlyHSTD','HourlyLEAvg','HourlyLESTD',...
    'HourlyGAvg','HourlyGSTD','HourlyUstrAvg','HourlyUstrSTD',...
    'HourlyRnAvg','HourlyRnSTD','HourlyFootAvg','HourlyFootSTD',...
    'HourlyWDAvg','HourlyWDSTD',...
    'HourlyGPPAvg','HourlyGPPSTD','HourlyREAvg','HourlyRESTD',...
    'HourlyLAvg','HourlyLSTD','CarbGPP','CarbRE','CarbNEE','-v7.3');

Hourly=figure('visible','on');
clf(Hourly);
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [plotwidth plotheight]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [2 0.25 plotwidth plotheight]);

ax=axes('position',sub_pos{1,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,[HourlyParAvg, HourlyParfAvg, HourlyPardAvg],'.'); 
yh = ylabel('PAR (\mumol m^{-2} s^{-1})');
ylim([0 2300]); 
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');
legend('PARt','PARf','PARd','Location','NW')
set(ax,'xticklabel',[]);
title([datestr(MetESTTime(10),'yyyy mmm')],'fontweight','bold','fontsize',14);


ax=axes('position',sub_pos{1,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight',...
    'bold');
o = plot(HourlyTime,HourlyVPDAvg,'.'); 
yh = ylabel('VPD ( Pa )');
ylim([0 3200]);
set(gca,'fontsize',14,'fontweight','bold');
set(ax,'xticklabel',[]);
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); 

ax=axes('position',sub_pos{1,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,HourlyNEEAvg,'*'); 
yh = ylabel('NEE (\mumol m^{-2} s^{-1})');
xh = xlabel('Time of Day [HH]');
ylim([-20 10]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')

ax=axes('position',sub_pos{2,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyTaAvg-273.15,'^'); 
set(ax,'xticklabel',[]);
yh = ylabel('Air Temperature (C)');
ylim([0 35]);
set(gca,'fontsize',14,'fontweight','bold');
t = title([datestr(MetESTTime(10),'yyyy mmm')]);
set([t yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');


ax=axes('position',sub_pos{2,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,HourlyTsAvg-273.15,'+'); 
yh = ylabel('Soil Temperature (C)');
set(ax,'xticklabel',[]); ylim([0 35]);
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{2,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyqAvg,'v'); 
yh = ylabel('q ( g kg^{-1})');
xh = xlabel('Time of Day [HH]');
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')


ax=axes('position',sub_pos{3,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyGPPAvg,'o'); 
yh = ylabel('GPP (\mumol m^{-2} s^{-1})');
set(ax,'xticklabel',[]);
set(gca,'fontsize',14,'fontweight','bold');
t = title([datestr(MetESTTime(10),'yyyy mmm')]);
set([t yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{3,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyREAvg,'.'); 
yh = ylabel('RE (\mumol m^{-2} s^{-1})');
set(ax,'xticklabel',[]);
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{3,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyLAvg,'.'); 
yh = ylabel('L ( m )'); ylim([-200 200]);
xh = xlabel('Time of Day [HH]'); datetick('x','HH')
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');


PlotHourlyDir=[OutputPlotDir datestr(MetESTTime(10),'yyyymm') '_Diel'];
print(Hourly, '-depsc2','-loose',[PlotHourlyDir,'.eps']);
system(['epstopdf ',PlotHourlyDir,'.eps']);
system(['convert -density 300 ',PlotHourlyDir,'.eps ',PlotHourlyDir,'.png']);

clear HourlyTime HourlyqAvg HourlyTsAvg HourlyTaAvg HourlyNEEAvg...
    HoulyVPDAvg HourlyParAvg HourlyParfAvg HourlyPardAvg MetESTTime...
    FlxESTTime FlxData MetData Hourly HourlyNEESTD HourlyGPPAvg ...
    HourlyGPPSTD HourlyREAvg HourlyRESTD HourlyLAvg HourlyLSTD

%% October
Month = datenum('2015-10','yyyy-mm');
FolderStr = datestr(Month,'mm');
    
FullOutFile = dir([DataDir FolderStr '\' csvFileType csvFileExt]);   
MetOutFile = dir([DataDir FolderStr '\' metFileType csvFileExt]);

[FlxESTTime, FlxData] = read_fulloutput([DataDir FolderStr '\' FullOutFile.name]);
[MetESTTime, MetData] = read_fullmet([DataDir FolderStr '\' MetOutFile.name]);

FlxESTTimeStr = datestr(FlxESTTime,'yyyy-mm-dd HH:MM:SS'); 
FlxESTTime = datenum(FlxESTTimeStr,'yyyy-mm-dd HH:MM:SS');
MetESTTimeStr = datestr(MetESTTime,'yyyy-mm-dd HH:MM:SS'); 
MetESTTime = datenum(MetESTTimeStr,'yyyy-mm-dd HH:MM:SS');
%remove the points where Fluxes aren't calculated to get the same array
%sizes
[MetESTTime,MetIndx,FlxIndx] = intersect(MetESTTime,FlxESTTime); 
MetData = MetData(MetIndx,:); FlxData = FlxData(FlxIndx,:);
FlxESTTime = FlxESTTime(FlxIndx,:);
%cleanup data
FlxData=cleanup(FlxData);
[RE, GPP] = respiration(FlxData(:,14),MetData(:,5));

FlxESTHour = datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM');

tvec = datevec(FlxESTTime);
[PARf, PARd, kt] = splitPAR(MetESTTime,...
    MetData(:,17),MetData(:,20),MetData(:,4),MetData(:,11));
[unHours, ~, subs] = unique(tvec(:,4:5),'rows');
HourlyTime = unique(datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM'));

id.Ta = 2;
id.Ts = 5;
id.PAR = 17; 
id.G = 24;

HourlyParfAvg = accumarray(subs,PARf,[],@nanmean);
HourlyParfSTD = accumarray(subs,PARf,[],@nanstd);
HourlyPardAvg = accumarray(subs,PARd,[],@nanmean);
HourlyPardSTD = accumarray(subs,PARd,[],@nanstd);
HourlyParAvg = accumarray(subs, MetData(:,id.PAR), [], @nanmean);
HourlyParSTD = accumarray(subs, MetData(:,id.PAR), [], @nanstd);
HourlyTsAvg = accumarray(subs, MetData(:,id.Ts), [], @nanmean);
HourlyTsSTD = accumarray(subs, MetData(:,id.Ts), [], @nanstd);
HourlyTaAvg = accumarray(subs, MetData(:,id.Ta), [], @nanmean);
HourlyTaSTD = accumarray(subs, MetData(:,id.Ta), [], @nanstd);
HourlyqAvg = accumarray(subs, FlxData(:,66)*1000, [], @nanmean);
HourlyqSTD = accumarray(subs, FlxData(:,66)*1000, [], @nanstd);
HourlyNEEAvg = accumarray(subs, FlxData(:,14), [], @nanmean);
HourlyNEESTD = accumarray(subs, FlxData(:,14), [], @nanstd);
HourlyVPDAvg = accumarray(subs, FlxData(:,68), [], @nanmean);
HourlyVPDSTD = accumarray(subs, FlxData(:,68), [], @nanstd);
HourlyGPPAvg = accumarray(subs, GPP, [], @nanmean);
HourlyGPPSTD = accumarray(subs, GPP, [], @nanstd);
HourlyREAvg = accumarray(subs, RE, [], @nanmean);
HourlyRESTD = accumarray(subs, RE, [], @nanstd);
HourlyLAvg = accumarray(subs, FlxData(:,84), [], @nanmean);
HourlyLSTD = accumarray(subs, FlxData(:,84), [], @nanstd);
HourlyHAvg = accumarray(subs, FlxData(:,8), [], @nanmean);
HourlyHSTD = accumarray(subs, FlxData(:,8), [], @nanstd);
HourlyLEAvg = accumarray(subs, FlxData(:,11), [], @nanmean);
HourlyLESTD = accumarray(subs, FlxData(:,11), [], @nanstd);
HourlyGAvg = accumarray(subs, MetData(:,id.G), [], @nanmean);
HourlyGSTD = accumarray(subs, MetData(:,id.G), [], @nanstd);
HourlyUstrAvg = accumarray(subs, FlxData(:,82), [], @nanmean);
HourlyUstrSTD = accumarray(subs, FlxData(:,82), [], @nanstd);
HourlyRnAvg = accumarray(subs, MetData(:,12), [], @nanmean);
HourlyRnSTD = accumarray(subs, MetData(:,12), [], @nanstd);
HourlyFootAvg = accumarray(subs, FlxData(:,89), [], @nanmean);
HourlyFootSTD = accumarray(subs, FlxData(:,89), [], @nanstd);
HourlyWDAvg = accumarray(subs, MetData(:,29), [], @nanmean);
HourlyWDSTD = accumarray(subs, MetData(:,29), [], @nanstd);
CarbGPP = nansum(HourlyGPPAvg)*0.0216; % umol m-2 s-1 CO2 to gC m-2 
CarbRE = nansum(HourlyREAvg)*0.0216;
CarbNEE = nansum(HourlyNEEAvg)*0.0216;


MatFile = [DataDir datestr(Month,'mm') '_HourlyFull.mat'];
save(MatFile,'FlxData','FlxESTTime','MetData','MetESTTime','HourlyTime',...
    'HourlyParAvg','HourlyParSTD','HourlyParfAvg','HourlyParfSTD',...
    'HourlyPardAvg','HourlyPardSTD','HourlyTsAvg','HourlyTsSTD',...
    'HourlyTaAvg','HourlyTaSTD','HourlyqAvg','HourlyqSTD','FlxESTHour',...
    'HourlyVPDSTD','HourlyVPDAvg','HourlyNEEAvg','HourlyNEESTD',...
    'HourlyHAvg','HourlyHSTD','HourlyLEAvg','HourlyLESTD',...
    'HourlyGAvg','HourlyGSTD','HourlyUstrAvg','HourlyUstrSTD',...
    'HourlyRnAvg','HourlyRnSTD','HourlyFootAvg','HourlyFootSTD',...
    'HourlyWDAvg','HourlyWDSTD',...
    'HourlyGPPAvg','HourlyGPPSTD','HourlyREAvg','HourlyRESTD',...
    'HourlyLAvg','HourlyLSTD','CarbGPP','CarbRE','CarbNEE','-v7.3');

Hourly=figure('visible','on');
clf(Hourly);
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [plotwidth plotheight]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [2 0.25 plotwidth plotheight]);

ax=axes('position',sub_pos{1,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,[HourlyParAvg, HourlyParfAvg, HourlyPardAvg],'.'); 
yh = ylabel('PAR (\mumol m^{-2} s^{-1})');
ylim([0 2300]); 
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');
legend('PARt','PARf','PARd','Location','NW')
set(ax,'xticklabel',[]);
title([datestr(MetESTTime(10),'yyyy mmm')],'fontweight','bold','fontsize',14);


ax=axes('position',sub_pos{1,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight',...
    'bold');
o = plot(HourlyTime,HourlyVPDAvg,'.'); 
yh = ylabel('VPD ( Pa )');
ylim([0 3200]);
set(gca,'fontsize',14,'fontweight','bold');
set(ax,'xticklabel',[]);
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); 

ax=axes('position',sub_pos{1,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,HourlyNEEAvg,'*'); 
yh = ylabel('NEE (\mumol m^{-2} s^{-1})');
xh = xlabel('Time of Day [HH]');
ylim([-20 10]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')

ax=axes('position',sub_pos{2,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyTaAvg-273.15,'^'); 
set(ax,'xticklabel',[]);
yh = ylabel('Air Temperature (C)');
ylim([0 35]);
set(gca,'fontsize',14,'fontweight','bold');
t = title([datestr(MetESTTime(10),'yyyy mmm')]);
set([t yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');


ax=axes('position',sub_pos{2,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,HourlyTsAvg-273.15,'+'); 
yh = ylabel('Soil Temperature (C)');
set(ax,'xticklabel',[]); ylim([0 35]);
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{2,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyqAvg,'v'); 
yh = ylabel('q ( g kg^{-1})');
xh = xlabel('Time of Day [HH]');
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')


ax=axes('position',sub_pos{3,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyGPPAvg,'o'); 
yh = ylabel('GPP (\mumol m^{-2} s^{-1})');
set(ax,'xticklabel',[]);
set(gca,'fontsize',14,'fontweight','bold');
t = title([datestr(MetESTTime(10),'yyyy mmm')]);
set([t yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{3,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyREAvg,'.'); 
yh = ylabel('RE (\mumol m^{-2} s^{-1})');
set(ax,'xticklabel',[]);
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{3,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyLAvg,'.'); 
yh = ylabel('L ( m )'); ylim([-200 200]);
xh = xlabel('Time of Day [HH]'); datetick('x','HH')
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');


PlotHourlyDir=[OutputPlotDir datestr(MetESTTime(10),'yyyymm') '_Diel'];
print(Hourly, '-depsc2','-loose',[PlotHourlyDir,'.eps']);
system(['epstopdf ',PlotHourlyDir,'.eps']);
system(['convert -density 300 ',PlotHourlyDir,'.eps ',PlotHourlyDir,'.png']);

clear HourlyTime HourlyqAvg HourlyTsAvg HourlyTaAvg HourlyNEEAvg...
    HoulyVPDAvg HourlyParAvg HourlyParfAvg HourlyPardAvg MetESTTime...
    FlxESTTime FlxData MetData Hourly HourlyNEESTD HourlyGPPAvg ...
    HourlyGPPSTD HourlyREAvg HourlyRESTD HourlyLAvg HourlyLSTD

%% November
Month = datenum('2015-11','yyyy-mm');
FolderStr = datestr(Month,'mm');

id.Ta = 4; id.Ts = 5; id.PAR = 17; id.G = 24;

FullOutFile = dir([DataDir FolderStr '\' csvFileType csvFileExt]);   
MetOutFile = dir([DataDir FolderStr '\' metFileType csvFileExt]);

[FlxESTTime, FlxData] = read_fulloutput([DataDir FolderStr '\' FullOutFile.name]);
[MetESTTime, MetData] = read_fullmet([DataDir FolderStr '\' MetOutFile.name]);

FlxESTTimeStr = datestr(FlxESTTime,'yyyy-mm-dd HH:MM:SS'); 
FlxESTTime = datenum(FlxESTTimeStr,'yyyy-mm-dd HH:MM:SS');
MetESTTimeStr = datestr(MetESTTime,'yyyy-mm-dd HH:MM:SS'); 
MetESTTime = datenum(MetESTTimeStr,'yyyy-mm-dd HH:MM:SS');
%remove the points where Fluxes aren't calculated to get the same array
%sizes
[MetESTTime,MetIndx,FlxIndx] = intersect(MetESTTime,FlxESTTime); 
MetData = MetData(MetIndx,:); FlxData = FlxData(FlxIndx,:);
FlxESTTime = FlxESTTime(FlxIndx,:);
%cleanup data
FlxData=cleanup(FlxData);
[RE, GPP] = respiration(FlxData(:,14),MetData(:,id.Ts));

FlxESTHour = datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM');

tvec = datevec(FlxESTTime);
[PARf, PARd, kt] = splitPAR(MetESTTime,...
    MetData(:,id.PAR),MetData(:,20),MetData(:,4),MetData(:,11));
[unHours, ~, subs] = unique(tvec(:,4:5),'rows');
HourlyTime = unique(datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM'));

HourlyParfAvg = accumarray(subs,PARf,[],@nanmean);
HourlyParfSTD = accumarray(subs,PARf,[],@nanstd);
HourlyPardAvg = accumarray(subs,PARd,[],@nanmean);
HourlyPardSTD = accumarray(subs,PARd,[],@nanstd);
HourlyParAvg = accumarray(subs, MetData(:,id.PAR), [], @nanmean);
HourlyParSTD = accumarray(subs, MetData(:,id.PAR), [], @nanstd);
HourlyTsAvg = accumarray(subs, MetData(:,id.Ts), [], @nanmean);
HourlyTsSTD = accumarray(subs, MetData(:,id.Ts), [], @nanstd);
HourlyTaAvg = accumarray(subs, MetData(:,id.Ta), [], @nanmean);
HourlyTaSTD = accumarray(subs, MetData(:,id.Ta), [], @nanstd);
HourlyqAvg = accumarray(subs, FlxData(:,66)*1000, [], @nanmean);
HourlyqSTD = accumarray(subs, FlxData(:,66)*1000, [], @nanstd);
HourlyNEEAvg = accumarray(subs, FlxData(:,14), [], @nanmean);
HourlyNEESTD = accumarray(subs, FlxData(:,14), [], @nanstd);
HourlyVPDAvg = accumarray(subs, FlxData(:,68), [], @nanmean);
HourlyVPDSTD = accumarray(subs, FlxData(:,68), [], @nanstd);
HourlyGPPAvg = accumarray(subs, GPP, [], @nanmean);
HourlyGPPSTD = accumarray(subs, GPP, [], @nanstd);
HourlyREAvg = accumarray(subs, RE, [], @nanmean);
HourlyRESTD = accumarray(subs, RE, [], @nanstd);
HourlyLAvg = accumarray(subs, FlxData(:,84), [], @nanmean);
HourlyLSTD = accumarray(subs, FlxData(:,84), [], @nanstd);
HourlyHAvg = accumarray(subs, FlxData(:,8), [], @nanmean);
HourlyHSTD = accumarray(subs, FlxData(:,8), [], @nanstd);
HourlyLEAvg = accumarray(subs, FlxData(:,11), [], @nanmean);
HourlyLESTD = accumarray(subs, FlxData(:,11), [], @nanstd);
HourlyGAvg = accumarray(subs, MetData(:,id.G), [], @nanmean);
HourlyGSTD = accumarray(subs, MetData(:,id.G), [], @nanstd);
HourlyUstrAvg = accumarray(subs, FlxData(:,82), [], @nanmean);
HourlyUstrSTD = accumarray(subs, FlxData(:,82), [], @nanstd);
HourlyRnAvg = accumarray(subs, MetData(:,12), [], @nanmean);
HourlyRnSTD = accumarray(subs, MetData(:,12), [], @nanstd);
HourlyFootAvg = accumarray(subs, FlxData(:,89), [], @nanmean);
HourlyFootSTD = accumarray(subs, FlxData(:,89), [], @nanstd);
HourlyWDAvg = accumarray(subs, MetData(:,29), [], @nanmean);
HourlyWDSTD = accumarray(subs, MetData(:,29), [], @nanstd);
CarbGPP = nansum(HourlyGPPAvg)*0.0216; % umol m-2 s-1 CO2 to gC m-2 
CarbRE = nansum(HourlyREAvg)*0.0216;
CarbNEE = nansum(HourlyNEEAvg)*0.0216;


MatFile = [DataDir datestr(Month,'mm') '_HourlyFull.mat'];
save(MatFile,'FlxData','FlxESTTime','MetData','MetESTTime','HourlyTime',...
    'HourlyParAvg','HourlyParSTD','HourlyParfAvg','HourlyParfSTD',...
    'HourlyPardAvg','HourlyPardSTD','HourlyTsAvg','HourlyTsSTD',...
    'HourlyTaAvg','HourlyTaSTD','HourlyqAvg','HourlyqSTD','FlxESTHour',...
    'HourlyVPDSTD','HourlyVPDAvg','HourlyNEEAvg','HourlyNEESTD',...
    'HourlyHAvg','HourlyHSTD','HourlyLEAvg','HourlyLESTD',...
    'HourlyGAvg','HourlyGSTD','HourlyUstrAvg','HourlyUstrSTD',...
    'HourlyRnAvg','HourlyRnSTD','HourlyFootAvg','HourlyFootSTD',...
    'HourlyWDAvg','HourlyWDSTD',...
    'HourlyGPPAvg','HourlyGPPSTD','HourlyREAvg','HourlyRESTD',...
    'HourlyLAvg','HourlyLSTD','CarbGPP','CarbRE','CarbNEE','-v7.3');

Hourly=figure('visible','on');
clf(Hourly);
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [plotwidth plotheight]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [2 0.25 plotwidth plotheight]);

ax=axes('position',sub_pos{1,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,[HourlyParAvg, HourlyParfAvg, HourlyPardAvg],'.'); 
yh = ylabel('PAR (\mumol m^{-2} s^{-1})');
ylim([0 2300]); 
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');
legend('PARt','PARf','PARd','Location','NW')
set(ax,'xticklabel',[]);
title([datestr(MetESTTime(10),'yyyy mmm')],'fontweight','bold','fontsize',14);


ax=axes('position',sub_pos{1,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight',...
    'bold');
o = plot(HourlyTime,HourlyVPDAvg,'.'); 
yh = ylabel('VPD ( Pa )');
ylim([0 3200]);
set(gca,'fontsize',14,'fontweight','bold');
set(ax,'xticklabel',[]);
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); 

ax=axes('position',sub_pos{1,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,HourlyNEEAvg,'*'); 
yh = ylabel('NEE (\mumol m^{-2} s^{-1})');
xh = xlabel('Time of Day [HH]');
ylim([-20 10]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')

ax=axes('position',sub_pos{2,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyTaAvg-273.15,'^'); 
set(ax,'xticklabel',[]);
yh = ylabel('Air Temperature (C)');
ylim([0 35]);
set(gca,'fontsize',14,'fontweight','bold');
t = title([datestr(MetESTTime(10),'yyyy mmm')]);
set([t yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');


ax=axes('position',sub_pos{2,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,HourlyTsAvg-273.15,'+'); 
yh = ylabel('Soil Temperature (C)');
set(ax,'xticklabel',[]); ylim([0 35]);
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{2,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyqAvg,'v'); 
yh = ylabel('q ( g kg^{-1})');
xh = xlabel('Time of Day [HH]');
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')


ax=axes('position',sub_pos{3,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyGPPAvg,'o'); 
yh = ylabel('GPP (\mumol m^{-2} s^{-1})');
set(ax,'xticklabel',[]);
set(gca,'fontsize',14,'fontweight','bold');
t = title([datestr(MetESTTime(10),'yyyy mmm')]);
set([t yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{3,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyREAvg,'.'); 
yh = ylabel('RE (\mumol m^{-2} s^{-1})');
set(ax,'xticklabel',[]);
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{3,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyLAvg,'.'); 
yh = ylabel('L ( m )'); ylim([-200 200]);
xh = xlabel('Time of Day [HH]'); datetick('x','HH')
% ylim([5 20]);
set(gca,'fontsize',14,'fontweight','bold');
set([xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');


PlotHourlyDir=[OutputPlotDir datestr(MetESTTime(10),'yyyymm') '_Diel'];
print(Hourly, '-depsc2','-loose',[PlotHourlyDir,'.eps']);
system(['epstopdf ',PlotHourlyDir,'.eps']);
system(['convert -density 300 ',PlotHourlyDir,'.eps ',PlotHourlyDir,'.png']);

clear HourlyTime HourlyqAvg HourlyTsAvg HourlyTaAvg HourlyNEEAvg...
    HoulyVPDAvg HourlyParAvg HourlyParfAvg HourlyPardAvg MetESTTime...
    FlxESTTime FlxData MetData Hourly HourlyNEESTD HourlyGPPAvg ...
    HourlyGPPSTD HourlyREAvg HourlyRESTD HourlyLAvg HourlyLSTD

