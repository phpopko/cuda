#include <stdio.h>
#include <iostream>
#include <vector>
#include <random>
#include <algorithm>

#include "particle.h"
#include "timer.h"

using namespace std;

constexpr int PARTICLE_COUNT = 10000000;
constexpr int WIDTH = 800;
constexpr int HEIGHT = 600;

void updateParticlesArray(vector<Particle>& particles)
{
	for (int i = 0; i < PARTICLE_COUNT; i++) { particles[i].update(); }
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

	Timer timer;
	updateParticlesArray(particles);
	timer.Stop();

	return 0;
}
