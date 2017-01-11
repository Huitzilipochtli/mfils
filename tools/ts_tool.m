function [ t_acc, x_acc ] = ts_tool( t, x, target_fmt, fct_handle )
%TS_TOOL Accumulates time-series data.
% t is time in datenum format (i.e. days)
% x is whatever variable you want to aggregate
% n is the number of minutes, hours, days
% target_fmt is 'minute', 'hour' or 'day'
% fct_handle can be an arbitrary function (e.g. @sum)
% Example 1: Calculate daily sums from 1 hour data:
% [t_days, x_days] = ts_tool( time_hours, x_hours, 'day', @sum );
% Example 2: Calculate hourly averages from 1 minute data:
% [t_hours, x_hours] = ts_tool( time_minutes, x_minutes, 'hour', @mean )
    tv = datevec( t(:) );
    x = x(:);
    switch target_fmt
        case 'year'
            col_idx = 1;
        case 'month'
            col_idx = 1:2;
        case 'day'
            col_idx = 1:3;
        case 'hour'
            col_idx = 1:4;
        case 'minute'
            col_idx = 1:5;
        otherwise
            disp('Pass a valid target format!')
    end
    [t_unique, ~, subs] = unique(tv(:,col_idx), 'rows');
     % gets past a small bug in datevec(), don't think about it for too long
    t_acc = datenum( [t_unique, zeros( abs( size(t_unique) - [0 6] ) )] );
    x_acc = accumarray(subs, x, [], fct_handle);
end