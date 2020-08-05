..\..\..\bin\gmad.exe create -out .\cqb_base.gma -warninvalid -folder "%~dp0
..\..\..\bin\gmpublish.exe update -id "2176251364" -addon .\cqb_base.gma -icon "%~dp0/cqb_base.jpg" -changes "Update"
del .\cqb_base.gma
pause