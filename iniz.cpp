#include <iostream>
#include <random>
#include <cmath>
#include "iniz.h"
using namespace std;

double aggiunta_rumore(mt19937& gen, const int amp){                                             
    double ampiezza_rumore = amp / 5.0;                                         // Crea i limiti in cui deve fare la distribuzione
    uniform_real_distribution<double> dist(-ampiezza_rumore, ampiezza_rumore);  // Crea la distribuzione
    return dist(gen);                                                           // Estrae il numero usando il motore passato come riferimento
}


void inizializzazione(double* vet, const double amp, const int grand_vet, const double periodo){
    mt19937 gen(11);                                                            // Genera un seed fisso
    for(int i = 0; i < grand_vet; i++){                                         // Si potrebbe usare size_t per evitare che l'indice vada in overflow con vettori enormi
        vet[i] = (amp * sin(i/periodo)) + aggiunta_rumore(gen, amp);            // Crea un segnale periodico come il seno 
    }                                                                           // lo amplifica e ci aggiunge il rumore
}