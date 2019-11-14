final int PARTICLE_COUNT = 5000;

PVector[] pos = new PVector[PARTICLE_COUNT];
PVector[] acc = new PVector[PARTICLE_COUNT]; // Remove this, we don't use it here
PVector[] vel = new PVector[PARTICLE_COUNT];
int[] life = new int[PARTICLE_COUNT];

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
 color c = color(200, 20, 20);
 int noiseScale = 1000;
 float mode = PI;
void setup()
{
  
  size(1000,1000);
  //fullScreen();
  background(0);
  //blendMode(BLEND);
  
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    pos[x] = new PVector(random(0, 200), random(0, height));
    vel[x] = new PVector(random(-1.0, 1.0), random(-1.0, 1.0));
    acc[x] = new PVector(0, 0);
    life[x] = (int) random(10, 500);
  }
  
  center = new PVector(width/2, height/2);
  
  fill(255);
  noStroke();
}

void draw()
{
  
  noiseScale = mouseX;
  println(noiseScale);
  
  //background(0);
  
  noStroke();
  fill(0, 20);
  rect(0, 0, width, height);
  
  // Act on each array seperately as well, otherwise you are still mixing and matching
  // the arrays that are in different parts of memory
  
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    //vel[x].add(acc[x]);
  }
  
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    PVector position = pos[x];
    float angle = noise((position.x/300), (position.y/200)); //noise(position.x/(noiseScale * 2.5), position.y/(noiseScale * 2.5))*HALF_PI*(noiseScale * 2.5);//4000//2500//noise(position.x/map(mouseY, 0, height, 1, 500), position.y/map(mouseX, 0, width, 1, 500)); //200 //50
    vel[x].x = cos(angle);
    vel[x].y = sin(angle);
    //vel[x].mult(1.5);
    vel[x].mult(1.5);//2);
    pos[x].add(vel[x]); // accessing vel here, bad!
    
    //fill(map(angle, 0, 1, 0, 255), map(vel[x].x, 0, 1, 0, 255), map(vel[x].y, 0, 1, 0, 255),life[x]);
            //fill(c, life[x]);
    //ellipse(pos[x].x, pos[x].y, 2, 2);
    
            fill(map(vel[x].x, 0, 1, 0, 255), 0, 120,life[x]);
    ellipse(pos[x].x, pos[x].y, 2, 2);
    
    //acc[x].mult(0);
    /*
    if (life[x] < 0) {
      pos[x] = new PVector(random(width), random(height));  
      life[x] = (int)random(250, 300); // 350, 500
    } else {
      life[x]--;
    }*/

    
    // Bounds check
    if (pos[x].x < 0) pos[x].x = 1000;
    if (pos[x].x > 1000) pos[x].x = 0;
    if (pos[x].y < 0) pos[x].y = 1000;
    if (pos[x].y > 1000) pos[x].y = 0;
  }
  
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    //PVector f = PVector.sub(center, pos[x]); // accessing pos here, bad!
    //f.normalize();
    //f.mult(0.01);
    //acc[x] = f;
    
        //fill(c, life[x]);

    
    //acc[x].mult(0);
    if (life[x] < 0) {
      pos[x] = new PVector(1, random(height));  
      life[x] = (int)random(350, 500);
    } else {
      life[x]--;
    }
    
    //fill(map(angle, 0, 1, 0, 255), map(vel[x].x, 0, 1, 0, 255), map(vel[x].y, 0, 1, 0, 255));


  }
  
  fill(255);
  //stroke(255);
  /*for (int x = 0; x < PARTICLE_COUNT; x++) {
    if (x % 2 == 0)
      fill(255, 150, 0);
    else
      fill(255);
    
    ellipse(pos[x].x, pos[x].y, 2, 2);
    //point(pos[x].x, pos[x].y);
  }
  */
  
  println("fps: " + frameRate);
}

void mousePressed()
{
  noiseSeed(millis());  

  
}
