# imports
. (Join-Path -Path $PSScriptRoot -ChildPath "..\Utils\New-Menu.ps1")
. (Join-Path -Path $PSScriptRoot -ChildPath "..\Utils\Text-Formatter.ps1")
. (Join-Path -Path $PSScriptRoot -ChildPath ".\Component-New.ps1")

$MainMenuTitle = Format-PoundBox -Text "Component Manager"
$MainMenuOptions = @("Create Component", "Remove Component", "Exit")

$CreateMenuTitle = Format-PoundBox -Text "Create Component"
$CreateMenuOptions = @("Single-File Component (SFC)", "Partial-File Split (PFS)", "Base-Class Split (BCS)", "Help", "Return")

function MainMenu {
    $MenuResult = New-Menu -MenuTitle $MainMenuTitle -MenuOptions $MainMenuOptions
    switch ($MenuResult) {
        0 { 
            $CreateMenuResult = New-Menu -MenuTitle $CreateMenuTitle -MenuOptions $CreateMenuOptions

            switch ($CreateMenuResult) {
                0 {
                    $componentName = Read-Host "Enter component name"
                    New-Component -type $ComponentType.SFC -name $componentName
                }
                1 {
                    $componentName = Read-Host "Enter component name"
                    New-Component -type $ComponentType.PFS -name $componentName
                }
                2 {
                    $componentName = Read-Host "Enter component name"
                    New-Component -type $ComponentType.BCS -name $componentName
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
            exit
        }
        Default {}
    }
}

MainMenu

