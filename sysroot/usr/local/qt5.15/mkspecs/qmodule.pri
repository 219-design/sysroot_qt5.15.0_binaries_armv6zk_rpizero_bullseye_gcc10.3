EXTRA_INCLUDEPATH += /home/brandyj/RPiZero/sysroot/usr/include/arm-linux-gnueabihf
EXTRA_LIBDIR += /home/brandyj/RPiZero/sysroot/usr/lib/arm-linux-gnueabihf
host_build {
    QT_CPU_FEATURES.x86_64 = mmx sse sse2
} else {
    QT_CPU_FEATURES.arm = 
}
QT.global_private.enabled_features = alloca_h alloca dbus dbus-linked dlopen gui libudev network posix_fallocate reduce_exports relocatable sql testlib widgets xml zstd
QT.global_private.disabled_features = sse2 alloca_malloc_h android-style-assets avx2 private_tests gc_binaries reduce_relocations release_tools stack-protector-strong system-zlib
PKG_CONFIG_EXECUTABLE = /usr/bin/pkg-config
QMAKE_LIBS_DBUS = -L/home/brandyj/RPiZero/sysroot/usr/lib/arm-linux-gnueabihf -ldbus-1
QMAKE_INCDIR_DBUS = /home/brandyj/RPiZero/sysroot/usr/include/dbus-1.0 /home/brandyj/RPiZero/sysroot/usr/lib/arm-linux-gnueabihf/dbus-1.0/include
QMAKE_LIBS_LIBDL = -ldl
QMAKE_LIBS_LIBUDEV = -L/home/brandyj/RPiZero/sysroot/usr/lib/arm-linux-gnueabihf -ludev
QT_COORD_TYPE = double
QMAKE_LIBS_ZSTD = -lzstd
CONFIG += cross_compile largefile precompile_header
QT_BUILD_PARTS += libs
QT_HOST_CFLAGS_DBUS += 
