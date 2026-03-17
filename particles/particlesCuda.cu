#include <stdio.h>
#include <iostream>
#include <vector>
#include <random>
#include <algorithm>
#include <curand_kernel.h>

#include "particle.h"
#include "timer.h"

using namespace std;

constexpr int PARTICLE_COUNT = 1000000;
constexpr int WIDTH = 800;
constexpr int HEIGHT = 600;


__global__ void updateParticlesCuda(Particle* particles)
{
	int i = blockDim.x*blockIdx.x + threadIdx.x;
	if (i < PARTICLE_COUNT) { particles[i].updateCuda(); }
}


__global__ void initParticlesCuda(Particle* particles, int vL, int vH, unsigned long seed)
{	
	int i = blockDim.x*blockIdx.x + threadIdx.x;
	if (i >= PARTICLE_COUNT) { return; }

	curandState state;
	curand_init(seed, i, 0, &state);

	int px = curand(&state) % WIDTH;
    int py = curand(&state) % HEIGHT;
    int range = vH - vL + 1;
    int vx = (curand(&state) % range) + vL;
    int vy = (curand(&state) % range) + vL;

    particles[i] = Particle(px, py, vx, vy);
}

void outputSample(vector<Particle>& v, int upto)
{
	int lim = min(PARTICLE_COUNT, upto);

	for (int i = 0; i < lim; i++) { printf("Particle %d (px=%d, py=%d, vx=%d, vy=%d)\n", i+1, v[i].getPx(), v[i].getPy(), v[i].getVx(), v[i].getVy()); }
}

int main()
{
	mt19937 rng(random_device{}());
	unsigned long seed = rng();

	vector<Particle> particles(PARTICLE_COUNT);

	Particle* d_particles;
	cudaMalloc(&d_particles, PARTICLE_COUNT*sizeof(Particle));

	int threadsPerBlock = min(PARTICLE_COUNT, 256);
	int blocks = (PARTICLE_COUNT+ threadsPerBlock - 1) / threadsPerBlock;
	initParticlesCuda<<<blocks, threadsPerBlock>>>(d_particles, -5, 5, seed);
	cudaDeviceSynchronize();

	cudaFree(d_particles);
	return 0;
}
