# $1: port number
who_uses_port() {
  local TMP_FILE="/tmp/$0"
  ss -lptn "sport = :$1" | tee $TMP_FILE
  local PID=$(cat $TMP_FILE | sed -n -e 's/^.*pid=\([0-9]\+\).*$/\1/p' | uniq | tr '\n' ' ' | sed 's/ *$//g')

  test -z $PID && return
  echo "Do you want to kill the following process(es): $PID ? (y|n)"
  read RESPONSE
  if [[ $RESPONSE == 'y' ]]; then
    for p in $PID; do
      kill -9 $p
      done
  fi
}
