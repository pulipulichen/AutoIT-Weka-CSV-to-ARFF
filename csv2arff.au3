#include <File.au3>
#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <WinAPIFiles.au3>
#include <Array.au3>

#pragma compile(Icon, 'arff.ico')


$main_path = @ScriptDir & "\weka.jar"

Func StripExt($FileName)
   If StringInStr($FileName, '.') Then
	  $pos = StringInStr ($FileName, '.', 2, -1)
	  $FileName = StringTrimRight($FileName, StringLen($FileName) - $pos + 1)
   EndIf
   Return $FileName
EndFunc

Func GetFileNameNoExt($sFilePath)
 If Not IsString($sFilePath) Then
	 Return SetError(1, 0, -1)
 EndIf

 Local $FileName = StringRegExpReplace($sFilePath, "^.*\\", "")
 If StringInStr(FileGetAttrib($sFilePath), "D") = False And StringInStr($FileName, '.') Then
   $FileName = StripExt($FileName)
 EndIf

 Return $FileName
EndFunc

For $i = 1 To $CmdLine[0]
   Local $filePath = $CmdLine[$i]
   If FileExists ($filePath) == 1 Then

    ;; ..\inkscape.exe --file in.svg --export-emf out.emf
    ;Local $cmd = $inkscape_path & "--file in.svg --export-emf out.emf"

    ; java -cp /path/to/weka.jar weka.core.converters.CSVLoader filename.csv > filename.arff
    Local $outputPath = StripExt($filePath) & ".arff"
    
    If FileExists ($outputPath) == 1 Then
      FileRecycle($outputPath)
    EndIf

    Local $cmd = @comspec & ' /C Java -Dfile.encoding=utf-8 -cp "' & $main_path & '" weka.core.converters.CSVLoader "' & $filePath & '" 1> "' & $outputPath & '"'
    ; run(@comspec & " /C Java -jar app.jar", "C:\myApp")
    ;MsgBox($MB_SYSTEMMODAL, "", $cmd)
    RunWait($cmd, '', @SW_MINIMIZE)
   EndIf
Next
