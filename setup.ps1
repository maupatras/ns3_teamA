param ( $TempCygDir="$env:temp\cygInstall" )
if(!(Test-Path -Path $TempCygDir -PathType Container))
{
   $null = New-Item -Type Directory -Path $TempCygDir -Force
}

$os=Get-WMIObject win32_operatingsystem

If ($os.OSArchitecture -Match "64-bit") {
	Write-Host "Downloading Cygwin..." -foreground "cyan"
	Invoke-WebRequest -OutFile "$TempCygDir\setup.exe" https://www.cygwin.com/setup-x86_64.exe
	Write-Host "Successful download: setup.exe" -foreground "green"
} Else {
	Write-Host "Downloading Cygwin..." -foreground "cyan"
	Invoke-WebRequest -OutFile "$TempCygDir\setup.exe" https://www.cygwin.com/setup-x86.exe
	Write-Host "Successful download: setup.exe" -foreground "green"
}

Echo ""
Write-Host "Intalling Cygwin..." -foreground "cyan"
Start-Process -wait -FilePath "$TempCygDir\setup.exe" -ArgumentList "-q -n -l $TempCygDir -s ftp://ftp.ntua.gr/pub/pc/cygwin/ -R c:\Cygwin"
Write-Host "Done" -foreground "green"
Write-Host "Installing gcc package (C compiler)..." -foreground "cyan"
Start-Process -wait -FilePath "$TempCygDir\setup.exe" -ArgumentList "-q -n -l $TempCygDir -s ftp://ftp.ntua.gr/pub/pc/cygwin/ -R c:\Cygwin -P gcc-core"
Write-Host "Done" -foreground "green"
Write-Host "Installing g++ package (C++ compiler)..." -foreground "cyan"
Start-Process -wait -FilePath "$TempCygDir\setup.exe" -ArgumentList "-q -n -l $TempCygDir -s ftp://ftp.ntua.gr/pub/pc/cygwin/ -R c:\Cygwin -P gcc-g++"
Write-Host "Done" -foreground "green"
Write-Host "Installing make package" -foreground "cyan"
Start-Process -wait -FilePath "$TempCygDir\setup.exe" -ArgumentList "-q -n -l $TempCygDir -s ftp://ftp.ntua.gr/pub/pc/cygwin/ -R c:\Cygwin -P make"
Write-Host "Done" -foreground "green"
Write-Host "Installing gdb package" -foreground "cyan"
Start-Process -wait -FilePath "$TempCygDir\setup.exe" -ArgumentList "-q -n -l $TempCygDir -s ftp://ftp.ntua.gr/pub/pc/cygwin/ -R c:\Cygwin -P gdb"
Write-Host "Done" -foreground "green"
Write-Host "Installing python" -foreground "cyan"
Start-Process -wait -FilePath "$TempCygDir\setup.exe" -ArgumentList "-q -n -l $TempCygDir -s ftp://ftp.ntua.gr/pub/pc/cygwin/ -R c:\Cygwin -C Python"
Write-Host "Done" -foreground "green"
Echo ""

Write-Host "Downloading NS-3 v3.22..." -foreground "cyan"
Invoke-WebRequest -OutFile "$TempCygDir\ns3.tar.bz2" https://www.nsnam.org/release/ns-allinone-3.22.tar.bz2
Write-Host "Done. Unzipping files..." -foreground "green"
$env:path = "$($env:path);c:\cygwin\bin"
tar.exe -xjf $TempCygDir\ns3.tar.bz2 --force-local
Echo ""
Write-Host "Done" -foreground "green"

Write-Host "Building NS-3..." -foreground "green"
cd .\ns-allinone-3.22\
New-Alias -Name python -Value "C:\cygwin\bin\python2.7.exe"
python ./build.py --enable-examples --enable-tests
Write-Host "Done" -foreground "green"

Write-Host "Deleting temp download folder..." -foreground "cyan"
rmdir $TempCygDir -recurse
Write-Host "Temporary folder $TempCygDir successfully deleted" -foreground "green"