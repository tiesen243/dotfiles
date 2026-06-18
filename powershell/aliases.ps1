# ------------       General        ------------
function q { exit }
function v { nvim $args }

# ------------    Scoop (Pacman/Yay)   ------------
function pu { scoop update * }
function ps_search { scoop search $args }
Set-Alias -Name pss -Value ps_search
function pi { scoop install $args }
function pr { scoop uninstall $args }
function pc { scoop cleanup * }
function pq { scoop info $args }
function pl { scoop list }

# ------------          LS            ------------
function ll { Get-ChildItem -Force | Format-Table }
function la { Get-ChildItem -Force }
function lla { Get-ChildItem -Force }

# ------------        Git            ------------
if (Get-Command git -ErrorAction SilentlyContinue) {
    function g { git $args }
    
    function gs { git status -sb $args }
    function gl { git log --oneline --graph --decorate $args }
    function gd { git diff $args }
    
    function ga { git add $args }
    function gaa { git add --all $args }
    function gco { git commit -m $args }
    function gca { git commit --amend $args }

    function gp { git push $args }
    function gu { git pull $args }
    function gf { git fetch $args }
    
    function gsw { git switch $args }
    function gsc { git switch -c $args }
    function gsm { git switch main $args }
    function gsd { git switch dev $args }
    function gswb { git switch - $args }
    
    function grs { git restore $args }
    function grsh { git restore --hard $args }
    function grss { git restore --staged $args }
    
    function gst { git stash $args }
    function gstp { git stash pop $args }
    
    if (Get-Command gh -ErrorAction SilentlyContinue) {
        function gr { gh repo $args }
        function grc { gh repo create $args }
        function grd { gh repo delete $args }
        function grf { gh repo fork $args }
        function grl { gh repo clone $args }
        function grv { gh repo view $args }
        function grr { gh repo rename $args }
    } else {
        function grl { git clone $args }
    }

    function gcz {
        if (-not (Get-Command fzf -ErrorAction SilentlyContinue)) {
            Write-Error "fzf is required for gcm function. Install via: scoop install fzf"
            return 1
        }

        $types = @("feat", "chore", "style", "fix", "docs", "refactor", "test", "ci", "build", "perf", "revert")
        $type = $types | fzf --height=40% --layout=reverse --prompt="Select commit type: "
        if (-not $type) { return 1 }

        $scope = Read-Host "Enter scope (optional, e.g., auth, api)"
        $scope = $scope.Trim()

        $message = Read-Host "Enter commit message"
        if (-not $message) {
            Write-Host "❌ Error: Commit message is required." -ForegroundColor Red
            return 1
        }

        if ($scope) {
            $final_msg = "${type}(${scope}): ${message}"
        } else {
            $final_msg = "${type}: ${message}"
        }

        git commit -m $final_msg
    }
}

if (Get-Command lazygit -ErrorAction SilentlyContinue) {
    function lg { lazygit $args }
}

# ------------          Bun            ------------
if (Get-Command bun -ErrorAction SilentlyContinue) {
    function bi { bun install $args }
    function ba { bun add $args }
    function bad { bun add -d $args }
    function bap { bun add -p $args }
    function bR { bun remove $args }
    function bu_pkg { bun update $args }
    function bU { bun update --interactive --recursive $args }

    function bx { bunx --bun $args }
    function bd { bun --bun run dev $args }
    function bb { bun --bun run build $args }
    function br { bun run $args }

    function b { bun $args }
    function bt { bun test $args }
}
