<#
.SYNOPSIS
Create list of on and off hosts in network
.DESCRIPTION
Script get hostnames from AD, wthen do parallel ping. For 300 hosts all operation takes about 2-3 minutes
It`s work with creating txt-files for each computers, because parallel cycles in PowerShell can not work with global variables, and not parallel cycles is so slow....
After work files deletes and all information stay in variables
#>

workflow Test-WFConnection {
 param(

    [string[]]$Computers
  )
foreach -parallel ($comp in $computers) {
#fast ping host in parallel script and create file in folders
IF (Test-Connection -ComputerName $comp -Quiet -Count 1 -ErrorAction SilentlyContinue)
{New-Item -itemtype file -path C:\on\on\ -name $comp -Force}else {New-Item -itemtype file -path C:\on\off\ -name $comp -Force}
} 
}

#Get all computers by AD
$AllComp = Get-ADComputer -Filter * | sort name  | select -ExpandProperty name

#Call workflow with measure
Measure-Command -Expression { Test-WFConnection -computers $AllComp}
#Collect on and off computers
$ON=Get-ChildItem -Path C:\on\on | select -ExpandProperty name
$OFF=Get-ChildItem -Path C:\on\off | select -ExpandProperty name
#Remove folder
Remove-Item -Path C:\on\ -Recurse -force