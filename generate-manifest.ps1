$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$extensions = @('.png', '.jpg', '.jpeg', '.webp', '.gif', '.svg', '.avif')
$paths = @(Get-ChildItem -LiteralPath $root -Recurse -File |
  Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' -and $extensions -contains $_.Extension.ToLowerInvariant() } |
  ForEach-Object { $_.FullName.Substring($root.Length + 1).Replace('\', '/') } |
  Sort-Object)
$json = ConvertTo-Json -InputObject $paths
[System.IO.File]::WriteAllText((Join-Path $root 'images.manifest.json'), $json, [System.Text.UTF8Encoding]::new($false))
Write-Output ("Generated {0} image paths for {1}" -f $paths.Count, (Split-Path $root -Leaf))