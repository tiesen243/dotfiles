jc() {
  rm -rf bin
  javac -d bin src/**/*.java
  if [ $? -eq 0 ]; then
    java -cp bin $1
  fi
}

vf() {
  local file
  file=$(fzf \
    --preview 'bat --style=numbers --color=always --line-range :500 {}' \
    --preview-window=right:60% \
    --border \
    --height=80%)
  if [ -n "$file" ]; then
    nvim "$file"
  fi
}

vh() {
  local file
  file=$(find $HOME -type f \
    -not -path '*/\.*' -o -path '*/.config/*' |
    fzf \
      --preview 'bat --style=numbers --color=always --line-range :500 {}' \
      --preview-window=right:60% \
      --border \
      --height=80%)
  if [ -n "$file" ]; then
    nvim "$file"
  fi
}
