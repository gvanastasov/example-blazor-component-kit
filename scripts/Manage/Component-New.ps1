
. (Join-Path -Path $PSScriptRoot -ChildPath "..\Utils\Text-Formatter.ps1")

$ComponentType = @{
    # Single File Component
    SFC = "SFC"
    # Partial Class Split
    PCS = "PCS"
    # Base Class Split
    BCS = "BCS"
}

$defaultConfig = @{
    "componentsDirectory" = ""
    "singleDirectoryComponent" = $false
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

    $dist = Resolve-Path -Path $dist

    switch ($type) {
        "SFC" { New-SFC -componentName $name -dist $dist }
        "PCS" { New-PCS -componentName $name -dist $dist }
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

    $styleClassName = Convert-To-TrainCase -inputString $componentName
    
   ($template |
        ForEach-Object {
            $_ -replace '__ELEMENTTYPE__', 'div' `
            -replace '__STYLECLASSNAME__', $styleClassName `
            -replace '__INNERHTML__', "Hello from $componentName" `
            -replace '__CODE__', ''
        }) | Out-File -FilePath "$dist\$componentName.razor" -Force
}

function New-PCS {
    param (
        [string]$componentName
    )

    $template = Get-Template -name 'template-pcs.txt'

    $styleClassName = Convert-To-TrainCase -inputString $componentName

    ($template |
        ForEach-Object {
            $_ -replace '__ELEMENTTYPE__', 'div' `
            -replace '__STYLECLASSNAME__', $styleClassName `
            -replace '__INNERHTML__', "Hello from $componentName" `
        }) | Out-File -FilePath "$dist\$componentName.razor" -Force

    $code = Get-Template -name 'template-pcs.code.txt'

    $namespace = Get-NamespaceFromFolder -dist $dist

    ($code |
        ForEach-Object {
            $_ -replace '__CLASSNAME__', "$componentName" `
            -replace '__NAMESPACE__', $namespace
        }) | Out-File -FilePath "$dist\$componentName.razor.cs" -Force
}

function New-BCS {
    param (
        [string]$componentName
    )

    $template = Get-Template -name 'template-bcs.txt'

    $styleClassName = Convert-To-TrainCase -inputString $componentName
    $className = ("$componentName" + "Base")

    ($template |
        ForEach-Object {
            $_ -replace '__ELEMENTTYPE__', 'div' `
            -replace '__NAMESPACE__', $namespace `
            -replace '__CLASSNAME__', "$className" `
            -replace '__STYLECLASSNAME__', $styleClassName `
            -replace '__INNERHTML__', "Hello from $componentName" `
        }) | Out-File -FilePath "$dist\$componentName.razor" -Force

    $code = Get-Template -name 'template-bcs.code.txt'

    $namespace = Get-NamespaceFromFolder -dist $dist

    ($code |
        ForEach-Object {
            $_ -replace '__CLASSNAME__', "$className" `
            -replace '__NAMESPACE__', $namespace
        }) | Out-File -FilePath "$dist\$className.cs" -Force
}

function Get-Template {
    param (
        [string]$name
    )

    $templatePath = Join-Path -Path $PSScriptRoot -ChildPath ".\Templates\$name"
    $templateContent = Get-Content -Path $templatePath -Raw

    return $templateContent
}

function Get-NamespaceFromFolder {
    param (
        [Parameter(Mandatory=$true)][string]$dist
    )

    $namespace = @()

    $currentDir = Get-Item $dist

    while ($null -ne $currentDir) {
        $csprojFile = Get-ChildItem -Path $currentDir.FullName -Filter *.csproj -File
        $namespace = @($currentDir.Name) + $namespace

        if ($null -ne $csprojFile) {
            break
        }

        $currentDir = $currentDir.Parent
    }

    return $namespace -join '.'
}