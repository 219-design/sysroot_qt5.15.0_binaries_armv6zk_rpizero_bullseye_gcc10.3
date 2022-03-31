#!/bin/bash
# 219 Design LLC
# Sample script for collecting the required files off of the raspberry pi device
# It will load these into your cross_compile directory under sysroot. 
# WARNING - Scripts will not be maintained as binaries in the SYSROOT are updated, if compiler versions change or QT versions change
# Contents of the script match original commits prior to April 2022
#

CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

if [[ -z "$CROSS_COMPILER_SYSROOT" ]]; then
  echo "not setup to cross compile.  did you expost CROSS_COMPILER_SYSROOT?"
  exit
else
  SYSROOT_PATH="$CROSS_COMPILER_SYSROOT"
fi

CROSS_IP=$1

echo ">> Rsync /lib to $SYSROOT_PATH"
rsync -avz --rsync-path="sudo rsync" --delete pi@$CROSS_IP:/lib $SYSROOT_PATH
echo ">> Rsync /usr/include to $SYSROOT_PATH/usr"
rsync -avz --rsync-path="sudo rsync" --delete pi@$CROSS_IP:/usr/include $SYSROOT_PATH/usr
echo ">> Rsync /usr/lib to $SYSROOT_PATH/usr"
rsync -avz --rsync-path="sudo rsync" --delete pi@$CROSS_IP:/usr/lib $SYSROOT_PATH/usr
echo ">> Rsync /opt/vc to $SYSROOT_PATH/opt"
rsync -avz --rsync-path="sudo rsync" --delete pi@$CROSS_IP:/opt/vc $SYSROOT_PATH/opt

$SYSROOT_PATH/../sysroot-relativelinks.py $SYSROOT_PATH/

#This is going to be done a different way, get from git TBD
#echo ">> Getting soci build from Target"
#rsync -avz --rsync-path="sudo rsync" --delete pi@$CROSS_IP:~/sbins_sys_system/build/soci* /$SYSROOT_PATH/../

echo ">> Copying SOCI build to $CUR_GIT_ROOT/build "
cp -R /$SYSROOT_PATH/../soci* $CUR_GIT_ROOT/build
