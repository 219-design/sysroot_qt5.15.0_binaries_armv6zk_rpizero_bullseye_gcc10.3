
add_library(Qt5::QEglFSBrcmIntegrationPlugin MODULE IMPORTED)


_populate_Gui_plugin_properties(QEglFSBrcmIntegrationPlugin RELEASE "egldeviceintegrations/libqeglfs-brcm-integration.so" FALSE)

list(APPEND Qt5Gui_PLUGINS Qt5::QEglFSBrcmIntegrationPlugin)
set_property(TARGET Qt5::Gui APPEND PROPERTY QT_ALL_PLUGINS_egldeviceintegrations Qt5::QEglFSBrcmIntegrationPlugin)
set_property(TARGET Qt5::QEglFSBrcmIntegrationPlugin PROPERTY QT_PLUGIN_TYPE "egldeviceintegrations")
set_property(TARGET Qt5::QEglFSBrcmIntegrationPlugin PROPERTY QT_PLUGIN_EXTENDS "")
set_property(TARGET Qt5::QEglFSBrcmIntegrationPlugin PROPERTY QT_PLUGIN_CLASS_NAME "QEglFSBrcmIntegrationPlugin")
