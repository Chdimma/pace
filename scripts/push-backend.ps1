$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

Write-Host 'Pushing main branch to origin...'
git push origin main

Write-Host 'Creating server-only subtree branch...'
git branch -D server-only 2>$null

git subtree split --prefix=server -b server-only

Write-Host 'Pushing server subtree to pace_backend main...'
git push -u pace_backend server-only:main

Write-Host 'Done.'
