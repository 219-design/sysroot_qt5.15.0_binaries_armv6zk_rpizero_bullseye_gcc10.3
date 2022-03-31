# 219 Design 
# Base Repo for Cross Compiling QT on the Raspberry Pi Zero

## Overview

The Raspberry Pi Zero W (not Zero 2 W) is a very small single core processor.  It could not natively compile the QT libraries without running out of memory.  We needed to setup the cross compile development environment and make it repeatable for continuous integration.

The RPi Zero W has a ARMv6 instruction set in an ARM11 footprint.  There is some historical timing that happened when the ARMv6 arrived on the scene, it was *sort-of* made compitatble with hard-float in a back porting attempt (read half a$$).  The Raspberry PI OS makes use of the hard float capabilities.

So we need a hard-float compiler (gnueabihf).  This was not as easy as it sounds.

The linaro tool chain has a gnueabihf option, but it will not accept the mach=armv6* option.  It just quietly ignores it until you try to run you application on an ARM6.  Linaro gnueabi actually has the same problem, it quietly ignores the mach=armv6 option.

The apt-get gnueabihf install also ignores the option.

The apt-get gnueabi will support ARMv6 architecture but that won’t compile the QT libraries.

Once the compilier is sorted out, we should be able to cross-compile the QT libraries, and the application, put them back on the RPi and see it run!

## Learned Facts as of April 2022

- [Cross Compile Reference](https://github.com/abhiTronix/raspberry-pi-cross-compilers/blob/master/QT_build_instructions.md)
- Raspberry Pi OS version Buster or Bullseye are supported by Raspberry Pi Zero
	- both will expect hard-float with their native libraries \usr\lib, \lib\ 
	- Buster is using version 8.3.0 of the G++ compiler
	- Bullseye is using version 10.3.0 of the G++ compiler
	- Bullseye is missing the graphics driver support from the stable release.  You will need to rpi-update to get them. They live in the (/opt/vc directory)
- [Link](https://github.com/raspberrypi/rpi-firmware/commits/master) RPi firmware repo.  You can run rpi-update with a git commit hash and get repeatability.
	- This repo was tested with hash a54fe46c85fd4a2155f2282454bee3c2a3d5b5eb
- [Link](https://linaro.atlassian.net/wiki/spaces/TCWGPUB/pages/25237062145/ARM+and+AArch64+Target+Triples) about why the compilers and libraries are named funny: link
- [Link](https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html) about cross-compiler arm options link
- Raspberry Pi Zero W is similar to Raspberry Pi 1 A/B
- Raspberry Pi Zero W 2 is not the same ARM core at all!
- Linaro Cross Compilers will not support ARM6 [Link](https://linaro-toolchain.linaro.narkive.com/ePQutEkp/linaro-toolchain-and-armv6)
- [Which Rasperry Pi do I have?](https://elinux.org/RPi_HardwareHistory#Which_Pi_have_I_got.3F)


Since the RPiZero cannot compile the qt libraries, you will need to setup a cross-compiling host.  Recommend using ubuntu 20.14. 

Setup your raspberry pi with the tools/installs you need to run your application.  Since chances are it won't be exactly the same as this repo, recommend using the "long way" described below.
You will need these links as well.  This tool seems handy:
```
	wget https://raw.githubusercontent.com/abhiTronix/raspberry-pi-cross-compilers/master/utils/SSymlinker
	sudo chmod +x SSymlinker
	./SSymlinker -s /usr/include/arm-linux-gnueabihf/asm -d /usr/include
	./SSymlinker -s /usr/include/arm-linux-gnueabihf/gnu -d /usr/include
	./SSymlinker -s /usr/include/arm-linux-gnueabihf/bits -d /usr/include
	./SSymlinker -s /usr/include/arm-linux-gnueabihf/sys -d /usr/include
	./SSymlinker -s /usr/include/arm-linux-gnueabihf/openssl -d /usr/include
	./SSymlinker -s /usr/lib/arm-linux-gnueabihf/crtn.o -d /usr/lib/crtn.o
	./SSymlinker -s /usr/lib/arm-linux-gnueabihf/crt1.o -d /usr/lib/crt1.o
	./SSymlinker -s /usr/lib/arm-linux-gnueabihf/crti.o -d /usr/lib/crti.o
```

## The Long Way

This is the long way to do it if you cannot use the sysroot supplied from the repo, exactly.  This will build everything from scratch, it will take about all day.

1. Run setup_cross_compile.sh on host system.
	- This will make a working cross-compile directory in your $HOME folder
2. Source your .bashrc file to make sure your env is updated
3. Run rsync_sysroot.sh \<ip of rpi\>
	- This will get all the native arm system libraries to compile against
4. Run qt_cross.sh or not
	- If you like the QT configuration and mkspec setup described in qt_cross.sh, then you can use the QT binaries in the repo (/usr/local/qt5.15).
	- If anything at all has changed, like different compiler, different device, different QT version, different qt options, then run qt_cross and build QT directly.
	- Script will compile cleanly with ./qt_cross.sh --clean \<ip of raspberry pi\>
	- after the configure portion runs, it will ask you to confirm the setup.  See expected configuration notes below. Pay attention to QT GUI and X11
	- if you miss the opportunity to type your password for the deploy step of QT, you can run qt_cross.sh --deploy \<ip of raspberry pi\> to skip all the fun stuff and just deploy.
5. Build your application pointing the `qmake` that was now created (/usr/local/qt5.15/bin)
6. Verify the app was build for the ARM using the `file` linux command. 
8. Deploy the app to the RPi

## The Shorter Way

This method is probably sufficent only if for some reason your setup is exactly the same as ours.  However, the short way can be used as a model after using the long way.

1. Run setup_cross_compile.sh. (This can be ran at the same time you are doing your native_install.sh on the RPi to save time.)
	- This will make a working cross-compile directory in your $HOME folder
	- Verify you have the lastest QT version 5.15 for purcell in the parent dir and the cross compiler in the tools directory
2. Run get_sysroot.sh
3. Run qt_cross.sh --deploy \<ip of raspberry pi\>
	- this should copy the QT libraries over to the RPi
5. Build your application pointing the `qmake` that was now created (/usr/local/qt5.15/bin)
6. Verify the app was build for the ARM using the `file` linux command
7. Deploy the app to the RPi	


## Trouble shooting
- The cross compile requires more explicit linking instructions than the X86 compilier.  You might be missing some dependancies in your .pro and .pri files
- There are lots of tangles around X11 and other display drivers.  
	- The ARMv6 vresion of Raspian wants to default to the EGL/EGLFS in /opt/vc.  You can see this in the device spec  (/qbase/mkspecs/linux-rasp-pi-g++)
	- The ARMv6 needed to use the legacy link to QMAKE_LIBS_OPENGL_ES, so that needs to be explicity setup in linux-rasp-pi-g++ instead of conditionally
	- The -qpa option in the configuration command in conjunction with the --platform command when running the application was helpful.
	- These exports might be helpful:
	```	
	export QT_QPA_PLATFORM_PLUGIN_PATH=/usr/local/qt5.15/plugins/platforms/
	export QML2_IMPORT_PATH=/usr/local/qt5.15/qml/
	export QT_PLUGIN_PATH=/usr/local/qt5.15/plugins/
	```
