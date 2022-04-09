function varargout = svnversion(varargin)


%% Get absolute path of svnversion.exe.
svnver   = '1.8.5';
switch svnver
case '1.8.5'
    svnexe = fullfile(fileparts(mfilename('fullpath')), 'private', ...
        'svn-1.8.5', 'svnversion.exe');
otherwise
    error('Invalid svnver.');
end


%% Execute svnversion command.
[status, result] = dos([sprintf('"%s" ', svnexe), sprintf('%s ', varargin{:})]);
if nargout == 0
    fprintf('%s\n', result);
end
if status ~= 0
    error('status ~= 0');
end


%% Assign output arguments.
switch nargout
case 0
    % Do nothing.
case 1
    varargout = {result};
otherwise
    error('Invalid number of output arguments.')
end


end
