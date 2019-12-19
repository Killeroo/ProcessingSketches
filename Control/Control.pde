Particle[] particles = new Particle[2000];
PVector direction = PVector.random2D();

void setup()
{
  background(255);
  size(1000, 1000);
  
  for (int x = 0; x < 2000; x++) {
    particles[x] = new Particle(new PVector(width/2, height/2), direction);
  }
}

void draw()
{
  //background(255);
  noStroke();
  fill(255, 40);
  rect(0, 0, width, height);
  
  for (int x = 0; x < 2000; x++) {
    particles[x].update();
    particles[x].draw();
  }  
  
  stroke(255, 0, 0);
  line(width/2,height/2,direction.x, direction.y);
}

class Particle 
{
  PVector pos;
  PVector vel;
  PVector acc;
  PVector target;
  int life = 350;
  
  Particle(PVector p, PVector dir)
  {
    pos = p;
    target = dir;
    vel = new PVector(0, 0);
    
    // Oldie but a goldie (hacked together splatter pattern)
    //vel = new PVector(dir.x + PVector.random2D().x, dir.y + PVector.random2D().y).mult(random(0, 15));
  }
  
  boolean done = false;
  void update()
  {
    if (life < 325 && !done) {
      vel.mult(0.05);
      done = true;
    } 
    
    // Small pull downwards (gravity
    vel.add(new PVector(0, 0.01));
    pos.add(vel);  
    life--;
  }
  
  void draw() 
  {
    //stroke(0);
    stroke(map(abs(vel.y), 0, 2, 0, 255), 0, 0);
    stroke(map(abs(vel.x), 0, 2, 0, 255), 0, 0);
    point(pos.x, pos.y);
  }
}
