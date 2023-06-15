find_package(nyu-cmake CONFIG REQUIRED)

include(${CMAKE_CURRENT_LIST_DIR}/nyu-syncTargets.cmake)

nyu_include_fixup(nyu::sync)
