function [FlxESTTime, FlxData] = read_fulloutput(FullOutFile)

% Function to read in the post-processed LiCor csv files with level 7 and
% biomet corrections. Time output is in local time 
% FullOutFile = 'C:\scratch\jzr201\FluxData\BioCorr\2014\05\eddypro_2014May_full_output_2015-03-25T195056.csv';
% [FlxESTTime, FlxData] = read_fulloutput(FullOutFile);

Hlines = 3;
a= {'Infinity'};
D = {' ','\t',','};
fid = fopen(FullOutFile);
tmp = textscan(fid,['%s%s%s' repmat('%n',1,178)],'Delimiter',D,...
    'Headerlines',Hlines,'CollectOutput',1,'treatasempty',a);
fclose(fid);
FlxData = [tmp{2}];

FullTime = datenum(tmp{1}(:,2),'yyyy-mm-dd') +...
    datenum(tmp{1}(:,3),'HH:MM') - datenum('00:00','HH:MM');

FlxESTTime = zeros(length(FullTime),1);
for i = 1:length(FullTime);
[ FlxESTTime(i) ] = TimezoneConvert(FullTime(i), 'UTC', 'America/New_York');
end

% % % FlxESTHour = datenum(datestr(ESTFullTime,'HH:MM'),'HH:MM') - datenum('00:00','HH:MM');
% % % FlxESTDate = datenum(datestr(ESTFullTime,'yyyy-mm-dd'),'yyyy-mm-dd'); 
end

