% % Making higher quality plots
% Define the folder where all your other m-files are (brewermap, makeplot..etc)
addpath(genpath('V:\Micrometeorology\mfiles\'));
% Define the folder where you would like the plots to be located
OutputPlotDir = 'F:\Micrometeorology\Reports\2015_Candidacy\2016-04-03\figures\';
% plot parameters to be used on all plots for consistency
PlotLineWidth = 2; plotheight=25; plotwidth=20; fontsz=18; linewidth = 2;
NumTicks = 8;
% Define a color map you would like to use.  The default colors on Matlab
% are terrible and you shouldn't be using them when reporting results.  This
% loads in a colormap that is developed by a PSU faculty in the geography
% department.  You can select a different colormap by viewing the help, or
% by simply typing brewermap('demo') for the options.  Most m-files are
% have examples if you open the m-file associated with the name.  Here I am
% loading in 9 colors from the Set1 map and naming it a variable to be used
% later.
cols = brewermap(9,'Set1');

% Call the figure a handle for exporting later
ReflectFig = figure;
% set the graphic size that you want instead of what is default
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [plotwidth plotheight]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [2 0.25 plotwidth plotheight]);
% using a subplot as an example
subplot(2,1,1);
% call the plot a handle also to modify all the attributes of the plot
p = plot(FullTime, EVI);  
% here we are modifying the values of the plot handle we just made
% https://www.mathworks.com/help/matlab/ref/chartline-properties.html
% the link has all the various modifications you can do (must be in pairs)
set(p,'Marker','o',...
    'LineStyle','none',...
    'MarkerFaceColor',cols(1,:),...
    'MarkerEdgeColor',cols(2,:),...
    'MarkerSize',9); 
% this command will place a tick mark in the format we specify
datetick('x','mm/yy','keepticks','keeplimits');
% this command changes the attributes of the whole figure including the
% axis that we specified earlier as variables
set(gca,'FontWeight','Bold','FontSize',fontsz,'LineWidth',linewidth);
% this command is making more or less ticks on the x-axis.  Essentially we
% want to dictate how many ticks are on all figures for consistency
set(gca,'XTick',linspace(FullTime(1),FullTime(end),NumTicks));
% In this example we don't need to label the x-axis labe because we will be
% doing that in the subplot below, both have same units.
set(gca,'XTicklabel',[]);
% this command places the y-axis in a handle in case we want to modify
% its attributes also
yh = ylabel('EVI2'); 
% this is where the limits of the y-axis are defined
ylim([-0.25 0.25]);
% same as the previous subplot
subplot(2,1,2);
r = plot(FullTime, FullInun);
set(r,'Marker','d',...
    'LineStyle','none',...
    'MarkerFaceColor',cols(5,:),...
    'MarkerEdgeColor',cols(4,:),...
    'MarkerSize',9);
set(gca,'FontWeight','Bold','FontSize',fontsz,'LineWidth',linewidth);
set(gca,'XTick',linspace(FullTime(1),FullTime(end),8));
ylabel('Inundation level(m)');
datetick('x','mm/yy','keepticks','keeplimits');
% this command will output the figure in eps, pdf, fig, and png format to
% the folder specified.  It needs the handle name of the figure, the output
% folder where the figure will be and a name for the figure in ' '.
% makeplot(ReflectFig,OutputPlotDir,'EVIvInun');
