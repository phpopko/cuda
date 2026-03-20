#include <iostream>
#include <random>
#include <vector>
#include "particle.h"
#include "timer.h"
#include "particlesCpu.h"

void updateParticlesVector(std::vector<Particle>& particles, int PARTICLE_COUNT)
{
	for (int i = 0; i < PARTICLE_COUNT; i++) { particles[i].update(); }
}


void initParticles(std::vector<Particle>& particles, int PARTICLE_COUNT, int max_width, int max_height, int vL, int vH, std::mt19937& rng)
{
	std::uniform_int_distribution<int> randPx(0, max_width);
    std::uniform_int_distribution<int> randPy(0, max_height);
    std::uniform_int_distribution<int> randV(vL, vH);

	for (int i = 0; i < PARTICLE_COUNT; i++) {
	    Particle p(randPx(rng), randPy(rng), randV(rng), randV(rng));
	    particles[i] = p;
	}
}



void runCpuTest(int PARTICLE_COUNT, int width, int height)
{
	std::mt19937 rng(std::random_device{}());

	std::vector<Particle> particles(PARTICLE_COUNT);

	std::cout << "Initializing particles...\n";
	{
		Timer timer;
		initParticles(particles, PARTICLE_COUNT, width, height, -5, 5, rng);
	}	

	std::cout << "Updating particles...\n";
	{
		Timer timer;
		updateParticlesVector(particles, PARTICLE_COUNT);
	}

}
