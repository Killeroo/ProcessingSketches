import java.util.Iterator;

final int PARTICLE_COUNT = 100; 
PVector[] pos_and_dir = new PVector[PARTICLE_COUNT]; 
color[] colors = new color[PARTICLE_COUNT];
int[] size = new int[PARTICLE_COUNT];

int deltaTime;
int lastFrameMillis;

PImage img;

void setup()
{
  size(1000, 1000); 
  img = loadImage("cover2.jpg");
  
  image(img, 0, 0);
  
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    pos_and_dir[x] = new PVector(random(0, width), random(0, height), random(-1, 1) * random(0.1, 1));
    colors[x] = get((int)pos_and_dir[x].x, (int)pos_and_dir[x].y); 
    size[x] = (int) random(2, 5);
  }
  
  noStroke();
  
  lastFrameMillis = millis();
  deltaTime = millis();
}

void draw()
{
  //image(img, 0, 0);
  
  float stepSize = deltaTime * 0.025;//0.025 // This value adjusts as the framerate goes up
                                      // It's a timestep! :O it allows particle movement to be consistent accross frames 
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    float px = pos_and_dir[x].x;
    float py = pos_and_dir[x].y;
    
    if (px > 1000 || px < 0 || py > 1000 || py < 0)
      continue;
    
    float pdir = pos_and_dir[x].z;
    
    pos_and_dir[x].x += pdir * (sin(py*0.1)*3) * stepSize; // 3 = speed 0.01 = radius
    pos_and_dir[x].y += pdir * (-sin(px*0.1)*3) * stepSize;
    
    //color c = get((int)pos_and_dir[x].x, (int) pos_and_dir[x].y);
    fill(colors[x]);
    ellipse(pos_and_dir[x].x, pos_and_dir[x].y, size[x], size[x]);
  }

  // Work out deltatime between frames
  deltaTime = millis() - lastFrameMillis;
  lastFrameMillis = millis();
  println(deltaTime);
}
