jc() {
  rm -rf bin
  javac -d bin src/**/*.java
  if [ $? -eq 0 ]; then
    java -cp bin $1
  fi
}

kill-port() {
  local port=$1
  if [ -z "$port" ]; then
    echo "Usage: kill-port <port>"
    return 1
  fi

  local pid=$(ss -tulpn | grep ":3000" | awk '{print $8}' | cut -d',' -f2 | cut -d'=' -f2)

  if [ -n "$pid" ]; then
    kill -9 $pid
    echo "Killed process on port $port"
  else
    echo "No process found on port $port"
  fi
}
