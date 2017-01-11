function makeplot(FigName,OutputPlotDir, PlotName)

% Function to output figures in pdf/fig/png format with Plot name.
% Figures will be placed in the OutputPlotDir using the figure handle.
% Example Call
% PlotName = 'PlotName';
% makeplot(FigureHandle,OutputPlotDir, PlotName);


PlotDir=[OutputPlotDir PlotName];
print(FigName, '-depsc2','-loose',[PlotDir,'.eps']);
saveas(FigName,PlotDir,'pdf');
system(['epstopdf ',PlotDir,'.eps']);
saveas(FigName,PlotDir,'fig'); 
saveas(FigName,PlotDir,'png');

end
