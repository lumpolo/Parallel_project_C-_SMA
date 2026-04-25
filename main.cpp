#include <iostream>
#include <fstream>
#include <string>
#include <omp.h>              // Per i tempi e OpenMP
#include <cuda_runtime.h>     // Per gestire la memoria GPU nel main

#include "iniz.h"
#include "stmp.h"
#include "indicator.h"
#include "cuda.h"

using namespace std;

// Costanti per il calcolo del segnale
const double AMP = 5.0;
const double PERIODO = 100.0;
const int STAMPA = 1000;

int main(int argc, char* argv[]){
    if(argc != 8){                                                              // Controllo che siano num. di parametri corretti
        cerr << "Errore! Numero argomenti sbagliato\n";
        return 1;
    }

    const int GRAND_VET = stoi(argv[1]);                                        // Trasformo in interi i parametri in ingresso
    const int WINDOW = stoi(argv[2]);
    string func_type = argv[3];
    const int THREADS = stoi(argv[4]);
    const int REPS = stoi(argv[5]);
    const bool STMP = stoi(argv[6]);
    string schedule = argv[7];

    double* vet = new double[GRAND_VET];                                        // Crea il vettore con una grandezza non precedentemente fissata
    inizializzazione(vet, AMP, GRAND_VET, PERIODO);                             // Assegno ad ogni valore dell'array un valore del segnale

    //stampa(vet, GRAND_VET);                                                   // Stampo per fare un controllo se funziona l'assegnazione
    
    int len = GRAND_VET - WINDOW;                                               // Non ho voglia di riscriverlo 3 volte
    double* sma = new double[len];                                              // Creo il vettore per la SMA. 

    double temp_min = 10000000000.0;
    double temp_max = 0.0;
    double tempo_tot = 0.0;
    double tempo;                                                               // Devo dichiararla qui se no non la vede a riga 55 perché creata nell'if

    if (func_type == "CUDA") {
        double* d_vet = nullptr;
        double* d_sma = nullptr;

        cudaMalloc(&d_vet, GRAND_VET * sizeof(double));                             // Alloca una volta sola fuori dal ciclo REPS
        cudaMalloc(&d_sma, len * sizeof(double));       
        
        cudaMemcpy(d_vet, vet, GRAND_VET * sizeof(double), cudaMemcpyHostToDevice); // Copia i dati iniziali sulla GPU

        int blocks = (len + THREADS - 1) / THREADS;                                 // Calcolo numero di blocchi

        cout << "Numero: blocchi GPU: " << blocks << endl;

        for (int i = 0; i < REPS; i++) {
            double start = omp_get_wtime();
            
            lancia_kernel_SMA(d_sma, d_vet, len, WINDOW, blocks, THREADS);          // Lancio del kernel
            
            cudaDeviceSynchronize();                                                // Sincronizzazione obbligatoria per misurare il tempo vero
            tempo = omp_get_wtime() - start;

            tempo_tot += tempo;
            if(tempo < temp_min) temp_min = tempo;
            if(tempo > temp_max) temp_max = tempo;
        }

    cudaMemcpy(sma, d_sma, len * sizeof(double), cudaMemcpyDeviceToHost);       // Alla fine di tutte le ripetizioni, riporta il risultato finale su RAM

    cudaFree(d_vet);                                                            // Libera la memoria
    cudaFree(d_sma);
} 
else {
    for (int i = 0; i < REPS; i++) {
        if(func_type == "outer") tempo = SMA_out(sma, vet, len, WINDOW);        // Parallelizzazione sul ciclo esterno
        else if(func_type == "intern") tempo = SMA_in(sma, vet, len, WINDOW);   // Parallelizzazione sul ciclo interno
        
        tempo_tot += tempo;
        if(tempo < temp_min) temp_min = tempo;
        if(tempo > temp_max) temp_max = tempo;
    }
}
    
    long long num_cicli = (long long)(GRAND_VET - WINDOW) * (WINDOW + 1);       // I cicli in cui devo calcolare l'SMA sono GRAND_VET - WINDOW. +1 perché conto anche i precedenti ma senza calcolo SMA
    cout << "Num. di cicli per singolo test(senza REPS): " << num_cicli << endl;

    cout << "Il tempo di esecuzione totale del calcolo dell'SMA e': " << tempo_tot << endl;
    cout << "Il tempo di esecuzione medio del calcolo dell'SMA e': " << tempo_tot/REPS << endl;
    cout << "Il tempo min e': " << temp_min << endl;
    cout << "Il tempo max e': " << temp_max << endl;

    ifstream check_file("dati.csv");                                            // Apro il file in lettura
    bool file_vuoto = check_file.peek() == ifstream::traits_type::eof();        // Controllo che sia vuoto
    check_file.close();

    ofstream dati_csv("dati.csv", ios::app);                                    // Apro il file in scrittura, ma non sovrascrivendo i dati precedenti

    if (!dati_csv.is_open()) {                                                  // Controllo che sia aperto
        cerr << "Il file non è aperto\n";
        return 1;
    }

    if (file_vuoto) {                                                           // Se il file è vuoto ci metto l'intestazione
        dati_csv << "tipo,schedule,threads,grand_vet,window,num_cili_per_rep,reps,tempo_medio,tempo_min,tempo_max\n";
    }

    if(STMP == 1){
        dati_csv << func_type << ",";
        dati_csv << schedule << ",";
        dati_csv << THREADS << ",";
        dati_csv << GRAND_VET << ",";
        dati_csv << WINDOW << ",";
        dati_csv << num_cicli << ",";
        dati_csv << REPS << ",";
        dati_csv << tempo_tot/REPS << ",";
        dati_csv << temp_min << ",";
        dati_csv << temp_max << endl;
    }

    //stampa(sma, len);                                                         // Stampo per fare un controllo se funziona l'assegnazione

    ofstream out_csv("output.csv");

    if (!out_csv.is_open()) {
        // Scrittura intestazioni
        cerr << "Il file non è aperto\n";
        return 1;
    }

    for(int i = WINDOW; i < STAMPA + WINDOW; i++){                              // Stampo i dati nel csv. 1000 e basta perché se no non si capisce nulla. Inizio da WINDOW per non avere buchi
        out_csv << vet[i] << ",";                                               // Scrivo Il valore del segnale originale
        out_csv << sma[i - WINDOW];                                             // La SMA inizia con uno sfasamento dovuto alla finestra
        out_csv << endl;  
    }

    out_csv.close();                                                            // Chiudo il csv

    delete[] vet;                                                               // Dealloco la memoria per vet
    delete[] sma;                                                               // Dealloco la memoria per la SMA

    cout << "Programma Finito!\n";

    return 0;
}


/*
Per compilare una volta: make
Poi pulisci: make clean
Per fare i vari test: make test
Per scrivere i risultati in un file di testo: make test > risultati_test.txt
Per fare test singolo con valori: ./Primo_Progetto <GRAND_VET> <WIN>
*/