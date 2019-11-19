final int PARTICLE_COUNT = 5000;

PVector[] pos = new PVector[PARTICLE_COUNT];
PVector[] vel = new PVector[PARTICLE_COUNT];
int[] life = new int[PARTICLE_COUNT];

// repel on mouse
float[][] noiseMap = new float[1000][1000];

PVector center;
 color c = color(200, 20, 20);
 int noiseScale = 1000;
 float mode = PI;
void setup()
{
  
  size(1000,1000);
  background(255); //0
  
  // Setup up our particle properties
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    pos[x] = new PVector(random(0, 200), random(0, height));
    vel[x] = new PVector(random(-1.0, 1.0), random(-1.0, 1.0));
    life[x] = (int) random(10, 500);
  }
  
  for (int x = 0; x < 1000; x++) {
    for (int y = 0; y < 1000; y++) {
      noiseMap[x][y] = noise((x/300), (y/200));
    }
  }
  
  // Draw noise map
  for (int x = 0; x < 1000; x++) {
    for (int y = 0; y < 1000; y++) {
      stroke(map(noiseMap[x][y], 0, 1, 0, 255));
      point(x, y);  
    }
  }
  
  fill(255);
  noStroke();
}
int blue_target = 120;
int current_blue = 120;
void draw()
{
  //background(20, 20, 150);
  
  // Motion blur
  noStroke();
  fill(0, 20);
  rect(0, 0, width, height);
  
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    PVector position = pos[x];
    float angle = noise((position.x/300), (position.y/200)); //noise(position.x/(noiseScale * 2.5), position.y/(noiseScale * 2.5))*HALF_PI*(noiseScale * 2.5);//4000//2500//noise(position.x/map(mouseY, 0, height, 1, 500), position.y/map(mouseX, 0, width, 1, 500)); //200 //50
    vel[x].x = cos(angle);
    vel[x].y = sin(angle);
    //vel[x].mult(1.5);
    vel[x].mult(1.5);//2);
    
    // Add repel force please
    if (((pos[x].x - mouseX) < 50 &
        (pos[x].y - mouseY) < 50) &&
        (mouseX - pos[x].x) > 50) {
      //vel[x].mult(10);  
    }
    pos[x].add(vel[x]); // accessing vel here, bad!
    
    // The one:
    fill(map(vel[x].y, 0, 1, 0, 255), map(pos[x].x, 0, 500, 0, 255), current_blue, life[x]);
    
    //fill(map(angle, 0, 1, 0, 255), life[x]);//,0,0);//, 15);
    
    /* float theta = vel[x].heading() + radians(90);
    pushMatrix();
    translate(pos[x].x, pos[x].y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -2.0*2);
    vertex(-2.0, 2.0*2);
    vertex(2.0, 2.0*2);
    endShape();
    popMatrix(); */
    ellipse(pos[x].x, pos[x].y, 2, 2);
    
    //println(vel[x].x + " " +vel[x].y);
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
    if (life[x] < 0) {
      pos[x] = new PVector(1, random(height));  
      life[x] = (int)random(350, 500);
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
