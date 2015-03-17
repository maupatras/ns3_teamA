param ( $TempCygDir="$env:temp\cygInstall" )
if(!(Test-Path -Path $TempCygDir -PathType Container))
{
   $null = New-Item -Type Directory -Path $TempCygDir -Force
}

$os=Get-WMIObject win32_operatingsystem

If ($os.OSArchitecture -Match "64-bit") {
	Echo "Downloading Cygwin..."
	Invoke-WebRequest -OutFile "$TempCygDir\setup.exe" https://www.cygwin.com/setup-x86_64.exe
	Echo "Successful download: setup.exe"
} Else {
	Echo "Downloading Cygwin..."
	Invoke-WebRequest -OutFile "$TempCygDir\setup.exe" https://www.cygwin.com/setup-x86.exe
	Echo "Successful download: setup.exe"
}

Echo "Intalling Cygwin..."
Start-Process -wait -FilePath "$TempCygDir\setup.exe" -ArgumentList "-q -n -l $TempCygDir -s ftp://ftp.ntua.gr/pub/pc/cygwin/ -R c:\Cygwin"
Echo "Done"
Echo "Installing gcc package (C compiler)..."
Start-Process -wait -FilePath "$TempCygDir\setup.exe" -ArgumentList "-q -n -l $TempCygDir -s ftp://ftp.ntua.gr/pub/pc/cygwin/ -R c:\Cygwin -P gcc-core"
Echo "Done"
Echo "Installing g++ package (C++ compiler)..."
Start-Process -wait -FilePath "$TempCygDir\setup.exe" -ArgumentList "-q -n -l $TempCygDir -s ftp://ftp.ntua.gr/pub/pc/cygwin/ -R c:\Cygwin -P gcc-g++"
Echo "Done"
Echo ""

Echo "Downloading NS3..."
Invoke-WebRequest -OutFile "$TempCygDir\ns3.tar.bz2" https://www.nsnam.org/release/ns-allinone-3.22.tar.bz2
Echo "Done. Unzipping files..."
$env:path = "$($env:path);c:\cygwin\bin"
C:\Cygwin\bin\tar.exe -xjf .\ns-allinone-3.22.tar.bz2
Echo ""
Echo "Done."