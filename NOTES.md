Personal notes where I logged the problems I faced and how I solved them.

# TODO
Problem: The character names are in english only, it would be better if it could detect the OS language automatically, or maybe ask the user (once) if they prefer english or their PC language.
Solution: TODO.

# Solved
Problem: Get all the unicode character names.
Solution: https://stackoverflow.com/a/72482270
Use a windows DLL that exposes that functionality: `u_charName` from `icuuc.dll`.

Problem: Loading the characters dynamically (i.e iterating from 0x20 to 0xFEEF and calling the dll function to get the name) to the GUI is very slow.
Solution: Save the number and the name of the characters to a file and create the GUI by reading it. It still takes a couple of seconds to load, but this is done once when the script is executed.

Problem: Filtering values by deleting the rows that don't contain the user input one by one is very slow.
Solution: Push the values that contain the user input to an array, clear the ListView and create a new one with those values.

Problem: Typing characters one by one doesn't always fire the Change callback, that's because as long as one callback is still getting executed, the following ones are ignored.
Solution: Fire the callback only when the enter key is pressed. To do this, add a search button with the "Default" option. This option fires the "Click" event when the button is clicked AND when the user presses enter.

Problem: Restoring all characters one by one in the gui is very slow.
Solution: Have two ListViews, one that shows the full list and other empty, both at the same position and with the same size. When searching for a character, add the filtered values to the empty list, then hide the full list with `ControlHide` and show the filtered list with `ControlShow`. To restore the list, simply hide the filtered list and show the full one.

Problem: Improve the search functionality, it's kind of uncomfortable.
Solution: save the current text to search in `toSearch` and the old one in `oldSearch`. Compare the length of the strings: if `newSearchLen <= oldSearchLen Or oldSearchLen == 0`, then filter through the full list, otherwise filter through the currently displayed characters. Example: 
- The user looks for `integral` => show all results with that word.
- Now, the user looks for `int` => instead of filtering through the results of `integral`, it will look through the whole list, because "int" is shorter than "integral"

Problem: reading the words from a txt file is not good.
Solution: embed it to the executable. Doesn't exactly solve the problem but at least it's no longer mandatory to have the file since the executable will generate it anyway.