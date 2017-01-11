function [data, LIheader] = read_LI7500(LI7500FileName)

% LI7500FileName = 'C:\scratch\jzr201\temp\aiu-0947-2014-11-29T0000.txt';
% [data, LIheader] = read_LI7500(LI7500FileName);

DELIMITER = {'\t'}; % Tab delimeted file
White = '\n\r';
Empty = 99999;

headerlines = 1;
fid = fopen(LI7500FileName);
LIheader = textscan(fid,'%s',25,'Delimiter',DELIMITER);
fclose(fid);

fid = fopen(LI7500FileName);
LIdata = (textscan(fid,['%f%s%s' repmat('%f',1,22)],'Delimiter',DELIMITER,...
    'HeaderLines',headerlines,'CollectOutput',1,'Whitespace',White));
fclose(fid);

ms = cellstr(num2str(LIdata{1}*1E-9));
ms = strtrim(strrep(ms,'0.',''));
stime = datenum(strcat(LIdata{2}(:,1),'_',LIdata{2}(:,2),'.',...
    ms),'yyyy-mm-dd_HH:MM:SS.FFF');
LIdata = LIdata{3};

CO2_Con = LIdata(:,6); % [mmol m-3]
H2O_Con = LIdata(:,7); % [mmol m-3]
T = LIdata(:,8); % [C]
TotPre = LIdata(:,9); % [kPa]
u = LIdata(:,10); % [m s-1]
v = LIdata(:,11); % [m s-1]
w = LIdata(:,12); % [m s-1]
% sos = LIdata(:,13); %[m s-1]
% Tv = LIdata(:,13); %[m s-1]
Tv = (LIdata(:,13).*LIdata(:,13))./(1.4*287.04); % [K] %Jordan code wants K

data = [stime,CO2_Con,H2O_Con,T,TotPre,u,v,w,Tv];

end
