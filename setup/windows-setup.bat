set HOME=%USERPROFILE%
set DROPBOX=%HOME%\Dropbox

set CODE=%DROPBOX%\code
mklink /D %HOME%\code %CODE%

set DUNGEON=%DROPBOX%\dungeon
mklink /D %HOME%\dungeon %DUNGEON%

mklink /D %HOME%\vimfiles %DUNGEON%\vim
mklink %HOME%\_vimrc %DUNGEON%\vimrc

