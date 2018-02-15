import java.util.Iterator;

////////////////////////////////////////////////////////////////////////////////////
///                                   Flow 2                                     ///
////////////////////////////////////////////////////////////////////////////////////
/// Particle system where particles are attracted to one another, collide and    ///
/// randomly explode.                                                            ///
////////////////////////////////////////////////////////////////////////////////////
// Sources:
// - Particles Inspiration : https://www.openprocessing.org/sketch/147268
// - Colour explosion effects : https://www.openprocessing.org/sketch/100893
// - https://www.openprocessing.org/sketch/100893 (old style colour look)

/* PARTICLE PROPERTIES */
final Boolean COLLISIONS = true; // If particles will collided with one another
final Boolean EXPLOSIONS = true; // If particles will explode when they get to certain size
final int MAX_PARTICLES = 75;
final int SIZE_MULTIPIER = 8;
final int EXPLOSION_RADIUS = 50;
final float MAX_SPEED = 1.5;
final float MAX_MASS = 2.5;
final float STARTING_MASS = 0.25;
final float BOUNCE = -0.5;
final float EXPLOSION_FORCE = 1.0;

/* SIMULATION PROPERTIES */
final float GRAVITY = 0.15; // 0.2 
final int EXPLOSION_DELAY = 2000; // ms (2000 = 2 seconds)

// Refactor

// Add more explosion constants
// Add colision trajectory change (look at example)
// Add option to remove noStroke at end of explosion

//ArrayList<Particle> particles = new ArrayList<Particle>();
//Explosion[] explosions_a = new Explosion[20];

ParticleSystem system = new ParticleSystem();

Particle attractor = new Particle();
Boolean dragging = false;
int backgroundMode = 1;
int time;

void setup() 
{
  // Initialize particle system
  system.init();
  
  size(600, 500, P2D);
  noStroke();
  time = millis();
  attractor.velocity = new PVector(); // Zero velocity of attractor
  attractor.mass = 20.0;
}

void draw() 
{
  fill(50);
  text("Flow (V1.2)", 10, 20);
  
  // Draw background
  drawBackground();
  
  // Update particle system
  system.update();
}

float amplify(float n) {
  return constrain(2 * n, 0, 255);
}

void drawBackground()
{
  switch (backgroundMode) {
    case 1:
      // Motion blur with black background
      fill(0, 30); //20
      rect(0, 0, width, height);
      fill(0);
      break;
    case 2:
      // Motion blur with white background
      fill(255, 20);
      rect(0, 0, width, height);
      fill(0);
      break;
    case 3:
      // Clear
      background(255);
      break;
    case 4:
      // No background
      break;
  }
}

class ParticleSystem
{
  ArrayList<Particle> particles = new ArrayList<Particle>();
  ArrayList<Explosion> explosions = new ArrayList<Explosion>();
  
  ParticleSystem() { }
  
  void init()
  {
    // Fill arraylist with particles
    for (int x = 0; x < MAX_PARTICLES; x++) { 
      particles.add(new Particle()); 
    }
  }
  
  void update()
  {
    // Use iterator to modify list while reading it
    Iterator<Explosion> i = explosions.iterator(); 
    
    // For every particle
    for (Particle p1 : particles) {
      
      // If particle has collided, dont act on it
      if (p1.collided) { continue; } 
      
      // Check if particle has collided with any other particle (still a bit large for bigger particles)
      if (COLLISIONS) { detectCollision(p1); }
      
      // Apply gravitational pull of other particles
      applyForces(p1);
      
      // Move and display particle
      p1.move();
      p1.display();
    } 
    
    // For every explosion
    while (i.hasNext()) {
      // Get next explosion
      Explosion ex = i.next();
      
      // Update explosion
      ex.update();
      
      // if not dead Display explosion 
      if (ex.isDead()) {
        i.remove();
      } else {
        ex.display();
      }
    }
  
    // If mouse is being dragged attract all particles
    if (dragging) {
      for (Particle part : particles) {
        PVector force = attractor.attract(part);
        part.applyForce(force);
      }
    }
  
    // Randomly explode large particles every x milliseconds
    if (millis() > time + EXPLOSION_DELAY && EXPLOSIONS) {
      for (Particle p1 : particles) {
        explodeParticle(p1);  
      }
      time = millis();
    }
  }
  
  // Randomly explode a given particle
  void explodeParticle(Particle p1)
  {
    // Check particle is above certain size
    if (p1.mass > (STARTING_MASS * 4)) {
      // Roll the dice!
      if (int(random(1, 11)) > 5) {
        // Create a new explosion
        Explosion ex = new Explosion(p1.pos.x, p1.pos.y, p1.colour, p1.velocity.heading());
        
        // Display initial explsion
        ex.init(); 
        
        // Explode particle
        p1.explode(); 
        
        // Add explosion to list
        explosions.add(ex);
      }
    }
  }
  
  // Apply force to a given particle
  void applyForces(Particle p1)
  {
    for (Particle p2 : particles) {
      if (p1 != p2 && p2.collided == false) {
        PVector force = p1.attract(p2);
        p2.applyForce(force);
      }
    }
  }
  
  // Detects any collisions for a given particle
  void detectCollision(Particle p1)
  {
    for (Particle p2 : particles) {
      if (p1 != p2 && p2.collided == false) {
       float distance = PVector.dist(p1.pos, p2.pos);
       if (distance >= 0 && distance <= (p1.mass * SIZE_MULTIPIER)) { // Distance check
         if ((p1.mass + p2.mass) <= MAX_MASS) { // Size check
           p2.collided = true;
           p1.collide(p2);
         }
       }
      }
    }
  }
}

class Particle
{
  ColourGenerator colour = new ColourGenerator();
  PVector acceleration = new PVector(0, 0);
  PVector velocity = new PVector(random(-MAX_SPEED, MAX_SPEED), random(-MAX_SPEED, MAX_SPEED));
  PVector pos;
  float mass = STARTING_MASS;
  Boolean collided = false;
  
  Particle()
  {
    pos = new PVector(random(width), random(height)); // Start at random location
  }
  
  void move()
  {
    // Apply our acceleration and speed vector
    velocity.add(acceleration);
    pos.add(velocity);
    acceleration.mult(0);
    
    // Boundary check
    if (pos.x < 0)
    {
      pos.x = 0;
      velocity.x *= BOUNCE;
    }
    else if (pos.x > width)
    {
      pos.x = width;
      velocity.x *= BOUNCE;
    }
    if (pos.y < 0) 
    {
      pos.y = 0;
      velocity.y *= BOUNCE;
    }
    else if (pos.y > height)
    {
      pos.y = height;
      velocity.y *= BOUNCE;
    }
  }
  
  PVector attract(Particle p)
  {
    PVector force = PVector.sub(this.pos, p.pos); // Calculate distance for force
    float distance = force.mag(); // Distance between particles
    distance = constrain(distance, 5.0, 25.0); // Constrain to avoid extreme results
    force.normalize(); // Normalize, get direction, distance doesnt matter
    
    float strength = (GRAVITY * this.mass * p.mass) / (distance * distance); // Calculate strength of gravitational force
    force.mult(strength); // Apply force to our vector
    return force;
  }
  
  void explode()
  {
    float numParticles = this.mass / STARTING_MASS; // Split the mass based on starting mass (work out num of particles to explode)
    int x = 1; // Skip first particle (it's this)

    // Find 'collided' particles to emit in explosion
    for (Particle part : system.particles) { 
      
      // Stop once we have found enough particles
      if (x >= round(numParticles)) {
        break;
      }
      
      // Found particle to repurpose
      if (part.collided) { 
        part.collided = false;
        part.pos = new PVector(pos.x, pos.y);
        part.velocity = new PVector(random(-EXPLOSION_FORCE, EXPLOSION_FORCE), random(-EXPLOSION_FORCE, EXPLOSION_FORCE));
        part.mass = STARTING_MASS;
        
        // Avoid false hit detection
        for (int y = 0; y < 20; y++) {
          part.move();
        }
        
        x++;
      }
    }
    
    // Avoid false hit detection
    for (int y = 0; y < 20; y++) {
      this.move();
    }
     
    // Reset mass and velocity
    this.mass = STARTING_MASS;
    this.velocity = new PVector(random(-MAX_SPEED, MAX_SPEED), random(-MAX_SPEED, MAX_SPEED)); // Random vector;
  }
  
  void collide(Particle part)
  {
    this.mass += part.mass;
  }
  
  void applyForce(PVector force)
  {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }
  
  void display()
  {
    colour.update();
    noFill();
    fill(colour.R, colour.G, colour.B);//amplify(colour.R), amplify(colour.G), amplify(colour.B));
    ellipse(pos.x, pos.y, this.mass * SIZE_MULTIPIER, this.mass * SIZE_MULTIPIER);
  }
}

class Explosion
{
  ColourGenerator colour;
  PVector pos;
  float angle;
  float size = 1;
  int lifespan = 100;
  
  Explosion(float startX, float startY, ColourGenerator colourGen, float a)
  {
    pos = new PVector(startX, startY);
    colour = colourGen;
    angle = a;
  }
  
  void update()
  {
    size = size+2.80;//++;
    lifespan--; 
  }
  
  // Display initial explosion details
  void init()
  {
    // Draw some lines emitting from explosion
    for (int y = 0; y < 12; y++) {
      float x2, y2;
      
      x2 = pos.x + random(-40, 40);
      y2 = pos.y + random(-40, 40);
      
      stroke(amplify(colour.R), amplify(colour.G), amplify(colour.B));//255);
      //line(pos.x, pos.y, x2, y2);
      noStroke();
    }
    
    // Draw initial white explosion
    pushMatrix();
    translate(pos.x, pos.y);
    for (int y = 0; y < 10; y++) { //4
      //stroke(amplify(colour.R), amplify(colour.G), amplify(colour.B));
      rotate(radians(25));
      fill(255);
      //ellipse(0, 0, random(10, 15), random(20, 60));//random(40, 100), random(10, 15));//random(12, 48), random(3, 6));
      noStroke();
    }
    popMatrix();
  }
  
  void display()
  { 
    // Draw random shaped ellipses
    pushMatrix();
    translate(pos.x, pos.y);
    for (int y = 0; y < 6; y++) { //4
      //stroke(amplify(colour.R), amplify(colour.G), amplify(colour.B));
      fill(amplify(colour.R), amplify(colour.G), amplify(colour.B), lifespan);// 255 //amplify(colour.R), amplify(colour.G), amplify(colour.B));
      rotate(radians(45));//radians(45));
      //ellipse(0, 0, size / random(5, 6), 4);//random(12, 48), random(3, 6));
      noStroke();
    }
    popMatrix();
    
    // Draw vertical ellipse
    //pushMatrix();
    //translate(pos.x, pos.y);
    //fill(amplify(colour.R), amplify(colour.G), amplify(colour.B), lifespan);// 255 //amplify(colour.R), amplify(colour.G), amplify(colour.B));
    //rotate(radians(angle));//radians(90));
    //ellipse(0, 0, size / 4, 5);//random(12, 48), random(3, 6));
    //noStroke();
    //popMatrix();
    
    // Draw horizontal ellipse
    pushMatrix();
    translate(pos.x, pos.y);
    fill(amplify(colour.R), amplify(colour.G), amplify(colour.B), lifespan);// 255 //amplify(colour.R), amplify(colour.G), amplify(colour.B));
    rotate(angle);//degrees(angle));
    rotate(radians(90));
    //ellipse(0, 0, size / 1.5, 5);//random(12, 48), random(3, 6));
    noStroke();
    popMatrix();
    
    // Draw point at center of explosion
    fill(255, lifespan);//amplify(colour.R), amplify(colour.G), amplify(colour.B), lifespan);
    //ellipse(pos.x, pos.y, (STARTING_MASS * SIZE_MULTIPIER) * 2, (STARTING_MASS * SIZE_MULTIPIER) * 2);// /2
    noStroke();
    
    // Draws halo eminating from explosion
    stroke(amplify(colour.R), amplify(colour.G), amplify(colour.B), lifespan);
    noFill();
    ellipse(pos.x, pos.y, size, size);
    noStroke();
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

class ColourGenerator
{
  final static float MIN_SPEED = 0.2;//7;
  final static float MAX_SPEED = 0.7;//1.5;
  float R, G, B;
  float Rspeed, Gspeed, Bspeed;
  
  ColourGenerator()
  {
    init();
  }
  
  public void init()
  {
    // Random starting colour
    R = random(255);
    G = random(255);
    B = random(255);
    
    // Random transition
    Rspeed = (random(1) > 0.5 ? 1 : -1) * random(MIN_SPEED, MAX_SPEED);
    Gspeed = (random(1) > 0.5 ? 1 : -1) * random(MIN_SPEED, MAX_SPEED);
    Bspeed = (random(1) > 0.5 ? 1 : -1) * random(MIN_SPEED, MAX_SPEED); 
  }
  
  public void update()
  {
    // Random transition (keep within RGB colour range)
    Rspeed = ((R += Rspeed) > 255 || (R < 0)) ? -Rspeed : Rspeed;
    Gspeed = ((G += Gspeed) > 255 || (G < 0)) ? -Gspeed : Gspeed;
    Bspeed = ((B += Bspeed) > 255 || (B < 0)) ? -Bspeed : Bspeed;
  }
}

void mousePressed()
{
  dragging = true;
  attractor.pos.x = mouseX;
  attractor.pos.y = mouseY;
}

void mouseDragged() 
{
  dragging = true;
  attractor.pos.x = mouseX;
  attractor.pos.y = mouseY;
}

void mouseReleased()
{
  dragging = false;  
}

void keyPressed()
{
  if (key == ENTER) {
      backgroundMode++;
      if (backgroundMode == 4) {
      backgroundMode = 0;
    }
  }
}