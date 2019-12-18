Particle[] particles = new Particle[1000];
PVector direction = PVector.random2D();

void setup()
{
  background(255);
  size(1000, 1000);
  
  for (int x = 0; x < 1000; x++) {
    particles[x] = new Particle(new PVector(width/2, height/2));
  }
}

void draw()
{
  //background(255);
  for (int x = 0; x < 1000; x++) {
    particles[x].update();
    particles[x].draw();
  }  
}

class Particle 
{
  PVector pos;
  PVector vel;
  int life = 500;
  
  Particle(PVector p)
  {
    pos = p;
    vel = PVector.random2D().mult(random(-20, 20));
  }
  boolean done = false;
  void update()
  {
    if (life < 475 && !done) {
      vel.mult(0.1);
      done = true;
    }
    vel.add(new PVector(0, 0.01));
    pos.add(vel);  
    life--;
  }
  
  void draw() 
  {
    stroke(0);
    point(pos.x, pos.y);
  }
}
