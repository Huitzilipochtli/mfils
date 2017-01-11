% The script calculates fluxes from sonics
% using data from the December 2010 HiRes
% trip

% delete RotatedSonics.ps
% DataDir = 'C:\Data\HRDEC2010';
% Sonics = {
%     '.cs0875'
%     '.cs0197'
%     '.cs1003'
%     '.cs0200'
%     '.cs0876'
%     '.cs0878'
%     '.cs1830'
%     };
% 
% TimeInt = [340.6 342.5];  %  [340.6 342.5]; for all data [341.01 342.5] for oxford data
% 
% z_s = [-6.99 -6.07 -4.24 -3.02 2.31 3.84 5.82] + 11.5;


DataDir = 'C:\Data\HR2010\Data';
Sonics = {
    '.cs1830'    % -6.07
    '.cs0878'    % -3.12
%     '.cs0200'   % -1.19
%     '.cs0537'   % 0
    '.cs0540'    % 1.3  FluxTW removal
%     '.cs1003'    % 2.36         data may be good for some times
    '.cs0197'    % 3.84
%     '.cs0876'    % 5.82 FluxTW removal
%     '.cs0539'    % 7.19
    };

TimeInt=[164.1 170.1]; %for all vertical data
% TimeInt=[165 166.5];

% z_s = [-6.07 -3.12 1.3 3.84 5.82 7.19] +  11.6154;% sonic distance above water

z_s = [-6.07 -3.12 1.3 3.84 5.82 7.19] + 11.6154;
% % % z_s = [-6.07 -3.12 3.84 7.19] + 11.6154;  % for sonics using the FluxTW

% z_full = [-6.07 -3.12 -1.19 0 1.3 2.36 3.84 5.82 7.19] + 11.6154;

Filt = 0.45; %Filter cutoff for lp_fil
SamplingFreqHz = 5; % In Herz
IntervalMinutes = 30;
IntervalDays = IntervalMinutes / 24/ 60;

FluxUW = zeros(length(Sonics), 200);
FluxTW = zeros(length(Sonics), 200);
FluxVW = zeros(length(Sonics), 200);
FluxJD = zeros(200,1); % Start of the interval for each flux calculation
FluxInterval = zeros(200,1);
uvwMeanWind_fil = zeros(length(Sonics), 200);
MeanWind = zeros(length(Sonics), 200);
wMeanWind = zeros(length(Sonics), 200);
cMean = zeros(length(Sonics), 200);
NFluxPoint = 0;

[fnl, fjd, DirectoriesOnly]= getflist(DataDir, TimeInt, Sonics{1});
% 
figure(1);
for ndir=1:size(DirectoriesOnly, 1)
    
    [GyroFile, GyroFileJD]= getflist(DirectoriesOnly(ndir,:), [0 400], '.GyroSerial');
    disp([num2str(GyroFileJD, '%8.4f') ' --- ' GyroFile]);
    [GyroTimeMS, GyroHeading] = ReadGyroSerial(GyroFile);
    GyroHeadingUnwrapped = 180/pi * unwrap(pi/180*GyroHeading);
    figure(1); subplot(4,1,1);
    plot(GyroFileJD + (GyroTimeMS - GyroTimeMS(1))/3.6e6/24, [GyroHeading(:) GyroHeadingUnwrapped(:)]); grid;
    axis('tight');
    ylabel('FLIP''s heading [deg]');
    fnstart = find(GyroFile == '\', 1, 'last');
    title([GyroFile((fnstart+1):end) ', measured and unwrapped']);
    
    for nsonic = 1:size(Sonics,1)
        [SonicFile, SonicFileJD]= getflist(DirectoriesOnly(ndir,:), [0 400], Sonics{nsonic});
        if (isempty(SonicFile)) continue; end
        disp([num2str(SonicFileJD, '%8.4f') ' --- ' SonicFile]);
        
        [SonicTimeMS, uvwc, cw] = campbell_HiRes(SonicFile);
        [TimeJD, uvwcSynch] = synchdata(SonicTimeMS, uvwc, SonicFileJD, SamplingFreqHz);
        [TimeJD, GyroHeadingSynch] = synchdata(GyroTimeMS, GyroHeadingUnwrapped(:), TimeJD);
        [ uvRotated ] = rotategyro(GyroHeadingSynch, uvwcSynch(:,[1 2]));
        uvwRotated = [uvRotated uvwcSynch(:,3)]; % Add the vertical velocity to the rotated
        
        TempSynch = uvwcSynch(:,4).^2/(1.4*287.04); %in Kelvin - 273.15 for celcius
        
        %
        % Test Plots ...
        %
        figure(1); subplot(4,1,2);
        plot(GyroFileJD + (GyroTimeMS - GyroTimeMS(1))/3.6e6/24, GyroHeadingUnwrapped(:),...
            TimeJD,GyroHeadingSynch);
        ylabel('FLIP''s heading [deg]');
        axis('tight');
        title([GyroFile((fnstart+1):end) ', measured and synchronized at 5 Hz']);
        
        figure(1); subplot(4,1,3);
        plot(SonicFileJD+(SonicTimeMS-SonicTimeMS(1))/3.6e6/24, uvwc(:,1:3), ...
            TimeJD, uvRotated);  % TimeJD, uvwcSynch(:,1:3), ...
        fnstart = find(SonicFile == '\', 1, 'last');
        legend('u','v','w','u_{East}','v_{North}');
        title([SonicFile((fnstart+1):end) ', measured and rotated, Y pointing North']);
        ylabel('U,V,W [m/s]');
        axis('tight');
        
        figure(1); subplot(4,1,4);
        plot(SonicFileJD+(SonicTimeMS-SonicTimeMS(1))/3.6e6/24, uvwc(:,4), ...
            TimeJD, uvwcSynch(:,4));
        axis('tight');
        ylabel('Speed of Sound [m/s]')
        xlabel('Time [JD]');
        
        pause(1);
%         orient tall; print -dpsc -append RotatedSonics.ps
        
        %
        % Calculation of the  momentum flux
        %
        
        DataDuration = TimeJD(end) - TimeJD(1);
        NIntervals = ceil(DataDuration / IntervalDays);
        for nint = 1:NIntervals
            IntervalStart = TimeJD(1) + (nint-1) * IntervalDays;
            IntervalEnd = IntervalStart + IntervalDays ;
            select = find((IntervalStart <= TimeJD) & (TimeJD <= IntervalEnd));
            if (isempty(select)) continue; end
            
            uvwInterval = uvwRotated(select,:);
            cInterval = uvwcSynch(select,4);
            TemperatureInterval = TempSynch(select,:); % grab only selected time interval
            uvwMeanWind = coordrot(uvwInterval', 0)'; % Rotate into the mean wind
            
%             uvwMeanWind_fil = lp_fil(uvwMeanWind,SamplingFreqHz,Filt);
            
            tmp = cov(detrend(uvwMeanWind(:,1)), detrend(uvwMeanWind(:,3)));
            FluxUW(nsonic, NFluxPoint + nint) = tmp(2,1) ;
                                  
            CD(nsonic, NFluxPoint + nint)= -tmp(2,1)/mean(uvwMeanWind(:,1))^2;
            
            tmp = cov(detrend(uvwMeanWind(:,2)), detrend(uvwMeanWind(:,3)));
            FluxVW(nsonic, NFluxPoint + nint) = tmp(2,1) ;
            
            MeanWind(nsonic, NFluxPoint + nint) = mean(uvwMeanWind(:,1));
            wMeanWind(nsonic, NFluxPoint + nint) = mean(uvwMeanWind(:,3));
                        
            tmp = cov(TemperatureInterval, detrend(uvwMeanWind(:,3)));     
            FluxTW(nsonic, NFluxPoint + nint) = tmp(2,1) ;
            
            cMean(nsonic, NFluxPoint + nint) = mean(cInterval);

            if (nsonic == 1)
                FluxJD(NFluxPoint + nint) = IntervalStart;
                FluxInterval(NFluxPoint + nint) = TimeJD(select(end)) - TimeJD(select(1));
            end
        end
    end
    NFluxPoint = NFluxPoint + NIntervals;
    disp(' ');
    
    
    
%     figure(1); subplot(4,1,1);
%     plot(SonicFileJD+(SonicTimeMS-SonicTimeMS(1))/3.6e6/24, uvwc(:,1:3), ...
%         TimeJD, uvRotated);  % TimeJD, uvwcSynch(:,1:3), ...
%     fnstart = find(SonicFile == '\', 1, 'last');
%     legend('u','v','w','u_{East}','v_{North}');
%     title([SonicFile((fnstart+1):end) ', measured and rotated, Y pointing North']);
%     ylabel('U,V,W [m/s]');
%     axis('tight');
%     
%     subplot(4,1,2);
%     plot(FluxJD, FluxUW); set(gca, 'YLim', [-.7 .4] );
%     ylabel('\langle u'' w'' \rangle [m^2/s^2]');xlim(TimeInt); grid
%     subplot(4,1,3); plot(FluxJD, FluxVW); set(gca, 'YLim', [-.7 .4] );
%     ylabel('\langle v'' w'' \rangle [m^2/s^2]'); xlim(TimeInt);grid
%     subplot(4,1,4); plot(FluxJD,MeanWind(1,:),FluxJD,MeanWind(6,:)); grid; xlim(TimeInt);
%     xlabel('Days of the year'); ylabel('Wind Speed [m/s]');
% 
%     
    
    
%     figure(2);plot(uvwMeanWind(:,3));
    
end

MeanWind = MeanWind(:,1:NFluxPoint);
CD = CD(:,1:NFluxPoint);
cMean = cMean(:,1:NFluxPoint);


FluxTW = FluxTW(:,1:NFluxPoint);
FluxUW = FluxUW(:,1:NFluxPoint);
FluxVW = FluxVW(:,1:NFluxPoint);
FluxJD = FluxJD(1:NFluxPoint);
FluxInterval = FluxInterval(1:NFluxPoint);

% save FluxesDec2010 Sonics FluxUW FluxVW FluxJD FluxInterval

figure; subplot(3,1,1); plot(FluxJD, FluxUW); set(gca, 'YLim', [-.7 .4] );
ylabel('\langle u'' w'' \rangle [m^2/s^2]');xlim(TimeInt); grid
subplot(3,1,2); plot(FluxJD, FluxVW); set(gca, 'YLim', [-.7 .4] );
ylabel('\langle v'' w'' \rangle [m^2/s^2]'); xlim(TimeInt);grid
subplot(3,1,3); plot(FluxJD,MeanWind(1,:),FluxJD,MeanWind(6,:)); grid; xlim(TimeInt);
xlabel('Days of the year'); ylabel('Wind Speed [m/s]');


return ;

figure;plot(FluxJD,1.253*1.005*FluxTW); set(gca, 'YLim', [-.15 .15] );
xlabel('DOY [UTC]');xlim(TimeInt); grid
ylabel('\rho C_p \langle T'' w'' \rangle [ kW / m^2 ]'); 
legend(num2str(z_s'));


figure;
subplot(3,1,1)
plot(FluxJD,MeanWind(3,:));grid on; hold on;
for i=1:size(FluxJD,1)
    figure(10);
    subplot(3,1,1);
    plot(FluxJD(i),MeanWind(3,i),'o','MarkerFaceColor','r'); grid on
    ylabel('Mean Wind Speed [m/s]'); xlabel('DOY [UTC]')
    subplot(3,1,2)
    plot(FluxUW(:,i),z_s,'-*');
    ylabel('Distance to surface'); title([num2str(FluxJD(i)) ', i = ' num2str(i)]);
    xlabel('\langle u''w'' \rangle [m^{2}/s^{2}]');  ylim([1 25])
%     xlim([-0.2 0.05]); %for december Data
        xlim([-.8 0.1]); %for june data 
    subplot(3,1,3)
    semilogy(MeanWind(:,i),z_s,'-*');
    ylabel('Distance to surface [m]'); title([num2str(FluxJD(i)) ', i = ' num2str(i)]);
    xlabel('Wind Speed [m/s]');  ylim([3 30]);
%     xlim([0 12]); % for decemeber data
    xlim([0 22]); %for june data
    pause
    %     if(mod(i,5)==0)
    %         clear
end




%
% % Sonics
%
for n=1:size(Sonics, 1)
    [fnl, fjd]= getflist(DataDir, [0 400], Sonics{n});
    
    for nfile=1:(size(fnl,1)-1)
        
        [t, uvwc, cw] = campbell_HiRes(fnl(nfile,:));
        if (nfile>1) pause(1); end
        subplot(2,1,1); plot(1e-3*(t-t(1)), uvwc(:,1:3));
        fnstart = find(fnl(end,:) == '\', 1, 'last');
        title(fnl(nfile,(fnstart+1):end));
        ylabel('U,V,W [m/s]')
        subplot(2,1,2); plot(1e-3*(t-t(1)), uvwc(:,4));
        ylabel('Speed of Sound [m/s]')
        xlabel('Time [s]')
    end
    
end

%%
figure; subplot(3,1,1); plot(FluxJD, FluxUW); set(gca, 'YLim', [-.7 .4] );
ylabel('\langle u'' w'' \rangle [m^2/s^2]');xlim(TimeInt); grid
subplot(3,1,2); plot(FluxJD, FluxVW); set(gca, 'YLim', [-.7 .4] );
ylabel('\langle v'' w'' \rangle [m^2/s^2]'); xlim(TimeInt);grid
subplot(3,1,3); plot(FluxJD,MeanWind(1,:),FluxJD,MeanWind(6,:)); grid; xlim(TimeInt);
xlabel('Days of the year'); ylabel('Wind Speed [m/s]');

figure; plot(FluxJD,MeanWind(1,:),FluxJD,MeanWind(6,:)); grid; xlim(TimeInt);
xlabel('Days of the year'); ylabel('Wind Speed [m/s]'); ylim([3 22]);

