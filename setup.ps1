param ( 
	[string]$tempcygwindir="$env:temp\cygInstall",
	[string]$folder = $PSScriptRoot,
	[string]$cygwinpath = "C:\Cygwin\",
	[string]$version = "3.22",
	[switch]$nonam
)

If (!$version.CompareTo("3.22") -or !$version.CompareTo("3.21") -or !$version.CompareTo("3.20")) {
	$netanimversion = 3.105
} ElseIf (!$version.CompareTo("3.19")) {
	$netanimversion = 3.104
} ElseIf (!$version.CompareTo("3.18") -or !$version.CompareTo("3.17") -or !$version.CompareTo("3.16")) {
	$netanimversion = 3.103
} ElseIf (!$version.CompareTo("3.15")) {
	$netanimversion = 3.101
} Else {
	Write-Host "Unsupported version selected. Please select version 3.18 to 3.22" -foreground "red"
	Exit
}


If (!(Test-Path -Path $tempcygwindir -PathType Container))
{
   $null = New-Item -Type Directory -Path $tempcygwindir -Force
}

Write-Host "`nNS-3 installation script`n" -foreground "cyan"
$title = "Installing NS-3 v$version in $folder and Cygwin in $cygwinpath"
$prompt = 'Proceed?'
$confirm = New-Object System.Management.Automation.Host.ChoiceDescription '&Yes','Installs with these parameters'
$abort = New-Object System.Management.Automation.Host.ChoiceDescription '&No','Aborts the operation'
$options = [System.Management.Automation.Host.ChoiceDescription[]] ($confirm, $abort)
$choice = $host.ui.PromptForChoice($title,$prompt,$options,0)

If ($choice) {
	Write-Host "Aborted" -foreground "red"
	Exit
}

# Check if 32 or 64-bit OS, download appropriate Cygwin
Write-Host "Downloading Cygwin..." -foreground "cyan"
$os=Get-WMIObject win32_operatingsystem
If ($os.OSArchitecture -Match "64-bit") {
	Invoke-WebRequest -OutFile "$tempcygwindir\setup.exe" https://www.cygwin.com/setup-x86_64.exe
} Else {
	Invoke-WebRequest -OutFile "$tempcygwindir\setup.exe" https://www.cygwin.com/setup-x86.exe
}
Write-Host "Download complete" -foreground "green"

# Install Cygwin and packages
Write-Host "`nIntalling Cygwin `& prerequisite packages..." -foreground "cyan"
Start-Process -wait -FilePath "$tempcygwindir\setup.exe" -ArgumentList "-q -n -l $tempcygwindir -s ftp://ftp.ntua.gr/pub/pc/cygwin/ -R $cygwinpath -P gcc-core,gcc-g++,make,gdb,libQtCore4-devel,libQtGui4-devel -C Python"
$env:path = "$($env:path);$cygwinpath\bin"
Write-Host "Done" -foreground "green"

# Download NS-3
Write-Host "`nDownloading NS-3 v$version..." -foreground "cyan"
Invoke-WebRequest -OutFile "$tempcygwindir\ns3.tar.bz2" https://www.nsnam.org/release/ns-allinone-$version.tar.bz2

Write-Host "Download complete. Unzipping files to $folder..." -foreground "green"
If (!(Test-Path -Path $folder -PathType Container))
{
   $null = New-Item -Type Directory -Path $folder -Force
}
If ($folder.EndsWith("\")) {
	$s = $folder + "."
	tar.exe -xjf $tempcygwindir\ns3.tar.bz2 -C $s --force-local
} ElseIf (!$folder.EndsWith("\.")) {
	$s = $folder + "\."
	tar.exe -xjf $tempcygwindir\ns3.tar.bz2 -C $s --force-local
} Else {
	tar.exe -xjf $tempcygwindir\ns3.tar.bz2 -C $folder --force-local
}
Write-Host "Done" -foreground "green"

# Install NS-3
Write-Host "`nBuilding NS-3..." -foreground "cyan"
cd $folder\ns-allinone-$version\

New-Alias -Name python -Value "$cygwinpath\bin\python2.7.exe"
python ./build.py --enable-examples --enable-tests
Write-Host "Building complete" -foreground "green"

#Install NetAnim
If (!$nonam) {
	Write-Host "`nBuilding NetAnim" -foreground "cyan"
	cd $folder\ns-allinone-$version\netanim-$netanimversion
	make clean
	& $cygwinpath\lib\qt4\bin\qmake.exe NetAnim.pro
	make
	Write-Host "Building complete" -foreground "green"
}

# Remove temp files
Write-Host "`nAll installations complete. Deleting temporary download folder..." -foreground "cyan"
rmdir $tempcygwindir -recurse
Write-Host "Temporary folder $tempcygwindir successfully deleted" -foreground "green"

cd $PSScriptRoot
Write-Host "`nReady!" -foreground "cyan"