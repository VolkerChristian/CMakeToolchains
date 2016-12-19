# CMake toolchain file for building ARM software for Raspberry Pi
# (c) Volker Christian 23.10.2016 

SET(RASPI_CROSS true)

# Adjust to your installation
SET(SYSROOT /home/voc/usr/toolchains/raspberry/tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/arm-linux-gnueabihf/sysroot)
SET(TOOLCHAINROOT /home/voc/usr/toolchains/raspberry/tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf)
SET(TARGETARCHITECTURE arm-linux-gnueabihf)

# You can set the REMOTE_INSTALL_BASE here or in your projects cmake-file like
#	set(REMOTE_INSTALL_BASE pi@raspberrypi.domain.org:/home/pi)
# or define and export the environment variable REMOTE_INSTALL_BASE like
#	export REMOTE_INSTALL_BASE=pi@raspberrypi.domain.org:/home/pi
# or call cmake like
#	cmake -DREMOTE_INSTALL_BASE=pi@raspberrypi.domain.org:/home/pi

# this one is important
SET(CMAKE_SYSTEM_NAME Linux)
# this one not so much
SET(CMAKE_SYSTEM_VERSION 1)
SET(CMAKE_SYSTEM_PROCESSOR armv7)

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
SET(ENV{PKG_CONFIG_SYSROOT_DIR} ${SYSROOT})
SET(ENV{PKG_CONFIG_LIBDIR} "${SYSROOT}/usr/lib/pkgconfig:${SYSROOT}/usr/share/pkgconfig:${SYSROOT}/usr/lib/${TARGETARCHITECTURE}/pkgconfig")
	
# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

if(NOT DEFINED MY_INSTALL_INCLUDED)
	SET(MY_INSTALL_INCLUDED yes)
	function(install)
		if(DEFINED ENV{REMOTE_INSTALL_BASE})
			SET(REMOTE_INSTALL_BASE $ENV{REMOTE_INSTALL_BASE})
		endif()
		if(DEFINED REMOTE_INSTALL_BASE)
			SET(multiValueArgs TARGETS FILES)
			SET(oneValueArgs DESTINATION LOCAL_DESTINATION)
			cmake_parse_arguments("INSTALL" "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
			if(NOT i${INSTALL_TARGETS}${INSTALL_FILES} STREQUAL i)
				string(REGEX MATCH "^.*:" REMOTE_HOST ${REMOTE_INSTALL_BASE})
				string(REPLACE ":" "" REMOTE_HOST ${REMOTE_HOST})
				string(REGEX MATCH ":.*$" REMOTE_ROOT ${REMOTE_INSTALL_BASE})
				string(REPLACE ":" "" REMOTE_ROOT ${REMOTE_ROOT})
				SET(REMOTE_INSTALL_PREFIX ${REMOTE_ROOT}${CMAKE_INSTALL_PREFIX} CACHE STRING "")
				SET(CMAKE_INSTALL_PREFIX "${${CMAKE_PROJECT_NAME}_BINARY_DIR}/install" CACHE STRING "" FORCE)
				_install(${ARGN})
				_install(CODE "MESSAGE(\"\tcreating install directory: using /usr/bin/ssh ${REMOTE_HOST} mkdir -p ${REMOTE_INSTALL_PREFIX}/${INSTALL_DESTINATION}\")")
				_install(CODE "execute_process(COMMAND /usr/bin/ssh ${REMOTE_HOST} mkdir -p \"${REMOTE_INSTALL_PREFIX}/${INSTALL_DESTINATION}\")")
				if(NOT i${INSTALL_TARGETS} STREQUAL i)
					foreach(INSTALL_TARGET IN LISTS INSTALL_TARGETS)
						_install(CODE "MESSAGE(\"\tinstalling ${INSTALL_TARGET}: using /usr/bin/scp ${INSTALL_SCPARGS} ${CMAKE_INSTALL_PREFIX}/${INSTALL_DESTINATION}/${INSTALL_TARGET} ${REMOTE_HOST}:${REMOTE_INSTALL_PREFIX}/${INSTALL_DESTINATION}/\")")
						_install(CODE "execute_process(COMMAND /usr/bin/scp -p ${INSTALL_SCPARGS} ${CMAKE_INSTALL_PREFIX}/${INSTALL_DESTINATION}/${INSTALL_TARGET} ${REMOTE_HOST}:${REMOTE_INSTALL_PREFIX}/${INSTALL_DESTINATION}/)")
					endforeach(INSTALL_TARGET)
				endif()
				if(NOT i${INSTALL_FILES} STREQUAL i)
					foreach(INSTALL_FILE IN LISTS INSTALL_FILES)
						_install(CODE "MESSAGE(\"\tinstalling ${INSTALL_FILE}: using /usr/bin/scp ${INSTALL_SCPARGS} ${CMAKE_INSTALL_PREFIX}/${INSTALL_DESTINATION}/${INSTALL_FILE} ${REMOTE_HOST}:${REMOTE_INSTALL_PREFIX}/${INSTALL_DESTINATION}/\")")
						_install(CODE "execute_process(COMMAND /usr/bin/scp -p ${INSTALL_SCPARGS} ${CMAKE_INSTALL_PREFIX}/${INSTALL_DESTINATION}/${INSTALL_FILE} ${REMOTE_HOST}:${REMOTE_INSTALL_PREFIX}/${INSTALL_DESTINATION}/)")
					endforeach(INSTALL_FILE)
				endif()
			endif()
		else()
			_install(${ARGN})
		endif()
	endfunction()
endif()
