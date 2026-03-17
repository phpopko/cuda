#include <stdio.h>
#include <iostream>
#include <vector>
#include <random>
#include <algorithm>

#include "particle.h"
#include "timer.h"

using namespace std;

constexpr int PARTICLE_COUNT = 1000000;
constexpr int WIDTH = 800;
constexpr int HEIGHT = 600;

void updateParticlesArray(vector<Particle>& particles)
{
	for (int i = 0; i < PARTICLE_COUNT; i++) { particles[i].update(); }
}

__global__ void updateParticlesCuda(Particle* particles)
{
	int i = blockDim.x*blockIdx.x + threadIdx.x;
	if (i < PARTICLE_COUNT) { particles[i].update(); }
}


void initParticles(vector<Particle>& particles, int vL, int vH, mt19937& rng)
{
	uniform_int_distribution<int> randPx(0, WIDTH);
    uniform_int_distribution<int> randPy(0, HEIGHT);
    uniform_int_distribution<int> randV(vL, vH);

	for (int i = 0; i < PARTICLE_COUNT; i++) {
	    Particle p(randPx(rng), randPy(rng), randV(rng), randV(rng));
	    particles[i] = p;
	}
}

void outputSample(vector<Particle>& v, int upto)
{
	int lim = min(PARTICLE_COUNT, upto);

	for (int i = 0; i < lim; i++) { printf("Particle %d (px=%d, py=%d, vx=%d, vy=%d)\n", i+1, v[i].getPx(), v[i].getPy(), v[i].getVx(), v[i].getVy()); }
}

int main()
{
	mt19937 rng(random_device{}());

	vector<Particle> particles(PARTICLE_COUNT);
	initParticles(particles, -5, 5, rng);

	
	Particle* d_particles;
	cudaMalloc(&d_particles, PARTICLE_COUNT*sizeof(Particle));
	cudaMemcpy(d_particles, particles.data(), PARTICLE_COUNT*sizeof(Particle), cudaMemcpyHostToDevice);

	int threadsPerBlock = min(PARTICLE_COUNT, 256);
	int blocks = (PARTICLE_COUNT+ threadsPerBlock - 1) / threadsPerBlock;


	cout << "UPDATING POSITION OF PARTICLES\n";
	cout << "PARTICLE COUNT: " << PARTICLE_COUNT << '\n';
	cout << "CPU BENCHMARK:\n";
	{
		Timer timer;
		updateParticlesArray(particles);
	}	
	cout << "\nCUDA BENCHMARK:\n";
	{
		Timer timer;
		updateParticlesCuda<<<blocks, threadsPerBlock>>>(d_particles);
		cudaDeviceSynchronize();
	}	




	cudaMemcpy(particles.data(), d_particles, PARTICLE_COUNT*sizeof(Particle), cudaMemcpyDeviceToHost);



	cudaFree(d_particles);
	return 0;
}
