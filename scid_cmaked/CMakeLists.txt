cmake_minimum_required(VERSION 2.8)
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/Modules)

project (test_scid D)

include_directories(/home/fux/sources/scid)

find_library(LIB_SCID scid 
       PATHS /home/fux/sources/scid/generated
             ${PREFIX}/lib/)
if (LIB_SCID)
     message(STATUS "scid library is located at ${LIB_SCID}")
     get_filename_component(SCID_PATH ${LIB_SCID} PATH)
     add_executable(test_scid test_scid.d)
     set(CMAKE_D_FLAGS "${CMAKE_LIBRARY_PATH_FLAG}${SCID_PATH} ${CMAKE_D_FLAGS}")
     target_link_libraries(test_scid scid)
else()
    message(FATAL_ERROR "you need from SCID")
endif()    
