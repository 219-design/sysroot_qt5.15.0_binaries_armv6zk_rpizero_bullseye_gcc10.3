#!/bin/bash

# 219 Design LLC
# Sample script for cross compiing QT libraries
# This script will attempt to clean, configure and build the QT libraries for the cross-complied environment
# WARNING - Scripts will not be maintained as binaries in the SYSROOT are updated, if compiler versions change or QT versions change
# Contents of the script match original commits prior to April 2022

# Usage
# run ./setup_cross_compile.sh first
# run ./rsync_sysroot.sh
# ./qt_cross.sh <action> <rpi ip>
# action Options:
#    --deploy : copy libraries to rpi
#     --clean : clean all old cross compiled libraries, configure and start over
# --configure : run the configure command again before making
#     --build : just make the libraries 
set -Eeuxo pipefail # https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

if [[ -z "${CROSS_COMPILER}" ]]; then
  echo "not setup to cross compile.  did you expost CROSS_COMPILER?"
  exit
fi

if [[ -z "${CROSS_COMPILER_SYSROOT}" ]]; then
  echo "not setup to cross compile.  did you expost CROSS_COMPILER_SYSROOT?"
  exit
fi
CROSS_ACTION="--configure"
CROSS_IP=""
if [ $# -gt 0 ]; then
CROSS_ACTION=$1
fi
if [ $# -gt 1 ]; then
CROSS_IP=$2
fi

LOG_FILE=qt_cross.log

if [[ -f "$LOG_FILE" ]]; then
    mv $LOG_FILE $LOG_FILE.bak 
fi

pushd $HOME/RPiZero/
trap "popd" EXIT HUP INT QUIT TERM


if [[ $CROSS_ACTION == "--clean" ]]; then
	echo "cleaning workspace" | tee -a $LOG_FILE
	rm -rf build/ | tee -a $LOG_FILE
	rm -rf qt5.15/| tee -a $LOG_FILE
	CROSS_ACTION="--configure"
	mkdir build;
fi

if [[ $CROSS_ACTION == "--deploy" ]]; then
	if [[ ! -z $CROSS_IP ]]; then 
	    echo "trying to sync them to raspberry pi" | tee -a ../$LOG_FILE
	    rsync -avz --rsync-path="sudo rsync" $CROSS_COMPILER_SYSROOT/usr/local/qt5.15 pi@$CROSS_IP:/usr/local | tee -a ../$LOG_FILE
	fi
	exit
fi

if [[ ! -d "build" ]]; then
	mkdir build;
fi

pushd build


keepGoing=1

if [[ $CROSS_ACTION == "--configure" ]]; then
	echo "Starting configuration" | tee -a $LOG_FILE
	../qt-everywhere-src-5.15.0/configure -v -prefix /usr/local/qt5.15 -extprefix $CROSS_COMPILER_SYSROOT/usr/local/qt5.15 -release -opengl es2 -eglfs -qpa xcb\
	 -device linux-rasp-pi-g++ -device-option CROSS_COMPILE=$CROSS_COMPILER/bin/arm-linux-gnueabihf- -sysroot $CROSS_COMPILER_SYSROOT \
	 -opensource -confirm-license -pkg-config -make libs \
	-qt-libpng \
	-qt-zlib \
	-skip qt3d \
	-skip qtactiveqt \
	-skip qtandroidextras \
	-skip qtcanvas3d \
	-skip qtconnectivity \
	-skip qtdatavis3d \
	-skip qtdoc \
	-skip qtdocgallery \
	-skip qtfeedback \
	-skip qtgamepad \
	-skip qtlocation \
	-skip qtlottie \
	-skip qtmacextras \
	-skip qtnetworkauth \
	-skip qtpim \
	-skip qtpurchasing \
	-skip qtqa \
	-skip qtquick3d \
	-skip qtremoteobjects \
	-skip qtrepotools \
	-skip qtscxml \
	-skip qtsensors \
	-skip qtspeech \
	-skip qtsystems \
	-skip qtwayland \
	-skip qtwebchannel \
	-skip qtwebengine \
	-skip qtwebglplugin \
	-skip qtwebsockets \
	-skip qtwebview \
	-skip qtwinextras \
	-no-compile-examples \
	-nomake tools \
	-nomake examples \
	-L$CROSS_COMPILER_SYSROOT/usr/lib/arm-linux-gnueabihf -I$CROSS_COMPILER_SYSROOT/usr/include/arm-linux-gnueabihf \
       | tee -a ../$LOG_FILE	

	echo "Is configure ok? (y/n)"
	read -n 1 ans <&1
	if [[ $ans = y ]];  then
		keepGoing=1
		CROSS_ACTION="--build"
	else
		keepGoing=0
	fi
fi

if [[ $keepGoing = 1 ]]; then
	if [[ $CROSS_ACTION == "--build" ]]; then
		echo "making the libraries" | tee -a ../$LOG_FILE
		make -j6 | tee -a ../$LOG_FILE

		make install | tee -a ../$LOG_FILE
	fi
	
fi


popd
popd

