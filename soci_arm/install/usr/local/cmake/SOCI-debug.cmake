#----------------------------------------------------------------
# Generated CMake target import file for configuration "Debug".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "SOCI::soci_core_static" for configuration "Debug"
set_property(TARGET SOCI::soci_core_static APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(SOCI::soci_core_static PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LINK_INTERFACE_LIBRARIES_DEBUG "-lpthread;/usr/lib/arm-linux-gnueabihf/libdl.so"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libsoci_core.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS SOCI::soci_core_static )
list(APPEND _IMPORT_CHECK_FILES_FOR_SOCI::soci_core_static "${_IMPORT_PREFIX}/lib/libsoci_core.a" )

# Import target "SOCI::soci_mysql_static" for configuration "Debug"
set_property(TARGET SOCI::soci_mysql_static APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(SOCI::soci_mysql_static PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LINK_INTERFACE_LIBRARIES_DEBUG "/usr/lib/arm-linux-gnueabihf/libmysqlclient.so"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/libsoci_mysql.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS SOCI::soci_mysql_static )
list(APPEND _IMPORT_CHECK_FILES_FOR_SOCI::soci_mysql_static "${_IMPORT_PREFIX}/lib/libsoci_mysql.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
