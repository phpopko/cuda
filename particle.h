#pragma once

class Particle {
public:
    Particle(int px=0, int py=0, int vx=0, int vy=0);

    int getPx() const { return px; } 
    int getPy() const { return py; }
    int getVx() const { return vx; }
    int getVy() const { return vy; }

    void update();
private:
    int px, py;
    int vx, vy;
}; 