function [TimeJD, DataSynch] = synchdata(TimeMS, DataOriginal, JDFileStart, SamplingFreqHz)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


if (nargin == 4)
    SamplingFreqInverseDays = 3600 * 24 * SamplingFreqHz;
    SamplingPeriodInverseDays  = 1 / SamplingFreqInverseDays;
    DataDurationDays = (TimeMS(end) - TimeMS(1))/3.6e6/24;
    
    TimeJD = JDFileStart + (0:SamplingPeriodInverseDays:DataDurationDays);
end

if (nargin == 3)
    TimeJD = JDFileStart; 
end 

TimeJD = TimeJD(:); 
% DataSynch = zeros(size(TimeJD,1), size(DataOriginal,2)); 

% for nc = 1:size(DataSynch,2)
    DataSynch = linint(TimeJD(1) + (TimeMS(:) - TimeMS(1))/3.6e6/24, DataOriginal, TimeJD);
% end

end

