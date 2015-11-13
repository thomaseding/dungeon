set HOME=%USERPROFILE%
set DUNGEON=%HOME%\dungeon

mklink /D %HOME%\vimfiles %DUNGEON%\vim
mklink %HOME%\_vimrc %DUNGEON%\vimrc

