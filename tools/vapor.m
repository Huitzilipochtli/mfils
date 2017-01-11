function [VPD] = vapor(Ta,RH)

% Function to compute Vapor Pressure deficit given a Relative humidity and
% air temperature.  This function uses the clausius clapeyron relation

Ta(Ta<100) = Ta(Ta<100)+273.15;  %this ensures Ta is in K
RH(RH>1) = RH(RH>1)./100; % this ensures RH is decimal 

es = clap(Ta); %saturation vapor pressure
% e = RH.*es; % vapor pressure

VPD = es.*(1-RH);
% VPD = es-e;

end