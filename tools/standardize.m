function [X, mean_X, std_X] = standardize(varargin)
switch nargin
    case 1
        mean_X = nanmean(varargin{1}); %// Find mean of each column
        std_X = nanstd(varargin{1}); %// Find std. dev. of each column

        X = bsxfun(@minus, varargin{1}, mean_X); %// Subtract each column by its respective mean
        X = bsxfun(@rdivide, X, std_X); %// Take each column and divide by its respective std dev.

    case 3
        mean_X = varargin{2};
        std_X = varargin{3};

        %// Same code as above
        X = bsxfun(@minus, varargin{1}, mean_X);
        X = bsxfun(@rdivide, X, std_X);
end