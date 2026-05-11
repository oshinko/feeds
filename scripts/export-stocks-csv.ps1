$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$jsonPath = Join-Path $repoRoot "data\stocks.json"
$csvPath = Join-Path $repoRoot "data\stocks.csv"

$data = Get-Content $jsonPath -Encoding UTF8 -Raw | ConvertFrom-Json
$columns = @("symbol", "market", "name", "segment", "memo")

function Convert-ToCsvField {
    param([AllowNull()][object] $Value)

    if ($null -eq $Value) {
        return ""
    }

    $text = [string]$Value
    if ($text.Contains('"')) {
        $text = $text.Replace('"', '""')
    }

    if ($text.Contains(',') -or $text.Contains('"') -or $text.Contains("`r") -or $text.Contains("`n")) {
        return '"' + $text + '"'
    }

    return $text
}

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add(($columns -join ","))

foreach ($stock in $data.items) {
    $fields = foreach ($column in $columns) {
        Convert-ToCsvField $stock.$column
    }
    $lines.Add(($fields -join ","))
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllLines($csvPath, $lines, $utf8NoBom)
