PVector[] pos = new PVector[10000];
PVector[] acc = new PVector[10000];
PVector[] vel = new PVector[10000];

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

void setup()
{
  size(1000,1000);
  //fullScreen();
  
  for (int x = 0; x < 10000; x++) {
    pos[x] = new PVector(random(0, width), random(0, height));
    vel[x] = new PVector(random(-1.0, 1.0), random(-1.0, 1.0));
    acc[x] = new PVector(0, 0);
  }
  
  fill(255);
}

void draw()
{
  //background(255);
  noStroke();
  fill(0, 20);
  rect(0, 0, width, height);
  
  // Act on each array seperately as well, otherwise you are still mixing and matching
  // the arrays that are in different parts of memory
  
  for (int x = 0; x < 10000; x++) {
    vel[x].add(acc[x]);
  }
  
  for (int x = 0; x < 10000; x++) {
    pos[x].add(vel[x]);
  }
  
  for (int x = 0; x < 10000; x++) {
    acc[x].mult(0);
  }
  
  fill(255);
  for (int x = 0; x < 10000; x++) {
    ellipse(pos[x].x, pos[x].y, 2, 2);
  }
}
