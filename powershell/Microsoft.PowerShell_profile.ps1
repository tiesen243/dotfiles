# Yuki Theme v1.0.0 for PowerShell
# Inspired by tiesen243/dotfiles

$YUKI_ARROW_ICON = "󰖳"
$YUKI_DISPLAY_CONTEXT = $true
$YUKI_DISPLAY_FULL_CWD = $false # Set $true để hiện full path

function prompt {
    $lastExitCode = $?
    $promptString = ""

    # 1. Status segment (Màu đỏ nếu lệnh trước lỗi, mặc định trắng)
    if ($lastExitCode) {
        $arrowColor = "White"
    } else {
        $arrowColor = "Red"
    }
    Write-Host "$YUKI_ARROW_ICON " -ForegroundColor $arrowColor -NoNewline

    # 2. User context segment (user@host 󱦰)
    if ($YUKI_DISPLAY_CONTEXT) {
        $currentUser = [Environment]::UserName
        $computerName = [Environment]::MachineName
        Write-Host "$currentUser@$($computerName.ToLower()) 󱦰 " -ForegroundColor White -NoNewline
    }

    # 3. Directory segment
    $currentPath = $ExecutionContext.SessionState.Path.CurrentLocation.Path
    if (!$YUKI_DISPLAY_FULL_CWD) {
        $currentPath = Split-Path $currentPath -Leaf
        if ($currentPath -eq "") { $currentPath = $ExecutionContext.SessionState.Path.CurrentLocation.Path }
    }
    Write-Host "$currentPath " -ForegroundColor Yellow -NoNewline

    # 4. Git segment (Phỏng vấn logic dirty/clean từ Yuki Zsh)
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $gitBranch = git branch --show-current 2>$null
        if ($gitBranch) {
            Write-Host "on " -ForegroundColor White -NoNewline
            Write-Host " $gitBranch" -ForegroundColor Blue -NoNewline
            
            # Check dirty/clean
            $gitStatus = git status --porcelain 2>$null
            if ($null -ne $gitStatus) {
                Write-Host " ✗ " -ForegroundColor Yellow -NoNewline # Dirty
            } else {
                Write-Host " ✔ " -ForegroundColor Green -NoNewline # Clean
            }
        }
    }
    
    return "λ "
}
