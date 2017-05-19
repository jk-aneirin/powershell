function Get-MACAddress { 
 
     
    $colItems = get-wmiobject -class "Win32_NetworkAdapterConfiguration" -computername $env:computername |Where{$_.IpEnabled -Match "True"}  
     
    foreach ($objItem in $colItems) {  
     
        $objItem |select Description,MACAddress  
     
    } 
} 

function Get-MonitorSn {
    $Monitor = gwmi wmimonitorid -namespace root\wmi -ComputerName $env:computername

    $Monitor | %{
    $psObject = New-Object PSObject
    $psObject | Add-Member NoteProperty SerialNumber ""
    $psObject | Add-Member NoteProperty Name ""
    $psObject | Add-Member NoteProperty WorkstationName ""
    $psObject.SerialNumber = ($_.SerialNumberID -ne 0 | %{[char]$_}) -join ""
    $psObject.Name = ($_.UserFriendlyName -ne 0 | %{[char]$_}) -join ""
    $psObject.WorkstationName = $_.PSComputerName
    $psObject
    }
}

function Get-HostSrvTag {
    wmic csproduct get vendor,name,identifyingnumber
}


$username=read-host "what's your name?"

Get-HostSrvTag | Out-File $home\desktop\"$username.txt"
Get-MACAddress | Out-File $home\desktop\"$username.txt" -NoClobber -Append
Get-MonitorSn  | Out-File $home\desktop\"$username.txt" -NoClobber -Append

#this file will be upload to ftp server
$file="$home\desktop\$username.txt"

#ftp server info
$ftp="ftp://ftpserver-ip"
$user="ftpuser"
$pass="password"

$webclient = New-Object System.Net.WebClient 
 
$webclient.Credentials = New-Object System.Net.NetworkCredential($user,$pass)  
 
#upload $username.txt file 
"Uploading $username.txt..." 
$uri = New-Object System.Uri($ftp+"$username.txt") 
$webclient.UploadFile($uri,$file) 


