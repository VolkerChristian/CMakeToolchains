# CMake toolchain file for building ARM software for Raspberry Pi
# (c) Volker Christian 23.10.2016 

set(RASPI_CROSS true)

# Adjust to your installation
SET(SYSROOT /home/voc/usr/toolchains/raspberry/tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/arm-linux-gnueabihf/sysroot)
SET(TOOLCHAINROOT /home/voc/usr/toolchains/raspberry/tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf)
SET(TARGETARCHITECTURE arm-linux-gnueabihf)

# this one is important
SET(CMAKE_SYSTEM_NAME Linux)
# this one not so much
SET(CMAKE_SYSTEM_VERSION 1)
# this informs cmake about the system-root
SET(CMAKE_SYSROOT ${SYSROOT})
# this sets the architecture correctly
SET(CMAKE_LIBRARY_ARCHITECTURE ${TARGETARCHITECTURE})

# specify the cross compiler
SET(CMAKE_C_COMPILER ${TOOLCHAINROOT}/bin/${TARGETARCHITECTURE}-gcc)
SET(CMAKE_CXX_COMPILER ${TOOLCHAINROOT}/bin/${TARGETARCHITECTURE}-g++)
SET(CMAKE_STRIP ${TOOLCHAINROOT}/bin/${TARGETARCHITECTURE}-strip)

# Set CMAKE_EXE_LINKER_FLAGS and CMAKE_MODULE_LINKER_FLAGS in case you don't have the current ld.so.conf file of your Pi
# to let the linker find _all_ libraries
#SET(CMAKE_EXE_LINKER_FLAGS "-Wl,-gc-sections\
# -Wl,-rpath-link,${SYSROOT}/lib/${TARGETARCHITECTURE}\
# -Wl,-rpath-link,${SYSROOT}/usr/lib/${TARGETARCHITECTURE}")# CACHE STRING "")
 
#set(CMAKE_MODULE_LINKER_FLAGS "-Wl,-gc-sections\
# -Wl,-rpath-link,${SYSROOT}/lib/${TARGETARCHITECTURE}\
# -Wl,-rpath-link,${SYSROOT}/usr/lib/${TARGETARCHITECTURE}")# CACHE STRING "")

# where is the target environment and where to find_ things
SET(CMAKE_FIND_ROOT_PATH ${SYSROOT})
set(ENV{PKG_CONFIG_SYSROOT_DIR} ${SYSROOT})
set(ENV{PKG_CONFIG_LIBDIR} "${SYSROOT}/usr/lib/pkgconfig:${SYSROOT}/usr/share/pkgconfig:${SYSROOT}/usr/lib/${TARGETARCHITECTURE}/pkgconfig")
	
# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

if(i${MY_INSTALL_INCLUDED} STREQUAL i)
	set(MY_INSTALL_INCLUDED true)
	function(install)
		set(options OPTIONAL RUNTIME)
		set(oneValueArgs DESTINATION)
		set(multiValueArgs TARGETS SCPARGS)
		cmake_parse_arguments(MY_INSTALL "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
		if(i${MY_INSTALL_DESTINATION} STREQUAL i)
			message(FATAL_ERROR "install TARGETS given no RUNTIME DESTINATION for executable ${MY_INSTALL_TARGETS}.")
		endif()
		_install(CODE "MESSAGE(\"\t${MY_INSTALL_TARGETS}: using /usr/bin/scp ${MY_INSTALL_SCPARGS} ${MY_INSTALL_TARGETS} ${SCP_INSTALL_DESTINATION}/${MY_INSTALL_DESTINATION}/\")")
		_install(CODE "execute_process(COMMAND \"/usr/bin/scp\" ${MY_INSTALL_SCPARGS} \"${MY_INSTALL_TARGETS}\" \"${SCP_INSTALL_DESTINATION}/${MY_INSTALL_DESTINATION}/\")")
	endfunction()
endif()
