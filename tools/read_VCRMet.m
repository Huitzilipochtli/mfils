function [VCRMetTime,VCRMet,VCRid] = read_VCRMet(VCRMetFile,Station)

% Function to read in the tide data measured by VCR-LTER at specified
% Station = 'OYSM', 'PHCK2', 'HOG2'
% VCRMetFile = 'F:\jzr201\VCRData\VCR_LTER_Hourly_Weather\whour15.csv';
% [VCRTime, VCRMet, VCRid] = read_VCRMet(VCRMetFile,'HOG2');
% Output is a 1 min continuous resampled VCRMet data structure.

expr = 'whour(?<year>\d{2})' ;
str = regexp(VCRMetFile,expr,'names');
yearnum = datenum(strjoin({'01-','Jan-' ,'20',str.year},''),'dd-mmm-yyyy');

Empty = '.';
Hlines = 1;
fid = fopen(VCRMetFile);
D = {',','"',' '};
tmp = textscan(fid,['%s' repmat('%f',1,17)],'Delimiter',D,...
    'Headerlines',Hlines,'CollectOutput',true,'MultipleDelimsAsOne',1,...
    'ReturnOnError',0,'TreatAsEmpty',Empty);
fclose(fid);

VCRData = squeeze([tmp{1,2}]);

% YrStr = repmat(['20',str.year],length(tmp{1}),1);
for i = 1:length(tmp{1});
    YrStr(i,:) = sprintf('%04d',(tmp{1,2}(i,1)));
    MnthStr(i,:) = sprintf('%02d',(tmp{1,2}(i,2)));
    DyStr(i,:) = sprintf('%02d',(tmp{1,2}(i,3)));
    HrStr(i,:) = sprintf('%04d',(tmp{1,2}(i,4)));
end

dash = repmat('-',length(YrStr),1);
spac = repmat(' ',length(YrStr),1);
TimeStr = [YrStr dash MnthStr dash DyStr spac HrStr ];

DForm = 'yyyy-mm-dd HHMM';
VCRMetTime = datenum(TimeStr,DForm);
VCRStation = tmp{1,1}(:,1);

%select station
ind=find(ismember(VCRStation,Station));
% VCRStation = TempStation{ind};
VCRData = VCRData(ind,5:17);
VCRMetTime = VCRMetTime(ind);

VCRid.ppt = 1; VCRid.avgTa = 2; VCRid.minTa = 3; VCRid.maxTa = 4; 
VCRid.avgRH = 5; VCRid.minRH =6; VCRid.maxRH = 7; VCRid.avgWS = 8;
VCRid.avgWD = 9; VCRid.stdWD = 10; VCRid.isr = 11; VCRid.PAR = 12;
VCRid.Ts=13;

VCRData = timeseries(VCRData,VCRMetTime);
set(VCRData,'Name',[Station ' Met' ]); timestep = 1; % 
FullTime = VCRMetTime(1):timestep/(24*60):VCRMetTime(end);
VCRData = resample(VCRData,FullTime); 
VCRMetTime = VCRData.Time;
VCRMet = VCRData.Data;

end
% % 
% % MatFile = 'C:\scratch\jzr201\VCRData\OYST2015.mat';
% % save(MatFile,'OYST2015Time','OYST2015Tide','-v7.3');
