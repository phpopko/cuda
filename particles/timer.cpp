#include <iostream>

#include "timer.h"

Timer::Timer() { 
	m_StartPoint = std::chrono::high_resolution_clock::now(); 
}

Timer::~Timer() { 
	Stop(); 
}

void Timer::Stop() {
	auto endPoint = std::chrono::high_resolution_clock::now();

	auto start = std::chrono::time_point_cast<std::chrono::microseconds>(m_StartPoint).time_since_epoch().count();
	auto end = std::chrono::time_point_cast<std::chrono::microseconds>(endPoint).time_since_epoch().count();

	auto duration = end - start; 

	double ms = duration * 0.001;
	std::cout << duration << "us (" << ms << " ms)\n";
}


