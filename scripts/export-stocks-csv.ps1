$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$jsonPath = Join-Path $repoRoot "data\stocks.json"
$csvPath = Join-Path $repoRoot "data\stocks.csv"

$data = Get-Content $jsonPath -Encoding UTF8 -Raw | ConvertFrom-Json
$columns = @("symbol", "market", "name", "tier", "tags", "note")

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

function Get-StockFieldValue {
    param(
        [object] $Stock,
        [string] $Column
    )

    if ($Column -eq "tags") {
        if ($null -eq $Stock.tags) {
            return ""
        }

        return (($Stock.tags | ForEach-Object { [string]$_ }) -join ",")
    }

    return $Stock.$Column
}

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add(($columns -join ","))

foreach ($stock in ($data.items | Sort-Object market, tier, symbol)) {
    $fields = foreach ($column in $columns) {
        Convert-ToCsvField (Get-StockFieldValue $stock $column)
    }
    $lines.Add(($fields -join ","))
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllLines($csvPath, $lines, $utf8NoBom)
