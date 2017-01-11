function [ jd ] = fn2jd(filelist)
% 
% function [ jd ] = fn2jd(filelist)
%   file name to julian day
% 

    NFiles = size(filelist, 1); 
    jd = zeros(NFiles, 1); 
    for nf = 1:NFiles
        StartFilename = find(filelist(nf,:) == filesep, 1, 'last') + 1;
        EndFilename = find(filelist(nf,:) == '.', 1, 'last') - 1;
        tmp = sscanf(filelist(nf,StartFilename:EndFilename),'%3d%2d%2d%2d');
        jd(nf) = tmp(1) + (3600*tmp(2) + 60*tmp(3) + tmp(4)) / 86400;
    end
    return ; 
end

