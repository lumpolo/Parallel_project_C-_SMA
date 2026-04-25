#ifndef CUDA_H
#define CUDA_H

#ifdef __cplusplus
extern "C" {
#endif

void lancia_kernel_SMA(double* sma, double* vet, int len, int window, int blocks, int threads);

#ifdef __cplusplus
}
#endif

#endif