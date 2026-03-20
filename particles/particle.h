#pragma once

#ifndef __CUDACC__
  #ifndef __host__
    #define __host__
  #endif
  #ifndef __device__
    #define __device__
  #endif
#endif


class Particle {
public:
    __host__ __device__ Particle(int px=0, int py=0, int vx=0, int vy=0) : px(px), py(py), vx(vx), vy(vy) {}

    int getPx() const { return px; } 
    int getPy() const { return py; }
    int getVx() const { return vx; }
    int getVy() const { return vy; }

    __host__ __device__ void update() {
        px += vx;
        py += vy;
    }


private:
    int px, py;
    int vx, vy;
}; 
