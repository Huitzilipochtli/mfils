function [MetData, FlxData, FlxESTTime] = hourly(DataDir, OutputPlotDir, Month)
% DataDir = Directory of data
% OutputPlotDir = Directory for plots to be written to (.png .pdf .eps)
% Month = Month to plot usually in a directory structure
% NEE has the storage term included in the output
%% Example call 
% OutputPlotDir = 'F:\jzr201\FluxData\BioCorr\2015\';
% DataDir = 'F:\jzr201\FluxData\BioCorr\2015\';
% Month = datenum('2015-11','yyyy-mm');
% [MetData, FlxData, FlxESTTime] = hourly(DataDir, OutputPlotDir, Month)

FolderStr = datestr(Month,'mm');
csvFileExt = '.csv';
csvFileType = '*full_output*';
metFileType = '*_biomet_*';

newinstr = datenum('06-04-2015 10:00:00','mm-dd-yyyy HH:MM:SS'); %added

if (Month >= newinstr)
id.Ta = 3; id.Ts = 5; id.PAR = 17; id.G = 22; id.Rg = 20; 
id.Rn = 12; id.WD = 27; id.RH = 10;
else
id.Ta = 2; id.Ts = 5; id.PAR = 15; id.G = 20; id.Rg = 18; 
id.Rn = 10; id.WD = 22; id.RH = 8;   
end

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
[RE, GPP] = respiration(FlxData(:,14)+ FlxData(:,28),MetData(:,id.Ts));

FlxESTHour = datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM');

tvec = datevec(FlxESTTime);
[FullPARf, FullPARd, eps, So, kt, Del] = splitPAR(MetESTTime,...
    MetData(:,id.PAR),MetData(:,id.Rg),MetData(:,id.Ta),MetData(:,id.RH));
[unHours, ~, subs] = unique(tvec(:,4:5),'rows');
HourlyTime = unique(datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM'));

HourlyParfAvg = accumarray(subs,FullPARf,[],@nanmean);
HourlyParfSTD = accumarray(subs,FullPARf,[],@nanstd);
HourlyPardAvg = accumarray(subs,FullPARd,[],@nanmean);
HourlyPardSTD = accumarray(subs,FullPARd,[],@nanstd);
HourlyParAvg = accumarray(subs, MetData(:,id.PAR), [], @nanmean);
HourlyParSTD = accumarray(subs, MetData(:,id.PAR), [], @nanstd);
HourlyTsAvg = accumarray(subs, MetData(:,id.Ts), [], @nanmean);
HourlyTsSTD = accumarray(subs, MetData(:,id.Ts), [], @nanstd);
HourlyTaAvg = accumarray(subs, MetData(:,id.Ta), [], @nanmean);
HourlyTaSTD = accumarray(subs, MetData(:,id.Ta), [], @nanstd);
HourlyqAvg = accumarray(subs, FlxData(:,66)*1000, [], @nanmean);
HourlyqSTD = accumarray(subs, FlxData(:,66)*1000, [], @nanstd);
HourlyNEEAvg = accumarray(subs, FlxData(:,14)+FlxData(:,28), [], @nanmean);
HourlyNEESTD = accumarray(subs, FlxData(:,14)+FlxData(:,28), [], @nanstd);
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
HourlyRnAvg = accumarray(subs, MetData(:,id.Rn), [], @nanmean);
HourlyRnSTD = accumarray(subs, MetData(:,id.Rn), [], @nanstd);
HourlyFootAvg = accumarray(subs, FlxData(:,89), [], @nanmean);
HourlyFootSTD = accumarray(subs, FlxData(:,89), [], @nanstd);
HourlyWDAvg = accumarray(subs, MetData(:,id.WD), [], @nanmean);
HourlyWDSTD = accumarray(subs, MetData(:,id.WD), [], @nanstd);
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


%% Plot Stuff
% % % %parameters for figure and panel size
cols = brewermap(8,'Dark2'); 
TitleFontSize = 12; labelfontsz = 15; fontsz = 15; 
NumTicks = 7; FontWeight ='demi'; markersz = 15; L =20; H =18;
PlotLineWidth = 2; markeredge = 'Black'; 
plotheight=18;
plotwidth=20;
subplotsx=3;
subplotsy=3;   
leftedge=2.1;
rightedge=0.4;   
topedge=1;
bottomedge=1.5;
spacex=1.5;
spacey=0.7;
fontsize=14;    
sub_pos=subplot_pos(plotwidth,plotheight,leftedge,rightedge,...
    bottomedge,topedge,subplotsx,subplotsy,spacex,spacey);
subplotsx=2;
subplotsy=2; 
sub_pos2=subplot_pos(plotwidth,plotheight,leftedge,rightedge,...
    bottomedge,topedge,subplotsx,subplotsy,spacex,spacey);
% Change to new colors.
set(0,'DefaultAxesColorOrder',cols);


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
set(ax,'xticklabel',[]); ylim([-1 35]);
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
% 
% clear HourlyTime HourlyqAvg HourlyTsAvg HourlyTaAvg HourlyNEEAvg...
%     HoulyVPDAvg HourlyParAvg HourlyParfAvg HourlyPardAvg MetESTTime...
%     FlxESTTime FlxData MetData Hourly HourlyNEESTD HourlyGPPAvg ...
%     HourlyGPPSTD HourlyREAvg HourlyRESTD HourlyLAvg HourlyLSTD

end
