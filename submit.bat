@echo off

set PATH=C:\Program Files\7zip;%PATH%
del /q release.zip
rmdir /s /q release
mkdir release
copy LICENSE release\
copy haxelib.json release\
copy README.md release\
copy .gitattributes release\
copy .gitignore release\
copy extraParams.hxml release\
copy .gitattributes release\
copy .gitignore release\
mkdir release\plasma
xcopy plasma release\plasma /E /I /Y
xcopy docs release\docs /E /I /Y

pushd release
7za a -tzip ..\release.zip *
popd
haxelib submit release.zip
del /q release.zip
rmdir /s /q release
pause
