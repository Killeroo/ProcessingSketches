void setup()
{
  size(400, 400);
}
//https://www.openprocessing.org/sketch/180734
void 

class ParticleSystem
{
    
  
}

class Particle
{
  PVector vel = new PVector(0, 0);
  PVector acc = new PVector(0, 0);
  PVector pos;
  int lifespan = 400;
  
  Particle(PVector p)
  {
    pos = new PVector (p.x, p.y);
    acc = new PVector (random(-0.1, 0.1), 0);
    c = color(255, 255, 255);
  }
  
  public void move()
  {
    vel.add(acc); // Apply acceleration
    pos.add(vel); // Apply our speed vector
    acc.mult(0);
    vel.mult(0.97);
    
    // Decrease particle lifespan
    lifespan--;
  }
  
  public void applyForce(PVector forceLoc) 
  {
    PVector d = PVector.sub(forceLoc, pos);
    d.normalize();
    d.mult(9);
    acc = d;
  }
  
  public void display()
  {
    stroke(255, 0, 0, map(vel.mag(), 0, 20, 50, 200));
    point(pos.x, pos.y);
  }
  
  public boolean isDead()
  {
    if (lifespan < 0) {
      return true;
    } else {
      return false;
    }
  }
}
