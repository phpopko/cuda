#include <iostream>
#include <string>
#include <cstdlib>
#include "particlesCuda.h"
#include "particlesCpu.h"

constexpr int WIDTH = 800;
constexpr int HEIGHT = 600;

int main(int argc, char** argv)
{
	if (argc < 2) { 
		std::cout << "Usage: ./a particle_count (optional '-cuda') \n";
		return EXIT_FAILURE; 
	}

	int PARTICLE_COUNT = std::atoi(argv[1]);

	std::cout << "\nParticles " << PARTICLE_COUNT << '\n';
	if (argv[2] && std::string(argv[2]) == "-cuda") { 
		std::cout << "Using GPU\n";
		runCudaTest(PARTICLE_COUNT, WIDTH, HEIGHT); 
	} 
	else { 
		std::cout << "Not using GPU\n";
		runCpuTest(PARTICLE_COUNT, WIDTH, HEIGHT); 
	}
	std::cout << '\n';


	return EXIT_SUCCESS;
}