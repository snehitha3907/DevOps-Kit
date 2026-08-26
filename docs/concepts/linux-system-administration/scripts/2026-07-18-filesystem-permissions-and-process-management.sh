#!/usr/bin/env bash
# last_verified: 2026-07-18 · bash 5.1
# Practice exercises for Linux filesystem permissions and process management.
# I wrote this as a scratch lab to get comfortable with chmod, chown, ps, and signals.

echo "== 1. Make a directory and play with permissions =="
mkdir -p ~/perm-lab && cd ~/perm-lab || exit
touch hello.txt
chmod 600 hello.txt                 # owner can read/write, nobody else
ls -l hello.txt
chmod u+x hello.txt                 # add execute for owner
chmod go+r hello.txt                # let group/others read
ls -l hello.txt

echo "== 2. Become root-owned, then take it back =="
sudo touch root-only.txt 2>/dev/null || touch root-only.txt
sudo chown root:root root-only.txt 2>/dev/null
ls -l root-only.txt
sudo chown "$USER:$USER" root-only.txt 2>/dev/null
ls -l root-only.txt

echo "== 3. Find a process by name and inspect it =="
sleep 30 &
SLEEP_PID=$!
echo "started sleep as PID $SLEEP_PID"
ps -o pid,ppid,stat,cmd -p "$SLEEP_PID"

echo "== 4. Send a signal and watch it die =="
kill -TERM "$SLEEP_PID"             # ask it nicely to stop
sleep 1
if kill -0 "$SLEEP_PID" 2>/dev/null; then
  echo "still alive, forcing with KILL"
  kill -KILL "$SLEEP_PID"
else
  echo "process exited cleanly after TERM"
fi

echo "== 5. Watch a process tree =="
ps --forest -o pid,ppid,cmd | head -n 12

cd ~ || exit
rm -rf ~/perm-lab
echo "done — cleaned up the lab"
