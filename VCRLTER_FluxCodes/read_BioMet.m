function [BioMetESTTime, BioMetData] = read_BioMet(BioMetFile)

% Function to read in the 1 min raw files. Time output is in local time
% BioMetFile = 'F:\jzr201\ProcessedData\MetData\BioMET_2015_06_05_00.csv';
% [BioMetESTTime, BioMetData] = read_BioMet(BioMetFile);
expression = ...
    'BioMET_(?<year>\d{4})_(?<month>\w{2})_(?<day>\w{2})';
str = regexp(BioMetFile,expression,'names');
Start = datenum([str.year '-' str.month '-' str.day],'yyyy-mm-dd');
newinstr = datenum('06-04-2015 10:00:00','mm-dd-yyyy HH:MM:SS'); 

Hlines = 2;
fid = fopen(BioMetFile);
D = {','};
if (Start >= newinstr)
    tmp = textscan(fid,['%s%s' repmat('%f',1,27)],'Delimiter',D,...
        'Headerlines',Hlines,'CollectOutput',1);
else
    tmp = textscan(fid,['%s%s' repmat('%f',1,22)],'Delimiter',D,...
        'Headerlines',Hlines,'CollectOutput',1);
end
fclose(fid);
BioMetData = squeeze([tmp{2}]);

FullTime = datenum(tmp{1}(:,1),'yyyy-mm-dd') +...
    datenum(tmp{1}(:,2),'HH:MM') - datenum('00:00','HH:MM');

% convert from UTC to EST\EDT accounting for daylight savings
BioMetESTTime = zeros(length(FullTime),1);  
for i = 1:length(FullTime);
    [ BioMetESTTime(i) ] = TimezoneConvert(FullTime(i), 'UTC', 'America/New_York');
end


end