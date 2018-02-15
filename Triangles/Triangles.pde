import java.util.Iterator;

// Inspired by: https://www.openprocessing.org/sketch/413567
// Triangles: https://www.openprocessing.org/sketch/147268
// Particle system: https://www.openprocessing.org/sketch/116931

// Move 2 triangles classes
// and discovery neighbbours part from update

/* PARTICLE PROPERTIES */
final float MAX_SPEED = 1.5;// 1.0;
final float BOUNCE = -0.5;
final float SIZE = 4;
final float LIFESPAN_DECREMENT = 2.0;
final float MAX_DISTANCE = 35; //25;

ParticleSystem system = new ParticleSystem();
ColourGenerator colour = new ColourGenerator();
float posX, posY;
int mode = 1; // Drawing mode

int triCount = 0;

void setup()
{
  size(500, 600, P2D);
  noStroke();
}

void draw()
{
  background(255);
 
  // Update our particle system each frame
  system.update();
}

void keyPressed()
{
  mode++; // Change display mode
  
  if (mode == 3)
  {
    mode = 1;
  }
}

void mousePressed()
{
  posX = mouseX;
  posY = mouseY;
  
  system.addParticle(new PVector(posX, posY));
}

void mouseDragged()
{
  posX = mouseX;
  posY = mouseY;
  
  system.addParticle(new PVector(posX, posY));
}

class ParticleSystem
{
  ArrayList<Particle> particles = new ArrayList<Particle>();
  ArrayList<Triangle> triangles = new ArrayList<Triangle>();
  
  ParticleSystem() { }
  
  void addParticle(PVector loc)
  {
    particles.add(new Particle(loc));
  }
  
  // Move to triangles class?
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
          // Create new triangle for each neighbour (always use the particle itself as part of the triangle)
          triangles.add(new Triangle(neighbours.get(0).pos, neighbours.get(i).pos, neighbours.get(j).pos));
        }
      }
    }
  }
  
  // Move to triangles class?
  void drawTriangles()
  {
    noStroke();
    //fill(max(colour.R - 15, 0), max(colour.G - 15, 0), max(colour.B, 0), 13);
    
    if (mode == 1)
    {
      stroke(max(colour.R - 15, 0), max(colour.G - 15, 0), max(colour.B, 0), 13);
    }
    else if (mode == 2)
    {
      fill(max(colour.R - 15, 0), max(colour.G - 15, 0), max(colour.B, 0), 13);
    }
    
    noFill();
    
    beginShape(TRIANGLES);
    for (int i = 0; i < triangles.size(); i++)
    {
      Triangle t = triangles.get(i);
      t.display();
    }
    endShape();
  }
  
  void update()
  {
    // Clear triangles
    triangles = new ArrayList<Triangle>();
    
    // Use an iterator to loop through active particles
    Iterator<Particle> i = particles.iterator();
    
    while(i.hasNext())
    {
      // Get next particle
      Particle p = i.next();
      
      // update position and lifespan
      p.move();
      
      // Remove particle if dead
      if (p.isDead())
      {
        i.remove();
      }
      else
      {
        p.display();
      }
    }
    
    colour.update();
    
    // Move below to discovery neighbours method
    Particle p1, p2;
    
    // Work out neighbours/triangles for each particle
    for (int x = 0; x < particles.size(); x++)//Particle p1 : particles)
    {
      p1 = particles.get(x);
      
      // Clear neighbours
      p1.neighbours = new ArrayList<Particle>();
      
      // Add particle itself to list of its neighbours (so traingles form using this particle)
      p1.neighbours.add(p1);
      
      // For other particles
      for (int y = x + 1; y < particles.size(); y++)
      {
        p2 = particles.get(y);
        
        float distance = PVector.dist(p1.pos, p2.pos);
        
        // If particle is within max distance 
        if (distance > 0 && distance < MAX_DISTANCE)
        {
          // Add to neighbours
          p1.neighbours.add(p2);  
        }
      }
      if (p1.neighbours.size() > 1)
      {
        triCount++;
        if (triCount < 64) {
        // Add neighbours/triangles to global triangles arraylist
        addTriangles(p1.neighbours);  
        }
      }
    }
    
    print(triCount + "\n");
    
    triCount = 0;
    
    // Draw Triangles
    drawTriangles();
  }
}

class Particle
{
  PVector velocity = new PVector(random(-MAX_SPEED, MAX_SPEED), random(-MAX_SPEED, MAX_SPEED));
  PVector pos;
  int lifespan = 255;
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
    
    // Decrease particle lifespan
    lifespan -= LIFESPAN_DECREMENT;
  }
  
  void display()
  {
    //colour.update();
    noFill();
    fill(colour.R, colour.G, colour.B, lifespan);
    ellipse(pos.x, pos.y, SIZE, SIZE);
  }
  
  boolean isDead()
  {
    if (lifespan < 0)
    {
      return true;
    }
    else
    {
      return false;
    }
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
    Rspeed = ((B += Bspeed) > 255 || (B < 0)) ? -Bspeed : Bspeed;
  }
  
}