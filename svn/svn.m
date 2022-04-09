function varargout = svn(varargin)

%
%     FUNCTION: svn - Run Svn.
%
%       SYNTAX: result = svn(svn, ...)
%               svn gdiff filename
%               svn gdiff filename head local
%               svn gdiff filename 235 local
%
%  DESCRIPTION: Run svn.
%
%               To resurrect directory tfp from revision 1298:
%               >> svn copy -r 1298 https://.../src/tfp https://.../src/tfp -m
%                       "Resurrect directory tfp from revision 1298."
%               OR
%               >> svn copy -r 1298 https://.../src/tfp https://.../src -m
%                       "Resurrect directory tfp from revision 1298."
%
%               To switch a file to a different location in the repository:
%               >> svn switch https://.../branches/debug/src/tfp/tfp_hsdsch.c
%                       c:\...\tfp\tfp_hsdsch.c
%
%        INPUT: TBD.
%
%       OUTPUT: - result (string)
%                   Result from dos command.


%% Special case: svn gdiff
if strcmp(varargin{1}, 'gdiff')
    svn_gdiff(varargin{2:end});
    return;
end


%% Special case: svn addci
if strcmp(varargin{1}, 'addci')
    svn('add --force', varargin{2:end});
    svn('ci', varargin{2:end}, '-m "Initial commit."');
    return;
end


%% Execute svn command.
svnver = '1.8.5';
cmd = ['"', get_svnexe(svnver), '"', ' ', sprintf('%s ', varargin{:})];
if ismember(varargin{1}, {'st', 'status', 'add', 'import'})
    cmd = [cmd, '--no-ignore'];
end
% fprintf('%s\n\n', cmd)
[status, result] = dos(cmd);
if nargout == 0
    fprintf('%s\n', result);
else
    varargout = {result};
end
if status ~= 0
    error('status ~= 0');
end


end



function svnexe = get_svnexe(svnver)

switch svnver
case '1.8.5'
    svnexe = fullfile(fileparts(mfilename('fullpath')), 'private', ...
        'svn-1.8.5', 'svn.exe');
otherwise
    error('Invalid svnver.');
end

end



function svn_gdiff(varargin)

if nargin == 3
    filename = varargin{1};
    revision = varargin(2:end);
elseif nargin == 1
    filename = varargin{1};
    revision = {'head', 'local'};
else
    error('Invalid number of input arguments for GDIFF.');
end

%% Delete previously created temporary files.
s = dir([tempdir, 'svngdiff-*']);
state = recycle;
recycle('off');
for n = 1:length(s)
    fprintf('Delete file %s\n', fullfile(s(n).folder, s(n).name));
    delete(fullfile(s(n).folder, s(n).name));
end
recycle(state);

%% Diff.
revision_filename = cell(1,2);
[pathstr, name, ext] = fileparts(filename);
for n = 1:2
    if strcmp(revision{n}, 'local')
        if isempty(pathstr)
            revision_filename{n} = fullfile(pwd, filename);
        else
            revision_filename{n} = filename;
        end
        if ismember(ext, '.pdf')
            revision_filename{n} = [tempdir, 'svngdiff-', name, '-local', ext];
            fprintf('copyfile %s %s\n', filename, revision_filename{n})
            copyfile(filename, revision_filename{n});
        end
    elseif strcmp(revision{n}, 'head')
        revision_filename{n} = [tempdir, 'svngdiff-', name, '-head', ext];
        str = sprintf('svn(''cat "%s" -r HEAD > "%s"'')', ...
            filename, revision_filename{n});
        fprintf('%s\n', str);
        tmp = eval(str);
        if ~isempty(tmp)
            error('tmp is not empty.');     % Make mlint happy.
        end
    elseif ~isempty(str2double(revision{n}))
        revision_filename{n} = [tempdir, 'svngdiff-', name, '-', revision{n}, ext];
        str = sprintf('svn(''cat "%s" -r %s > "%s"'')', ...
            filename, num2str(revision{n}), revision_filename{n});            
        fprintf('%s\n', str);
        tmp = eval(str);
        if ~isempty(tmp)
            error('tmp is not empty.');     % Make mlint happy.
        end
    else
        error('Invalid revision.');
    end
end
if ~isempty(revision_filename{1}) && ~isempty(revision_filename{2})
    if ismember(ext, {'.mlx', '.slx', '.mlapp'})
        visdiff(revision_filename{1}, revision_filename{2});
    elseif ismember(ext, {'.pdf'})
        txtfilenames = revision_filename;
        for n = 1:numel(txtfilenames)
            txtfilenames{n}(end-2 : end) = 'txt';
        end
        pdf2txt(revision_filename, txtfilenames);
        halt = 0;
        winmerge(txtfilenames{1}, txtfilenames{2}, 'None', halt);        
    else
        halt = 0;
        winmerge(revision_filename{1}, revision_filename{2}, 'None', halt);
    end
end

end

