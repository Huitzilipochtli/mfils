function [WQ] = read_WQ(WQFile,Station)

% Function to read in the water quality at the VCR
% Station =
% 'CM','CSM','GC','LC','MI','NC','NM','OH','PCB','PCH','PCM','QI','RB','RCC'
% ,'SH','SS','SSI'
% WQFile = 'F:\jzr201\VCRData\WaterQ\WQ_crop.csv';
% [WQ] = read_VCRTide(WQFile,'CM');

% expr = 'tide(?<year>\d{2})' ;
% str = regexp(TideFile,expr,'names');
% yearnum = datenum(strjoin({'01-','Jan-' ,'20',str.year},''),'dd-mmm-yyyy');

Hlines = 21;
fid = fopen(WQFile);
D = {','};
a= {'"NAN"','"INF"','"-INF"','\n'};
tmp = textscan(fid,['%s%s' repmat('%f',1,11)],'Delimiter',D,...
    'Headerlines',Hlines,'CollectOutput',1,'MultipleDelimsAsOne',1,...
    'ReturnOnError', true,'treatasempty',a);
fclose(fid);

for i = 1:length(tmp{1});
    WQ.Time(i,:) = datenum(tmp{1,1}(i,2),'mm/dd/yyyy');
end

WQ.Lat = [tmp{1,2}(:,1)];
WQ.Lon = [tmp{1,2}(:,2)];
WQ.Tw = [tmp{1,2}(:,3)];
WQ.Sal = [tmp{1,2}(:,4)];
WQ.Ta = [tmp{1,2}(:,6)];
WQ.RefSal = [tmp{1,2}(:,7)];
WQ.Tw2 = [tmp{1,2}(:,8)];
WQ.Station = [tmp{1,1}(:,1)];

%select station
ind=find(ismember(WQ.Station,Station));
% VCRStation = TempStation{ind};
WQ.Sal = WQ.Sal(ind);
WQ.Ta = WQ.Ta(ind);
WQ.Time = WQ.Time(ind);
WQ.Tw = WQ.Tw(ind);
WQ.RefSal = WQ.RefSal(ind);
WQ.Tw2 = WQ.Tw2(ind);
WQ.Lat = WQ.Lat(ind);
WQ.Lon = WQ.Lon(ind);
end