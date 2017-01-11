function bit = licordiag(value)

bit = dec2bin(value,8);
chopper = str2double(bit(1));
detector = str2double(bit(2));
PLL =  str2double(bit(3));
signal = bin2dec(bit(5:8))*6.67;

if (chopper == 1)
    disp('Chopper wheel temperature is near setpoint')
elseif (chopper == 0)
    disp('Chopper wheel temperature is not near setpoint')
end

if (detector == 1)
    disp('Detector temperature is near setpoint')
elseif (detector == 0)
    disp('Detector temperature is not near setpoint')
end

if (PLL == 1)
    disp('Lock bit is ok')
elseif (PLL == 0)
    disp('Lock bit is not ok, not rotating at correct rate')
end

disp(['Signal Strength = ' num2str(signal)])

end