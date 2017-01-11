function ew = clap(T)
%Vapor pressure calculation using the Clausius-Clapeyron equation [Pa]

%**********************************************************************
%     This function computes the equilibrium vapor pressure
%     over ice. Argument is in K and the units returned
%     are mks
%     Polynomial fit is from Flatau et al. (1989)
%**********************************************************************

% ensure temperature in kelvin
T(T<100)=T(T<100)+273.15;

%constants
e0 = 610.5851; %[Pa] 
T0 = 273.15;  %[K]

% ew = e0.* exp((Lv./Rv).*((1./T0)-(1./T))); % water vapor pressure
tc = T-T0;

ew = e0+tc.*(44.40316+tc.*(1.430341+ ...
    tc.*(.2641412E-1+tc.*(.2995057E-3+tc.*(.2031998E-5+ ...
    tc.*(.6936113E-8+tc.*(.2564861E-11+tc.*-.3704404E-13)))))));

end