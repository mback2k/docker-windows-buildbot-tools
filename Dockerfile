# escape=`

ARG BASE_TAG=latest_1803

FROM mback2k/windows-buildbot-worker:${BASE_TAG}

SHELL ["powershell", "-command"]

ARG GIT_X64="https://github.com/git-for-windows/git/releases/download/v2.21.0.windows.1/Git-2.21.0-64-bit.exe"

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
    Invoke-WebRequest $env:GIT_X64 -OutFile "C:\Windows\Temp\Git-64-bit.exe"; `
    Start-Process -FilePath "C:\Windows\Temp\Git-64-bit.exe" -ArgumentList /VERYSILENT, /NORESTART, /NOCANCEL, /SP- -NoNewWindow -PassThru -Wait; `
    Remove-Item @('C:\Windows\Temp\*', 'C:\Users\*\Appdata\Local\Temp\*') -Force -Recurse;

ARG IS_UNICODE="http://files.jrsoftware.org/is/5/innosetup-5.6.1-unicode.exe"

RUN Invoke-WebRequest $env:IS_UNICODE -OutFile "C:\Windows\Temp\is-unicode.exe"; `
    Start-Process -FilePath "C:\Windows\Temp\is-unicode.exe" -ArgumentList /VERYSILENT, /NORESTART, /NOCANCEL, /SP- -NoNewWindow -PassThru -Wait; `
    Remove-Item @('C:\Windows\Temp\*', 'C:\Users\*\Appdata\Local\Temp\*') -Force -Recurse; `
    Write-Host 'Checking PATH ...'; `
    Get-Item -Path 'C:\Program Files (x86)\Inno Setup 5';

RUN Write-Host 'Updating PATH ...'; `
    $env:PATH = 'C:\Program Files (x86)\Inno Setup 5;' + $env:PATH; `
    [Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine);

ARG P7Z_X64="http://www.7-zip.org/a/7z1604-x64.exe"

RUN Invoke-WebRequest $env:P7Z_X64 -OutFile "C:\Windows\Temp\7z1604-x64.exe"; `
    Start-Process -FilePath "C:\Windows\Temp\7z1604-x64.exe" -ArgumentList /S -NoNewWindow -PassThru -Wait; `
    Remove-Item @('C:\Windows\Temp\*', 'C:\Users\*\Appdata\Local\Temp\*') -Force -Recurse;

ARG STUNNEL="https://www.stunnel.org/downloads/stunnel-5.53-win64-installer.exe"

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
    Invoke-WebRequest $env:STUNNEL -OutFile "C:\Windows\Temp\stunnel-win64-installer.exe"; `
    Start-Process -FilePath "C:\Windows\Temp\stunnel-win64-installer.exe" -ArgumentList /S -NoNewWindow -PassThru -Wait; `
    Remove-Item @('C:\Windows\Temp\*', 'C:\Users\*\Appdata\Local\Temp\*') -Force -Recurse; `
    Write-Host 'Checking PATH ...'; `
    Get-Item -Path 'C:\Program Files (x86)\stunnel\bin';

RUN Write-Host 'Updating PATH ...'; `
    $env:PATH = 'C:\Program Files (x86)\stunnel\bin;' + $env:PATH; `
    [Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine);

ARG OPENSSH_WIN64="https://github.com/PowerShell/Win32-OpenSSH/releases/download/v7.9.0.0p1-Beta/OpenSSH-Win64.zip"

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
    Invoke-WebRequest $env:OPENSSH_WIN64 -OutFile "C:\Windows\Temp\OpenSSH-Win64.zip"; `
    Start-Process -FilePath "C:\Program` Files\7-Zip\7z.exe" -ArgumentList x, "C:\Windows\Temp\OpenSSH-Win64.zip", `-oC:\OpenSSH -NoNewWindow -PassThru -Wait; `
    Remove-Item @('C:\Windows\Temp\*', 'C:\Users\*\Appdata\Local\Temp\*') -Force -Recurse; `
    Write-Host 'Checking PATH ...'; `
    Get-Item -Path 'C:\OpenSSH\OpenSSH-Win64';

RUN Write-Host 'Updating PATH ...'; `
    $env:PATH = 'C:\OpenSSH\OpenSSH-Win64;' + $env:PATH; `
    [Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine);

ARG VCREDIST_2012_X64="https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe"

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
    Invoke-WebRequest $env:VCREDIST_2012_X64 -OutFile "C:\Windows\Temp\vcredist_x64.exe"; `
    Start-Process -FilePath "C:\Windows\Temp\vcredist_x64.exe" -ArgumentList /passive, /norestart -NoNewWindow -PassThru -Wait; `
    Remove-Item @('C:\Windows\Temp\*', 'C:\Users\*\Appdata\Local\Temp\*') -Force -Recurse; `
    Write-Host 'Checking MSVCR110 ...'; `
    Get-Item -Path 'C:\Windows\system32\msvcr110.dll';

ARG GROUP_JOB_X64="https://github.com/mback2k/group-job/releases/download/v0.1/group-job-x64.exe"
ADD ${GROUP_JOB_X64} C:\Windows\system32\group-job.exe
