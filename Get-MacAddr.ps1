function Get-MACAddress { 
    param ($strComputer) 
     
    $colItems = get-wmiobject -class "Win32_NetworkAdapterConfiguration" -computername $strComputer |Where{$_.IpEnabled -Match "True"}  
     
    foreach ($objItem in $colItems) {  
     
        $objItem |select Description,MACAddress  
     
    } 
} 
$username=read-host "what's your name?"
get-macaddress $env:computername|out-file $home\desktop\"$username.txt"

$file="$home\desktop\$username.txt"

#ftp server
$ftp="ftp://10.0.0.27/"
$user="username"
$pass="pwd"

$webclient = New-Object System.Net.WebClient 
 
$webclient.Credentials = New-Object System.Net.NetworkCredential($user,$pass)  
 
#upload MacAddr.txt file 

"Uploading $username.txt..." 
$uri = New-Object System.Uri($ftp+"macaddr/$username.txt") 
$webclient.UploadFile($uri,$file) 
 
