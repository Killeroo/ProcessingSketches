import java.util.Iterator;

final float GRAVITY = 0.03; //0.05

// More vairation in movement
// more colour per effect
// more initial force
//sub sub explosions
// triangles
// Add octopus wandering

// redo names and/or add description to each class

ParticleSystem system = new ParticleSystem();
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
  
  if (millis() > interval) {
    Particle p = new Particle(new PVector(width/2, height));
    system.add(p);
    interval = millis() + 4000;//2500;
  }
}


class ParticleSystem
{
  // Privatise
  
  ArrayList<Particle> particles = new ArrayList<Particle>();
  
  // All sub particles
  ArrayList<Randomer> randomers = new ArrayList<Randomer>();
  ArrayList<Floater> floaters = new ArrayList<Floater>();
  ArrayList<Faller> fallers = new ArrayList<Faller>();
  
  void add(Particle p) // Change this, or add endpoints for subparticles?
  {
    // Apply some initial upward force
    p.applyForce(new PVector(0, random(-7, -9)));
    particles.add(p);  
  }
  
  void update()
  {  
    this.updateParticles();
    
    this.updateRandomers();
    this.updateFloaters();
    this.updateFaller();
  }
  
  void updateParticles()
  {
    Iterator<Particle> i = particles.iterator();
    while (i.hasNext()) {
      Particle p = i.next();
      
      // Apply gravity
      p.applyForce(new PVector(0, GRAVITY));
      
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
  
  void updateRandomers()
  {
    Iterator<Randomer> i = randomers.iterator();
    while (i.hasNext()) {
      Randomer r = i.next();
      
      r.applyForce(PVector.random2D());
      r.move();
      
      if (r.isDead()) {
        i.remove();
      } else {
        r.display();
      }
    }
  }
  
  void updateFloaters()
  {
    Iterator<Floater> i = floaters.iterator();
    while (i.hasNext()) {
      Floater f = i.next();
      
      f.move();
      
      if (f.isDead()) {
        i.remove();
      } else {
        f.display();
      }
    }
  }
  
  void updateFaller()
  {
    Iterator<Faller> i = fallers.iterator();
    while (i.hasNext()) {
      Faller f = i.next();
      
      f.applyForce(new PVector(0, GRAVITY));
      f.move();
      
      if (f.isDead()) {
        i.remove();
      } else {
        f.display();
      }
    }
  }
}

// TODO: limit speed
class Randomer extends Particle
{
  public Randomer(PVector p)
  {
    super(p);  
    
    this.r = random(150, 255);
    this.g = 40;
    
    this.subParticle = true;
    this.applyForce(PVector.random2D());
    this.lifespan = 125;
    this.randomMovement = true;
    this.size = 2.5;
  }
}

class Faller extends Particle
{
  public Faller(PVector p)
  {
    super(p);
    
    this.r = random(0, 255);
    this.b = 0;
    this.g = 0;
    
    this.vel = PVector.random2D();
    this.acc = PVector.random2D();
    
    this.subParticle = true;
    this.applyForce(PVector.random2D());
    this.r = random(0, 255);
    this.g = random(0, 255);
    this.lifespan = 200;
    this.size = 2;
  }
}

class Floater extends Particle
{
  public Floater(PVector p)
  {
    super(p);
    
    this.r = random(0, 255);
    this.g = random(0, 255);
    
    this.subParticle = true;
    this.acc = PVector.random2D();
    this.applyForce(PVector.random2D());
    this.lifespan = 175;
    this.noGravity = true;
    this.size = 3;
  }
}

class Trailer extends Particle
{
  // No gravity then fall off
  public Trailer(PVector p)
  {
    super(p);
    
    
  }
}

class Twister extends Particle
{
  // spiral off (affected by gravity)
  public Twister(PVector p)
  {
    super(p);
    
    
  }
}

class Lines extends Particle
{
  // Draw lines to other line particles
  public Lines(PVector p)
  {
    super(p);
  }
}

class Particle
{
  // ######## CLEAN UP PROPERTIES #######
  final static float MAX_SPEED = 0.1; // Remove
  
  PVector vel = new PVector(random(-MAX_SPEED, MAX_SPEED), random(-MAX_SPEED, MAX_SPEED));
  PVector acc = new PVector(0, 0);
  PVector pos;
  
  float size = 2;
  float mass = random(2, 2.5); // TODO: this works i suppose?
  float r, g, b; // Switch to Color()
  int lifespan = 400;
  
  boolean exploded = false; // Remove?
  boolean noGravity = false; // Remove
  boolean randomMovement = false; // Remove
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
       for (int x = 0; x < 75; x++) {
         float chance = random(0, 1);
         if (chance <= 0.25) {
           Randomer r = new Randomer(pos);
           system.randomers.add(r);
           continue;
         } else if (chance <= 0.5f) {
           Floater f = new Floater(pos);
           system.floaters.add(f);
           continue;
         } else {
           Faller fa = new Faller(pos);
           system.fallers.add(fa);
           continue;
         }
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
    ellipse(pos.x, pos.y, size, size);
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
