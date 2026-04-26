# General
function rmf { rm -Recurse -Force $args }
if (!(Test-Path alias:v)) { Set-Alias v nvim }
function q { exit }

# Bun
function bff { bun format:fix $args }
function bf { bun format $args }
function blf { bun lint:fix $args }
function bl { bun lint $args }
function ba { bun add $args }
function bi { bun install $args }
function bur { bun update --recursive --interactive $args }
function bu { bun update $args }
function br { bun remove $args }
function bx { bunx --bun $args }
function bb { bun run build $args }
function bs { bun start $args }
function bd { bun dev $args }
function b { bun $args }

# Git & GitHub CLI
function grc { gh repo create $args }
function grd { gh repo delete $args }
function gcl { gh repo clone $args }
function lzg { lazygit $args }
function g { git $args }

function gd { git diff --output-indicator-new=' ' --output-indicator-old=' ' $args }
function gl { git log --all --graph --decorate --pretty=format:'%C(magenta)%h %C(white) %an - %ar%C(auto) %D%n%s%n' $args }
function gs { git switch $args }
function gp { git push $args }
function gu { git pull $args }

function gst { git status $args }
function gap { git add --patch $args }
function gca { git commit -a $args }
function gaa { git add . }
function ga { git add $args }
