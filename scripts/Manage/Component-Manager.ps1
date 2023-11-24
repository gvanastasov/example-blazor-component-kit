# Component-Manager.ps1
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition

# imports
. (Join-Path -Path $scriptDirectory -ChildPath "..\Utils\New-Menu.ps1")

$MainMenuTitle = "Component Manager"
$MainMenuOptions = @("Create Component", "Remove Component", "Exit")

$CreateMenuTitle = "Create Component"
$CreateMenuOptions = @("Single-File Component (SFC)", "Partial-File Split (PFS)", "Base-Class Split (BCS)", "Help", "Return")

function MainMenu {
    $MenuResult = New-Menu -MenuTitle $MainMenuTitle -MenuOptions $MainMenuOptions
    switch ($MenuResult) {
        0 { 
            Write-Host "create component..."
            $CreateMenuResult = New-Menu -MenuTitle $CreateMenuTitle -MenuOptions $CreateMenuOptions

            switch ($CreateMenuResult) {
                0 {
                    Write-Host "SFC..."
                }
                1 {
                    Write-Host "PFS..."
                }
                2 {
                    Write-Host "BCS..."
                }
                3 {
                    Write-Host "Help..."
                }
                4 {
                    MainMenu
                }
            }
        }
        1 {
            Write-Host "delete component..."
        }
        2 {
            Write-Host "exit..."
        }
        Default {}
    }
}

MainMenu

