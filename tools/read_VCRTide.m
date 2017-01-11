function [VCRTime, VCRTide] = read_VCRTide(TideFile,Station)

% Function to read in the tide data measured by VCR-LTER at specified
% station
% Station = 'OYST', 'REDB', 'HOG4'
% TideFile = 'F:\jzr201\VCRData\VCRTide_Yearly_dat\tide15.dat';
% [REDB2015Time, REDB2015Tide] = read_VCRTide(TideFile,'REDB');

expr = 'tide(?<year>\d{2})' ;
str = regexp(TideFile,expr,'names');
yearnum = datenum(strjoin({'01-','Jan-' ,'20',str.year},''),'dd-mmm-yyyy');

Hlines = 18;
fid = fopen(TideFile);
D = {'Whitespace',' ','','\t'};
tmp = textscan(fid,'%4s%12s%5s%11s%4s%*s%*s%[^\n\r]','Delimiter',D,...
    'Headerlines',Hlines,'CollectOutput',1,'MultipleDelimsAsOne',1,...
    'ReturnOnError', false);
fclose(fid);

for i = 1:length(tmp{1});
    VCRTimeHR(i,:)=sprintf('%0*d',4,str2double(tmp{1,1}(i,3)));
end

VCRTime = datenum(VCRTimeHR,'HHMM') - floor(datenum(VCRTimeHR,'HHMM')) ...
    + datenum(tmp{1,1}(:,2),'ddmmmyyyy');
% datenum(VCRTimeHR,'HHMM') + datenum(tmp{1,1}(:,2),'ddmmmyyyy')...
%     - yearnum;
VCRTide = str2double([tmp{1,1}(:,4)]);
VCRTemp = str2double([tmp{1,1}(:,5)]);
VCRStation = tmp{1,1}(:,1);

%select station
ind=find(ismember(VCRStation,Station));
% VCRStation = TempStation{ind};
VCRTide = VCRTide(ind);
VCRTemp = VCRTemp(ind);
VCRTime = VCRTime(ind);

end
% % 
% % MatFile = 'C:\scratch\jzr201\VCRData\OYST2015.mat';
% % save(MatFile,'OYST2015Time','OYST2015Tide','-v7.3');
