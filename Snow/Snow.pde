import java.util.Iterator;

ParticleSystem system;

// alot of reference and use of processing force example
//https://processing.org/examples/smokeparticlesystem.html
void setup()
{
  //background(255);
  size(1000, 1000);  
  system = new ParticleSystem();
}

void draw()
{
  background(255);
  
  PVector wind = new PVector(-0.01, 0);
  system.applyForce(wind);
  system.run();
  system.add();
}

class Particle
{
  PVector pos;
  PVector vel;
  PVector acc;
  int lifespan;
  int startingLifespan; // Use to properly fade particle
  // TODO: add mass
  // TODO: random wind direction change
  
  Particle(PVector p)
  {
    // Bit of random initial velocity (I really like this effect)
    float vx = randomGaussian()*0.3;
    float vy = randomGaussian()*0.3 - 1.0;
    vel = new PVector(vx, vy);
    
    pos = p;
    acc = new PVector(0, 0);
    lifespan = (int) random(250, 300);
    startingLifespan = lifespan;
  }
  
  void applyForce(PVector force) 
  {
    acc.add(force);  
  }
  
  boolean isDead()
  {
    if (lifespan <= 0) {
      return true;  
    } else {
      return false;
    }
  }
  
  void update()
  {
    vel.add(acc);
    pos.add(vel);
    acc.mult(0);
    
    lifespan--;
  }
  
  void draw()
  {
    fill(0, map(lifespan, 0, startingLifespan, 0, 255));
    ellipse(pos.x, pos.y, 2, 2);
  }
  
}

class ParticleSystem
{
  ArrayList<Particle> particles = new ArrayList<Particle>();
  
  ParticleSystem()
  {
    for (int i = 0; i < 50; i++) {
      particles.add(new Particle(new PVector(random(width), 0)));  
    }
  }
  
  void run()
  {
    Iterator<Particle> i = particles.iterator();
    while(i.hasNext()) {
      Particle p = i.next();
      
      p.applyForce(new PVector(0, 0.03));
      p.update();
      p.draw();
      
      if (p.isDead()) {
        i.remove();
      }
    }
  }
  
  void applyForce(PVector f)
  {
    for (Particle p : particles) {
      p.applyForce(f);
    }
  }
  
  void add()
  {
    if (particles.size() > 400) {
      return;  
    }
    particles.add(new Particle(new PVector(random(width), 0)));
  }
}
