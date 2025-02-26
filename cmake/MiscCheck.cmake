# Copyright (c) Facebook, Inc. and its affiliates.
# All rights reserved.
#
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

include(CheckCXXSourceCompiles)
include(CMakePushCheckState)

# We use the [[nodiscard]] attribute, which GCC 5 complains about.
# Silence this warning if GCC 5 is used.
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS 6)
    add_definitions("-Wno-attributes")
  endif()
endif()

if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
  # Check libc contains process_vm_readv
  CMAKE_PUSH_CHECK_STATE(RESET)
  set(CMAKE_REQUIRED_FLAGS "${CMAKE_CXX_FLAGS}")
  CHECK_CXX_SOURCE_COMPILES("
    #include <sys/uio.h>
    int main() {
      ssize_t rv = ::process_vm_readv(1, nullptr, 0, nullptr, 0, 0);
      return 0;
    }" SUPPORT_GLIBCXX_USE_PROCESS_VM_READV)
  CMAKE_POP_CHECK_STATE()
endif()

