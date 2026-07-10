#pragma once

#include <__clang_cuda_runtime_wrapper.h>

/*
 * clangd / clang CUDA syntax-only compatibility shim.
 * For Emacs eglot/clangd parsing only, not for real builds.
 */
#if defined(__clang__) && defined(__CUDA__)

extern "C" cudaError_t cudaConfigureCall(dim3 gridDim,
                                         dim3 blockDim,
                                         size_t sharedMem = 0,
                                         cudaStream_t stream = 0);

extern "C" cudaError_t cudaSetupArgument(const void *arg,
                                         size_t size,
                                         size_t offset);

extern "C" cudaError_t cudaLaunch(const void *func);

#endif
