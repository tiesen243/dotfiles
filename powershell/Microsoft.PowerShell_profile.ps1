# Yuki Theme v1.0.0
#
# Copyright 2026, All rights reserved
#
# Code licensed under the MIT license
# http://github.com/tiesen243/dotfiles/blob/main/LICENSE

# Options {{{
# Set to false to disable the git status
$YUKI_DISPLAY_GIT = $true

# Set to true to show the date
$YUKI_DISPLAY_TIME = $false
$YUKI_TIME_FORMAT = "HH:mm"

# Set to true to show the 'context' segment
$YUKI_DISPLAY_CONTEXT = $true

# Set to true to use a new line for commands
$YUKI_DISPLAY_NEW_LINE = $false

# Set to 1 to show full path of current working directory
$YUKI_DISPLAY_FULL_CWD = $false

# Icons
$YUKI_ARROW_ICON = "󰖳"
$YUKI_EXECUTED_ICON = "λ "
# }}}

function prompt {
  $lastExitCode = $?
  $promptString = ""

  # Status segment {{{
  if ($lastExitCode) { $arrowColor = "White" }
  else { $arrowColor = "Red" }
  
  Write-Host "$YUKI_ARROW_ICON " -ForegroundColor $arrowColor -NoNewline
  # }}}

  # Time segment {{{
  if ($YUKI_DISPLAY_TIME) {
      $currentTime = Get-Date -Format $YUKI_TIME_FORMAT
      Write-Host "$currentTime " -ForegroundColor Cyan -NoNewline
  }
  # }}}

  # Context segment {{{
  if ($YUKI_DISPLAY_CONTEXT) {
      $currentUser = [Environment]::UserName
      $computerName = [Environment]::MachineName
      Write-Host "$currentUser@$($computerName.ToLower()) 󱦰 " -ForegroundColor White -NoNewline
  }
  # }}}

  # Directory segment {{{
  $currentPath = $ExecutionContext.SessionState.Path.CurrentLocation.Path
  if (!$YUKI_DISPLAY_FULL_CWD) {
    $currentPath = Split-Path $currentPath -Leaf
    if ($currentPath -eq "") { $currentPath = $ExecutionContext.SessionState.Path.CurrentLocation.Path }
  }
  Write-Host "$currentPath " -ForegroundColor Yellow -NoNewline
  # }}}

  # Async Git segment {{{
  if (Get-Command git -ErrorAction SilentlyContinue) {
    $gitBranch = git --no-optional-locks symbolic-ref --quiet HEAD 2>$null
    $gitBranch = $gitBranch -replace "refs/heads/", ""

    if ($gitBranch) {
      Write-Host "on " -ForegroundColor White -NoNewline

      $gitStatus = git status --porcelain 2>$null
      if ($null -ne $gitStatus) { Write-Host " $gitBranch " -ForegroundColor Yellow -NoNewline }
      else { Write-Host " $gitBranch " -ForegroundColor Green -NoNewline }
    }
  }
  # }}}
  
  if ($YUKI_DISPLAY_NEW_LINE) { return "`n$YUKI_EXECUTED_ICON" }
  return "$YUKI_EXECUTED_ICON"
}

. $PSScriptRoot/aliases.ps1
