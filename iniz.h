#ifndef INIZ_H
#define INIZ_H

#include <random>

void inizializzazione(double* vet, const double amp, const int grand_vet, const double periodo);
double aggiunta_rumore(std::mt19937& gen, const int amp);

#endif