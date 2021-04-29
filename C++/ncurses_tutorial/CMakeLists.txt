
cmake_minimum_required(VERSION 3.10)

# set the project name
project(ls2)

find_package(Curses REQUIRED)

# add the executable
add_executable(ls2 ls2.cxx)

#add_library(ncurses)
target_link_libraries(ls2 ${CURSES_LIBRARIES})