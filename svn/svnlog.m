function svnlog(varargin)

%%
%       SYNTAX: svnlog
%               svnlog top
%
%  DESCRIPTION: Write svn log to a file called log.txt.
%
%        INPUT: -top (char)
%                   Top-level folder or a single file name.
%
%       OUTPUT: none.


%% Assign input argument.
top = '.';
switch nargin
case 0
    % Do nothing.
case 1
    top = varargin{1};
otherwise
    error('Invalid number of input arguments.');
end


%% Find the latest revision in local workspace.
r = svnversion([top, ' --no-newline']);
r = strrep(r, 'M', '');
if contains(r, ':')
    r = strsplit(r, ':');
    r = str2double(r{2});
else
    r = str2double(r);
end
if isnan(r)
    error('Cannot get revision number.');
end


%% Call svn log.
cmd = sprintf('log %s -v -r%d:1 > log.txt', top, r);
[~] = svn(cmd);
fprintf('Log file: %s\\log.txt\n', pwd)
edit log.txt


end

