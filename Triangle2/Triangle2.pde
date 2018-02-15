import java.util.Iterator;

///////////////////////////////////////////////////////////////////
///                        Triangles                            ///
///////////////////////////////////////////////////////////////////
/// Click and drag mouse to create a trail of triangles         ///
///////////////////////////////////////////////////////////////////
// Inspired by: https://www.openprocessing.org/sketch/413567    ///
// Triangles: https://www.openprocessing.org/sketch/147268      ///
// Particle system: https://www.openprocessing.org/sketch/116931///
///////////////////////////////////////////////////////////////////

// Slow down

/* Simulation Properties - Edit them! */
//final float MAX_PARTICLES = 100; // ADD
//final float MAX_TRIANGLES = 1000; //500 // ADD
//final float MAX_PARTICLE_SPEED = 1.5;//0.5;// 1.0;
//final float SIZE = 1;//2;
//final float LIFESPAN_DECREMENT = 1.0;//.5; //2.0
//final float MAX_TRI_DISTANCE = 70;//50; //35 //25; 
//final float MIN_TRI_DISTANCE = 20;//15; //10
//final int MAX_PARTICLE_NEIGHBOURS = 10; //5;//10;//5;
//final int MAX_WANDERER_SPEED = 4;//4;
//final int SPAWN_DELAY = 35;//20; //10
//final int PARTICLE_LIFESPAN = 300;

//V 2
//final float MAX_PARTICLES = 500; // ADD
//final float MAX_TRIANGLES = 1000; //500 // ADD
//final float MAX_PARTICLE_SPEED = 1.5;// 1.0;
//final float SIZE = 1;//2;
//final float LIFESPAN_DECREMENT = 1.0;//.5; //2.0
//final float MAX_TRI_DISTANCE = 50;//50; //35 //25; 
//final float MIN_TRI_DISTANCE = 10;//15; //10
//final int MAX_PARTICLE_NEIGHBOURS = 10; //5;//10;//5;
//final int MAX_WANDERER_SPEED = 4;//4;
//final int SPAWN_DELAY = 20; //10
//final int PARTICLE_LIFESPAN = 255;

final float MAX_PARTICLES = 500; // ADD
final float MAX_TRIANGLES = 1000; //500 // ADD
final float MAX_PARTICLE_SPEED = 1.5;// 1.0;
final float SIZE = 1;//2;
final float LIFESPAN_DECREMENT = 1.0;//.5; //2.0
final float MAX_TRI_DISTANCE = 50;//50; //35 //25; 
final float MIN_TRI_DISTANCE = 10;//15; //10
final int MAX_PARTICLE_NEIGHBOURS = 10; //5;//10;//5;
final int MAX_WANDERER_SPEED = 4;//4;
final int SPAWN_DELAY = 20; //10
final int PARTICLE_LIFESPAN = 255;

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
  size(500, 600, P2D);
  frameRate(60);
  noStroke();
  smooth();
}

void draw()
{
  background(255);
  
  println("Particles: " + system.particles.size());
  println("Triangles: " + triangles.triangles.size());
  
  // Clear Triangles
  triangles.clear();
  
  // Move spawner
  spawner.update();
  
  // Add particles at spawner location
  system.addParticle(new PVector(spawner.loc.x, spawner.loc.y));
 
  // Update our particle and triangle systems each frame
  system.update();
  triangles.display();
  
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