#include <iostream>
#include "indicator.h"
#include <omp.h> 

// --- FUNZIONI OPENMP (GIRANO SU CPU) ---

double SMA_out(double* sma, double* vet, const int len, const int window){
    double start = omp_get_wtime(); 

    #pragma omp parallel for schedule(runtime)
    for(int i = 0; i < len; i++){
        double sum = 0; 
        int index = i + window - 1; 
        for(int j = index; j >= i; j--){
            sum += vet[j];
        }
        sma[i] = sum / window;
    } 
    double stop = omp_get_wtime(); 
    return stop - start;
}

double SMA_in(double* sma, double* vet, const int len, const int window){
    double start = omp_get_wtime(); 

    for(int i = 0; i < len; i++){
        double sum = 0; 
        int index = i + window - 1; 

        #pragma omp parallel for reduction(+:sum) schedule(runtime)
        for(int j = index; j >= i; j--){
            sum += vet[j];
        }

        sma[i] = sum / window;
    }

    double stop = omp_get_wtime(); 
    return stop - start;
}

