cmake_minimum_required(VERSION 2.8)
# to use CMAKE
# create a link cmake/Modules pointing to cmaked/cmaked

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/Modules)

project (test_scid D)

set(SCID_ROOT $ENV{SCID_ROOT})
if (NOT ${SCID_ROOT})
  message(FATAL_ERROR "define the variable SCID_ROOT")
endif()

include_directories(${SCID_ROOT})

find_library(LIB_SCID scid PATHS ${SCID_ROOT}/generated ${SCID_ROOT})

if (LIB_SCID)
     message(STATUS "scid library is located at ${LIB_SCID}")
     get_filename_component(SCID_PATH ${LIB_SCID} PATH)
     add_executable(test_scid test_scid.d)
     set(CMAKE_D_FLAGS "${CMAKE_LIBRARY_PATH_FLAG}${SCID_PATH} ${CMAKE_D_FLAGS}")
     target_link_libraries(test_scid scid)
else()
    message(FATAL_ERROR "scid not found!")
endif()    
