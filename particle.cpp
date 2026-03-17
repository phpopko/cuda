#include "particle.h"

Particle::Particle(int px, int py, int vx, int vy) : px(px), py(py), vx(vx), vy(vy) {}

void Particle::update() {
        px += vx;
        py += vy;
}
    


