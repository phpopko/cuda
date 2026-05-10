CC       = gcc
CFLAGS   = -Wall -Wextra -O2 -march=native
TARGET   = particle_sim
TARGET_CPU = cpu_sim
OBJS     = main.o ocl.o

.PHONY: all clean run run-cpu

all: $(TARGET) $(TARGET_CPU)

$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(TARGET)

$(TARGET_CPU): cpu_sim.o
	$(CC) cpu_sim.o -o $(TARGET_CPU)

main.o: main.c ocl.h
	$(CC) $(CFLAGS) -c main.c

ocl.o: ocl.c ocl.h
	$(CC) $(CFLAGS) -c ocl.c

cpu_sim.o: cpu_sim.c
	$(CC) $(CFLAGS) -c cpu_sim.c

run: $(TARGET)
	./$(TARGET)

run-cpu: $(TARGET_CPU)
	./$(TARGET_CPU)

clean:
	del /q *.o $(TARGET).exe $(TARGET_CPU).exe 2>nul || true
