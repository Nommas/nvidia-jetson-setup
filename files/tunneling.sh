#!/bin/sh

DST_PORT=2230 # change this if needed
SRC_PORT=8888 # jupyter
DST_PORT2=$(($DST_PORT+1))
SRC_PORT2=6006 # tensorboard
DST_PORT3=$(($DST_PORT+2))
SRC_PORT3=22 # ssh



## Kill other instances of this script and ssh
pgrep  -f "autossh -i $PEM_FILE" | xargs kill -9
pgrep  -f "ssh -i $PEM_FILE" | xargs kill -9
pgrep  -x -f "sh $0" | head -n -1 | xargs kill -9 # kill all but last instan$

echo ""
echo '
   _  __                        
  / |/ /__  __ _  __ _  ___ ____
 /    / _ \/  \'' \/  \'' \/ _ `(_-<
/_/|_/\___/_/_/_/_/_/_/\_,_/___/
'
echo "======================================================================"
echo "= to access port $SRC_PORT visit http://$AWS_PUBLIC_IP:$DST_PORT    ="
echo "= to access port $SRC_PORT2 visit http://$AWS_PUBLIC_IP:$DST_PORT2   ="
echo "= to access port $SRC_PORT3 visit http://$AWS_PUBLIC_IP:$DST_PORT3   ="
echo "======================================================================"
echo ""

autossh -N -p 443 -i $PEM_FILE -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" \
  -R ubuntu@$AWS_PUBLIC_IP:$DST_PORT:localhost:$SRC_PORT \
  -R ubuntu@$AWS_PUBLIC_IP:$DST_PORT2:localhost:$SRC_PORT2 \
  -R ubuntu@$AWS_PUBLIC_IP:$DST_PORT3:localhost:$SRC_PORT3 \
  ubuntu@$AWS_PUBLIC_IP

while sleep 1; \
 do \
  ssh -N -p 443 -o StrictHostKeyChecking=No -i $PEM_FILE \
  -R ubuntu@$AWS_PUBLIC_IP:$DST_PORT:localhost:$SRC_PORT \
  -R ubuntu@$AWS_PUBLIC_IP:$DST_PORT2:localhost:$SRC_PORT2 \
  -R ubuntu@$AWS_PUBLIC_IP:$DST_PORT3:localhost:$SRC_PORT3 \
  ubuntu@$AWS_PUBLIC_IP || sleep 1; \
 done

