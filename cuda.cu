#include <iostream>
#include <cuda_runtime.h>
#include "cuda.h" 

__global__ void SMA_cuda(double* sma, double* vet, const int len, const int window) {
    int i = blockIdx.x * blockDim.x + threadIdx.x; 

    if (i < len) { 
        double sum = 0.0;
        int index_fine = i + window - 1; 
        for (int j = index_fine; j >= i; j--) {
            sum += vet[j];
        }
        sma[i] = sum / (double)window;
    }
}

// --- FUNZIONE PONTE (WRAPPER) ---
extern "C" void lancia_kernel_SMA(double* sma, double* vet, int len, int window, int blocks, int threads) {
    SMA_cuda<<<blocks, threads>>>(sma, vet, len, window);
}