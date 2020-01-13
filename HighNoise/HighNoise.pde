final int PARTICLE_COUNT = 5000;

PVector[] pos = new PVector[PARTICLE_COUNT];
PVector[] acc = new PVector[PARTICLE_COUNT]; // Remove this, we don't use it here
PVector[] vel = new PVector[PARTICLE_COUNT];
int[] life = new int[PARTICLE_COUNT];

// Spawn mode
int spawnMode = 0; // 0 = spawn from left and right sides
                   // 1 = spawn from up, down, left and right sides 
                   // 2 = spawn from anywhere
              
//https://www.desmos.com/calculator/l3u8133jwj

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
  
  noiseSeed(10);
  
  for (int x = 0; x < PARTICLE_COUNT; x++) {

    vel[x] = new PVector(random(-1.0, 1.0), random(-1.0, 1.0));
    acc[x] = new PVector(0, 0);
    life[x] = (int) random(10, 500);
  }
  
  center = new PVector(width/2, height/2);
  
  fill(255);
  noFill();
  noStroke();
}

void draw()
{
  
  noiseScale = 255;
  println(noiseScale);
  
  //background(0);
  
  noStroke();
  fill(0, 20);
  rect(0, 0, width, height);
  
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    PVector position = pos[x];
    float angle = noise(position.x/(noiseScale * 2.5), position.y/(noiseScale * 2.5))*HALF_PI*(noiseScale * 2.5);//4000//2500//noise(position.x/map(mouseY, 0, height, 1, 500), position.y/map(mouseX, 0, width, 1, 500)); //200 //50
    vel[x].x = cos(angle);//cos(angle);
    vel[x].y = sin(angle);//sin(angle);
    
    //vel[x].mult(1.5);
    vel[x].mult(0.8);//2);
    pos[x].add(vel[x]); // accessing vel here, bad!
    
    fill(map(angle, 0, 1, 0, 255), map(vel[x].x, 0, 1, 0, 255), map(vel[x].y, 0, 1, 0, 255),life[x]);
    
    if (x == 12)
    {
      println(">angle<" + angle);
      println(">vel.x<" + vel[x].x);
      println(">vel.y<" + vel[x].y);
      ellipse(pos[x].x, pos[x].y, 6, 6);
    }
    else
    {
      ellipse(pos[x].x, pos[x].y, 2, 2);
      //point(pos[x].x, pos[x].y);
    }
    
    //acc[x].mult(0);
    if (life[x] < 0) {
      if (x % 2 == 0) {
        pos[x] = new PVector(random(width), 0);//random(height)); 
      } else {
        pos[x] = new PVector(0, random(height));//random(height)); 
      }
      //pos[x] = new PVector(random(width), 0);//random(height));  
      life[x] = (int) random(450, 900);//random(250, 300); 
    } else {
      life[x]--;
    }

    
    // Bounds check
    if (pos[x].x < 0) pos[x].x = 1000;
    if (pos[x].x > 1000) pos[x].x = 0;
    if (pos[x].y < 0) pos[x].y = 1000;
    if (pos[x].y > 1000) pos[x].y = 0;
  }
  
  println("fps: " + frameRate);
}

void mousePressed()
{
  noiseSeed(millis());  

  
}

PVector GetParticleSpawnPosition(int particleIndex)
{
  PVector pos = new PVector(random(0, width), 0);
  switch (spawnMode)
  {
    case 0:
    {
      pos = new PVector(random(0, width), 0);
    }
    case 1:
    {
      if (particleIndex % 2 == 0) {
        pos = new PVector(random(width), 0);
      } else {  
        pos = new PVector(0, random(height)); 
      }
    }
    case 2:
    {
      pos = new PVector(random(0, width), random(0, height)); 
    }
  }
  return pos;
}
