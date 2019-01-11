import java.util.Iterator;

final float GRAVITY = 0.03; //0.05

ParticleSystem system = new ParticleSystem();

void setup()
{
  size(1000, 1000);  
  system.particles.add(new Particle(new PVector(width/2, height/2)));
}

void draw()
{
  //background(0);
    // Motion blur
  noStroke();
  fill(0, 20);
  rect(0, 0, width, height);
  
  system.update();
}

void mousePressed()
{
  system.add(new Particle(new PVector(mouseX, mouseY)));  
}
class Particle
{
  PVector vel = new PVector(0, 0);
  PVector acc = new PVector(0, 0);
  PVector pos;
  
  float size = 4;
  float mass = random(2, 2.5); // TODO: this works i suppose?
  color c;
  int lifespan = 1000;
  
  boolean subParticle = false;
  boolean exploded = false; // TODO: Find a way to remove this filthy hack
  
  float theta;
  
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
    exploded = true;
  }
  
  public void display()
  {
    fill(c, map(lifespan, 0, 400, 0, 255));
    ellipse(pos.x, pos.y, size, size);
    
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(theta);
    theta += TWO_PI/100;
    ellipse(5, 5, size-2, size-2);
    ellipse(10, 10, size-2, size-2);
    ellipse(25, 25, size-2, size-2);
    popMatrix();
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

class ParticleSystem
{
  // Privatise
  
  ArrayList<Particle> particles = new ArrayList<Particle>();
  
  void add(Particle p) // Change this, or add endpoints for subparticles?
  {
    // Apply some initial upward force
    p.applyForce(new PVector(0, random(-7, -9)));
    particles.add(p);  
  }
  
  void update()
  {  
    this.updateParticles();
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
  
}
