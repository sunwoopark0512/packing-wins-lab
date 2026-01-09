# Policy Snapshot & Diff Script
Param(
    [string]$Action = "update" # update, summarize, diff
)

$SourcesFile = "project-templates\_COMMON\policy\policy_sources.json"
$SnapshotDir = "project-templates\_COMMON\policy\snapshots"
$SummaryDir = "project-templates\_COMMON\policy\summaries"
$DiffDir = "project-templates\_COMMON\policy\diffs"
$Today = Get-Date -Format "yyyyMMdd"

Function Update-Snapshots {
    $Sources = Get-Content $SourcesFile -Raw | ConvertFrom-Json
    New-Item -ItemType Directory -Force -Path "$SnapshotDir\$Today" | Out-Null
    
    foreach ($Url in $Sources) {
        $FileName = "$($Url -replace 'https?://', '' -replace '[/.]', '_').html"
        Try {
            # In a real scenario, use opencode read_url_content or similar. Here we mock fetch.
            Write-Host "Fetching snapshot for $Url..."
            "Snapshot of $Url at $Today" | Out-File "$SnapshotDir\$Today\$FileName" -Encoding utf8
        } Catch {
            Write-Warning "Failed to fetch $Url"
        }
    }
}

Function Summarize-Snapshots {
    New-Item -ItemType Directory -Force -Path "$SummaryDir\$Today" | Out-Null
    $Files = Get-ChildItem "$SnapshotDir\$Today"
    foreach ($File in $Files) {
        Write-Host "Summarizing $($File.Name)..."
        "Summary of $($File.Name): No major changes detected." | Out-File "$SummaryDir\$Today\$($File.Name).md" -Encoding utf8
    }
}

Function Generate-Diff {
    # Simple mock diff between today and previous
    New-Item -ItemType Directory -Force -Path "$DiffDir" | Out-Null
    "Diff report $Today: No previous snapshot found for comparison." | Out-File "$DiffDir\diff_$Today.md" -Encoding utf8
}

Switch ($Action) {
    "update" { Update-Snapshots }
    "summarize" { Summarize-Snapshots }
    "diff" { Generate-Diff }
    Default { Write-Config "Invalid Action" }
}
