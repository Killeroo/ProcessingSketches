// Long term:
// TODO: Setup constants and properties
// TODO: Add trails & other effects (like that app - data wing)
// TODO: Add velocity colouring
// TODO: Add obstacles (Continous enviroment?)
// TODO: Add predators (https://www.openprocessing.org/sketch/127609)

// Short term:
// Implement predator
// Implement repel foce (do we need mass?)
// Add colour to boids
// Condense and clean up comments (add summary at start of each function

// Add a system to hold the pack and the flock

final int BOID_COUNT = 10;//150;

// Overview:
//http://www.vergenet.net/~conrad/boids/pseudocode.html
// Nice predator example:
//https://www.openprocessing.org/sketch/127609

Flock flock; // Flock of boids
Pack pack; // Pack of predators

void setup()
{
  size(1000, 1000);
  flock = new Flock();
  pack = new Pack();
  
  // Add initial boids
  for (int i = 0; i < BOID_COUNT; i++) { // TODO: Constants?
    flock.addBoid(new Boid(width/2, height/2));
  }
  
  pack.predators.add(new Predator(width/2, height/2));
}

void draw()
{
  fill(0, 10); // 50
  rect(0, 0, width, height);
  //background(50, 50);
  pack.run();
  flock.run();
}

class Predator extends Boid {
  public Predator(float x, float y)
  {
    super(x, y);
    
    r = 4.0;
    maxspeed = 2.5;
    maxforce = 0.03;
    
    
    colour = color(200, 20, 20);
  }
}

// TODO: Trim comments
// TODO: Reorder boid functions
// Implementation of Boids based off 'Flocking' by Daniel Shiffman
// https://processing.org/examples/flocking.html
class Boid
{
  PVector pos;
  PVector vel;
  PVector acc;
  
  color colour;
  
  float r;
  // TODO: Constants?
  float maxforce;
  float maxspeed;

  Boid(float x, float y)
  {
    // Setup initial state
    acc = new PVector(0, 0);
    
    float angle = random(TWO_PI);
    vel = new PVector(cos(angle), sin(angle));
    
    //vel = PVector.random2D();
    pos = new PVector(x, y);
    
    r = 2.0;
    maxspeed = 2;
    maxforce = 0.03;
    
    colour = color(20, 200, 20);
  }
  
  // Run boid routines
  void run(ArrayList<Boid> boids)
  {
    flock(boids);
    update();
    borders();
    render();
  }
  
  // Apply force to boid
  void applyForce(PVector force)
  {
    acc.add(force);  
  }
  
  void repelForce(PVector source, float range)
  {
    float forceScale = 2; // Make property of boid
    
    PVector repel = new PVector();
    float d = PVector.sub(source, pos).mag();
    if (d != 0 && d <= range) { // If there is a force 
      repel = PVector.sub(pos, source);
      repel.normalize();
      repel.mult(map(d, range, 0, 0, forceScale * 150));
    }
    applyForce(repel);
  }
  
  // Accumulate acceleration based on three rules
  void flock(ArrayList<Boid> boids)
  {
    PVector sep = seperate(boids); // Seperation
    PVector ali = align(boids);    // Alignment
    PVector coh = cohesion(boids); // Cohesion
    
    // Arbitrarily weight values
    sep.mult(1.6);
    ali.mult(1.0);
    coh.mult(1.0);
    
    // Add force vectors to acceleration of boid
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }
  
  // Update position of boid
  void update()
  {
    // Update velocity
    vel.add(acc);
    // Limit speed
    vel.limit(maxspeed);
    pos.add(vel);
    // Reset acceleration
    acc.mult(0);
  }
  
  // Borders check (wrap around)
  void borders()
  {
    if (pos.x < -r) pos.x = width+r;
    if (pos.y < -r) pos.y = height+r;
    if (pos.x > width+r) pos.x = -r;
    if (pos.y > height+r) pos.y = -r;
  }
  
  void render()
  {
    // Draw triangle rotated in the direction of boid velocity
    //float theta = vel.heading2D() + radians(90);
    float theta = vel.heading() + radians(90);
    
    fill(colour, 100);//200, 100);
    stroke(255);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }
  
  // Seperation
  // Method checking for nearby boids and steers away from them
  PVector seperate(ArrayList<Boid> boids)
  {
    float desiredSeperation = 25.0f; // TODO: Constants?
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    
    // Foreach boid check if too close
    for (Boid other : boids) {
      float distance = PVector.dist(pos, other.pos);
      if ((distance > 0) && (distance < desiredSeperation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(pos, other.pos);
        diff.normalize();
        diff.div(distance);
        steer.add(diff);
        count++;
      }
    }
    
    // Divide by how many close calls
    if (count > 0) {
      steer.div((float)count);  
    }
    
    // Steer aslong as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.setMag(maxspeed);
      steer.sub(vel);
      steer.limit(maxforce);
    }
    
    return steer;
  }
  
  // Alignment
  // For every boid, calculate the average velocity (and match it)
  PVector align(ArrayList<Boid> boids) 
  {
    float neighbourDist = 50; // TODO: Constants?
    PVector sum = new PVector(0, 0);
    int count = 0;
    
    for (Boid other : boids) {
      float distance = PVector.dist(pos, other.pos);
      if ((distance > 0) && (distance < neighbourDist)) {
        sum.add(other.vel);
        count++;
      }
    }
    
    if (count > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      sum.setMag(maxspeed);
      PVector steer = PVector.sub(sum, vel);
      steer.limit(maxforce);
      return steer;
    } else {
      return new PVector(0, 0);
    }
  }
  
  // Cohhesion
  // For average position (the center) of all nearby boids and steer towards it
  PVector cohesion(ArrayList<Boid> boids)
  {
    float neighbourDist = 50; // TODO: Constants?
    PVector sum = new PVector(0, 0);
    int count = 0;
    
    for (Boid other : boids) {
      float distance = PVector.dist(pos, other.pos);
      if ((distance > 0) && (distance < neighbourDist)) { // All nearby boids
        sum.add(other.pos); // Add position
        count++;
      }
    }
    
    if (count > 0) {
      sum.div(count); // workout average
      return seek(sum); // Steer toward position
    } else {
      return new PVector(0, 0);  
    }
  }
  
  // Method that calculates and applies steering force towards a target
  PVector seek(PVector target) 
  {
    // Vector pointing towards target
    PVector desired = PVector.sub(target, pos); 
    
    // Scale to maxspeed
    desired.setMag(maxspeed);
    
    // Steering = desired - velocity
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxforce);
    return steer;
  }
}

// The 'Flock' (a list of boids)
class Flock
{
  ArrayList<Boid> boids; // Contains all boids
  
  Flock()
  {
    boids = new ArrayList<Boid>();
  }
  
  // Run each boid individually
  void run()
  {
    for (Boid b : boids) {
      for (Predator predator : pack.predators) {
        // b.repelForce(predator.pos, 80); NOT WORKING, REDO REPELFORCE TO WORK WITH OUR SYSTEM. 
      }
      b.run(boids);
    }
  }
  
  void addBoid(Boid b)
  {
    boids.add(b);  
  }
}

// Inherit from flock?
class Pack
{
  ArrayList<Predator> predators;
  
  Pack()
  {
    predators = new ArrayList<Predator>();
  }
  
  void run()
  {
    for (Predator p : predators) {
      p.run(flock.boids);  
    }
  }
}
