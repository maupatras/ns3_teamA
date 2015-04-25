param ( 
	$tempcygwindir="$env:temp\cygInstall",
	[string]$folder = $PSScriptRoot,
	$cygwinpath = "C:\Cygwin\"
)
Echo $tempcygwindir
If (!(Test-Path -Path $tempcygwindir -PathType Container))
{
   $null = New-Item -Type Directory -Path $tempcygwindir -Force
}

Write-Host "`nNS-3 installation script`n" -foreground "cyan"
$title = 'Installing NS-3 v3.22 in $folder and Cygwin in $cygwinpath'
$prompt = 'Proceed?'
$confirm = New-Object System.Management.Automation.Host.ChoiceDescription '&Yes','Installs Cygwin with these parameters'
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
Write-Host '`nIntalling Cygwin `& prerequisite packages...' -foreground "cyan"
Start-Process -wait -FilePath "$tempcygwindir\setup.exe" -ArgumentList "-q -n -l $tempcygwindir -s ftp://ftp.ntua.gr/pub/pc/cygwin/ -R $cygwinpath -P gcc-core,gcc-g++,make,gdb,libQtCore4-devel,libQtGui4-devel -C Python"
$env:path = "$($env:path);$cygwinpath\bin"
Write-Host "Done" -foreground "green"

# Download NS-3
Write-Host "`nDownloading NS-3 v3.22..." -foreground "cyan"
Invoke-WebRequest -OutFile "$tempcygwindir\ns3.tar.bz2" https://www.nsnam.org/release/ns-allinone-3.22.tar.bz2

Write-Host "Done. Unzipping files..." -foreground "green"
tar.exe -xjf $tempcygwindir\ns3.tar.bz2 -C $folder
Write-Host "`nDone" -foreground "green"

# Install NS-3
Write-Host "Building NS-3..." -foreground "cyan"
cd $folder\ns-allinone-3.22\

New-Alias -Name python -Value "$cygwinpath\bin\python2.7.exe"
python ./build.py --enable-examples --enable-tests
Write-Host "`nBuilding complete" -foreground "green"

#Install NetAnim
If (!$nonam) {
	Write-Host "Building NetAnim" -foreground "cyan"
	cd $folder\ns-allinone-3.22\netanim-3.105
	make clean
	& $cygwinpath\lib\qt4\bin\qmake.exe NetAnim.pro
	make
	Write-Host "`nBuilding complete" -foreground "green"
}

# Remove temp files
Write-Host "All installations complete. Deleting temp download folder..." -foreground "cyan"
rmdir $tempcygwindir -recurse
Write-Host "Temporary folder $tempcygwindir successfully deleted" -foreground "green"