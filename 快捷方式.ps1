param(
    [Parameter(Mandatory=$true)]
    [string]$InputFile
)

$scriptDir = $PSScriptRoot
$OutputFolder = Join-Path $scriptDir "快捷方式"

if (-not (Test-Path $InputFile)) {
    Write-Host "错误：输入文件不存在！" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder | Out-Null
    Write-Host "已创建输出目录: $OutputFolder"
}

$successCount = 0
$errorCount = 0
$invalidChars = [System.IO.Path]::GetInvalidFileNameChars()

Get-Content $InputFile | ForEach-Object {
    if ([string]::IsNullOrWhiteSpace($_)) { return }

    if ($_ -match '^(.*?)\s+(https?://\S+)$') {
        $name = $matches[1].Trim()
        $url = $matches[2].Trim()
        
        $safeName = $name
        foreach ($char in $invalidChars) {
            $safeName = $safeName.Replace($char, '_')
        }
        
        if ([string]::IsNullOrWhiteSpace($safeName)) {
            $safeName = "网站快捷方式"
        }
        
        $filePath = Join-Path $OutputFolder "$safeName.url"
        @"
[InternetShortcut]
URL=$url
IDList=
HotKey=0
IconIndex=0
"@ | Out-File -FilePath $filePath -Encoding ASCII
        
        $successCount++
        Write-Host "已创建: $safeName.url ($url)"
    } else {
        Write-Host "格式错误: $_" -ForegroundColor Yellow
        $errorCount++
    }
}

Write-Host "`n操作完成！"
Write-Host "成功创建: $successCount 个快捷方式"
Write-Host "失败: $errorCount 个"

if ($successCount -gt 0) {
    explorer $OutputFolder
}