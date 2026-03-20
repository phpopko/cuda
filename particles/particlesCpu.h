#pragma once
#include <vector>
#include <random>
#include "particle.h"


void updateParticlesVector(std::vector<Particle>& particles);
void initParticles(std::vector<Particle>& particles, int max_width, int max_height, int vL, int vH, std::mt19937& rng);
void runCpuTest(int PARTICLE_COUNT, int width, int height);
