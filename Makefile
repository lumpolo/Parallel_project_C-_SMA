# Compilatori
CXX = g++
NVCC = nvcc
CUDA_PATH = /usr

# FLAG CPU: g++ farà miracoli
CXXFLAGS = -fopenmp 

# FLAG GPU: Solo per il codice della scheda video
NVCCFLAGS = -arch=sm_61

TARGET = Primo_Progetto

# Sorgenti separati
CPP_SRCS = main.cpp iniz.cpp stmp.cpp indicator.cpp
CUDA_SRCS = cuda.cu

# Oggetti separati
CPP_OBJS = $(CPP_SRCS:.cpp=.o)
CUDA_OBJS = $(CUDA_SRCS:.cu=.o_cuda)

CUDA_LIBS = -lcudart

all: $(TARGET)

$(TARGET): $(CPP_OBJS) $(CUDA_OBJS)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(CPP_OBJS) $(CUDA_OBJS) $(CUDA_LIBS)

# Compilazione CPU: Qui g++ ottimizza come faceva all'inizio
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Compilazione GPU: nvcc compila solo il kernel
%.o_cuda: %.cu
	$(NVCC) $(NVCCFLAGS) -c $< -o $@


test: all

	@echo "--- TEST 1: OPENMP (1 Thread, static, ciclo esterno) ---"
	OMP_NUM_THREADS=1 OMP_SCHEDULE="static" ./$(TARGET) 32768 256 outer 1 100 1 static

	@echo "--- TEST 1: OPENMP (1 Thread, static, ciclo esterno) ---"
	OMP_NUM_THREADS=1 OMP_SCHEDULE="static" ./$(TARGET) 65536 256 outer 1 100 1 static

	@echo "--- TEST 1: OPENMP (1 Thread, static, ciclo esterno) ---"
	OMP_NUM_THREADS=1 OMP_SCHEDULE="static" ./$(TARGET) 131072 256 outer 1 100 1 static

	@echo "--- TEST 1: OPENMP (1 Thread, static, ciclo esterno) ---"
	OMP_NUM_THREADS=1 OMP_SCHEDULE="static" ./$(TARGET) 262144 256 outer 1 100 1 static
	
	@echo "--- TEST 1: OPENMP (1 Thread, static, ciclo esterno) ---"
	OMP_NUM_THREADS=1 OMP_SCHEDULE="static" ./$(TARGET) 524288 256 outer 1 100 1 static

	@echo "--- TEST 1: OPENMP (1 Thread, static, ciclo esterno) ---"
	OMP_NUM_THREADS=1 OMP_SCHEDULE="static" ./$(TARGET) 1048576 256 outer 1 100 1 static
	
	@echo "--- TEST 2: OPENMP (1 Thread, static, ciclo esterno) ---"
	OMP_NUM_THREADS=1 OMP_SCHEDULE="static" ./$(TARGET) 2097152 256 outer 1 100 1 static

	@echo "--- TEST 2: OPENMP (1 Thread, static, ciclo esterno) ---"
	OMP_NUM_THREADS=1 OMP_SCHEDULE="static" ./$(TARGET) 4194304 256 outer 1 10 1 static

	@echo "--- TEST 2: OPENMP (1 Thread, static, ciclo esterno) ---"
	OMP_NUM_THREADS=1 OMP_SCHEDULE="static" ./$(TARGET) 8388608 256 outer 1 10 1 static

	@echo "--- TEST 3: OPENMP (1 Thread, static, ciclo esterno) ---"
	OMP_NUM_THREADS=1 OMP_SCHEDULE="static" ./$(TARGET) 2097152 512 outer 1 100 1 static

	@echo "--- TEST 4: OPENMP (1 Thread, static, ciclo intern) ---"
	OMP_NUM_THREADS=1 OMP_SCHEDULE="static" ./$(TARGET) 2097152 512 intern 1 100 1 static

	@echo "--- TEST 5: OPENMP (2 Thread, static, ciclo esterno) ---"
	OMP_NUM_THREADS=2 OMP_SCHEDULE="static" ./$(TARGET) 2097152 512 outer 2 100 1 static

	@echo "--- TEST 6: OPENMP (2 Thread, dynamic, ciclo esterno) ---"
	OMP_NUM_THREADS=2 OMP_SCHEDULE="dynamic" ./$(TARGET) 2097152 512 outer 2 100 1 dynamic

	@echo "--- TEST 7: OPENMP (2 Thread, guided, ciclo esterno) ---"
	OMP_NUM_THREADS=2 OMP_SCHEDULE="guided" ./$(TARGET) 2097152 512 outer 2 100 1 guided

	@echo "--- TEST 8: OPENMP (2 Thread, static, ciclo intern) ---"
	OMP_NUM_THREADS=2 OMP_SCHEDULE="static" ./$(TARGET) 2097152 512 intern 2 50 1 static

	@echo "--- TEST 9: OPENMP (2 Thread, dynamic, ciclo intern) ---"
	OMP_NUM_THREADS=2 OMP_SCHEDULE="dynamic" ./$(TARGET) 2097152 512 intern 2 10 1 dynamic

	@echo "--- TEST 10: OPENMP (2 Thread, guided, ciclo intern) ---"
	OMP_NUM_THREADS=2 OMP_SCHEDULE="guided" ./$(TARGET) 2097152 512 intern 2 50 1 guided

	@echo "--- TEST 11: OPENMP (4 Thread, static, ciclo esterno) ---"
	OMP_NUM_THREADS=4 OMP_SCHEDULE="static" ./$(TARGET) 2097152 512 outer 4 100 1 static

	@echo "--- TEST 12: OPENMP (4 Thread, dynamic, ciclo esterno) ---"
	OMP_NUM_THREADS=4 OMP_SCHEDULE="dynamic" ./$(TARGET) 2097152 512 outer 4 100 1 dynamic

	@echo "--- TEST 13: OPENMP (4 Thread, guided, ciclo esterno) ---"
	OMP_NUM_THREADS=4 OMP_SCHEDULE="guided" ./$(TARGET) 2097152 512 outer 4 100 1 guided

	@echo "--- TEST 14: OPENMP (4 Thread, static, ciclo intern) ---"
	OMP_NUM_THREADS=4 OMP_SCHEDULE="static" ./$(TARGET) 2097152 512 intern 4 50 1 static

	@echo "--- TEST 15: OPENMP (4 Thread, dynamic, ciclo intern) ---"
	OMP_NUM_THREADS=4 OMP_SCHEDULE="dynamic" ./$(TARGET) 2097152 512 intern 4 10 1 dynamic

	@echo "--- TEST 16: OPENMP (4 Thread, guided, ciclo intern) ---"
	OMP_NUM_THREADS=4 OMP_SCHEDULE="guided" ./$(TARGET) 2097152 512 intern 4 25 1 guided

	@echo "--- TEST 17: OPENMP (8 Thread, static, ciclo esterno) ---"
	OMP_NUM_THREADS=8 OMP_SCHEDULE="static" ./$(TARGET) 2097152 512 outer 8 100 1 static

	@echo "--- TEST 18: OPENMP (8 Thread, dynamic, ciclo esterno) ---"
	OMP_NUM_THREADS=8 OMP_SCHEDULE="dynamic" ./$(TARGET) 2097152 512 outer 8 100 1 dynamic

	@echo "--- TEST 19: OPENMP (8 Thread, guided, ciclo esterno) ---"
	OMP_NUM_THREADS=8 OMP_SCHEDULE="guided" ./$(TARGET) 2097152 512 outer 8 100 1 guided

	@echo "--- TEST 20: OPENMP (8 Thread, static, ciclo intern) ---"
	OMP_NUM_THREADS=8 OMP_SCHEDULE="static" ./$(TARGET) 2097152 512 intern 8 25 1 static

	@echo "--- TEST 21: OPENMP (8 Thread, dynamic, ciclo intern) ---"
	OMP_NUM_THREADS=8 OMP_SCHEDULE="dynamic" ./$(TARGET) 2097152 512 intern 8 25 1 dynamic

	@echo "--- TEST 22: OPENMP (8 Thread, guided, ciclo intern) ---"
	OMP_NUM_THREADS=8 OMP_SCHEDULE="guided" ./$(TARGET) 2097152 512 intern 8 25 1 guided

	@echo "--- TEST 23: OPENMP (16 Thread, static, ciclo esterno) ---"
	OMP_NUM_THREADS=16 OMP_SCHEDULE="static" ./$(TARGET) 2097152 512 outer 16 100 1 static

	@echo "--- TEST 24: OPENMP (16 Thread, dynamic, ciclo esterno) ---"
	OMP_NUM_THREADS=16 OMP_SCHEDULE="dynamic" ./$(TARGET) 2097152 512 outer 16 100 1 guided

	@echo "--- TEST 25: OPENMP (16 Thread, guided, ciclo esterno) ---"
	OMP_NUM_THREADS=16 OMP_SCHEDULE="guided" ./$(TARGET) 2097152 512 outer 16 100 1 dynamic

	#@echo "--- TEST 26: OPENMP (16 Thread, static, ciclo intern) ---"
	#OMP_NUM_THREADS=16 OMP_SCHEDULE="static" ./$(TARGET) 2097152 512 intern 16 1 1 static

	#@echo "--- TEST 27: OPENMP (16 Thread, dynamic, ciclo intern) ---"
	#OMP_NUM_THREADS=16 OMP_SCHEDULE="dynamic" ./$(TARGET) 2097152 512 intern 16 1 1 dynamic

	#@echo "--- TEST 28: OPENMP (16 Thread, guided, ciclo intern) ---"
	#OMP_NUM_THREADS=16 OMP_SCHEDULE="guided" ./$(TARGET) 2097152 512 intern 16 1 1 guided

	@echo "--- TEST 29: OPENMP (32 Thread, static, ciclo esterno) ---"
	OMP_NUM_THREADS=32 OMP_SCHEDULE="static" ./$(TARGET) 2097152 512 outer 32 100 1 static

	@echo "--- TEST 30: OPENMP (32 Thread, dynamic, ciclo esterno) ---"
	OMP_NUM_THREADS=32 OMP_SCHEDULE="dynamic" ./$(TARGET) 2097152 512 outer 32 100 1 dynamic

	@echo "--- TEST 31: OPENMP (32 Thread, guided, ciclo esterno) ---"
	OMP_NUM_THREADS=32 OMP_SCHEDULE="guided" ./$(TARGET) 2097152 512 outer 32 100 1 guided

	@echo "--- TEST 32: OPENMP (64 Thread, static, ciclo esterno) ---"
	OMP_NUM_THREADS=64 OMP_SCHEDULE="static" ./$(TARGET) 2097152 512 outer 64 100 1 static

	@echo "--- TEST 33: OPENMP (64 Thread, dynamic, ciclo esterno) ---"
	OMP_NUM_THREADS=64 OMP_SCHEDULE="dynamic" ./$(TARGET) 2097152 512 outer 64 100 1 dynamic

	@echo "--- TEST 34: OPENMP (64 Thread, guided, ciclo esterno) ---"
	OMP_NUM_THREADS=64 OMP_SCHEDULE="guided" ./$(TARGET) 2097152 512 outer 64 100 1 guided

	@echo "--- TEST 29: OPENMP (128 Thread, static, ciclo esterno) ---"
	OMP_NUM_THREADS=128 OMP_SCHEDULE="static" ./$(TARGET) 2097152 512 outer 128 100 1 static

	@echo "--- TEST 30: OPENMP (128 Thread, dynamic, ciclo esterno) ---"
	OMP_NUM_THREADS=128 OMP_SCHEDULE="dynamic" ./$(TARGET) 2097152 512 outer 128 100 1 dynamic

	@echo "--- TEST 31: OPENMP (128 Thread, guided, ciclo esterno) ---"
	OMP_NUM_THREADS=128 OMP_SCHEDULE="guided" ./$(TARGET) 2097152 512 outer 128 100 1 guided

	@echo "--- TEST 32: CUDA (32 Thread per blocco) ---"
	./$(TARGET) 2097152 512 CUDA 32 100 1 NA

	@echo "--- TEST 33: CUDA (64 Thread per blocco) ---"
	./$(TARGET) 2097152 512 CUDA 64 100 1 NA

	@echo "--- TEST 34: CUDA (128 Thread per blocco) ---"
	./$(TARGET) 2097152 512 CUDA 128 100 1 NA

	@echo "--- TEST 35: CUDA (256 Thread per blocco) ---"
	./$(TARGET) 2097152 512 CUDA 256 100 1 NA

	@echo "--- TEST 36: CUDA (128 Thread per blocco) ---"
	./$(TARGET) 2097152 512 CUDA 512 100 1 NA

	@echo "--- TEST 37: CUDA (1024 Thread per blocco) ---"
	./$(TARGET) 2097152 512 CUDA 1024 100 1 NA

	@echo "--- TEST 38: CUDA (32 Thread per blocco) ---"
	./$(TARGET) 33554432 512 CUDA 32 100 1 NA

	@echo "--- TEST 39: CUDA (64 Thread per blocco) ---"
	./$(TARGET) 33554432 512 CUDA 64 100 1 NA

	@echo "--- TEST 40: CUDA (128 Thread per blocco) ---"
	./$(TARGET) 33554432 512 CUDA 128 100 1 NA

	@echo "--- TEST 41: CUDA (256 Thread per blocco) ---"
	./$(TARGET) 33554432 512 CUDA 256 100 1 NA

	@echo "--- TEST 42: CUDA (128 Thread per blocco) ---"
	./$(TARGET) 33554432 512 CUDA 512 100 1 NA

	@echo "--- TEST 43: CUDA (1024 Thread per blocco) ---"
	./$(TARGET) 33554432 512 CUDA 1024 100 1 NA

	@echo "CREAZIONE DATI: CUDA (32 Thread per blocco) ---"
	./$(TARGET) 2097152 20 CUDA 32 100 0 NA

	

clean:
	rm -f $(CPP_OBJS) $(CUDA_OBJS) $(TARGET) output.csv dati.csv