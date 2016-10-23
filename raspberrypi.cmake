# CMake toolchain file for building ARM software for raspberry-pi
# (c) Volker Christian 23.10.2016 

# Adjust to your installation
SET(SYSROOT /home/voc/usr/toolchains/raspberry/tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/arm-linux-gnueabihf/sysroot)
SET(TOOLCHAINROOT /home/voc/usr/toolchains/raspberry/tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf)
SET(TARGETARCHITECTURE arm-linux-gnueabihf)

# this one is important
SET(CMAKE_SYSTEM_NAME Linux)
#this one not so much
SET(CMAKE_SYSTEM_VERSION 1)
# this sets the architecture correctly
SET(CMAKE_LIBRARY_ARCHITECTURE ${TARGETARCHITECTURE})

# specify the cross compiler
SET(CMAKE_C_COMPILER ${TOOLCHAINROOT}/bin/${CMAKE_LIBRARY_ARCHITECTURE}-gcc)
SET(CMAKE_CXX_COMPILER ${TOOLCHAINROOT}/bin/${CMAKE_LIBRARY_ARCHITECTURE}-g++)
SET(CMAKE_STRIP ${TOOLCHAINROOT}/bin/${CMAKE_LIBRARY_ARCHITECTURE}-strip)

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-gc-sections")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-rpath-link,${SYSROOT}/usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-rpath-link,${SYSROOT}/lib/${CMAKE_LIBRARY_ARCHITECTURE}" CACHE STRING "")

# where is the target environment and where to find_ things
SET(CMAKE_SYSROOT ${SYSROOT})
SET(CMAKE_FIND_ROOT_PATH ${SYSROOT})
set(ENV{PKG_CONFIG_SYSROOT_DIR} ${SYSROOT})
set(ENV{PKG_CONFIG_LIBDIR} "${SYSROOT}/usr/lib/pkgconfig:${SYSROOT}/usr/share/pkgconfig:${SYSROOT}/usr/lib/${CMAKE_LIBRARY_ARCHITECTURE}/pkgconfig")
	
# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
