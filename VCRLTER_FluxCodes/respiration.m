function [RE,GPP] = respiration(Fco2, Tsoil)
% This function uses the relationship as described in James Kathilankiel
% Thesis and by Lloyd/Taylor 1994

%constants
Ea = 45212.8; %[J mol-1]
Tref = 283.15; % [K]
R = 8.314; %[J K-1 mol-1]
REref = 0.82; %[umol m-2 s-1]
% REref = 0.563; %[umol m-2 s-1] 

% % % Tsoil = MetData(:,5);
% % Tsoil = MetData(:,6);
% % Fco2 = FlxData(:,14);

% ensure temperature in kelvin
Tsoil(Tsoil<100)=Tsoil(Tsoil<100)+273.15;

RE = REref.*exp((Ea./(Tref.*R)).*(1-Tref./Tsoil));% [umol m-2 s-1]
GPP = -Fco2+RE;% [umol m-2 s-1]
% GPP = -(-Fco2)+RE;% [umol m-2 s-1]

end