#!/bin/bash

# 219 Design LLC
# Sample script for getting the sysroot from the repo and not the device.
# It will load these into your cross_compile directory under sysroot. 
# WARNING - Scripts will not be maintained as binaries in the SYSROOT are updated, if compiler versions change or QT versions change
# Contents of the script match original commits prior to April 2022

CUR_GIT_ROOT=$(git rev-parse --show-toplevel)

if [[ -z "$CROSS_COMPILER_SYSROOT" ]]; then
  echo "not setup to cross compile.  did you expost CROSS_COMPILER_SYSROOT?"
  exit
else
  SYSROOT_PATH="$CROSS_COMPILER_SYSROOT"
fi

WORKING_DIR=$HOME/RPiZero

pushd $WORKING_DIR

#get starter sysroot and soci libs
#if you add anything extra to the RPi you will need to rsync again (rpi/rsync_sysroot.sh)
#remember to deploy the QT libraries to your device after qt_cross.sh --deploy <ip>
echo "get base sysroot and soci directories"
sudo wget https://github.com/219-design/sysroot_qt5.15.0_binaries_armv6zk_rpizero_bullseye_gcc10.3/archive/refs/heads/main.tar.gz
tar xfv main.tar.gz --strip-components=1 -C $WORKING_DIR

popd
