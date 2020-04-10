//import java.util.Iterator;

//final int PARTICLE_COUNT = 100; 
//PVector[] pos_and_dir = new PVector[PARTICLE_COUNT]; 
//color[] colors = new color[PARTICLE_COUNT];
//int[] size = new int[PARTICLE_COUNT];

//int deltaTime;
//int lastFrameMillis;

//PImage img;

//void setup()
//{
//  size(1000, 1000); 
//  img = loadImage("cover2.jpg");
  
//  image(img, 0, 0);
  
//  for (int x = 0; x < PARTICLE_COUNT; x++) {
//    pos_and_dir[x] = new PVector(random(0, width), random(0, height), random(-1, 1) * random(0.1, 1));
//    colors[x] = get((int)pos_and_dir[x].x, (int)pos_and_dir[x].y); 
//    size[x] = (int) random(2, 5);
//  }
  
//  noStroke();
  
//  lastFrameMillis = millis();
//  deltaTime = millis();
//}

//void draw()
//{
//  //image(img, 0, 0);
  
//  float stepSize = deltaTime * 0.025;//0.025 // This value adjusts as the framerate goes up
//                                      // It's a timestep! :O it allows particle movement to be consistent accross frames 
//  for (int x = 0; x < PARTICLE_COUNT; x++) {
//    float px = pos_and_dir[x].x;
//    float py = pos_and_dir[x].y;
    
//    if (px > 1000 || px < 0 || py > 1000 || py < 0)
//      continue;
    
//    float pdir = pos_and_dir[x].z;
    
//    pos_and_dir[x].x += pdir * (sin(py*0.1)*3) * stepSize; // 3 = speed 0.01 = radius
//    pos_and_dir[x].y += pdir * (-sin(px*0.1)*3) * stepSize;
    
//    //color c = get((int)pos_and_dir[x].x, (int) pos_and_dir[x].y);
//    fill(colors[x]);
//    ellipse(pos_and_dir[x].x, pos_and_dir[x].y, size[x], size[x]);
//  }

//  // Work out deltatime between frames
//  deltaTime = millis() - lastFrameMillis;
//  lastFrameMillis = millis();
//  println(deltaTime);
//}

final int PARTICLE_COUNT = 5000;

PVector[] pos = new PVector[PARTICLE_COUNT];
PVector[] start_pos = new PVector[PARTICLE_COUNT];
PVector[] vel = new PVector[PARTICLE_COUNT];
int[] life = new int[PARTICLE_COUNT];
color[] colors = new color[PARTICLE_COUNT];

PVector center;
color c = color(200, 20, 20);
int noiseScale = 1000;
float mode = PI;
 
PImage img;

//void setup()
//{
//  size(1000, 1000); 
//  img = loadImage("cover2.jpg");
  
//  image(img, 0, 0);
 
 
void setup()
{

  size(1000,1000);
  background(0); //0
  
  img = loadImage("cover2.jpg");
  image(img, 0, 0);
  
  // Setup up our particle properties
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    pos[x] = new PVector(random(0, width), random(0, height));
    start_pos[x] = pos[x];
    vel[x] = new PVector(random(-1.0, 1.0), random(-1.0, 1.0));
    life[x] = (int) random(250, 300);
    colors[x] = get((int)pos[x].x, (int)pos[x].y);
  }
  
  noStroke();
  
}
int blue_target = 120;
int current_blue = 120;
void draw()
{
  //background(20, 20, 150);
  
  // Motion blur
  //noStroke();
  //fill(0, 20);
  //rect(0, 0, width, height);
  
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    PVector position = pos[x];
    float angle = noise((position.x/30), (position.y/20)); //noise(position.x/(noiseScale * 2.5), position.y/(noiseScale * 2.5))*HALF_PI*(noiseScale * 2.5);//4000//2500//noise(position.x/map(mouseY, 0, height, 1, 500), position.y/map(mouseX, 0, width, 1, 500)); //200 //50
    vel[x].x = cos(angle);
    vel[x].y = sin(angle);
    vel[x].mult(1.5);//2);
    
    pos[x].add(vel[x]); // accessing vel here, bad!
    
    // The one:
    fill(colors[x],
      //map(vel[x].y, 0, 1, 0, 255),
      //map(pos[x].x, 0, 500, 0, 255), 
      //current_blue, 
      20);//life[x] < 255 ? life[x] : map(life[x], 400, 0, 0, 255));
    
    ellipse(pos[x].x, pos[x].y, 2, 2);
  }
  
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    if (life[x] < 0) {
      pos[x] = new PVector(start_pos[x].x + random(-300, 0), start_pos[x].y); 
      //new PVector(start_pos[x].x + random(-100, 100), start_pos[x].y + random(-100, 100));
      //new PVector(width/2 + 100 + random(-50, 50), random(0, 1) > 0.5 ? random(0, (height /2) - 100) : random(height/2 + 100, height));
      //width/2 + 100 + random(-50, 50), random(0, height));  
      //new PVector(width/2 + 100 + random(-50, 50), random(0, height));  
      life[x] = (int)random(150, 250);
    } else {
      life[x]--;
    }
  }
  
  if (millis() % 200 == 0) {
    blue_target = (int) random(0, 255);  
  } else {
    if (current_blue < blue_target) {
      current_blue++;  
    } else if (current_blue > blue_target) {
      current_blue--;  
    }
  }
  
  //println("fps: " + frameRate);
}


void mousePressed()
{
  noiseSeed(millis());  
}
