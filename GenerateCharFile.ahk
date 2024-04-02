#Requires AutoHotkey v2.0

; Generate a file with the number and the corresponding name of the unicode char.
; It's easier to pull characters from a file instead of loading all 55k characters
; at once to the GUI.

; Gets the character name. Source: https://stackoverflow.com/a/72482270
; This function assumes the user has a windows version greater than
; the one specified in the SO answer (Fall Creators Update (Version 1709 Build 16299))
GetCharName(charCode) {
  nameBuffer := Buffer(512)
  error := 0
  out := DllCall("icuuc.dll\u_charName", "Int", charCode, "UInt", 0, "Ptr", nameBuffer, "Int", 512, "Ptr*", error)
  Return StrGet(nameBuffer, "UTF-8")
}

startChar := 32
endChar := 0xFEFF

i := startChar
data := ""
While i < endChar {
  name := GetCharName(i)
  If StrLen(name) > 0 {
    data := data . i . "|" . name . "|"
  }
  i++
}
FileAppend(data, "characters.txt")
MsgBox "Done"