function [MetESTTime, MetData] = read_fullmet(MetOutFile)

% Function to read in the post-processed csv files for the same averaging
% period as the flux processed results. Time output is in local time
% MetOutFile = 'C:\scratch\jzr201\FluxData\BioCorr\2014\05\eddypro_2014May_biomet_2015-03-25T194122.csv';
% [MetESTTime, MetData] = read_fullmet(MetOutFile);


expression = ...
    'eddypro_(?<year>\d{4})(?<month>\w+)_biomet';
str = regexp(MetOutFile,expression,'names');
Start = datenum([str.year '-' str.month],'yyyy-mmm');
newinstr = datenum('06-04-2015 10:00:00','mm-dd-yyyy HH:MM:SS'); %added

Hlines = 2;
fid = fopen(MetOutFile);
D = {' ','\t',','};
if (Start >= newinstr)
    tmp = textscan(fid,['%s%s' repmat('%f',1,24+5)],'Delimiter',D,...
        'Headerlines',Hlines,'CollectOutput',1);
else
    tmp = textscan(fid,['%s%s' repmat('%f',1,24)],'Delimiter',D,...
        'Headerlines',Hlines,'CollectOutput',1);
end
fclose(fid);
MetData = [tmp{2}];

FullTime = datenum(tmp{1}(:,1),'yyyy-mm-dd') +...
    datenum(tmp{1}(:,2),'HH:MM') - datenum('00:00','HH:MM');

MetESTTime = zeros(length(FullTime),1);
for i = 1:length(FullTime);
    [ MetESTTime(i) ] = TimezoneConvert(FullTime(i), 'UTC', 'America/New_York');
end

% % % FlxESTHour = datenum(datestr(ESTFullTime,'HH:MM'),'HH:MM') - datenum('00:00','HH:MM');
% % % FlxESTDate = datenum(datestr(ESTFullTime,'yyyy-mm-dd'),'yyyy-mm-dd');
end

