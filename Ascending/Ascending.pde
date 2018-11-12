import java.util.Iterator;

final float GRAVITY = -0.1;

ParticleSystem system = new ParticleSystem();

// TODO: Culling

void setup()
{
  size(500, 500);  
}

void draw()
{
  background(0);
  
  system.update();
}

void mouseDragged()
{
    
  ellipse(mouseX, mouseY, 3, 4);
  
  system.particles.add(new Particle(mouseX, mouseY));
}

class ParticleSystem
{
  ArrayList<Particle> particles = new ArrayList<Particle>();
  
  void update()
  {
    Iterator<Particle> i = particles.iterator();
    
    while (i.hasNext()) {
      Particle p = i.next();
      
      // Apply gravity
      p.applyForce(new PVector(0, GRAVITY));
      
      p.move();
      
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
  float size = random(0.1, 2.0);
  float r, g, b;
  int lifespan = 255;
  
  Particle(int x, int y)
  {
    pos = new PVector (x, y);
    acc = new PVector (random(0.1, 1.5), 0);
    r = random (100, 255);
    g = random (0, 50);
    b = 0;
  }
  
  public void move()
  {
    vel.add(acc); // Apply acceleration
    pos.add(vel); // Apply our speed vector
    acc.mult(0);
    
    // Boundary check
    if (pos.x < 0) {
      //pos.x = 0;
      //velocity.x *= BOUNCE;
    } else if (pos.x > width) {
      //pos.x = width;
      //velocity.x *= BOUNCE;
    }
    if (pos.y < 0) {
      //pos.y = 0;
      //velocity.y *= BOUNCE;
    } else if (pos.y > height) {
      //pos.y = height;
      //velocity.y *= BOUNCE;
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
    fill(r, g, b, lifespan);
    
    ellipse(pos.x, pos.y, size * 4, size * 4);
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
