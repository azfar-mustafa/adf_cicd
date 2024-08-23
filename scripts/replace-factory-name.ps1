# replace-factory-name.ps1
param(
    [string]$templateFile,
    [string]$parameterFile
)

# Read the ARM template
$template = Get-Content $templateFile -Raw | ConvertFrom-Json

# Replace the factory name with a parameter reference
$template.resources | ForEach-Object {
    if ($_.type -eq "Microsoft.DataFactory/factories") {
        $_.name = "[parameters('factoryName')]"
    }
}

# Save the modified template
$template | ConvertTo-Json -Depth 100 | Set-Content $templateFile

# Modify the parameter file to include factoryName
$params = Get-Content $parameterFile -Raw | ConvertFrom-Json
if (-not $params.parameters.factoryName) {
    $params.parameters | Add-Member -NotePropertyName "factoryName" -NotePropertyValue @{value = ""}
}
$params | ConvertTo-Json -Depth 100 | Set-Content $parameterFile