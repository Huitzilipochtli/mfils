function [TimeJD, DataSynch] = synchdatas(TimeMS, DataOriginal, JDFileStart, SamplingFreqHz)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% TimeMS in datenum format per minute

[JDFileStart,~]=date2doy(TimeMS(1));

if (nargin == 4)
    SamplingFreqInverseDays = 60 * 24 * SamplingFreqHz;
    SamplingPeriodInverseDays  = 1 / SamplingFreqInverseDays;
    DataDurationDays = daysact(TimeMS(1),TimeMS(end));
    TimeJD = JDFileStart + (0:SamplingPeriodInverseDays:DataDurationDays);
end

if (nargin == 3)
    TimeJD = JDFileStart;
end

TimeJD = TimeJD(:);
% DataSynch = zeros(size(TimeJD,1), size(DataOriginal,2));

% for nc = 1:size(DataSynch,2)
DataSynch = linint(TimeJD(1) + (TimeMS(:) - TimeMS(1))/60/24, DataOriginal, TimeJD);
% end

end

