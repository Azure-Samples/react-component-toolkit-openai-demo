# ensure tools are found
$npmCmd = Get-Command npm
pwd
# install.mjs
Start-Process -FilePath ($npmCmd).Source -ArgumentList "run ladle:dev" -Wait -NoNewWindow
