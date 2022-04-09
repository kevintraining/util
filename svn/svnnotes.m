% ------------------------------------------------------------------------------
%                   Plain Text File VS Binary File
% ------------------------------------------------------------------------------


%% Should SVN Care About Plain Text File VS Binary File?
%
% * Answer is yes. The following lists all situations where this distinction
%   makes a difference
%
% * Situatiion 1: Keyword substitution.
%
% * Situation 2: Merging. SVN will perform merging on text files only.
%
% * Situation 3: svn update. This is related to svn merging. Turns out that in
%                the situation where a local file has local modifications and
%                you perform 'svn update' on this file, then (in case of text
%                file) svn will automatically merge HEAD revision of this file
%                with the local modications and save the merged result to the
%                local file.
%
% * Situation 4: You want SVN to standardize end-of-line characters for all text
%                files.


%% Google Search
%
% * http://svnbook.red-bean.com/en/1.7/svn.forcvs.binary-and-trans.html
%
% * http://help.collab.net/index.jsp?topic=/faq/svnbinary.html


%% MATLAB Documentation
%
% * web(fullfile(docroot, 'matlab/matlab_prog/set-up-svn-source-control.html'))


% ------------------------------------------------------------------------------
%                               Ignore
% ------------------------------------------------------------------------------


%% global-ignores
%
% * In pp. 231 of svn-book-1p7.pdf, it says,
%
%       The default value is *.o *.lo *.la *.al .libs *.so *.so.[0-9]* *.a *.pyc
%       *.pyo *.rej *~ #*# .#* .*.swp .DS_Store.
%
% * https://stackoverflow.com/questions/86049/how-do-i-ignore-files-in-subversion
%
% * edit C:\Users\khung\AppData\Roaming\Subversion\config
%
% * svn add --no-ignore . --force
%
% * svn st . --no-ignore


% ------------------------------------------------------------------------------
%                           Start a New Project
% ------------------------------------------------------------------------------

%% Create a new repository on c:\ drive.
svnadmin('create c:\users\khung\desktop\svnrepos-test')

%% Create a new folder "trunk" in the repository.
svn mkdir file:///c:/users/khung/desktop/svnrepos-test/trunk -m ""

%% Checkout everything from trunk, branches and tags.
svn co file:///c:/users/khung/desktop/svnrepos-test c:\users\khung\desktop\test

%% Create files. Commit.
ckhfilewrite('c:\users\khung\desktop\test\trunk\aaa.txt', 'wt', {'agc'});
ckhfilewrite('c:\users\khung\desktop\test\trunk\bbb.txt', 'wt', {'agc'});
svn add c:\users\khung\desktop\test\trunk\aaa.txt
svn add c:\users\khung\desktop\test\trunk\bbb.txt
svn ci  c:\users\khung\desktop\test\trunk\aaa.txt -m ""
svn ci  c:\users\khung\desktop\test\trunk\bbb.txt -m ""

%% Create tags.
svn mkdir file:///c:/users/khung/desktop/svnrepos-test/tags -m ""
svn cp file:///c:/users/khung/desktop/svnrepos-test/trunk file:///c:/users/khung/desktop/svnrepos-test/tags/release_1 -m ""
svn cp file:///c:/users/khung/desktop/svnrepos-test/trunk file:///c:/users/khung/desktop/svnrepos-test/tags/release_2 -m ""

%% Update tags in local workspace.
svn up --depth empty c:\users\khung\desktop\test\tags
svn up c:\users\khung\desktop\test\tags\release_1
rmdir c:\users\khung\desktop\test\tags\release_1 s
svn st c:\users\khung\desktop\test  % Get annoying !

%% Alternate Approach: Checkout trunk, branches and tags individually.
%
% * Drawback: now you will have .svn under trunk/
%
svn co file:///c:/users/khung/desktop/svnrepos-test/trunk          c:\users\khung\desktop\test\trunk
svn co file:///c:/users/khung/desktop/svnrepos-test/tags/release_1 c:\users\khung\desktop\test\tags\release_1

%% Another Alternate Approach.
%
% * Don't do "svn st" on c:\users\khung\desktop\test\tags otherwise you get
%   the annoying !
%
svn co --depth empty file:///c:/users/khung/desktop/svnrepos-test c:\users\khung\desktop\test
svn up c:\users\khung\desktop\test\trunk
svn up --depth empty c:\users\khung\desktop\test\tags
svn up c:\users\khung\desktop\test\tags\release_1


% ------------------------------------------------------------------------------
%                           Authentication
% ------------------------------------------------------------------------------

getenv('appdata')
type c:\Users\khung\AppData\Roaming\Subversion\auth\svn.simple\77f89936954f5731001c65472f2488b7
ll c:\Users\khung\AppData\Roaming\Subversion\auth
mv c:\Users\khung\AppData\Roaming\Subversion\auth\svn.simple\77f89936954f5731001c65472f2488b7 c:\users\khung\Desktop\
svn up . --username cykhung --password KevinHung2001
svn up . --username cykhung --password KevinHung2001 --no-auth-cache  % Do not save password.

% ------------------------------------------------------------------------------
%                   Backup a Remote SVN Repository
% ------------------------------------------------------------------------------

%% Notes
%
% * https://stackoverflow.com/questions/2302592/how-do-i-back-up-a-remote-svn-repository

%% Create a brand new repository on local c:\ drive.
svnadmin('create v:\khung\svnrepos-ashlandroboticsclub')

%% Next, create a file named pre-revprop-change.bat.
dos('echo exit 0 > v:\khung\svnrepos-ashlandroboticsclub\hooks\pre-revprop-change.bat')

%% Initialize the sync on the local repository.
svnsync('init file:///V:/khung/svnrepos-ashlandroboticsclub https://subversion.assembla.com/svn/ashlandroboticsclub')

%% Incremental sync. Run this command periodically to backup repository.
svnsync('sync file:///V:/khung/svnrepos-ashlandroboticsclub')


% ------------------------------------------------------------------------------
%           Import Existing SVN Repository From Assembla To SlikSVN
% ------------------------------------------------------------------------------

%% Notes
%
% * https://sliksvn.com/support/import-subversion-repository

%% Initialize the sync on SlikSVN repository.
svnsync('init https://svn.sliksvn.com/ashlandroboticsclub https://subversion.assembla.com/svn/ashlandroboticsclub')

%% Copy. 
svnsync('sync https://svn.sliksvn.com/ashlandroboticsclub')


% ------------------------------------------------------------------------------
%                           TortoiseSVN Settings
% ------------------------------------------------------------------------------

%% Diff Viewer
%
% * Configure the program used for comparing different revisions of files
%   (1) Select "External"
%   (2) V:\khung\WinMerge\WinMergeU.exe -e -ub -dl %bname -dr %yname %base %mine
%
% * Configure the program used for comparing different revisions of properties
%   (1) Select "External"
%   (2) V:\khung\WinMerge\WinMergeU.exe -e -ub -dl %bname -dr %yname %base %mine


% ------------------------------------------------------------------------------
%                                Export
% ------------------------------------------------------------------------------

%% Export a single file at a particular revision.
svn export -r1478 file:///V:/khung/svnrepos-skunk/trunk/startup.m startup_r1478.m
svn export file:///V:/khung/svnrepos-skunk/trunk/startup.m@1478 startup_r1478.m
svn cat file:///V:/khung/svnrepos-skunk/trunk/startup.m@1478 > startup_r1478.m


% ------------------------------------------------------------------------------
%                       Resurrect Deleted Files/Folders
% ------------------------------------------------------------------------------

%% Resurrect deleted file and keep history.
svn copy file:///V:/khung/svnrepos-skunk/trunk/startup.m@807 startup.m
svn commit -m "Resurrect startup.m from revision 807."

%% Resurrect deleted file but do not want to keep history.
svn cat file:///V:/khung/svnrepos-skunk/trunk/startup.m@807 > startup.m
svn add startup.m
svn commit -m "Resurrect startup.m from revision 807 but no history."

%% Resurrect deleted folder but do not want to keep history.
%
% * 'test' is a folder with 2 files and the entire folder (with its 2 files) is
%   deleted in revision 4341.
%
svn export file:///V:/khung/svnrepos-skunk/trunk/test@4340 test

%% Resurrect deleted file and keep history. Directly done to the repository.
svn rm file:///V:/khung/svnrepos-skunk/trunk/startup.m -m "Delete file."
svn copy file:///V:/khung/svnrepos-skunk/trunk/startup.m@807    ...
         file:///V:/khung/svnrepos-skunk/trunk/startup.m        ...
         -m "Resurrect startup.m from revision 807."


% ------------------------------------------------------------------------------
%                                GITHUB
% ------------------------------------------------------------------------------

%% GitHub Documentation
%
% * https://help.github.com/en/articles/support-for-subversion-clients

%% Start a new local workspace from GitHub repository.
cd v:\khung
svn co --depth empty https://github.com/cykhung/anissa.git anissa
cd anissa
svn up trunk
svn up --depth empty branches
svn propget git-commit --revprop -r HEAD

%% Initialize the sync on the local repository. Does not work.
dos([                                                                       ...
    'v:\khung\skunk\trunk\lib\svnwin32\svn-win32-1.8.5\bin\svnsync.exe ',   ...
    'init ',                                                                ...
    'file:///C:/Users/khung/Desktop/tmp/svnrepos-adash ',                   ...
    'https://github.com/adashofdata/intro-to-text-analytics.git',           ...
    ])

%% Incremental sync.  Does not work.
dos([                                                                       ...
    'v:\khung\skunk\trunk\lib\svnwin32\svn-win32-1.8.5\bin\svnsync.exe ',   ...
    'sync ',                                                                ...
    'file:///C:/Users/khung/Desktop/tmp/svnrepos-adash',                    ...
    ])


% ------------------------------------------------------------------------------
%                       Download SVN DOS Executables
% ------------------------------------------------------------------------------

%% Subversion 1.11.1 DOS Executables
%
% https://www.visualsvn.com/downloads/
% https://www.visualsvn.com/files/Apache-Subversion-1.11.1.zip


% ------------------------------------------------------------------------------
%                       Modify Commit Log Message
% ------------------------------------------------------------------------------

%%
%
% * >> svnadmin setlog v:\khung\svnrepos-test123 --bypass-hooks -r 2 log.txt
%
% * After running the above command, you need to update cache in Tortoise (if
%   log caching is enabled).

