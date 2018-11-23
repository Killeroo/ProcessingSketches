import java.util.Iterator;

final float GRAVITY = 0.03; //0.05

// TODO: Cleanup hacks
// More vairation in movement
// more colour per effect
// more initial force
// More sub particles

ParticleSystem system = new ParticleSystem();
ParticleSystem subSystem = new ParticleSystem();
int interval = 0;

void setup()
{
  size(500, 500);  
}

void draw()
{
  // Motion blur
  noStroke();
  fill(0, 20);
  rect(0, 0, width, height);
  
  system.update();
  subSystem.update();
  
  if (millis() > interval) {
    Particle p = new Particle(new PVector(width/2, height));
    system.add(p);
    interval = millis() + 2500;//2500;
  }
}


class ParticleSystem
{
  ArrayList<Particle> particles = new ArrayList<Particle>();
  
  void add(Particle p)
  {
    // Apply some initial upward force
    p.applyForce(new PVector(0, random(-7, -9)));
    particles.add(p);  
  }
  
  void update()
  {  
    Iterator<Particle> i = particles.iterator();

    while (i.hasNext()) {
      Particle p = i.next();
      
      // Remove any particles outside of the screen
      if (p.pos.x > width || p.pos.x < 0) {
        i.remove();
        continue;
      } //else if (p.pos.y > height || p.pos.y < 0) {
        //i.remove();
        //continue;
      //}
      
      // TODO: Hack only meant for sub particles, remove
      if (p.randomMovement) {
        p.applyForce(PVector.random2D());
      }
      
      if (!p.noGravity) {
        // Apply gravity
        p.applyForce(new PVector(0, GRAVITY));
      }
      
      // Move particle position
      p.move();
      
      // Remove exploded particles
      if (p.exploded) {
        i.remove();
        continue;
      }
      
      // Remove dead particles
      if (p.isDead()) {
        i.remove();  
      } else {
        p.display();
      }
      
    }
  }
}

class Particle
{
  final static float BOUNCE = -0.5;
  final static float MAX_SPEED = 0.1;
  
  PVector vel = new PVector(random(-MAX_SPEED, MAX_SPEED), random(-MAX_SPEED, MAX_SPEED));
  PVector acc = new PVector(0, 0);
  PVector pos;
  
  float mass = random(2, 2.5);
  float r, g, b; // TODO: Switch to Color()
  int lifespan = 400;
  boolean exploded = false;
  
  boolean noGravity = false;
  boolean randomMovement = false;
  
  boolean subParticle = false;
  
  Particle(PVector p)
  {
    pos = new PVector (p.x, p.y);
    acc = new PVector (random(-0.1, 0.1), 0);
    
    r = 255;
    g = 255;
    b = 255;
  }
  
  public void move()
  {
    vel.add(acc); // Apply acceleration
    pos.add(vel); // Apply our speed vector
    acc.mult(0);
    
    // TODO: Kinda resolved hack but is there a better way to do this? (OLD: this not random movement is a hack to stop subparticles from adding more particles, find a way to flag them apart and clean up other hacks)
    if (vel.y > 0 && !exploded && !subParticle) { 
       // Spawn a load of subparticles
       for (int x = 0; x < 25; x++) {
         Particle p = new Particle(pos);
         p.applyForce(PVector.random2D());
         p.r = random(0, 255);
         p.g = random(0, 255);
         p.lifespan = 150;
         float chance = random(0, 1);
         if (chance <= 0.25f) {
           p.lifespan = 75;
           p.randomMovement = true;
         }
         chance = random(0, 1);
         if (chance <= 0.5f) {
           p.lifespan = 225;
           p.noGravity = true;
         }
         p.subParticle = true;
         subSystem.particles.add(p);
       }
       
       exploded = true;
    }
    
    lifespan--;
  }
  
  public void applyForce(PVector force) 
  {
    PVector f = PVector.div(force, mass);
    acc.add(f);
  }
  
  public void display()
  {
    fill(r, g, b, map(lifespan, 0, 400, 0, 255));
    ellipse(pos.x, pos.y, 2, 2);
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
