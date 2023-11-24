
. (Join-Path -Path $PSScriptRoot -ChildPath "..\Utils\Text-Formatter.ps1")

$ComponentType = @{
    SFC = "SFC"
    PFS = "PFS"
    BCS = "BCS"
}

$defaultConfig = @{
    "componentsDirectory" = ""
    "singleDirectoryComponent" = false
}

$configPath = Join-Path -Path $PWD -ChildPath ".\cm.config.json"

if (Test-Path -Path $configPath) {
    $configContent = Get-Content -Path $configPath | Out-String | ConvertFrom-Json
} else {
    $configContent = $defaultConfig
}

function New-Component {
    param (
        [string]$type = $ComponentType.SFC,
        [Parameter(Mandatory=$True)][string]$name
    )

    $invocationDirectory = $PWD
    
    # todo: lets add config if subfolder should be used
    $dist = $invocationDirectory

    if ($configContent.componentsDirectory) {
        $dist = Join-Path -Path $dist -ChildPath $configContent.componentsDirectory
    }

    if ($configContent.singleDirectoryComponent) {
        $dist = Join-Path -Path $dist -ChildPath $name
    }

    if (-not (Test-Path -Path $dist -PathType Container)) {
        New-Item -Path $dist -ItemType Directory | Out-Null
    }

    switch ($type) {
        "SFC" { New-SFC -componentName $name -dist $dist }
        "PFS" { New-PFS -componentName $name -dist $dist }
        "BCS" { New-BCS -componentName $name -dist $dist }
        default { Write-Host "Unknown component type: $type" }
    }
}

function New-SFC {
    param (
        [string]$componentName,
        [string]$dist
    )
    
    $template = Get-Template -name 'template-sfc.txt'

    $className = Convert-To-TrainCase -inputString $componentName
    
   ($template |
        ForEach-Object {
            $_ -replace '__ELEMENTTYPE__', 'div' `
            -replace '__CLASSNAME__', $className `
            -replace '__INNERHTML__', "Hello from $componentName" `
            -replace '__CODE__', ''
        }) | Out-File -FilePath "$dist\$componentName.razor" -Force
}

function New-PFS {
    param (
        [string]$componentName
    )
}

function New-BCS {
    param (
        [string]$componentName
    )
}

function Get-Template {
    param (
        [string]$name
    )

    $templatePath = Join-Path -Path $PSScriptRoot -ChildPath ".\Templates\$name"
    $templateContent = Get-Content -Path $templatePath -Raw

    return $templateContent
}