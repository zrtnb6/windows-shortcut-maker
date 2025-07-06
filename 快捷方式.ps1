param(
    [Parameter(Mandatory=$true)]
    [string]$InputFile
)

$scriptDir = $PSScriptRoot
$OutputFolder = Join-Path $scriptDir "��ݷ�ʽ"

if (-not (Test-Path $InputFile)) {
    Write-Host "���������ļ������ڣ�" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder | Out-Null
    Write-Host "�Ѵ������Ŀ¼: $OutputFolder"
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
            $safeName = "��վ��ݷ�ʽ"
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
        Write-Host "�Ѵ���: $safeName.url ($url)"
    } else {
        Write-Host "��ʽ����: $_" -ForegroundColor Yellow
        $errorCount++
    }
}

Write-Host "`n������ɣ�"
Write-Host "�ɹ�����: $successCount ����ݷ�ʽ"
Write-Host "ʧ��: $errorCount ��"

if ($successCount -gt 0) {
    explorer $OutputFolder
}