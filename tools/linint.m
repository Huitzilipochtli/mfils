function yi=linint(x, y, xi)
% 
% function yi=linint(x, y, xi)
% 
% Assume x sorted 
% 
% test: 
% 
% 	% option 'o'
% 	n=10; x = (1:n) + 0.4 * (rand(1, n) - .5);  y=rand(1,n); 
% 	xi=(min(x)):.5:max(x);
% 	linint(x,y,xi,'o')
% 
% 
%	% option 'i'
%	n=10; x = 1:n; y=rand(size(x)); 
% 	xi = (2:.25:n-1); xi= xi + 0.4 * (rand(size(xi)) - .5); 
%	linint(x,y,xi,'i'); 


x = x(:); 
% y = y(:);
xi = xi(:);

[indicator index] = sort([x; xi]);   
indicator = [ones(size(x)); zeros(size(xi))]; 
indicator = indicator(index) ; % Reorder the 0's and 1's  
index = cumsum(indicator); % find the interval in x each xi belongs to
index = index(find(~indicator)) ; % from that array extract only the elements 
                                  % corresponding to xi (the 0's) and discard elements 
                                  % corresponding to x (the 1's)

index = index + (index < 1);      % elements of xi smaller than x(1) will use the interval 
                                  % [x(1) x(2)]

Nx = length(x); 
index(index > (Nx-1)) = (Nx-1);   % elements of xi greater than max(x) will use the last interval

% figure(10); plot(indicator); title('Indicator')
% figure(11); plot(index); title('Index')

clear indicator

xcolumn = ones(size(y,2), 1) ; 

% Lx = length(x) ; Ly = length(y) ; 
% MaxIndex = max(index); MinIndex = min(index) ; 
% [Lx Ly MinIndex MaxIndex length(index)]

% [size(x) size(y)] 
% [min(index) max(index)]


yi = y(index, :) + (y(index + 1, :) - y(index,:))  ./ ...
     (x(index+1, xcolumn) - x(index, xcolumn))  .* ...
     (xi(:, xcolumn) - x(index, xcolumn));


% subplot(2,1,1); plot(x, 3*ones(size(x)), 'x', xi, ones(size(xi)), '+', [0 6], [0 6], '.');  
% subplot(2,1,2); plot(x,y, x,y,'o', xi, yi, xi, yi, 'x')
end
 
