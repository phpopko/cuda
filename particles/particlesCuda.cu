#include "particlesCuda.h"

__global__ void updateParticlesCuda(Particle* particles, int PARTICLE_COUNT)
{
	int i = blockDim.x*blockIdx.x + threadIdx.x;
	if (i < PARTICLE_COUNT) { particles[i].update(); }
}


__global__ void initParticlesCuda(Particle* particles, int PARTICLE_COUNT, int max_width, int max_height, int vL, int vH, unsigned long seed)
{	
	int i = blockDim.x*blockIdx.x + threadIdx.x;
	if (i >= PARTICLE_COUNT) { return; }

	curandState state;
	curand_init(seed, i, 0, &state);

	int px = curand(&state) % max_width;
    int py = curand(&state) % max_height;
    int range = vH - vL + 1;
    int vx = (curand(&state) % range) + vL;
    int vy = (curand(&state) % range) + vL;

    particles[i] = Particle(px, py, vx, vy);
}

void runCudaTest(int PARTICLE_COUNT, int width, int height)
{
	std::mt19937 rng(std::random_device{}());
	unsigned long seed = rng();

	Particle* d_particles;
	cudaMalloc(&d_particles, PARTICLE_COUNT*sizeof(Particle));

	int threadsPerBlock = min(PARTICLE_COUNT, 256);
	int blocks = (PARTICLE_COUNT+ threadsPerBlock - 1) / threadsPerBlock;

	std::cout << "Initializing particles...\n";
	{
		Timer timer;
		initParticlesCuda<<<blocks, threadsPerBlock>>>(d_particles, PARTICLE_COUNT, width, height, -5, 5, seed);
		cudaDeviceSynchronize();
	}	

	std::cout << "Updating particles...\n";
	{
		Timer timer;
		updateParticlesCuda<<<blocks, threadsPerBlock>>>(d_particles, PARTICLE_COUNT);
		cudaDeviceSynchronize();
	}

	cudaFree(d_particles);
}
