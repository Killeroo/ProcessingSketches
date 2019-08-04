final int PARTICLE_COUNT = 5000;

PVector[] pos = new PVector[PARTICLE_COUNT];
PVector[] acc = new PVector[PARTICLE_COUNT]; // Remove this, we don't use it here
PVector[] vel = new PVector[PARTICLE_COUNT];

Boolean clicked = false;

// The trick is store structures of arrays as opposed to arrays of structures.

// If you have an array of objects (each storing a position, speed, colour etc) and 
// your process is to go through that array and act on each property, think of how 
// that array of objects would be layed out in memory, your cutting it all up.

// If you want to store stuff efficiently and nicely in memory seperate out the properties
// into their own arrays

// Orders of making things efficient:
// Seperation
// Vectorisation
// Parrellisation

PVector center;

void setup()
{
  size(1000,1000);
  //fullScreen();
  background(0);
  
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    pos[x] = new PVector(random(0, width), random(0, height));
    vel[x] = new PVector(random(-0.5, 0.5), random(-0.5, 0.5));//5);
    acc[x] = new PVector(0, 0);
  }
  
  center = new PVector(width/2, height/2);
  
  fill(255);
  noStroke();
}

void draw()
{
  //background(0);
  noStroke();
  fill(0, 40);
  rect(0, 0, width, height);
  
  // Act on each array seperately as well, otherwise you are still mixing and matching
  // the arrays that are in different parts of memory
  
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    vel[x].add(acc[x]);
  }
  
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    pos[x].add(vel[x]); // accessing vel here, bad!
    
    // Bounds check
    if (pos[x].x < 0) pos[x].x = 1000;
    if (pos[x].x > 1000) pos[x].x = 0;
    if (pos[x].y < 0) pos[x].y = 1000;
    if (pos[x].y > 1000) pos[x].y = 0;
  }
  
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    if (pos[x].dist(new PVector(mouseX, mouseY)) < 50) // accessing pos here, bad!
    {
      
    
      PVector f = PVector.sub(new PVector(mouseX, mouseY), pos[x]); 
      f.normalize();
      f.mult(0.11);
      acc[x] = f;
    }
    else
    {
    
    acc[x].mult(0);
    }
  }
  
  fill(255);
  //stroke(255);
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    if (x % 2 == 0)
      fill(255, 150, 0);
    else
      fill(255);
    
    ellipse(pos[x].x, pos[x].y, 2, 2);
    //point(pos[x].x, pos[x].y);
  }
  
  println("fps: " + frameRate);
}

void mousePressed()
{
  
}
