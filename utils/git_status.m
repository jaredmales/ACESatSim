function [ sha1, modified ] = git_status(repodir)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


if isunix()
    
    fn = tempname();

    cmd = sprintf('git --git-dir=%s/.git --work-tree=%s log -1 --format=%%H >> %s &', repodir, repodir, fn);

    system(cmd);

    cmd = sprintf('git --git-dir=%s/.git --work-tree=%s status >> %s &', repodir, repodir, fn);

    stat = system(cmd);

    pause(0.2); %have to wait for the last write to finish
    
    fid = fopen(fn);
    
    sha1 = fgetl(fid);
   
    tline = fgetl(fid);
    
    
    modified = 0;
    
    while ~feof(fid)
        if(length(strfind(tline, 'modified')))
            modified = 1;
            break;
        end
        tline = fgetl(fid);
    end
    
    fclose(fid);
    
end %isunix()

end

