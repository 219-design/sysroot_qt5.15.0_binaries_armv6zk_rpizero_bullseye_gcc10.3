#!/bin/bash
# 219 Design LLC
# Sample script for collecting the tools necessary for cross compiling QT
# It will setup cross-compile utils in your $HOME directory
# WARNING - Scripts will not be maintained as binaries in the SYSROOT are updated, if compiler versions change or QT versions change
# Contents of the script match original commits prior to April 2022
#

LOG_FILE=setup_cross_compile.log

cp $LOG_FILE $LOG_FILE.bak

WORKING_DIR=$HOME/RPiZero

mkdir $WORKING_DIR | tee -a $LOG_FILE
mkdir $WORKING_DIR/tools | tee -a $LOG_FILE
mkdir $WORKING_DIR/sysroot | tee -a $LOG_FILE

pushd $WORKING_DIR

echo "get qt"
sudo wget http://download.qt.io/archive/qt/5.15/5.15.0/single/qt-everywhere-src-5.15.0.tar.xz
sudo tar xfv qt-everywhere-src-5.15.0.tar.xz

echo "get relative link corrector"
wget https://raw.githubusercontent.com/riscv/riscv-poky/master/scripts/sysroot-relativelinks.py
sudo chmod +x sysroot-relativelinks.py

pushd tools
	echo "get cross compiler"
	#Buster Compiler
#	sudo wget https://sourceforge.net/projects/raspberry-pi-cross-compilers/files/Raspberry%20Pi%20GCC%20Cross-Compiler%20Toolchains/Buster/GCC%208.3.0/Raspberry%20Pi%201%2C%20Zero/cross-gcc-8.3.0-pi_0-1.tar.gz
#	tar xfv cross-gcc-8.3.0-pi_0-1.tar.gz
	#Bullseye Cross compiler
	sudo wget https://sourceforge.net/projects/raspberry-pi-cross-compilers/files/Raspberry%20Pi%20GCC%20Cross-Compiler%20Toolchains/Bullseye/GCC%2010.3.0/Raspberry%20Pi%201%2C%20Zero/cross-gcc-10.3.0-pi_0-1.tar.gz
	tar xfv cross-gcc-10.3.0-pi_0-1.tar.gz
	
popd

echo "create cross compile mkspec"
pushd qt-everywhere-src-5.15.0/qtbase/mkspecs
	cp -R linux-arm-gnueabi-g++/ linux-arm-gnueabihf-g++/
	sed -i -e 's/arm-linux-gnueabi-/arm-linux-gnueabihf-/g' linux-arm-gnueabihf-g++/qmake.conf
popd

echo "Adding very specific ARM6 support for EGL"
pushd qt-everywhere-src-5.15.0/qtbase/mkspecs/devices/linux-rasp-pi-g++/
#Not sure of the best generic way to do this, but this works for our specific case
	sed -i -e 's/squeeze/squeeze|buster/g' qmake.conf
	sed -ie '/^QMAKE_CXXFLAGS/a #Overriding for ARM6 specifics\nQMAKE_LIBS_OPENGL_ES2   = -lGLESv2 -lEGL' qmake.conf
popd


#export CROSS_COMPILER=$WORKING_DIR/tools/cross-pi-gcc-8.3.0-0/
export CROSS_COMPILER=$WORKING_DIR/tools/cross-gcc-10.3.0-0/
export CROSS_COMPILER_SYSROOT=$WORKING_DIR/sysroot

#Add it to bashrc for future use
echo "adding env vars to .bashrc" | tee -a $LOG_FILE
echo "#Purcell Cross Compile Vars for Raspberry Pi" | tee -a $HOME/.bashrc
echo "export CROSS_COMPILER=$WORKING_DIR/tools/cross-pi-gcc-10.3.0-0/" | tee -a $HOME/.bashrc
echo "export CROSS_COMPILER_SYSROOT=$WORKING_DIR/sysroot" | tee -a $HOME/.bashrc

popd
