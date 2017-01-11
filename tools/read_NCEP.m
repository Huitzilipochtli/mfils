
file_ext = '*.nc';
data_directory = 'F:\jzr201\temp\dswrf\';
files = dir([data_directory file_ext]);
totalPAR = []; NCEPbase = datenum(1800,1,1);

for i = 1:length(files)
    ncid = netcdf.open([data_directory files(i).name]);
    data = [data_directory files(i).name];
    ncdisp(data);
    lat = ncread(data,'lat');
    lon = ncread(data,'lon');
    time = ncread(data,'time');
    dswrf = squeeze(ncread(data,'dswrf',[150,34,1],[1,1,inf]));
    PAR = 0.45*dswrf;
    totalPAR = [totalPAR;PAR];
    Time = time/24 + datenum(NCEPbase);

    figure
    plot(PAR)
    set(gcf,'color','white')
    xlabel('Day','FontSize',18,'FontName','Arial','FontWeight','bold')
    ylabel('PAR (W m^{-2})','FontSize',18,'FontWeight','bold','FontName','Arial')
    title('Daily Average PAR','FontSize',18,'FontWeight','bold','FontName',...
    'Arial')
    set(gca,'LineWidth',2.5,'FontSize',12,'FontWeight','bold','FontName','Arial')

end


Tower_data = xlsread('D:\Florida_MODIS\tower_inputs_daily_20140206.xlsx');
TowerPAR = Tower_data(1:2496,4);
figure(9)
plot(totalPAR)
set(gcf,'color','white')
datetick('x','yyyy')
set(gca,'XTickLabel',{'2004','2005','2006','2007','2008','2009','2010',...
    '2011','2012'})
xlabel('Day','FontSize',18,'FontName','Arial','FontWeight','bold')
ylabel('PAR (W m^{-2})','FontSize',18,'FontName','Arial','FontWeight','bold')
title('Daily Average PAR 2004 - 2011','FontSize',18,'FontWeight','bold',...
    'FontName','Arial')
set(gca,'LineWidth',2.5,'FontSize',12,'FontWeight','bold','FontName','Arial')






