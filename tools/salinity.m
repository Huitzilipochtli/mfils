      function [sal]  = convert (kst,temp)

      % convert : contains all conversion functions from slinity to density chlorinity etc for SACO
      %
      % This function converts to and from salinity, density, chlorinity and conductivity
      % It is based on the fortran program of Kees Kuijper (SaCo; Salinity conversions; Bulletin Kuijpe_k
      %
      % If temperature is needed for the conversion that should be the 3th argument in the function call
      % If temperature is not needed for the conversion 2 arguments are sufficient
      %
      % Pre-assumed units are:
      % Salinity     [ psu ]
      % Density      [kg/m3]
      % Chlorinity   [  -  ]
      % Conductivity [mS/cm]
      %
      % Formula  9: calculation conductivity --->     salinity; equation according to Labrique/Kohlrausch            (NaCl)
      % Formula 10: calculation conductivity --->     salinity; equation NaCl 94                                     (NaCl)
      % Formula 11: calculation conductivity --->     salinity; fit head (1983) based on chiu data (1968)            (NaCl)
      % Formula 12: calculation conductivity --->     salinity; hewitt (1960)                                        (NaCl)
      % Formula 13: calculation conductivity --->     salinity; UNESCO                                               (Seawater)
      %
      % Example: to convert salinity to density according to UNESCO Formulations your function call should be something like:
      % [dens] = convert(salinity,3,temperature);
      %

% 
%       function [sal] = conversion_09 (kst,temp)
%       %
%       % Conductivity to salinity according to Labrique/Kohlrausch (NaCl)
%       %
%       mt     = 1./((0.008018*temp + 1.0609)^2 -0.5911);
%       k25    = mt*kst;
% 
%       sal    = (k25/2.134)^(1./0.92);
% 
%       function [sal] = conversion_10 (kst,temp)
%       %
%       % Conductivity to salinity (NaCl 94)
%       %
%       %----------------------------------------------------------------+
%       % CALCULATION CONDUCTIVITY ---> SALINITY                         |
%       % NACL94                                                         |
%       % NACL SOLUTION                                                  |
%       % TEMPERATURE RANGE: -2 - 35 dgr C                               |
%       % SALINITY RANGE: .06 - 56                                       |
%       %----------------------------------------------------------------+
% 
%       rsmt  = 0.6766097         + 2.00564E-02*temp + 1.104259E-04*temp^2      ...
%              -6.9698E-07*temp^3 + 1.00310E-09*temp^4;
%       m     = 1.2365374 / rsmt;
%       k25   = m * kst;
%       sal   = 0.018 * k25 * ( (abs(k25))^0.5 + 27.176 );
% 
%       function [sal] = conversion_11 (kst,temp)
% 
%       %----------------------------------------------------------------+
%       % CALCULATION CONDUCTIVITY ---> SALINITY                         |
%       % FIT HEAD (1983) BASED ON CHIU DATA (1968)                      |
%       % NACL SOLUTION                                                  |
%       % TEMPERATURE RANGE: -2.0 - 35 dgr C                             |
%       % SALINITY RANGE: 4 - 59                                         |
%       %----------------------------------------------------------------+
% 
%       %  CONVERSION OF CONDUCTIVITY KST AT TEMPERATURE T TO CONDUCT.
%       %  K25 AT TEMPERATURE OF 25 DGR. C USING THE ADAPTED UNESCO EQ.
%       %  (THE UNESCO EQ. CONVERTS TO A REFERENCE TEMP. OF 15 DGR.
%       %  CELSIUS BUT THIS CAN BE REWRITTEN TO 25 DRG. C, THUS:
%       %  RSMT = KST/K15 BECOMES:
%       %  RT = R25 (KST/K25) WITH R25 = 1.2365374)
% 
%       rsmt  = 0.6766097          + 2.00564E-02*temp + 1.104259E-04*temp^2    ...
%              -6.9698E-07*temp^3 + 1.0031E-09*temp^4;
% 
%       k25   = 1.2365374 * ( kst / rsmt );
% 
%       %  CALCULATION OF SALINITY SAL FROM K25 USING FIT BY HEAD (1983, PAGE 159).
%       %  COEFF. a5 BY HEAD SHOULD BE: 0.000006269 !!!
% 
%       sal   = 0.01498478            - 0.01458078 * k25^0.5 + 0.05185288 * k25 +       ...
%               0.00206994  * k25^1.5 - 0.00010365 * k25^2.0 +                          ...
%               0.000006269 * k25^2.5;
% 
%       % CONVERSION FROM weight% TO salinity
%       sal   = sal * 10.0;
% % 
%       function [sal] = conversion_12 (kst,temp)
% 
%       % Rather crude, use inverse routine
% 
%       difmin = 1.0e37;
% 
%       for ss = 0.0: 0.001: 100.0
%          kcmp = conversion_16(ss,temp);
%          diff = abs(kcmp - kst);
%          if diff < difmin
%             difmin = diff;
%             sal_estimate = ss;
%          end
%       end
% 
%       sal   = sal_estimate;
% 

%       function [sal] = conversion_13 (kst,temp)
      %
      % Conductivity to salinity according to Unesco 1981 (Seawater)
      %
      kref15 = 42.910;

      rsmt   = 0.6766097 + 2.00564E-02*temp + 1.104259E-04*temp^2 ...
              -6.9698E-07*temp^3 + 1.0031E-09*temp^4;
      kreft  = rsmt * kref15;
      rgrt   = kst / kreft;

      sal    = 0.0080 - 0.1692*rgrt^0.5 + 25.3851*rgrt +14.0941*rgrt^1.5 - 7.0261*rgrt^2 + 2.7081*rgrt^2.5;
      corrs  = ((temp-15.)/(1.+0.0162*(temp-15.))) * (0.0005 - 0.0056*rgrt^0.5 - 0.0066*rgrt -  ...
                0.0375*rgrt^1.5 + 0.0636*rgrt^2 - 0.0144*rgrt^2.5);
      sal    = sal  + corrs;

      end
%       function [kst] = conversion_14 (sal,temp)
% 
%       % LABRIQUE
% 
%       m     = 1./((0.008018 * temp + 1.0609)^2 - 0.5911);
% 
%       % INVERSE KOHLRAUSCH
%       kst   = (2.134 * sal^0.92) / m;
% 
%       function [kst] = conversion_15 (sal,temp)
% 
%       diff   = 1.0e36;
%       k25old = 2.134 * sal^0.92;
% 
%       %  START OF ITERATION BY RE-SUBSTITUTION
% 
%       while diff > 1.0e-6
% 
%          k25   = sal / (0.018 * (sqrt(abs(k25old)) + 27.176));
% 
%          % TEST IF NEW AND OLD VALUE FOR CONDUCTIVITY AT 25 DGR. DIFFER
%          % MORE THAN 1E-06
% 
%          diff = abs ( k25 - k25old );
% 
%          if  diff > 1E-06
%             k25old = k25;
%          end
%       end
% 
%       rsmt  = 0.6766097         + 2.00564E-02*temp + 1.104259E-04*temp^2 ...
%              -6.9698E-07*temp^3 + 1.0031E-09*temp^4;
% 
%       m     = 1.2365374 / rsmt;
% 
%       kst   = k25 / m;

      