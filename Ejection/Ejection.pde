final int PARTICLE_COUNT = 1000;

Particle[] particles = new Particle[PARTICLE_COUNT];

void setup()
{
  size(500, 500, P3D);
  background(0);
  
  noFill();
  stroke(255);
  strokeWeight(1);
  
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    particles[x] = new Particle(new PVector(0, 0, 0));
  }
}

void draw()
{
  background(0);
  
  // Translate around the center of the sketch
  translate(width/2, height/2);
  
  // Rotate around center
  rotateY(frameCount / 100.0);
  
  noFill();
  stroke(255);
  strokeWeight(1);
  box(300);
  //sphere(20);
  
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    particles[x].update();
    particles[x].render();
  }
}

class Particle
{
  PVector pos;
  PVector vel;
  PVector acc;
  
  Particle(PVector p)
  {
    vel = new PVector(
            randomGaussian()*1.3 + random(0, 1),
            randomGaussian()*1.3 + random(0, 1),
            randomGaussian()*1.3 + random(0, 1));
    acc = new PVector(0, 0, 0);
    pos = p;
  }
  
  void update()
  {
    vel.add(acc);
    acc.mult(0);
    pos.add(vel);
  }
  
  void render()
  {
    stroke(255, 0, 0);
    point(pos.x, pos.y, pos.z);
    
  }
}
