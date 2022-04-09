function svncreaterepos(projectname)


%%
repos = fullfile(findroot('khung'), ['svnrepos-', projectname]);
if exist(repos, 'dir') ~= 0
    error('repos already exists.');
end
local = fullfile(findroot('khung'), projectname);
if exist(local, 'dir') ~= 0
    error('local already exists.');
end


%% Create new svn repository.
svnadmin('create', repos);
url = ['file:///', strrep(repos, '\', '/'), '/trunk'];
svn('mkdir', url, '-m "Start trunk."');
url = ['file:///', strrep(repos, '\', '/'), '/branches'];
svn('mkdir', url, '-m "Start branches."');


%% Checkout a local copy.
url   = ['file:///', strrep(repos, '\', '/')];
svn('co', url, local);


end

