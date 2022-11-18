on run argv
    set AppleScript's text item delimiters to {" "}
    tell application "Terminal"
        do script (argv as text)
    end tell
end run
