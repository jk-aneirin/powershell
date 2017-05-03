 if ( -not (test-path "C:\Program Files (x86)\Google\Chrome\Application"))
{
	new-item -path "C:\Program Files (x86)\Google\Chrome\Application" -type directory
}

 #FTP Server Information - SET VARIABLES
$ftp = "ftp://10.0.0.27" 
$user = 'username' 
$pass = 'password'
$folder = 'winscp'
$target = "$home\desktop\"

#SET CREDENTIALS
$credentials = new-object System.Net.NetworkCredential($user, $pass)

function Get-FtpDir ($url,$credentials) {
    $request = [Net.WebRequest]::Create($url)
    $request.Method = [System.Net.WebRequestMethods+FTP]::ListDirectory
    if ($credentials) { $request.Credentials = $credentials }
    $response = $request.GetResponse()
    $reader = New-Object IO.StreamReader $response.GetResponseStream() 
    while(-not $reader.EndOfStream) {
        $reader.ReadLine()
    }
        #$reader.ReadToEnd()
    $reader.Close()
    $response.Close()
}

    #SET FOLDER PATH
$folderPath= $ftp + "/" + $folder + "/"

$files = Get-FTPDir -url $folderPath -credentials $credentials

$webclient = New-Object System.Net.WebClient 
$webclient.Credentials = New-Object System.Net.NetworkCredential($user,$pass) 
$counter = 0
foreach ($file in ($files | where {$_ -like "*.*"})){
    $source=$folderPath + $file  
    $destination = $target + $file 
    $webclient.DownloadFile($source, $target+$file)

        #PRINT FILE NAME AND COUNTER
    $counter++
}
	
	# Load WinSCP .NET assembly
Add-Type -Path "WinSCPnet.dll"

# Setup session options
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Ftp
    HostName = "10.0.0.27"
    UserName = "username"
    Password = "pwd"
}

$session = New-Object WinSCP.Session

try
{
    # Connect
    $session.Open($sessionOptions)

    # Download files
    $session.GetFiles("/application/*", "C:\Program Files (x86)\Google\Chrome\Application\*").Check()
}
finally
{
    # Disconnect, clean up
    $session.Dispose()
} 


$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\Chrome.lnk")
$Shortcut.TargetPath = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
$Shortcut.Save()

