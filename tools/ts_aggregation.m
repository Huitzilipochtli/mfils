function [ t_acc, x_acc, subs ] = ts_aggregation( t, x, n, target_fmt, fct_handle )
% t is time in datenum format (i.e. days)
% x is whatever variable you want to aggregate
% n is the number of minutes, hours, days
% target_fmt is 'minute', 'hour' or 'day'
% fct_handle can be an arbitrary function (e.g. @sum)
    t = t(:);
    x = x(:);
    switch target_fmt
        case 'day'
            t_factor = 1;
        case 'hour'
            t_factor = 1 / 24;
        case 'minute'
            t_factor = 1 / ( 24 * 60 );
    end
    t_acc = ( t(1) : n * t_factor : t(end) )';
    subs = ones(length(t), 1);
    for i = 2:length(t_acc)
       subs(t > t_acc(i-1) & t <= t_acc(i)) = i; 
    end
    x_acc = accumarray( subs, x, [], fct_handle );
end