#SingleInstance Force

If Not FileExist("characters.txt") {
  FileInstall("characters.txt", "characters.txt")
}

CharMapGui := Gui("AlwaysOnTop", "Pocket CharMap")
CharMapGui.AddText(, "Search character (enter empty text to restore)")
textSearch := CharMapGui.AddEdit()
searchBtn := CharMapGui.AddButton("Default x135 y23", "Search")
searchBtn.OnEvent("Click", searchChar)

charListView := CharMapGui.Add("ListView", "r20 x10 w400", ["Character", "Name"])
charListView.OnEvent("ItemSelect", setItemToClipboard)
filteredChars := CharMapGui.Add("ListView", "r20 x10 y51 w400", ["Character", "Name"], )
filteredChars.OnEvent("ItemSelect", setItemToClipboard)
ControlHide(filteredChars)

oldSearch := ""

; Read data from file and add it to the listview
; The file is deleted only in the compiled version
content := FileRead("characters.txt")
/*@Ahk2Exe-Keep
FileDelete("characters.txt")
*/
data := StrSplit(content, "|")
createList(data) {
  i := 1
  While i < data.Length-1 {
    num := data[i]
    name := data[i+1]
    charListView.Add(, Chr(num), name)
    i += 2
  }
}

setItemToClipboard(GuiCtrlObj, Item, Selected) {
  If Selected {
    A_Clipboard := GuiCtrlObj.GetText(Item, 1)
  }
}

filterList(toSearch, ctrlObj) {
  i := 1
  rowCount := ctrlObj.GetCount()
  filteredData := []
  wordList := StrSplit(toSearch, " ")
  While i < rowCount {
    charName := ctrlObj.GetText(i, 2)
    ; TODO: Maybe there's a cleaner way to check for a list of words with regex?
    wordsFound := True
    For n, word In wordList {
      If Not InStr(charName, word) {
        wordsFound := False
        Break
      }
    }
    If wordsFound {
      char := ctrlObj.GetText(i, 1)
      filteredData.Push([char, charName])
    }
    i++
  }
  Return filteredData
}

searchChar(CntrlObj, info) {
  Global oldSearch
  toSearch := textSearch.Value
  newSearchLen := StrLen(toSearch)
  If newSearchLen == 0 {
    ; Restore ListView
    oldSearch := ""
    filteredChars.Delete()
    ControlHide(filteredChars)
    ControlShow(charListView)
    Return
  }
  oldSearchLen := StrLen(oldSearch)
  searchAll := newSearchLen <= oldSearchLen Or oldSearchLen == 0
  filteredData := filterList(toSearch, searchAll ? charListView : filteredChars)
  filteredChars.Delete()
  For i, filtered In filteredData {
    filteredChars.Add(, filtered[1], filtered[2])
  }
  ControlHide(charListView)
  ControlShow(filteredChars)
  oldSearch := toSearch
}

; Win+, to show the gui in the bottom right corner
#,:: {
  CharMapGui.Show("x" . A_ScreenWidth-550 . "y" . A_ScreenHeight-550)
}

createList(data)