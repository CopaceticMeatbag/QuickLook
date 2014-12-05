#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent
#SingleInstance, Force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#NoTrayIcon
FileInstall, C:\Users\michaelanthony\Pictures\TooBig.png, %A_appdata%\TooBig.png

SetBatchLines, -1
ListLines, Off
spaceOpen = 0
imgExt = jpg,jpeg,png,tiff,tif
;txtExt = txt,text,ahk,rtf,doc

#If ActiveDir()
Space::ImageSplash()

#If (ActiveDir() && spaceOpen = 1)
Up Up::
Send {Up}
spaceOpen=0
ImageSplash()
Return

#If (ActiveDir() && spaceOpen = 1)
Down Up::
Send {Down}
spaceOpen=0
ImageSplash()
Return

#If (ActiveDir() && spaceOpen = 1)
Left Up::
Send {Left}
spaceOpen=0
ImageSplash()
Return

#If (ActiveDir() && spaceOpen = 1)
Right Up::
Send {Right}
spaceOpen=0
ImageSplash()
Return

#If
gst(ByRef Type = "") { 
	IsClipEmpty := (Clipboard = "") ? 1 : 0
	if (!IsClipEmpty) {
		ClipboardBackup := ClipboardAll
		While !(Clipboard = "") {
			Clipboard := ""
			Sleep, 10
		}
	}
	Send, ^c
	ClipWait, 0.1
	Type := fileInClip()
	clipValue := Clipboard
	Clipboard := ClipboardBackup
	if (!IsClipEmpty)
		ClipWait, 0.5, 1
	Return clipValue
}
ActiveDir() {
	WinGetActiveTitle, title
	WinGetText, text, % title
	WinGetClass, class, % title
	if InStr(text, "Address")
	{
		StringSplit, Dir, Text, `n, %A_Space%
      Dir := SubStr(Dir1, 10, -1) ; Remove the "Adress:" and a space from the end.
	}
	else if (class = "Progman") or (class = "") ; If mouse is over desktop
		Dir := A_Desktop
	Return Dir
}



fileInClip() { ; Checks to see if the clipboard contains a file.
    Return % ((DllCall("IsClipboardFormatAvailable", "uint", 15) && InStr(Clipboard, ".")) ? "File" : "")
}
ImageSplash() {
	global
	if (spaceOpen = 1)
	{
		SplashImage, Off
		spaceOpen = 0
	}
	else
	{
		clipValue := gst(type) ; Gets the clipboard and determines if it contains a file.
		SplitPath, clipValue,,,clipExt
		if (type != "File"){
			Send, %A_Space%
			SplashImage, Off
			spaceOpen = 0
		}
		Else if clipExt in %imgExt%
		{
			FileGetSize, vCheck,%clipValue%,M
			if (vCheck < 20)
			{
				guinum = 99
				gui, %guinum%:add,picture,vmypic,%clipValue%
				GuiControlGet, mypic, %guinum%:Pos
				gui, %guinum%:destroy
				if (mypicH > 1080 || mypicW > 1920)
					SplashImage, %clipValue%,B ZH1000 ZW-1,%A_Space%,%A_Space%
				else
					SplashImage, %clipValue%,B,%A_Space%,%A_Space%
				spaceOpen = 1
			}
			else
			{
				Send, %A_Space%
				SplashImage, %A_appdata%\TooBig.png,B,%A_Space%,%A_Space%
				spaceOpen = 1
			}
		}
		Else
		{
			Send, %A_Space%
			SplashImage, Off
			spaceOpen = 0
		}
	}
}