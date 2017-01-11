function [leaves, leafheader] = leafarea(LeafFileName)

% LeafFileName = 'C:\Users\Jesus\Box Sync\Data\LAI\LeafCount_6.txt';

delim = ','; % Tab delimited file
max_num_col = 5;
format = repmat('%f',1,max_num_col);
fid = fopen(LeafFileName,'rt');
leafheader = textscan(fid,'%s%f',8,'HeaderLines',0,'Delimiter',':');
c = textscan(fid,format,'HeaderLines',0,'Delimiter',delim);
fclose(fid);
leaves = [c{:}];

end