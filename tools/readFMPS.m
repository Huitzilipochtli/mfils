function [FMPS] = readFMPS(FMPSfile)
%% This function will read the FMPS .txt file
%   Input = FMPS File Name
%   Output = FMPS data structure

%% Example Call 
%   FMPSfile = 'C:\scratch\jzr201\temp\FMPS.txt';
%   [FMPS] = readFMPS(FMPSfile);
% FMPSfile = 'C:\scratch\jzr201\temp\FMPS.txt'; % comment line when not testing

fid = fopen(FMPSfile);
StartTime = textscan(fid,'%s%s',1,'Delimiter','"'); %File Timestamp
FMPS.header = textscan(fid,'%s%s%s',4,'Delimiter','"','CollectOutput',1); %Extra info
FMPS.status = textscan(fid,'%s%s',2,'Delimiter',':','CollectOutput',1); %Instrument status/errors
FMPS.dilution = cell2mat(textscan(fid,'%*s%n',1,'Delimiter',':')); % Dilution factor

%read in the Channel Size [nm]
lines = 3;
tmp = (textscan(fid,['%s' repmat('%f',1,14)],lines,...
     'Delimiter',':\t','CollectOutput',1,'TreatAsEmpty','\r\n'));
indx = find(isnan(tmp{2}) == 0); 
FMPS.channelsize = sort([tmp{2}(indx); str2double(tmp{1}(2:lines))]);

%read in the Min. dN/dlogDp [#/cm]
lines = 4;
tmp = (textscan(fid,['%s' repmat('%f',1,14)],lines,...
     'Delimiter',':\t','CollectOutput',1,'TreatAsEmpty','\r\n'));
indx = find(isnan(tmp{2}) == 0); 
FMPS.min = sort([tmp{2}(indx); str2double(tmp{1}(2:lines))],'descend');

%read in the Max. dN/dlogDp [#/cm]
lines = 6;
tmp = (textscan(fid,['%s' repmat('%f',1,14)],lines,...
     'Delimiter',':\t','CollectOutput',1,'TreatAsEmpty','\r\n'));
indx = find(isnan(tmp{2}) == 0); 
FMPS.max = sort([tmp{2}(indx); str2double(tmp{1}(2:lines))],'descend');

%read in the Data [#/cm]
lines = 30000; skiplines = 14;
tmp = (textscan(fid,[repmat('%f',1,22)],lines,...
     'Delimiter',':\t','headerlines',skiplines,'CollectOutput',1,'TreatAsEmpty','\r\n'));
FMPS.data = [tmp{:}];
 % % indx = find(isnan(tmp{2}) == 0); 
% % FMPS.data = sort([tmp{2}(indx); str2double(tmp{1}(2:lines))],'descend');

%read in the Offset / RMS [fA]
lines = 25; skiplines = 1;
tmp = (textscan(fid,[repmat('%f',1,3)],lines,...
     'Delimiter','\t','headerlines',skiplines,'CollectOutput',0,'TreatAsEmpty','\r\n'));
% % indx = find(isnan(tmp{2}) == 0); 
FMPS.channel = [tmp{1}]; FMPS.offset = [tmp{2}]; FMPS.rms = [tmp{3}];

fclose(fid);

disp(FMPS.status{1})
FMPS.starttime = datenum(StartTime{2},'dddd, mmmm dd, yyyy HH:MM:SS');


end