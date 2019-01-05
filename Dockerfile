# escape=`

ARG BASE_TAG=latest_1803

FROM mback2k/windows-buildbot-worker:${BASE_TAG}

SHELL ["powershell", "-command"]

ARG GIT_X64="https://github.com/git-for-windows/git/releases/download/v2.19.1.windows.1/Git-2.19.1-64-bit.exe"
ADD ${GIT_X64} C:\Windows\Temp\Git-64-bit.exe

RUN Start-Process -FilePath "C:\Windows\Temp\Git-64-bit.exe" -ArgumentList /VERYSILENT, /NORESTART, /NOCANCEL, /SP- -NoNewWindow -PassThru -Wait; `
    Remove-Item @('C:\Windows\Temp\*', 'C:\Users\*\Appdata\Local\Temp\*') -Force -Recurse;

ARG IS_UNICODE="http://www.jrsoftware.org/download.php/is-unicode.exe"
ADD ${IS_UNICODE} C:\Windows\Temp\is-unicode.exe

RUN Start-Process -FilePath "C:\Windows\Temp\is-unicode.exe" -ArgumentList /VERYSILENT, /NORESTART, /NOCANCEL, /SP- -NoNewWindow -PassThru -Wait; `
    Remove-Item @('C:\Windows\Temp\*', 'C:\Users\*\Appdata\Local\Temp\*') -Force -Recurse;

ARG P7Z_X64="http://www.7-zip.org/a/7z1604-x64.exe"
ADD ${P7Z_X64} C:\Windows\Temp\7z1604-x64.exe

RUN Start-Process -FilePath "C:\Windows\Temp\7z1604-x64.exe" -ArgumentList /S -NoNewWindow -PassThru -Wait; `
    Remove-Item @('C:\Windows\Temp\*', 'C:\Users\*\Appdata\Local\Temp\*') -Force -Recurse;

ARG STUNNEL="https://www.stunnel.org/downloads/stunnel-5.50-win64-installer.exe"
ADD ${STUNNEL} C:\Windows\Temp\stunnel-win64-installer.exe

RUN Start-Process -FilePath "C:\Windows\Temp\stunnel-win64-installer.exe" -ArgumentList /S -NoNewWindow -PassThru -Wait; `
    Remove-Item @('C:\Windows\Temp\*', 'C:\Users\*\Appdata\Local\Temp\*') -Force -Recurse; `
    Write-Host 'Checking PATH ...'; `
    Get-Item -Path 'C:\Program Files (x86)\stunnel\bin';

RUN Write-Host 'Updating PATH ...'; `
    $env:PATH = 'C:\Program Files (x86)\stunnel\bin;' + $env:PATH; `
    [Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine);

ARG OPENSSH_WIN64="https://github.com/PowerShell/Win32-OpenSSH/releases/download/v7.7.2.0p1-Beta/OpenSSH-Win64.zip"
ADD ${OPENSSH_WIN64} C:\Windows\Temp\OpenSSH-Win64.zip

RUN Start-Process -FilePath "C:\Program` Files\7-Zip\7z.exe" -ArgumentList x, "C:\Windows\Temp\OpenSSH-Win64.zip", `-oC:\OpenSSH -NoNewWindow -PassThru -Wait; `
    Remove-Item @('C:\Windows\Temp\*', 'C:\Users\*\Appdata\Local\Temp\*') -Force -Recurse; `
    Write-Host 'Checking PATH ...'; `
    Get-Item -Path 'C:\OpenSSH\OpenSSH-Win64';

RUN Write-Host 'Updating PATH ...'; `
    $env:PATH = 'C:\OpenSSH\OpenSSH-Win64;' + $env:PATH; `
    [Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine);

ARG VCREDIST_2012_X64="https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe"
ADD ${VCREDIST_2012_X64} C:\Windows\Temp\vcredist_x64.exe

RUN Start-Process -FilePath "C:\Windows\Temp\vcredist_x64.exe" -ArgumentList /passive, /norestart -NoNewWindow -PassThru -Wait; `
    Remove-Item @('C:\Windows\Temp\*', 'C:\Users\*\Appdata\Local\Temp\*') -Force -Recurse; `
    Write-Host 'Checking MSVCR110 ...'; `
    Get-Item -Path 'C:\Windows\system32\msvcr110.dll';

ARG GROUP_JOB_X64="https://github.com/mback2k/group-job/releases/download/v0.1/group-job-x64.exe"
ADD ${GROUP_JOB_X64} C:\Windows\system32\group-job.exe
