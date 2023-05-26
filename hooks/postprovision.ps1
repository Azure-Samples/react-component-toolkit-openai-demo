# ensure tools are found
$nodeCmd = Get-Command node
$npmCmd = Get-Command npm
$gitCmd = Get-Command git

# git clone and checkouot
Start-Process -FilePath ($gitCmd).Source -ArgumentList "clone https://github.com/microsoft/react-component-toolkit.git" -Wait -NoNewWindow
Set-Location ./react-component-toolkit

# install.mjs
Start-Process -FilePath ($nodeCmd).Source -ArgumentList "install.mjs" -Wait -NoNewWindow
Start-Process -FilePath ($npmCmd).Source -ArgumentList "install" -Wait -NoNewWindow

# ladle:dev - as background job - 
Write-Host "Lauching ladle. Please navigate to http://localhost:61000/ to view the ladle dashboard for Windows..." 
$ladle = Start-Job -FilePath ../hooks/ladle-dev.ps1

$continue = $true  
  
while ($continue) {  
    $description = Read-Host "Enter a description for the new React component"  
    
    # createnew.mjs
    Start-Process -FilePath ($nodeCmd).Source -ArgumentList "createnew.mjs `"$($description)`"" -Wait -NoNewWindow
    Start-Process -FilePath ($npmCmd).Source -ArgumentList "install" -Wait -NoNewWindow
    
    $test = Read-Host "Would you like to test the component? (y/N)"
    if ($test -eq "y") 
    {  
        Start-Process -FilePath ($npmCmd).Source -ArgumentList "run test:update" -Wait -NoNewWindow
    }  
  
    $package = Read-Host "Would you like to package the component as an Azure API Management developer portal widget and test it? (y/N)"  
    if ($package -eq "y") 
    {  
        $components = Get-ChildItem "./src/components" -Directory | Where-Object { $_.Name -notin @("bingmaps", "common", "footer", "graphikle", "markdownviewer", "index.ts", "signin", "styledtext") }  
        if ($components.Count -eq 0) 
        {  
            Write-Host "No components found."  
        } 
        else 
        {  
            Write-Host "Components: $($components.Name -join ', ')"  
            $componentName = Read-Host "Enter the name of the component to publish to Azure API Management"  

            if ($components.Name -contains $componentName) {  
                if (Test-Path "./src/components/$componentName") {
                    # packagewidget.mjs
                    Start-Process -FilePath ($nodeCmd).Source -ArgumentList "packagewidget.mjs $($componentName)" -Wait -NoNewWindow
                } else {  
                    Write-Host "Component directory does not exist."  
                    Continue  
                }  
            } else {  
                Write-Host "Invalid component name."  
                Continue  
            }  
            
        }  
    }  
  
    $continue = Read-Host "Do you want to create another component? (y/N)"  
    if ($continue -ne "y") {  
        $continue = $false
    }
}  
# stop all backgroung jobs
Get-Job | Stop-Job

