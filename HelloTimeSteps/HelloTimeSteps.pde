// HelloTimeStep (10/4/2020)
// A learning experiment in timesteps and maths, all possible thanks to studying this: https://www.openprocessing.org/sketch/751983 (This man is a genius, give him your money)
// matthewcarney.info [matthewcarney64@gmail.com]

final int PARTICLE_COUNT = 10000; // This can go up to 20k :O

PVector[] pos_and_dir = new PVector[PARTICLE_COUNT]; // Everything in one array for speed
int deltaTime;
int lastFrameMillis;

void setup()
{
  size(1000,1000);
  background(0);
  
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    // x and y position AND direction in one array to cut down on amount of times accessing array
    pos_and_dir[x] = new PVector(random(0, width), random(0, height), random(-1, 1) * random(0.1, 1));
  }
  
  fill(255);
  noStroke();
  
  lastFrameMillis = millis();
  deltaTime = millis();
}

void draw()
{
  //background(0);
  noStroke();
  fill(0, 20);
  rect(0, 0, width, height);
 
  float stepSize = deltaTime * 0.025; // This value adjusts as the framerate goes up
                                      // It's a timestep! :O it allows particle movement to be consistent accross frames 
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    float px = pos_and_dir[x].x;
    float py = pos_and_dir[x].y;
    
    if (px > 1000 || px < 0 || py > 1000 || py < 0)
      continue;
    
    float pdir = pos_and_dir[x].z;
    
    pos_and_dir[x].x += pdir * (sin(py*0.01)*3) * stepSize; // 3 = speed 0.01 = radius
    pos_and_dir[x].y += pdir * (-sin(px*0.01)*3) * stepSize;
    
    stroke(map(abs(px-pos_and_dir[x].x), 0.01, 1, 30, 200), 20, map(abs(px-pos_and_dir[x].x), 0.01, 0.1, 0, 255));
    point(pos_and_dir[x].x, pos_and_dir[x].y);
  }

  // Work out deltatime between frames
  deltaTime = millis() - lastFrameMillis;
  lastFrameMillis = millis();
}
