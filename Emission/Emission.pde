import java.util.Iterator;

final int     BACKGROUND_COLOUR = 0;                         // 0 = black, 255 = white
final int     MOTION_BLUR_FACTOR = 15;                       // Lower = more motion blur

final float EXPLOSION_HALO_THICKNESS = 1;                    // Higher = thicker halo
final int   EXPLOSION_HALO_LIFESPAN = 175;                   // How long the halo lasts, lower = fade quicker
final float EXPLOSION_HALO_SPEED_MIN = 2;                    // Lower bound used to generate speed the halo emits from its starting point, higher = faster
final float EXPLOSION_HALO_SPEED_MAX = 4;                    // Upper bound used to generate speed the halo emits from its starting point, higher = faster

final int   FLOATING_PARTICLE_SIZE = 3;                      // Higher = bigger particle
final int   FLOATING_PARTICLE_LIFESPAN = 175;                // Lower = fade faster, higher = last longer
final float FLOATING_PARTICLE_VELOCITY_LIMIT_MIN = 2;      // Lower bound used to generate initial particle velocity
final float FLOATING_PARTICLE_VELOCITY_LIMIT_MAX = 5;        // Upper bound used to generate initial particle velocity

ParticleSystem system = new ParticleSystem();

int interval;
int colorInterval;
int colorSelection = 0;

void setup()
{
  background(BACKGROUND_COLOUR);
  size(1000, 1000);
}

void draw()
{
  // Motion blur
  noStroke();
  fill(BACKGROUND_COLOUR, MOTION_BLUR_FACTOR);
  rect(0, 0, width, height);

  // Update the particle system
  system.update();
  
  
  if (interval < millis()) {
    GenerateExplosion();
    interval = millis() + int(random(750));
  }
  
  if (colorInterval < millis()) {
    colorSelection++;
    if (colorSelection == 5) { colorSelection = 0; }
    
    colorInterval = millis() + 7500 + int(random(10000));
  }
}

void mousePressed() 
{
  GenerateExplosion();
}

void GenerateExplosion()
{
  color haloColor = 0, particleColor = 0;
  switch(colorSelection) 
  {
    case 0:
      haloColor = color(#0D2B52); //left
      particleColor = color(#FFF59E); // right
      break;
    case 1:
      haloColor = color(#ED3D66);
      particleColor = color(#003E83);
      break;    
    case 2:
      haloColor = color(#E6ADCF);
      particleColor = color(#A90636);
      break;
    case 3:
      haloColor = color(#A6D40D);
      particleColor = color(#FFA6D9);
      break;
    case 4:
      haloColor = color(#D94D99);
      particleColor = color(255);
      break;
      
  }
  
  int count = int(random(50, 100));
  for (int i = 0; i < count; i++) {
    system.FloatingParticles.add(new FloatingParticle(new PVector(width/2, height/2), particleColor)); 
  }

  system.Halos.add(new Halo(new PVector(width/2, height/2), haloColor)); 
}

color CMYKtoRGB(int c, int y, int m, int k)
{
  return color(255 * (1 - c / 100) * ( 1 - k / 100), 
    255 * (1 - m / 100) * ( 1 - k / 100), 
    255 * (1 - y / 100) * ( 1 - k / 100));
}

class ParticleSystem
{
  // All sub particles
  ArrayList<FloatingParticle> FloatingParticles = new ArrayList<FloatingParticle>();
  ArrayList<Halo> Halos = new ArrayList<Halo>();

  void update()
  {  
    // Update every particle in existence
    this.updateFloatingParticles();
    this.updateHalos();
  }

  void updateFloatingParticles()
  {
    Iterator<FloatingParticle> i = FloatingParticles.iterator();
    while (i.hasNext()) {
      FloatingParticle f = i.next();


      f.vel.limit(f.limit);
      f.move();

      if (f.isDead()) {
        i.remove();
      } else {
        f.display();
      }
    }
  }

  void updateHalos()
  {
    Iterator<Halo> i = Halos.iterator();
    while (i.hasNext()) {
      Halo h = i.next();

      h.update();

      if (h.isDead()) {
        i.remove();
      } else {
        h.display();
      }
    }
  }
}

class Particle
{
  PVector pos;                       // Position
  PVector vel = new PVector(0, 0);   // Velocity
  PVector acc = new PVector(0, 0);   // Acceleration
  float mass = random(2, 2.5);       // Weight (This adds more variance to movement)

  float size = 2;                    // Draw size of particle
  color c;                           // Color
  int lifespan = 400;                // Particle lifespan, decremented every update, particle destroyed when 0

  boolean exploded = false;          // This flag stops the firework from exploding multiple times
  boolean subParticle = false;       // This flag is used by all derived particle types, it stops them from
  // from exploding the way the initial particle/firework does

  Particle(PVector p)
  {
    pos = new PVector (p.x, p.y); 
    acc = new PVector (random(-0.1, 0.1), 0);
    c = color(255, 255, 255);
  }

  public void move()
  {
    vel.add(acc); // Apply acceleration
    pos.add(vel); // Apply our speed vector to our position 
    acc.mult(0);

    // Decrease particle lifespan
    lifespan--;
  }

  public void applyForce(PVector force) 
  {
    PVector f = PVector.div(force, mass);
    acc.add(f);
  }

  public void display()
  {
    // We dim the colour of the particle as the lifespan decreases 
    fill(c, map(lifespan, 0, FLOATING_PARTICLE_LIFESPAN, 0, 255));
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

class FloatingParticle extends Particle
{
  float limit;

  public FloatingParticle(PVector p, color _c)
  {
    super(p);

    this.c = _c;//color(random(200, 255), random(200, 255), 0);
    this.subParticle = true;
    this.acc = PVector.random2D();
    this.applyForce(PVector.random2D());
    this.limit = random(FLOATING_PARTICLE_VELOCITY_LIMIT_MIN, FLOATING_PARTICLE_VELOCITY_LIMIT_MAX);
    this.lifespan = FLOATING_PARTICLE_LIFESPAN;
    this.size = random(1, FLOATING_PARTICLE_SIZE + 3);
  }
}

class Halo
{
  color c;
  PVector pos;
  float size = EXPLOSION_HALO_THICKNESS;
  float speed;
  int lifespan = EXPLOSION_HALO_LIFESPAN;

  Halo(PVector start, color colour)
  {
    pos = start;
    c = colour;
    speed = random(EXPLOSION_HALO_SPEED_MIN, EXPLOSION_HALO_SPEED_MAX);
  }

  void update()
  {
    size = size + speed;
    lifespan--;
  }

  void display()
  { 
    strokeWeight(6);
    stroke(c, map(lifespan, 0, EXPLOSION_HALO_LIFESPAN, 0, 255));
    noFill();
    ellipse(pos.x, pos.y, size, size);
    noStroke();

    //  for (int i = 0; i < 5; i++) {
    //    float r = random(-2, 2);
    //    stroke(c, map(lifespan, 0, EXPLOSION_HALO_LIFESPAN, 0, 255));
    //    ellipse(pos.x, pos.y, size + int(r), size + int(r));
    //  }
  }

  boolean isDead()
  {
    if (lifespan < 0) {
      return true;
    } else {
      return false;
    }
  }
}
