cmake_minimum_required(VERSION 3.24)

if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
  include(FetchContent)
  FetchContent_Declare(
    vcpkg
    GIT_REPOSITORY https://github.com/microsoft/vcpkg.git
    GIT_TAG master
    GIT_SHALLOW TRUE
  )
  FetchContent_MakeAvailable(vcpkg)
  set(CMAKE_TOOLCHAIN_FILE
    ${vcpkg_SOURCE_DIR}/scripts/buildsystems/vcpkg.cmake
    CACHE FILEPATH "Vcpkg toolchain file"
  )
  set(VCPKG_ROOT_DIR ${vcpkg_SOURCE_DIR} CACHE PATH "Vcpkg Root Directory")
endif()

add_custom_target(UpdateVcpkgBaseline
  ${VCPKG_ROOT_DIR}/vcpkg x-update-baseline
)

project(nyu-sync VERSION 1.0.0)

find_package(nyu-cmake CONFIG REQUIRED)

add_library(sync INTERFACE)

add_subdirectory(rtl)

if(NYU_BUILD_TESTS)
  enable_testing()
  add_subdirectory(dv)
endif()

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

nyu_install_sv(
  EXPORT nyusyncTargets
  TARGETS sync
  NAMESPACE nyu::
  EXPORT_DEST ${CMAKE_INSTALL_DATADIR}/nyusync
  SV_DEST ${CMAKE_INSTALL_DATADIR}/nyusync/rtl
)

write_basic_package_version_file(
  ${CMAKE_CURRENT_BINARY_DIR}/nyusync-config-version.cmake
  COMPATIBILITY ExactVersion
  ARCH_INDEPENDENT
)

install(FILES
  ${CMAKE_CURRENT_SOURCE_DIR}/cmake/nyusync-config.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/nyusync-config-version.cmake
  DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/nyusync
)
