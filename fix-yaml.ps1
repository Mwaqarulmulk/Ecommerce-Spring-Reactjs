# Fix YAML syntax errors
$file = ".github\workflows\ci-cd.yml"
$content = Get-Content $file -Raw
$fixed = $content -replace "''", "'"
Set-Content $file -Value $fixed -NoNewline
Write-Host "✓ Fixed YAML syntax in $file" -ForegroundColor Green

# Commit and push
git add $file
git commit -m "Fix: Correct YAML syntax - replace double quotes with single quotes"
git push origin master
Write-Host "✓ Changes pushed to GitHub" -ForegroundColor Green
