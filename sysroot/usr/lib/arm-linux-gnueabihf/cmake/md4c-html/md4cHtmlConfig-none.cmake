#----------------------------------------------------------------
# Generated CMake target import file for configuration "None".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "md4c-html" for configuration "None"
set_property(TARGET md4c-html APPEND PROPERTY IMPORTED_CONFIGURATIONS NONE)
set_target_properties(md4c-html PROPERTIES
  IMPORTED_LOCATION_NONE "${_IMPORT_PREFIX}/lib/arm-linux-gnueabihf/libmd4c-html.so.0.4.7"
  IMPORTED_SONAME_NONE "libmd4c-html.so.0"
  )

list(APPEND _IMPORT_CHECK_TARGETS md4c-html )
list(APPEND _IMPORT_CHECK_FILES_FOR_md4c-html "${_IMPORT_PREFIX}/lib/arm-linux-gnueabihf/libmd4c-html.so.0.4.7" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
