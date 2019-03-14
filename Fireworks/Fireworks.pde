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
  size(1000, 1000);  
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
    interval = millis() + 2000;//2500;
  }
}


class ParticleSystem
{
  ArrayList<Particle> particles = new ArrayList<Particle>();
  
  // All sub particles
  ArrayList<Randomer> randomers = new ArrayList<Randomer>();
  ArrayList<Floater> floaters = new ArrayList<Floater>();
  ArrayList<Faller> fallers = new ArrayList<Faller>();
  ArrayList<Twister> twisters = new ArrayList<Twister>();
  ArrayList<Sparkler> sparklers = new ArrayList<Sparkler>();
  ArrayList<Trailer> trailers = new ArrayList<Trailer>();
  
  void add(Particle p) // Change this, or add endpoints for subparticles?
  {
    // Apply some initial upward force
    p.applyForce(new PVector(0, random(-10, -30)));
    particles.add(p);  
  }
  
  void update()
  {  
    this.updateParticles();
    
    this.updateRandomers();
    this.updateFloaters();
    this.updateFallers();
    this.updateTwisters();
    this.updateSparklers();
    this.updateTrailers();
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
      
      f.vel.limit(2);
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
  boolean exploded = false;
  
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
    CompleteEmission(pos);
    
    //FallerEmission(pos);
    //MixedEmission(pos);
    //FullEmission(pos);
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
  int particles = (int) random(100, 400);
  
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
       f.c = color(random(0, 255), random(0, 255), random(0, 255));
       system.floaters.add(f);
       //continue;
     } 
   }
}

void SprawlingEmission(PVector pos)
{
  int particles = (int) random(400, 500);
  int red = int(random(0, 255));
  int green = int(random(0, 255));
  int blue = int(random(0, 255));
 
  for (int x = 0; x < particles; x++) {
    Randomer r = new Randomer(pos);
    int new_r = red + (int) random(0, 100);
    int new_g = green + (int) random(0, 100);
    int new_b = blue + (int) random(0, 100);
    r.c = color(new_r, new_g, new_b);
    system.randomers.add(r);
  }
}

// Spawn just fallers
void FallerEmission(PVector pos)
{
  int particles = (int) random(250, 450);
  
  for (int x = 0; x < particles; x++) {
    Faller f = new Faller(pos);
    f.size = 1.5;
    Twister t = new Twister(pos);
    f.c = color(random(0, 255), random(0, 255), random(0, 255));
    t.c = color(random(0, 255), random(0, 255), random(0, 255));
    system.fallers.add(f);
    system.twisters.add(t);
  }
}

void CompleteEmission(PVector pos)
{
  int particles = (int) random(10, 500);
  
  // Switch to using different compbinations of complimentary colours (adobe colour wheel)
  int base_red = (int) random(0, 255);
  int base_green = (int) random(0, 255);
  int base_blue = (int) random(0, 255);
  
  for (int x = 0; x < particles; x++) {
    
    Trailer tr = new Trailer(pos);
    // switched to amplify
    //tr.c = color(base_red, base_green, base_blue);
    tr.c = color(amplify(base_red), amplify(base_green), amplify(base_blue));
    system.trailers.add(tr);
    
    int count = (int) random(1, 6);
    switch(count)
    {
      case 1:
        Randomer r = new Randomer(pos);
        //system.randomers.add(r);
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

float amplify(float n) {
  return constrain(2 * n, 0, 255);
}
