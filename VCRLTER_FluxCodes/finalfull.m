function [MetData, FlxData, FlxESTTime] = finalfull(DataDir, OutputPlotDir, Month)
% Month = datenum('2015-11','yyyy-mm');
FolderStr = datestr(Month,'mm');
csvFileExt = '.csv';
csvFileType = '*full_output*';
metFileType = '*_biomet_*';

% id.Ta = 2; id.Ts = 5; id.PAR = 17; id.G = 24; id.Rg = 20; id.Rn = 12; 
% id.WD = 29; id.RH = 10; id.Tide= 28; id.RMYws = 21; id.RMYdr = 29;

newinstr = datenum('06-04-2015 10:00:00','mm-dd-yyyy HH:MM:SS'); %added

if (Month >= newinstr)
id.Ta = 3; id.Ts = 5; id.PAR = 17; id.G = 22; id.Rg = 20; 
id.Rn = 12; id.WD = 27; id.RH = 10; id.Tide= 26; 
id.RMYws = 21; id.RMYdr = 27;
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

FlxData=cleanup(FlxData);
[RE, GPP] = respiration(FlxData(:,14)+FlxData(:,28),MetData(:,id.Ts));

FlxESTHour = datenum(datestr(FlxESTTime,'HH:MM'),'HH:MM')...
    - datenum('00:00','HH:MM');

%restrict the full tide data to the described month
% % indx = REDB2015Time >= FlxESTTime(1) & REDB2015Time < FlxESTTime(end);
% % REDBTime = REDB2015Time(indx); REDBTide = REDB2015Tide(indx);
% % %find the low tide in REDBANK DATA
f1 = MetData(:,id.Tide) <= 0.3; %Low Tide -0.2
f2 = MetData(:,id.Tide) >= 0.6;  %High Tide
% % f3 = REDBTide(:) >= 0.8;  %Inundated Marsh

% % % % all conditions must be met, and recast the variables
% % % LowTide = REDBTide(f1); LowTideTime = REDBTime(f1);
% % % HighTide = REDBTide(f2); HighTideTime = REDBTime(f2);
% % % % % InundatedTide = REDBTide(f3); InundatedTime = REDBTime(f3);
% % % [LowFlxTime, LowFlxInd, LowTideInd] = intersect(FlxESTTime,LowTideTime); 
% % % [HighFlxTime, HighFlxInd, HighTideInd] = intersect(FlxESTTime,HighTideTime); 

LowFlxData = FlxData(f1,:); HighFlxData = FlxData(f2,:);
LowMetData = MetData(f1,:); HighMetData = MetData(f2,:);
LowTime = FlxESTTime(f1); HighTime = FlxESTTime(f2);

% Find the Nighttime <=50 Flux Low Tide data
f3 = LowFlxData(:,2) < 1; f4 = HighFlxData(:,2) < 1;
NightLowTs = LowMetData(f3,id.Ts); NightLowTa = LowMetData(f3,id.Ta);
NightLowFlxTime = LowTime(f3); NightLowFlx = LowFlxData(f3,14);
NightHighTs = HighMetData(f4,id.Ts); NightHighTa = HighMetData(f4,id.Ta);
NightHighFlxTime = HighTime(f4); NightHighFlx = HighFlxData(f4,14);

%% Plots
TitleFontSize = 12; labelfontsz = 15; fontsz = 15; 
NumTicks = 7; FontWeight ='demi'; markersz = 15; L =20; H =18;
PlotLineWidth = 2; markeredge = 'Black'; %colors = brewermap(13,'Spectral');
[colors,profnum,type] = brewermap(8,'*Dark2'); 
lim = [0,1]; % #limits for the frictional velocity

markerface = colors(7,:); markerface3 = colors(1,:);
NEETa = figure;
subplot(2,1,1);
f = plot(NightHighTa,NightHighFlx,'o'); hold on;
g = plot(NightLowTa,NightLowFlx,'o'); 
legend('High Tide','Low Tide'); ylim([-1 10]);
xh = xlabel('Air Temperature (C)'); 
yh = ylabel('NEE (\mumol m^{-2} s^{-1})');
t=title([datestr(Month,'mmm yyyy') '  NightTime']);
set([t xh yh],'Fontsize',fontsz,'Fontname','Timesnewroman',...
    'FontWeight','bold');
set(f,'LineWidth',PlotLineWidth,'Markersize',6,...
    'MarkerFaceColor',markerface,'MarkerEdgeColor',markeredge,...
    'Color',markerface);
set(g,'LineWidth',PlotLineWidth,'Markersize',6,...
    'MarkerFaceColor',markerface3,'MarkerEdgeColor',markeredge,...
    'Color',markerface3);
set(gca,'fontsize',fontsz,'fontweight','bold');    hold off;
subplot(2,1,2);
f = plot(NightHighTs,NightHighFlx,'o'); hold on;
g = plot(NightLowTs,NightLowFlx,'o'); 
legend('High Tide','Low Tide'); ylim([-1 10]);
xh = xlabel('Soil Temperature (C)');
yh = ylabel('NEE (\mumol m^{-2} s^{-1})');
set([xh yh],'Fontsize',fontsz,'Fontname','Timesnewroman',...
    'FontWeight','bold');
set(f,'LineWidth',PlotLineWidth,'Markersize',6,...
    'MarkerFaceColor',markerface,'MarkerEdgeColor',markeredge,...
    'Color',markerface);
set(g,'LineWidth',PlotLineWidth,'Markersize',6,...
    'MarkerFaceColor',markerface3,'MarkerEdgeColor',markeredge,...
    'Color',markerface3);
set(gca,'fontsize',fontsz,'fontweight','bold');    hold off;


ustar = FlxData(:,82); Fc = FlxData(:,14)+FlxData(:,28); 
NEEustarFig = figure;
s = plot(FlxData(:,82),FlxData(:,14)+FlxData(:,28),'.'); 
xlabel('Friction Velocity (m s^{-1})');
ylabel('NEE (\mumol m^{-2} s^{-1})');
title(datestr(Month,'mmm yyyy'));
xlim([0 1]); ylim([-30 15]);

VPD = FlxData(:,68); Fc = FlxData(:,14)+FlxData(:,28); 
NEEustarFig = figure;
s = plot(FlxData(:,68),FlxData(:,14)+FlxData(:,28),'.'); 
xlabel('VPD ( Pa )');
ylabel('NEE (\mumol m^{-2} s^{-1})');
title(datestr(Month,'mmm yyyy'));
ylim([-30 15]);

RMYdir.raw = MetData(:,id.RMYdr);
RMYspd.raw = MetData(:,id.RMYws);

% name_ustar = 'u_* (m/s)'; % #4 name of variable U
% name_NEE = [datestr(Month,'mmm yyyy') '   NEE (\mumol m^{-2} s^{-1})'];
% NEE_lims = [-30 10];
% NEEustarDirFig = figure;
% h = ScatterWindRose(RMYdir.raw,ustar,lim,name_ustar,Fc,name_NEE,NEE_lims);

NEEparFig = figure;
s = plot(MetData(:,id.PAR),FlxData(:,14)+FlxData(:,28),'.'); 
xlabel('PAR (\mumol m^{-2} s^{-1})');
ylabel('NEE (\mumol m^{-2} s^{-1})');
title(datestr(Month,'mmm yyyy'));
xlim([0 2300]); ylim([-30 15]);


PlotNEEustar = [OutputPlotDir '2015NEEustar'];
PlotNEEdir = [OutputPlotDir '2015NEEustarDir'];
print(NEEustarFig, '-dpsc2', '-append',PlotNEEustar);
% print(NEEustarDirFig,'-dpsc2', '-append',PlotNEEdir);
% % % 
MatFile = [DataDir datestr(Month,'mm') '_FinalFull.mat'];
save(MatFile,'FlxData','FlxESTTime','MetData','MetESTTime','LowFlxData',...
    'LowMetData','LowTime','HighFlxData','HighMetData','HighTime',...
    'NightLowTs','NightLowTa','NightLowFlxTime','NightLowFlx',...
    'NightHighTs','NightHighTa','NightHighFlxTime','NightHighFlx','-v7.3');


end