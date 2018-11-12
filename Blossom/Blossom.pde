import java.util.Iterator;

/* Simulation Properties - Edit them! */

final float MAX_PARTICLES = 500; // ADD
final float MAX_TRIANGLES = 1000; //500 // ADD
final float MAX_PARTICLE_SPEED = 0.5;//1.5;// 1.0;
final float SIZE = 2;//2;
final float LIFESPAN_DECREMENT = 1.0;//.5; //2.0
final float MAX_TRI_DISTANCE = 50;//50; //35 //25; 
final float MIN_TRI_DISTANCE = 10;//15; //10
final int MAX_PARTICLE_NEIGHBOURS = 10; //5;//10;//5;
final int MAX_WANDERER_SPEED = 4;//4;
final int SPAWN_DELAY = 20; //10
final int PARTICLE_LIFESPAN = 255;
final boolean MOTION_BLUR = false;

// Simulation Systems
ParticleSystem system = new ParticleSystem();
TriangleSystem triangles = new TriangleSystem();

// Particle spawner
Wanderer spawner = new Wanderer();

/* Global colour object */
ColourGenerator colour = new ColourGenerator();

float posX, posY;

void setup()
{
  background(0);
  //fullScreen();
  size(1000, 1000, P2D);
  frameRate(60);
  noStroke();
  smooth();
  
  // Place spawner in center of screen
  spawner.loc = new PVector(width/2,height/2);
}

void draw()
{
  //if (!MOTION_BLUR)
    //background(0);
  
  //println("Particles: " + system.particles.size());
  //println("Triangles: " + triangles.triangles.size());
  
  // Clear Triangles
  triangles.clear();
  
  // Move spawner
  spawner.update();
  
  // Add particles at spawner location
  system.addParticle(new PVector(spawner.loc.x, spawner.loc.y));
 
  // Update our particle and triangle systems each frame
  system.update();
  //triangles.display();
  
}

float amplify(float n) {
  return constrain(2 * n, 0, 255);
}

//void mouseDragged()
//{
//  posX = mouseX;
//  posY = mouseY;
  
//  system.addParticle(new PVector(posX, posY));
//}

class ColourGenerator
{
  final static float MIN_SPEED = 0.2;
  final static float MAX_SPEED = 0.7;
  float R, G, B;
  float Rspeed, Gspeed, Bspeed;
  
  ColourGenerator()
  {
    init();  
  }
  
  public void init()
  {
    // Starting colour
    R = random(255);
    G = random(255);
    B = random(255);
    
    // Starting transition speed
    Rspeed = (random(1) > 0.5 ? 1 : -1) * random(MIN_SPEED, MAX_SPEED);
    Gspeed = (random(1) > 0.5 ? 1 : -1) * random(MIN_SPEED, MAX_SPEED);
    Bspeed = (random(1) > 0.5 ? 1 : -1) * random(MIN_SPEED, MAX_SPEED);
  }
  
  public void update()
  {
    // Use transition to alter original colour (Keep within RGB bounds)
    Rspeed = ((R += Rspeed) > 255 || (R < 0)) ? -Rspeed : Rspeed;
    Gspeed = ((G += Gspeed) > 255 || (G < 0)) ? -Gspeed : Gspeed;
    Bspeed = ((B += Bspeed) > 255 || (B < 0)) ? -Bspeed : Bspeed;
  }
  
}

class Particle
{
  PVector velocity = new PVector(random(-MAX_PARTICLE_SPEED, MAX_PARTICLE_SPEED), random(-MAX_PARTICLE_SPEED, MAX_PARTICLE_SPEED));
  PVector pos;
  int lifespan = PARTICLE_LIFESPAN;
  //ColourGenerator colour = new ColourGenerator();
  
  // Stores nearby particles, for drawing triangles
  ArrayList<Particle> neighbours;
  
  Particle(PVector origin)
  {
    pos = origin;  
  }
  
  void move()
  {
    // Apply velocity to particle
    pos.add(velocity);
    
    // Wrap around screen
    if (pos.x > width)
      pos.x -= width;
    if (pos.x < 0)
      pos.x += width;
    if (pos.y > height)
      pos.y -= height;
    if (pos.y < 0)
      pos.y += height;
    
    // Decrease particle lifespan
    lifespan -= LIFESPAN_DECREMENT;
  }
  
  void display()
  {
  //  colour.update();
    fill(amplify(colour.R),amplify(colour.B),amplify(colour.G), random(0, 255));
    
    ellipse(random(pos.x-(15), pos.x+(15)),random(pos.y-(15),pos.y+(15)), random(1,3), random(1,3));
    point(random(pos.x-15, pos.x+15),random(pos.y-15,pos.y-15)); 
    point(random(pos.x-15, pos.x+15),random(pos.y-15,pos.y-15)); 
    point(random(pos.x-15, pos.x+15),random(pos.y-15,pos.y-15)); 
  
    noFill();
    fill(colour.R, colour.G, colour.B, lifespan);
    ellipse(pos.x, pos.y, SIZE, SIZE);
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

class ParticleSystem
{
  ArrayList<Particle> particles = new ArrayList<Particle>();
  
  
  ParticleSystem() { }
  
  /* Add a particle to the particle system */
  void addParticle(PVector loc)
  {
    if (particles.size() < MAX_PARTICLES) {
      Particle part = new Particle(loc);
      
      for (int i = 0; i < SPAWN_DELAY; i++) {
        part.move();  
      }
      particles.add(part);
    }
  }
  
  /* Discover and draw triangles between particle neighbours */
  void discoverNeighbours()
  {
    Particle p1, p2;
    
    // Work out neighbours/triangles for each particle
    for (int x = 0; x < particles.size(); x++) {
      p1 = particles.get(x);
      
      // Clear neighbours
      p1.neighbours = new ArrayList<Particle>();
      
      // Add particle itself to list of its neighbours (so traingles form using this particle)
      p1.neighbours.add(p1);
      
      // For other particles
      for (int y = x + 1; y < particles.size(); y++) {
        p2 = particles.get(y);
        
        float distance = PVector.dist(p1.pos, p2.pos);
        
        // If particle is within max distance 
        if (distance > MIN_TRI_DISTANCE && distance < MAX_TRI_DISTANCE)
        {
          // Add to neighbours
          p1.neighbours.add(p2);  
        }
      }
      if (p1.neighbours.size() > 1 && p1.neighbours.size() < MAX_PARTICLE_NEIGHBOURS) {
          triangles.addTriangles(p1.neighbours);
      }
    }
  }
  
  /* Update Particle System */
  void update()
  {

    Iterator<Particle> i = particles.iterator();
    
    // Loop through particles and remove inactive particles
    while(i.hasNext()) {
      // Get next particle
      Particle p = i.next();
      
      // update position and lifespan
      p.move();
      
      // Remove particle if dead
      if (p.isDead()) {
        i.remove();
      } else {
        p.display();
      }
    }
    
    // Update the colour of the particle system
    colour.update();
    
    
    // Discover neighbours and draw triangles
    discoverNeighbours();
    
  }
}

class Triangle
{
  PVector A, B, C;
  
  Triangle(PVector p1, PVector p2, PVector p3)
  {
    A = p1;
    B = p2;
    C = p3;
  }
  
  void display()
  {
    vertex(A.x, A.y);
    vertex(B.x, B.y);
    vertex(C.x, C.y);
  }
}

class TriangleSystem
{
  ArrayList<Triangle> triangles = new ArrayList<Triangle>();
  
  void addTriangles(ArrayList<Particle> neighbours)
  {
    // Takes neighbours of a particle and adds triangles
    int size = neighbours.size();
    
    // Foreach neighbour (if there are over 2 neighbours)
    if (size > 2)
    {
      for (int i = 1; i < size - 1; i++)
      {
        for (int j = i + 1; j < size; j++)
        {
          if (triangles.size() < MAX_TRIANGLES) {
            // Create new triangle for each neighbour (always use the particle itself as part of the triangle)
            triangles.add(new Triangle(neighbours.get(0).pos, neighbours.get(i).pos, neighbours.get(j).pos));
          }
        }
      }
    }
  }
  
  void display() 
  {
    noStroke();
    stroke(max(colour.R, 0), max(colour.G, 0), max(colour.B, 0), 13);// - 15, 0), max(colour.G - 15, 0), max(colour.B, 0), 13);
    fill(amplify(colour.R), amplify(colour.G), amplify(colour.B), 30);
    //noFill();
    
    beginShape(TRIANGLES);
    for (int i = 0; i < triangles.size(); i++)
    {
      Triangle t = triangles.get(i);
      t.display();
    }
    endShape();  
  }
  
  void clear()
  {
    // Clear triangles
    triangles = new ArrayList<Triangle>(); 
  }
  
}

class Wanderer {
  PVector loc;
  PVector vel;
  PVector acc;
  
  float angle;
  
  Wanderer() 
  {
    loc = new PVector(random(width), random(height));
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
  }
  
  void update()
  {
    // Move in random direction with random speed
    angle += random(0, TWO_PI);
    float magnitude = random(0, 1.5); //3
    
    // Work out force 
    acc.x += cos(angle) * magnitude;
    acc.y += sin(angle) * magnitude;
    
    // limit result
    acc.limit(3);
    
    // Add to current velocity
    vel.add(acc);
    vel.limit(MAX_WANDERER_SPEED);//6);
    
    // Appy result to current location
    loc.add(vel);
    
    // Wrap around screen
    if (loc.x > width)
      loc.x -= width;
     if (loc.x < 0)
       loc.x += width;
     if(loc.y > height)
       loc.y -= height;
     if(loc.y < 0)
       loc.y += height;
  }
  
  void display() {
     fill(0);
     ellipse(loc.x, loc.y, 10, 10);
  }
}
