/////////////////////////////////////////////////////////////////////////////////////
///                                  HighVolume                                   ///
/////////////////////////////////////////////////////////////////////////////////////
///                                                                               ///
/// An experiment to see how many particles can be displayed with acceptable      ///
/// framerate and performance using a technique of unfolding the bare properties  ///
/// of particle objects into simple arrays. These arrays are then accessed        ///
/// separately as to force optimsations as the code gets translated lower down.   ///
///                                                                               ///
/// Its not perfectly executed, I access the velocity array at the same time as   ///
/// the position array on line 68, which isn't good and might degrade perfomance. ///
///                                                                               ///
/// Inspired by a conversation with a games industry veteran graphics programmer  ///
/// Here are some notes from the converations:                                    ///
///                                                                               ///
/// - The trick is store structures of arrays as opposed to arrays of structures. ///
/// - If you have an array of objects (each storing a position, speed, colour etc)///
/// and your process is to go through that array and act on each property, think  ///
/// of how that array of objects would be layed out in memory, your cutting it    ///
/// all up.                                                                       ///
/// - If you want to store stuff efficiently and nicely in memory seperate out    ///
/// the properties into their own arrays                                          ///
/// - Orders of of making efficient graphical code in higher level languages:     ///
///    + Seperation (Unroll objects and accessing their different properties)     ///
///    + Vectorisation                                                            ///
///    + Parrellisation (Thread what you can)                                     ///
///                                                                               ///
/// Hope it is of some interest to someone.                                       ///
///                                                                               ///
/// Written by Matthew Carney (26th Jul 2019)                                     ///
///     [matthewcarney64@gmail.com] [https://github.com/Killeroo]                 ///
/////////////////////////////////////////////////////////////////////////////////////


final int PARTICLE_COUNT = 10000;

// Particle properties split out into their own arrays instead of objects
PVector[] pos = new PVector[PARTICLE_COUNT];
PVector[] vel = new PVector[PARTICLE_COUNT];


void setup()
{
  size(1000,1000);
  //fullScreen();
  background(0);
  
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    pos[x] = new PVector(random(0, width), random(0, height));
    vel[x] = new PVector(random(-1.0, 1.0), random(-1.0, 1.0));
  }
  
  fill(255);
  noStroke();
}

void draw()
{
  //background(0);
  noStroke();
  fill(0, 20);
  rect(0, 0, width, height);
  
  // Act on each array seperately as well, otherwise you are still mixing and matching
  // the arrays that are in different parts of memory
 
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    pos[x].add(vel[x]); // accessing vel here, bad!
    
    // Bounds check
    if (pos[x].x < 0) pos[x].x = 1000;
    if (pos[x].x > 1000) pos[x].x = 0;
    if (pos[x].y < 0) pos[x].y = 1000;
    if (pos[x].y > 1000) pos[x].y = 0;
  }
  
  // Noticed that ellipses are more performant on the desktop version of processing
  // where as points are definitely produce better framerates in processing.js 
  fill(255);
  //stroke(255);
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    if (x % 2 == 0)
      fill(255, 0, 0);
    else
      fill(255);
    
    ellipse(pos[x].x, pos[x].y, 2, 2);
    //point(pos[x].x, pos[x].y);
  }
  
  //println("fps: " + frameRate);
}
