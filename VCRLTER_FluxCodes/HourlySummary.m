function [MetData,FlxData,FlxESTTime,HourlyTime]= HourlySummary(FlxESTTime,FlxData,MetData,OutputPlotDir)
addpath(genpath('V:\Micrometeorology\mfiles\'));
% OutputPlotDir = 'F:\jzr201\temp\GillFieldTest\';
% DataDir = 'F:\jzr201\FluxData\BioCorr\2014\10\';
csvFileExt = '.csv';
csvFileType = '*full_output*';
metFileType = '*_biomet*';

id.Ta = 3; id.Ts = 5; id.PAR = 17; id.G = 22; id.Rg = 20; 
id.Rn = 12; id.WD = 27; id.RH = 10; id.Tw = 8;
fact = round(length(FlxESTTime)/2);
% % clear all; close all;
% % StartTime = '2015-06-26 00:00';
% % EndTime = '2015-07-20 00:00';
% % [BioMetFile] = BioMet(StartTime,EndTime);

% FlxFile = ...
% 'F:\jzr201\temp\GillFieldTest\eddypro_2015July_full_output_2015-07-13T104259.csv';
%     'F:\jzr201\temp\GillFieldTest\eddypro_2015June_full_output_2015-07-09T143935.csv';

% FlxFile = dir([DataDir csvFileType csvFileExt]);
% MetFile = dir([DataDir metFileType csvFileExt]);
% 
% [FlxESTTime, FlxData] = read_fulloutput([DataDir FlxFile.name]);
% % MetFile = ...
% % 'F:\jzr201\temp\GillFieldTest\eddypro_2015July_biomet_2015-07-13T095534.csv';
% %     'F:\jzr201\temp\GillFieldTest\eddypro_2015June_biomet_2015-07-09T140146.csv';
% 
% [MetESTTime, MetData] = read_fullmet([DataDir MetFile.name]);

%% Plot Stuff
% % % %parameters for figure and panel size
cols = brewermap(8,'Dark2');
TitleFontSize = 12; labelfontsz = 15; fontsz = 14;
NumTicks = 7; FontWeight ='demi'; markersz = 10; L =20; H =18;
PlotLineWidth = 2; markeredge = 'Black';
plotheight=23;
plotwidth=30;
subplotsx=3;
subplotsy=3;
leftedge=2.1;
rightedge=0.4;
topedge=1;
bottomedge=1.5;
spacex=2.0;
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

%%

% FlxESTTimeStr = datestr(FlxESTTime,'yyyy-mm-dd HH:MM:SS');
% FlxESTTime = datenum(FlxESTTimeStr,'yyyy-mm-dd HH:MM:SS');
% MetESTTimeStr = datestr(MetESTTime,'yyyy-mm-dd HH:MM:SS');
% MetESTTime = datenum(MetESTTimeStr,'yyyy-mm-dd HH:MM:SS');
% %remove the points where Fluxes aren't calculated to get the same array
% %sizes
% [MetESTTime,MetIndx,FlxIndx] = intersect(MetESTTime,FlxESTTime);
% MetData = MetData(MetIndx,:); FlxData = FlxData(FlxIndx,:);
% FlxESTTime = FlxESTTime(FlxIndx,:);
% %cleanup data
% FlxData=cleanup(FlxData);
[RE, GPP] = respiration(FlxData(:,14)+FlxData(:,28),MetData(:,id.Ts));

newinstr = datenum('06-04-2015 10:00:00','mm-dd-yyyy HH:MM:SS'); %added

% % if (FlxESTTime(1) >= newinstr)
% %     %% Met Data columns
% %     id.ws = 21; %Wind Speed RMY
% %     id.G = 24; %Soil Heat Flux
% % else
% %     id.ws = 19; %Wind Speed RMY
% %     id.G = 22; %Soil Heat Flux
% % end

if (FlxESTTime(1) >= newinstr)
id.Ta = 3; id.Ts = 5; id.PAR = 17; id.G = 22; id.Rg = 20; 
id.Rn = 12; id.WD = 27; id.RH = 10;
else
id.Ta = 2; id.Ts = 5; id.PAR = 15; id.G = 20; id.Rg = 18; 
id.Rn = 10; id.WD = 22; id.RH = 8;   
end


a = FlxData(:,73).*FlxData(:,73);
b = FlxData(:,74).*FlxData(:,74);
c = FlxData(:,75).*FlxData(:,75);
SonicWS = sqrt(a+b);

FlxESTHour = datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM');

tvec = datevec(FlxESTTime);
[FullPARf, FullPARd, eps, So, kt, Del] = splitPAR(FlxESTTime,...
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
HourlyTwAvg = accumarray(subs, MetData(:,id.Tw), [], @nanmean);
HourlyTwSTD = accumarray(subs, MetData(:,id.Tw), [], @nanstd);
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
% HourlyWDAvg = accumarray(subs, MetData(:,id.WD), [], @nanmean);
% HourlyWDSTD = accumarray(subs, MetData(:,id.WD), [], @nanstd);
HourlyWDAvg = accumarray(subs, FlxData(:,78), [], @nanmean);
HourlyWDSTD = accumarray(subs, FlxData(:,78), [], @nanstd);


Hourly=figure('visible','on');
clf(Hourly);
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [plotwidth plotheight]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [2 0.25 plotwidth plotheight]);

ax=axes('position',sub_pos{1,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
% s =  plot(HourlyTime,[HourlyParAvg, HourlyParfAvg, HourlyPardAvg],'.');
s =  plot(HourlyTime,HourlyParAvg,'.');
set(s,'MarkerSize',markersz);
yh = ylabel('PAR (\mumol m^{-2} s^{-1})');
ylim([0 2300]); 
set(gca,'fontsize',fontsz,'fontweight','bold');
t = title([datestr(FlxESTTime(10),'yyyy mmm dd') ' to ' ...
    datestr(FlxESTTime(end),'mmm dd')],'fontweight','bold','fontsize',fontsz);
% legstr={'PARt','PARf','PARd'}; hleg = legend(legstr);
% set(hleg,'Orientation','Horizontal','box','off',...
%     'Location','NorthWest','fontsize',fontsz);
set(ax,'xticklabel',[]);
set([t yh],'Fontsize',fontsz,'Fontname','Timesnewroman',...
    'FontWeight','bold');


ax=axes('position',sub_pos{1,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight',...
    'bold');
o = plot(HourlyTime,HourlyVPDAvg,'<'); set(o,'MarkerSize',markersz);
yh = ylabel('VPD ( Pa )');
ylim([0 3200]);
set(gca,'fontsize',fontsz,'fontweight','bold');
set(ax,'xticklabel',[]);
set([yh],'Fontsize',fontsz,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{1,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,HourlyNEEAvg,'*'); set(s,'MarkerSize',markersz);
yh = ylabel('NEE (\mumol m^{-2} s^{-1})');
xh = xlabel('Time of Day [HH]');
ylim([-20 10]);
set(gca,'fontsize',fontsz,'fontweight','bold');
set([xh yh],'Fontsize',fontsz,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')

ax=axes('position',sub_pos{2,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,[HourlyTaAvg-273.15 HourlyTsAvg-273.15 HourlyTwAvg],'^');
set(s,'MarkerSize',markersz);
set(ax,'xticklabel',[]); legstr = {'Air','Soil','Water'};
yh = ylabel('Temperature (C)');
ylim([0 35]);
set(gca,'fontsize',14,'fontweight','bold');
t = title([datestr(FlxESTTime(10),'yyyy mmm dd') ' to ' ...
    datestr(FlxESTTime(end),'yyyy mmm dd')],'fontweight','bold','fontsize',fontsz);
hleg = legend(legstr);
set(hleg,'Orientation','Horizontal','box','off',...
    'Location','NorthWest','fontsize',fontsz);
set([t yh],'Fontsize',fontsz,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{2,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s =  plot(HourlyTime,[HourlyRnAvg HourlyLEAvg HourlyHAvg HourlyGAvg],'+');
yh = ylabel(' Energy (W m^{-2})'); set(s,'MarkerSize',markersz);
set(ax,'xticklabel',[]); legstr = {'Rn','LE','H','G'};
ylim([0 1200]);
set(gca,'fontsize',fontsz,'fontweight','bold');
hleg = legend(legstr);
set(hleg,'Orientation','Horizontal','box','off',...
    'Location','NorthWest','fontsize',fontsz);
set([yh],'Fontsize',fontsz,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{2,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyqAvg,'v'); set(s,'MarkerSize',markersz);
yh = ylabel('q ( g kg^{-1})');
xh = xlabel('Time of Day [HH]');
ylim([1 20]);
set(gca,'fontsize',fontsz,'fontweight','bold');
set([xh yh],'Fontsize',fontsz,'Fontname','Timesnewroman',...
    'FontWeight','bold'); datetick('x','HH')

ax=axes('position',sub_pos{3,3},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,[HourlyGPPAvg HourlyREAvg],'o'); 
legstr = {'GPP','RE'};
hleg = legend(legstr);
% s = plot(HourlyTime,HourlyGPPAvg,'o'); 
set(s,'MarkerSize',markersz);
yh = ylabel('GPP , RE (\mumol m^{-2} s^{-1})');
set(ax,'xticklabel',[]); ylim([0 10]);
set(gca,'fontsize',fontsz,'fontweight','bold');
t=title([datestr(FlxESTTime(10),'yyyy mmm dd') ' to ' ...
    datestr(FlxESTTime(end),'yyyy mmm dd')],'fontweight','bold','fontsize',14);
set([t yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');
set(hleg,'Orientation','Horizontal','box','off',...
    'Location','NorthWest','fontsize',fontsz);

ax=axes('position',sub_pos{3,2},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,HourlyFootAvg,'d');
yh = ylabel('Footprint (m)'); set(s,'MarkerSize',markersz);
set(ax,'xticklabel',[]);
ylim([0 200]);
set(gca,'fontsize',fontsz,'fontweight','bold');
set([yh],'Fontsize',fontsz,'Fontname','Timesnewroman',...
    'FontWeight','bold');

ax=axes('position',sub_pos{3,1},'XGrid','off','XMinorGrid','off',...
    'FontSize',fontsize,'Box','on','Layer','top','fontweight','bold');
s = plot(HourlyTime,[HourlyUstrAvg HourlyWDAvg/360],'s');
set(s,'MarkerSize',markersz);
yh= ylabel('U_* ( m s^{-1}) , WD '); ylim([0 1]);
xh = xlabel('Time of Day [HH]');
t1 = text(0.02,.95,'N'); t2 = text(0.02,.7,'W'); t3 = text(0.02,.45,'S');
t4 = text(0.02,.20,'E'); t5 = text(0.02,0.02,'N');
hleg = legend('U_*','WD');
set(gca,'fontsize',14,'fontweight','bold');
set([t1 t2 t3 t4 t5 xh yh],'Fontsize',14,'Fontname','Timesnewroman',...
    'FontWeight','bold');
set(hleg,'Orientation','Horizontal','box','off',...
    'Location','NorthEast','fontsize',13); datetick('x','HH');

PlotName = [datestr(FlxESTTime(fact),'yyyymm') '_FlxSummary'];
makeplot(Hourly,OutputPlotDir, PlotName);
 
% 
% GillWDfig = figure;
% x = 0:10:400;
% plot(FlxData(:,78),MetData(:,id.WD),'o'); hold on;
% line(x,x,'LineStyle','-','Color','black','LineWidth',PlotLineWidth);
% xlabel('WDIR Sonic');ylabel('WDIR RMY'); hold off;
% 
% GillWSfig = figure; plot(SonicWS,MetData(:,id.ws),'o'); hold on;
% line(x,x,'LineStyle','-','Color','black','LineWidth',PlotLineWidth);
% xlim([0 14]); xlabel('WSPD Sonic');ylabel('WSPD RMY'); hold off;
% 
% PlotGillWD=[OutputPlotDir datestr(FlxESTTime(10),'yyyymm') '_WD'];
% print(GillWDfig, '-depsc2','-loose',[PlotGillWD,'.eps']);
% system(['epstopdf ',PlotGillWD,'.eps']);
% 
% PlotGillWS=[OutputPlotDir datestr(FlxESTTime(10),'yyyymm') '_WS'];
% print(GillWSfig, '-depsc2','-loose',[PlotGillWS,'.eps']);
% system(['epstopdf ',PlotGillWS,'.eps']);
% 
% PlotGillTest=[OutputPlotDir datestr(FlxESTTime(10),'yyyymm') '_Diel'];
% print(Hourly, '-depsc2','-loose',[PlotGillTest,'.eps']);
% system(['epstopdf ',PlotGillTest,'.eps']);

% % GillUfig = figure;  plot(FlxData(:,70),MetData(:,22),'o'); hold on;
% % line(x,x,'LineStyle','-','Color','black','LineWidth',PlotLineWidth);
% % xlim([0 14]); xlabel('U SONIC (unrotated)');ylabel('U RMY'); hold off;
% % 
% % GillVfig = figure;  plot(FlxData(:,71),MetData(:,23),'o'); hold on;
% % line(x,x,'LineStyle','-','Color','black','LineWidth',PlotLineWidth);
% % xlim([0 14]); xlabel('V SONIC (unrotated)');ylabel('V RMY'); hold off;
% % 
% % GillUrotfig = figure;  plot(FlxData(:,73),MetData(:,22),'o'); hold on;
% % line(x,x,'LineStyle','-','Color','black','LineWidth',PlotLineWidth);
% % xlim([0 14]); xlabel('U SONIC (rotated)');ylabel('U RMY'); hold off;


end

