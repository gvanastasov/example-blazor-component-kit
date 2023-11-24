# Component-Manager.ps1
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition

# imports
. (Join-Path -Path $scriptDirectory -ChildPath "..\Utils\New-Menu.ps1")

$MainMenuTitle = "Component Manager"
$MainMenuOptions = @("Create Component", "Remove Component", "Exit")

$MenuResult = New-Menu -MenuTitle $MainMenuTitle -MenuOptions $MainMenuOptions

switch ($MenuResult) {
    0 { 
        Write-Host "create component..."
        New-Menu -MenuTitle "Type" -MenuOptions @("")
    }
    1 {
        Write-Host "delete component..."
    }
    2 {
        Write-Host "exit..."
    }
    Default {}
}