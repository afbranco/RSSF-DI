 #!/bin/bash
 
 export APP_HOME="/home/rssf/rssf_DI"
 APP_NAME="receiveData.lua"
 
 cd $APP_HOME
 
 check_running() {
  pids=$(ps h -e -o pid)
  for pid in $pids; do
    tmp=$(ps h -o cmd -p $pid | grep "$APP_NAME")
    if [ -n "$tmp" ]; then
      echo "[ERRO] App executando (pid = $pid)"
      exit 1
    fi
  done
}

do_stop() {
  pids=$(ps h -e -o pid)
  for pid in $pids; do
    tmp=$(ps h -o cmd -p $pid | grep "$APP_NAME")
    if [ -n "$tmp" ]; then
      echo "[INFO] App executando (pid = $pid)"
      sid=$(ps h -p $pid -o sess)
      spids=$(ps h -s $sid -o pid)
      for spid in $spids; do
        echo "[INFO] Parando App(pid = $spid)"
        kill -9 $spid
      done
    fi
  done
}

do_start() {
  lua receiveData.lua &
}

################################################################################

case $1 in
stop)
  do_stop
;;
start)
  check_running
  do_start
;;
restart)
  do_stop
  sleep 3
  do_start
;;
*)
  echo "Usage: rssfDI.sh {start | stop | restart}"
  exit 1
;;
esac

exit 0

