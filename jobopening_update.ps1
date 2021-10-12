# the goal of this script is to rename the current file in current directory and upload it to vanderbend domain via FTP
# Job Openings Summary as of 10.08.21 rename it to match
Rename-Item -p . -NewName "Job Openings Summary as of 10.08.21"

# Start-Process -FilePath "C:\Windows\system32\net.exe start filezilla-server"

# mkdir
# create the FtpWebRequest and configure it
$ftp = [System.Net.FtpWebRequest]::Create("ftp://localhost/me.png")
$ftp = [System.Net.FtpWebRequest]$ftp
$ftp.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
$ftp.Credentials = new-object System.Net.NetworkCredential("anonymous","anonymouspassword","anonymous@localhost")
$ftp.UseBinary = $true
$ftp.UsePassive = $true
# read in the file to upload as a byte array
$content = [System.IO.File]::ReadAllBytes("C:\me.png")
$ftp.ContentLength = $content.Length
# get the request stream, and write the bytes into it
$rs = $ftp.GetRequestStream()
$rs.Write($content, 0, $content.Length)
# be sure to clean up after ourselves
$rs.Close()
$rs.Dispose()