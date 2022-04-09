function upload


%% Zip everything under c:\class
d = fileparts(mfilename('fullpath'));
switch getenv('COMPUTERNAME')
case 'AH-KHUNG-NEW'
    f = 'kevin.zip';
case 'AH-NLONGO-NEW'
    f = 'nick.zip';
otherwise
    error('Invalid computername.');
end
zipfilename = fullfile(d, f);
zip(zipfilename, 'c:\class')


% %% svn update.
% d = fileparts(mfilename('fullpath'));
% svn('update ', d);


%% svn commit zipfile.
try     %#ok<TRYNC> 
    r = svn('add', zipfilename);
end
svn('ci ', zipfilename, '-m ""');


end

