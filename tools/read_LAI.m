function [LAIdata, LAIheader, LAIweights]= read_LAI(LAIFileName)
% 
% LAIFileName = 'C:\scratch\jzr201\LAI\May\Area\2014_May_1.txt' ;

expression = '(?<year>\d+)_(?<month>\w+)_(?<num>\d+)';
str = regexp(LAIFileName,expression,'names');

headerlines = 0;
fid = fopen(LAIFileName);
LAIheader = textscan(fid,'%s%s',9,'Delimiter',':');
LAIdata = cell2mat(textscan(fid,'%n%n%n%n','Delimiter',',',...
    'HeaderLines',headerlines,'CollectOutput',1));
fclose(fid);

LAIheader = strcat(LAIheader(:,1),LAIheader(:,2));
LAIweights = str2double(LAIheader{1,1}(3:8,2));
LAIdata(:,5) = 1:1:size(LAIdata,1); %shoots
LAIdata(:,6) = str2double(str.num); %plot no
%live
LAIdata(:,7)=(str2double(LAIheader{1,1}{8,2})- str2double(LAIheader{1,1}{6,2}))/0.0625; %biomass [g m-2]
%dead
% LAIdata(:,7)=(str2double(LAIheader{1,1}{5,2})- str2double(LAIheader{1,1}{3,2}))/0.0625; %biomass [g m-2]


end