function [p,scale] = wavepower(y,dt,wname)

% [p,scale] = wavepower(y,dt,wname);
%
% WAVEPOWER estimates the spectral power density of a time
% series using the discrete wavelet decomposition. The power
% density is estimated at scales distributed on a dyadic grid
%   y       time series
%   dt      sampling period, default is 1
%   wname   wavelet name, default is 'db5'
%   p       power density : [n,1] array
%   scale   corresponding scale axis : [n,1] array
%                                           

if nargin<2, dt = 1; end
if nargin<3, wname = 'db5'; end

npts = length(y);
nlevel = floor(log(npts)/log(2));      % maximum nr of levels

[c,l] = wavedec(y(:),nlevel,wname);    % wavelet decomposition

% do some bookkeeping with the indices
first = cumsum(l)+1;
first = first(end-2:-1:1);
ld   = l(end-1:-1:2);
last = first+ld-1;
cf = c;
lf = l;

p = zeros(nlevel,1);
scale = sqrt(2)*dt*(2.^[1:nlevel]');

% for each scale, ask for threshold 
for k = 1:nlevel
    w = first(k):last(k);
    cw = c(w);
    p(k) = cw'*cw/length(cw);
end


% % %         [pw,scale] = wavepower(AE,dt);  
% % %         freqw = 1./scale;
% % % Now plot the two estimates together on the same plot, with logarithmic axes
% % % 
% % %         loglog(freq,p,’r-’,freqw,pw,’b.-’)  
% % %         legend(’Fourier’,’wavelet’)  
% % %         grid on

figure;clf
loglog(scale,p,'b.-');
grid on
xlabel('scale')
ylabel('spectral density')
    
    