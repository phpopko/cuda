#pragma once
#include <iostream>
#include <random>
#include <curand_kernel.h>
#include "particle.h"
#include "timer.h"


__global__ void updateParticlesCuda(Particle* particles, int PARTICLE_COUNT);
__global__ void initParticlesCuda(Particle* particles, int PARTICLE_COUNT, int max_width, int max_height, int vL, int vH, unsigned long seed);
void runCudaTest(int PARTICLE_COUNT, int width, int height);
