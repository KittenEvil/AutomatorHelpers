on run {input, parameters}
	set userInput to text returned of (display dialog "Name of window to find?" default answer "")
	set matchingWindows to {}
	set windowData to {}
	
	tell application "System Events"
		set processList to name of every process whose background only is false
		repeat with procName in processList
			try
				tell process procName
					set windowList to every window
					repeat with win in windowList
						set winName to name of win
						set windowEntry to (procName & ": " & winName)
						ignoring case
							if windowEntry contains userInput then
								set end of matchingWindows to windowEntry
								set end of windowData to {procName, win}
							end if
						end ignoring
					end repeat
				end tell
			end try
		end repeat
	end tell
	
	if length of matchingWindows > 1 then
		set selectedWindow to choose from list matchingWindows with prompt "Select a window:"
		if selectedWindow is not false then
			set selectedText to item 1 of selectedWindow
			set selectedIndex to my getIndex(selectedText, matchingWindows)
			set {procName, winRef} to item selectedIndex of windowData
			tell application "System Events"
				tell process procName
					set frontmost to true
					perform action "AXRaise" of winRef
				end tell
			end tell
		end if
	else if length of matchingWindows = 1 then
		set {procName, winRef} to item 1 of windowData
		tell application "System Events"
			tell process procName
				set frontmost to true
				perform action "AXRaise" of winRef
			end tell
		end tell
	else
		display dialog "No windows found containing: " & userInput
	end if
	
	return input
end run

on getIndex(selectedText, lst)
	repeat with i from 1 to length of lst
		if selectedText = item i of lst then return i
	end repeat
end getIndex