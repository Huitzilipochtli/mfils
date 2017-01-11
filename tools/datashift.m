function FluxData = datashift(Flux,HoursShift,MinutesShift,SecondsShift)

% % HoursShift = -3;
% % MinutesShift = -49;
% % SecondsShift = -59;

for i = 1:size(Flux,1);
FluxData(i) = addtodate(Flux(i),HoursShift,'hour');
FluxData(i) = addtodate(FluxData(i),MinutesShift,'minute');
FluxData(i) = addtodate(FluxData(i),SecondsShift,'second');
end

end