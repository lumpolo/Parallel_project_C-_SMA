#include <iostream>
#include "stmp.h"
using namespace std;

void stampa(double* stmp, const int len){
    for(int i = 0; i < len; i++){
        cout << stmp[i] << " ";
    }
}