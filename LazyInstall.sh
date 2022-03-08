#!/bin/bash
#Tested on RockyLinux 8.5 (Should works on others O/S)
if ! [ -x "$(command -v git)" ]; then
  echo 'Error: git is not installed.' >&2
  exit 1
fi
if ! [ -x "$(command -v make)" ]; then
  echo 'Error: make is not installed.' >&2
  exit 1
fi
Path_Install="/tmp"
GitURL="https://github.com/BFoxyfox/Backup-Manager.git"
CronPath="/etc/cron.daily"
ConfPath="/etc/backup-manager.conf"

echo "--STEP1: Install Backup Manager"
cd $Path_Install
git clone $GitURL
cd Backup-Manager
make install
echo "--STEP2: Copy Conf"
cp -R backup-manager.conf.tpl $ConfPath
echo "--STEP3: Install Cron"
touch $CronPath/backup-manager
cat >$CronPath/backup-manager <<EOF
#!/bin/bash
test -x backup-manager || exit 0
backup-manager -c $ConfPath
EOF
chmod 751 $CronPath/backup-manager
echo "--Done!"
