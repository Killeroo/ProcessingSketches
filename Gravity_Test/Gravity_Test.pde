import java.util.Iterator;

final float GRAVITY = 0.6;

ParticleSystem system = new ParticleSystem();


void setup()
{
  size(300, 300);  
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
      p.applyForce(new PVector(0, 0.6));
      
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
  
  PVector velocity = new PVector(random(-MAX_SPEED, MAX_SPEED), random(-MAX_SPEED, MAX_SPEED));
  PVector acceleration = new PVector(0, 0);
  PVector pos;
  
  float mass = random(0.1, 2.0);
  int lifespan = 255;
  
  Particle(int x, int y)
  {
    pos = new PVector (x, y);
  }
  
  public void move()
  {
    velocity.add(acceleration); // Apply acceleration
    pos.add(velocity); // Apply our speed vector
    acceleration.mult(0);
    
    // Boundary check
    if (pos.x < 0) {
      pos.x = 0;
      velocity.x *= BOUNCE;
    } else if (pos.x > width) {
      pos.x = width;
      velocity.x *= BOUNCE;
    }
    if (pos.y < 0) {
      pos.y = 0;
      velocity.y *= BOUNCE;
    } else if (pos.y > height) {
      pos.y = height;
      velocity.y *= BOUNCE;
    }
    
    lifespan--;
  }
  
  public void applyForce(PVector force) 
  {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }
  
  public void display()
  {
    fill(255, 0, 0, lifespan);
    
    ellipse(pos.x, pos.y, mass * 4, mass * 4);
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
