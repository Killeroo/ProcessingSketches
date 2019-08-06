import java.util.Iterator;

final float GRAVITY = 0.03; //0.05

// TODO:
// -------
// Must:
// -> Dynamic Emission Generation
//    +> Rip out generic Emissions (DONE)
//    +> Wire up emmission triggers in Particle
//    +> Keep some full Emissions
// -> Add functions to generate colour relations of base colours
//    +> Convert HSL then work out colour compliments etc
//    +> Find out how the colour wheels do it
// -> Clean the code
//    +> Add comments and seperators (IN-PROGRESS)
//    +> Rename particles (sparkler -> SparklerParticle)
//    +> Add explanation to what each particle does
//    +> Cleanup base particle class

// Should:
// -> Capitalise function and public variable names 
// -> Can you clean up the ParticleSystem updaters?
// -> Randomised particle gravity
// -> Stop initial upward force being default behaviour (DONE)

// Nice to have:
// -> New particles:
//    +> Octopus wandering
//    +> Explosions within explosions
// -> Make the explosion code less hacky

ParticleSystem system = new ParticleSystem();
int interval = 0;

void setup()
{
  size(1000, 1000);  
}

void draw()
{
  // Motion blur
  noStroke();
  fill(0, 20);
  rect(0, 0, width, height);
  
  // Update the particle system
  system.update();
  
  if (millis() > interval) {
    // Position the particle bottom center
    Particle p = new Particle(new PVector(width/2, height));
    
    // Apply some initial upward force
    p.applyForce(new PVector(0, random(-10, -30)));
    
    // Add to particle system
    system.particles.add(p);
    
    // Interval between fireworks
    interval = millis() + 2000;
  }
}

//////////////////////////////////////////////////////////////////////////////////////
// Particle system
// Controls, displays and updates every particle in the sketch.
// (we do implement some specific behaviours for some particle types here so watch out)
//////////////////////////////////////////////////////////////////////////////////////
class ParticleSystem
{
  // Initial particles
  ArrayList<Particle> particles = new ArrayList<Particle>();
  
  // All sub particles
  ArrayList<RandomMovementParticle> RandomMovementParticles = new ArrayList<RandomMovementParticle>();
  ArrayList<Floater> floaters = new ArrayList<Floater>();
  ArrayList<Faller> fallers = new ArrayList<Faller>();
  ArrayList<Twister> twisters = new ArrayList<Twister>();
  ArrayList<Sparkler> sparklers = new ArrayList<Sparkler>();
  ArrayList<Trailer> trailers = new ArrayList<Trailer>();
  
  void update()
  {  
    // Update every particle in existence
    this.updateBaseParticles();
    this.updateRandomMovementParticles();
    this.updateFloaters();
    this.updateFallers();
    this.updateTwisters();
    this.updateSparklers();
    this.updateTrailers();
  }
  
  // Most update functions 
  void updateBaseParticles()
  {
    // We use an interator so we can modify the contents of the list as we
    // go through it
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
  
  void updateRandomMovementParticles()
  {
    Iterator<RandomMovementParticle> i = RandomMovementParticles.iterator();
    while (i.hasNext()) {
      RandomMovementParticle r = i.next();
      
      r.applyForce(PVector.random2D());
      r.vel.limit(r.limit); 
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
      
      f.vel.limit(f.limit);
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
      
      t.applyForce(new PVector(0, 0.01)); // TODO: Change to 0? 
      t.move();
      
      if (t.isDead()) {
        i.remove();
      } else {
        t.display();
      }
    }
  }
  
  void updateSparklers()
  {
    Iterator<Sparkler> i = sparklers.iterator();
    while (i.hasNext()) {
      Sparkler s = i.next();
      
      if (s.lifespan < 225) {
        
        s.applyForce(new PVector(0, 0.025));
        s.vel.limit(0.5);
      }
      
      s.sparkle();
      s.move();
      
      if (s.isDead()) {
        i.remove();
      } else {
        s.display();
      }
    }
    
  }
  
  void updateTrailers()
  {
    Iterator<Trailer> i = trailers.iterator();
    while (i.hasNext()) {
      Trailer t = i.next();
      
      if (t.lifespan < 175) {
        
        //t.applyForce(new PVector(0, 0.025));//1));//1));//0.05));
        //t.vel.limit(0.5); //1 //0.05);
      } 
      
      t.applyForce(new PVector(0, 0.005));
      t.move();
      
      if (t.isDead()) {
        i.remove();
      } else {
        t.display();
      }
    }
  }
}

//////////////////////////////////////////////////////////////////////////////////////
// Base particle class
// All other particle classes derive from this one
//////////////////////////////////////////////////////////////////////////////////////
class Particle
{
  PVector pos;                       // Position
  PVector vel = new PVector(0, 0);   // Velocity
  PVector acc = new PVector(0, 0);   // Acceleration
  float mass = random(2, 2.5);       // Weight (This adds more variance 

  float size = 2;                    // Draw size of ellipse
  color c;                           // Color
  int lifespan = 400;                // Particle lifespan, decremented every update, particle destroyed when 0
  
  boolean exploded = false;          // This flag stops the firework from exploding again
  boolean subParticle = false;       ///
  
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
    
    float chance = random(0, 1);
    if (chance <= 0.25) {
      //FullEmission(pos);
    } else if ( chance <= 0.5) {
      //FallerEmission(pos); 
    } else { 
      //SprawlingEmission(pos);
      //MixedEmission(pos);  
    }
    
    GenerateDynamicEmission(pos);
    
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

//////////////////////////////////////////////////////////////////////////////////////
// Firework types
// These types all derive from the base particle class, each has its own set of properties
// and movement types
//////////////////////////////////////////////////////////////////////////////////////

// RandomMovementParticle
// As the name sugguests, these have force applied to them randomly meaning they have 
// seperadic acceleration and directional movement
class RandomMovementParticle extends Particle
{
  float limit;
  
  public RandomMovementParticle(PVector p)
  {
    super(p);  
    
    this.limit = 1;
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
    
    this.vel = PVector.random2D().limit(random(3,6));//(0.5, 1));//random(1,2));
    this.acc = PVector.random2D().limit(random(3,6));//(random(0.5, 1));//random(1,2));
    this.c = color(random(0, 200), random(25, 100), random(0, 255));//color(random(75, 125), 0, random(0, 255));
    
    this.subParticle = true;
    this.applyForce(PVector.random2D().limit(random(2,6)));//1, 2)));
    this.lifespan = 250;
    this.size = 1;
  }
}

// TODO: Swap the name between this? (it falls eventually?, maybe have one actually just floats?)
class Floater extends Particle
{
  float limit = 2;
  
  public Floater(PVector p)
  {
    super(p);
    
    this.c = color(random(200, 255), random(200, 255), 0);
    
    this.subParticle = true;
    this.acc = PVector.random2D();
    this.applyForce(PVector.random2D());
    this.lifespan = 175;//125;
    this.size = 3;
  }
}

class Sparkler extends Particle
{
  int r, g, b;
  
  public Sparkler(PVector p, int _r, int _g, int _b)
  {
    super(p);
    
    this.lifespan = 315;
    this.subParticle = true;
    this.vel = PVector.random2D().limit(random(0.25, 0.5));//random(0.5, 1));//random(1,2));
    this.acc = PVector.random2D().limit(random(0.25, 0.5));//random(0.5, 1));//random(1,2));
    
    this.r = _r;
    this.g = _g;
    this.b = _b;
  }

  void sparkle()
  {
    fill(r, b, g, lifespan);
    ellipse(random(pos.x-(5), pos.x+(5)),random(pos.y-(5),pos.y+(5)), random(1,3), random(1,3));
  }
}

// No gravity then fall off
class Trailer extends Particle
{
  public Trailer(PVector p)
  {
    super(p);
    
    this.lifespan = 255;
    this.subParticle = true;
    this.applyForce(PVector.random2D().limit(random(0.1,7)));
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
    this.c = color(random(25, 255), random(75, 125), 0);
    this.rot = random(50, 150);
    
    this.subParticle = true;
    this.applyForce(PVector.random2D().limit(random(1,2)));
    this.lifespan = 250;
    this.size = 2;
  }
  
  void display()
  {
    fill(c, map(lifespan, 0, 400, 0, 255));
    
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(theta);
    theta += TWO_PI/rot;
    ellipse(5, 5, size, size);
    ellipse(-5, -5, size, size);
    popMatrix();
  }
}

//////////////////////////////////////////////////////////////////////////////////////
// Emission functions
// Control the different ways the fireworks explode (What type of particles are used,
// how many are spawned and introduces some variance to their colours, speed and gravity
//////////////////////////////////////////////////////////////////////////////////////

// Spawn every type of particle, pretty generic
void FullEmission(PVector pos)
{
  int particles = (int) random(100, 400);
  
  for (int x = 0; x < particles; x++) {
    RandomMovementParticle r = new RandomMovementParticle(pos);
    Faller fa = new Faller(pos);
    Floater f = new Floater(pos);
    Twister t = new Twister(pos);
    
    system.RandomMovementParticles.add(r);
    system.fallers.add(fa);
    system.floaters.add(f);
    system.twisters.add(t);
  }
}

// Emission with all particle types, uses complimentary colours
void ComplementaryEmission(PVector pos)
{
  int particles = (int) random(10, 500);
  
  // Switch to using different compbinations of complimentary colours (adobe colour wheel)
  int base_red = (int) random(0, 255);
  int base_green = (int) random(0, 255);
  int base_blue = (int) random(0, 255);
  
  for (int x = 0; x < particles; x++) {
    
    Trailer tr = new Trailer(pos);
    tr.c = color(amplify(base_red), amplify(base_green), amplify(base_blue));
    system.trailers.add(tr);
    
    int count = (int) random(1, 6);
    switch(count)
    {
      case 1:
        RandomMovementParticle r = new RandomMovementParticle(pos);
        //system.RandomMovementParticles.add(r);
        break;
      case 2:
        Twister t = new Twister(pos);
        t.c = color(base_red + (int) random(0, 25), base_green + (int) random(0, 25), base_blue);
        system.twisters.add(t);
        break;
      case 3:
        for (int i = 0; i < 5; i++) {
          Faller f = new Faller(pos);
          f.c = color(base_red, (int) random(0, 255), base_blue + (int) random(0, 15));
          system.fallers.add(f);
        }
        break;
      case 4:
        Floater fl = new Floater(pos);
        fl.c = color(base_blue, base_red + (int) random(0, 25), base_green + (int) random(0, 25));
        system.floaters.add(fl);
        break;
      case 5:
        Sparkler s = new Sparkler(pos, base_red, base_green, base_blue);
        s.c = color(base_red, base_blue, base_green);
        system.sparklers.add(s);
    }
  }
}

// Dynamically generates an emission pattern
void GenerateDynamicEmission(PVector pos)
{
  // Base colours to derive everything from
  int base_red = (int) random(0, 255);
  int base_green = (int) random(0, 255);
  int base_blue = (int) random(0, 255);
  
  int iterations = (int) random(2, 6);
  
  for (int x = 0; x < iterations; x++) {
    int choice = (int) random(1, 6);
    int particleCount = 0;
    
    switch(choice) {
      case 1: 
        particleCount = (int) random(50, 150);
        for (int i = 0; i < particleCount; i++) {
          RandomMovementParticle r = new RandomMovementParticle(pos);
          r.c = color(base_red + random(-20, 20), base_blue + random(-20, 20), base_green + random(-20, 20));
          system.RandomMovementParticles.add(r);
        }
        break;
      case 2:
        particleCount = (int) random(25, 175);
        for (int i = 0; i < particleCount; i++) {
          Floater fl = new Floater(pos);
          fl.limit = random(0.5, 2);
          fl.c = color(base_blue, base_red + (int) random(-25, 25), base_green + (int) random(-25, 25));
          system.floaters.add(fl);
        }
        break;
      case 3:
        particleCount = (int) random(50, 150);
        for (int i = 0; i < particleCount; i++) {
          Faller f = new Faller(pos);
          f.c = color(base_red, (int) random(0, 255), base_blue + (int) random(0, 15));
          system.fallers.add(f);
        }
        break;
      case 4:
        particleCount = (int) random(10, 100);
        for (int i = 0; i < particleCount; i++) {
          Twister t = new Twister(pos);
          t.c = color(base_red + (int) random(-50, 50), base_green + (int) random(-50, 50), base_blue);
          system.twisters.add(t);
        }
        break;
      case 5:
        particleCount = (int) random(50, 150);
        for (int i = 0; i < particleCount; i++) {
          Sparkler s = new Sparkler(pos, base_red, base_green, base_blue);
          s.c = color(amplify(base_red), amplify(base_blue), amplify(base_green));
          system.sparklers.add(s);
        }
        break;
      case 6:
        particleCount = (int) random(50, 150);
        for (int i = 0; i < particleCount; i++) {
          Trailer t = new Trailer(pos);
          t.c = color(amplify(base_red), amplify(base_blue), amplify(base_green));
          system.trailers.add(t);
        }
        break;
    }
  }
}

//////////////////////////////////////////////////////////////////////////////////////
// Helper functions
//////////////////////////////////////////////////////////////////////////////////////

// 'Brighten' a given RGB value
float amplify(float n) {
  return constrain(2 * n, 0, 255);
}
