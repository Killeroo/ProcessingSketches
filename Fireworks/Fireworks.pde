import java.util.Iterator;

final float GRAVITY = 0.03; //0.05

// More vairation in movement
//sub sub explosions
// triangles
// Add octopus wandering
// Add more variation to emittion patterns
// Add multicolored ones

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
  ArrayList<Twister> twisters = new ArrayList<Twister>();
  
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
    this.updateFallers();
    this.updateTwisters();
  }
  
  // TODO: Rename
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
      r.vel.limit(2); // TODO: Move limited amount to class
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
      
      //f.vel.limit(1);
      f.move();
      
      if (f.isDead()) {
        i.remove();
      } else {
        f.display();
      }
    }
  }
  
  void updateFallers()
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
  
  void updateTwisters()
  {
    Iterator<Twister> i = twisters.iterator();
    while (i.hasNext()) {
      Twister t = i.next();
      
      t.applyForce(new PVector(0, GRAVITY));
      t.move();
      
      if (t.isDead()) {
        i.remove();
      } else {
        t.display();
      }
    }
  }
}

class Randomer extends Particle
{
  public Randomer(PVector p)
  {
    super(p);  

    this.c = color(random(150, 255), 40, random(0, 150));
    this.subParticle = true;
    this.applyForce(PVector.random2D());
    this.lifespan = 125;
    this.size = 2.5;
  }
}

class Faller extends Particle
{
  public Faller(PVector p)
  {
    super(p);
    
    this.vel = PVector.random2D().limit(random(0.5, 1));//random(1,2));
    this.acc = PVector.random2D().limit(random(0.5, 1));//random(1,2));
    this.c = color(random(75, 125), 0, random(0, 255));
    
    this.subParticle = true;
    this.applyForce(PVector.random2D().limit(random(1,2)));
    this.lifespan = 250;
    this.size = 1;
  }
}

class Floater extends Particle
{
  public Floater(PVector p)
  {
    super(p);
    
    this.c = color(random(200, 255), random(200, 255), 0);
    
    this.subParticle = true;
    this.acc = PVector.random2D();
    this.applyForce(PVector.random2D());
    this.lifespan = 125;
    this.size = 2 ;
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
  float theta;
  float rot;
 
  // spiral off (affected by gravity)
  public Twister(PVector p)
  {
    super(p);
    this.vel = PVector.random2D().limit(random(0.5, 1));//random(1,2));
    this.acc = PVector.random2D().limit(random(0.5, 1));//random(1,2));
    this.c = color(random(75, 125), random(0, 255), random(0, 255));
    this.rot = random(50, 150);
    
    this.subParticle = true;
    this.applyForce(PVector.random2D().limit(random(1,2)));
    this.lifespan = 300;
    this.size = 1;
  }
  
  void display()
  {
    fill(c, map(lifespan, 0, 400, 0, 255));
    
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(theta);
    theta += TWO_PI/rot;
    ellipse(5, 5, size-2, size-2);
    ellipse(-5, -5, size-2, size-2);
    popMatrix();
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
  PVector vel = new PVector(0, 0);
  PVector acc = new PVector(0, 0);
  PVector pos;
  
  float size = 2;
  float mass = random(2, 2.5); // TODO: this works i suppose?
  color c;
  int lifespan = 400;
  
  boolean subParticle = false;
  boolean exploded = false; // TODO: Find a way to remove this filthy hack
  
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
    
    // TODO: Get rid of exploded, HACKS
    if (vel.y > 0 && !exploded && !subParticle) { 
      explode();
    }
    
    // Decrease particle lifespan
    lifespan--;
  }
  
  public void applyForce(PVector force) 
  {
    PVector f = PVector.div(force, mass);
    acc.add(f);
  }
  
  public void explode()
  {
    //FallerEmission(pos);
    //MixedEmission(pos);
    FullEmission(pos);
    exploded = true;
  }
  
  public void display()
  {
    fill(c, map(lifespan, 0, 400, 0, 255));
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

// Emission patters
// (Different ways the fireworks explode)

// Spawn every type of particle
void FullEmission(PVector pos)
{
  int particles = (int) random(100, 200);
  
  for (int x = 0; x < particles; x++) {
    Randomer r = new Randomer(pos);
    Faller fa = new Faller(pos);
    Floater f = new Floater(pos);
    Twister t = new Twister(pos);
    
    system.randomers.add(r);
    system.fallers.add(fa);
    system.floaters.add(f);
    system.twisters.add(t);
  }
}

// Spawn a random mix
void MixedEmission(PVector pos)
{
   for (int x = 0; x < 250; x++) {
     float chance = random(0, 1);
     if (chance <= 0.25) {
       Randomer r = new Randomer(pos);
       system.randomers.add(r);
       continue;
     } else {
       Floater f = new Floater(pos);
       system.floaters.add(f);
       continue;
     } //else {
     //  Faller fa = new Faller(pos);
     //  system.fallers.add(fa);
     //  continue;
     //}
   }
}

// Spawn just fallers
void FallerEmission(PVector pos)
{
  for (int x = 0; x < 500; x++) {
    Faller f = new Faller(pos);
    f.c = color(random(0, 255), random(0, 255), random(0, 255));
    system.fallers.add(f);
  }
}
