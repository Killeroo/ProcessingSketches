final int PARTICLE_COUNT = 5000;
final int FONT_SIZE = 20;

PVector[] pos = new PVector[PARTICLE_COUNT];
PVector[] acc = new PVector[PARTICLE_COUNT]; // Remove this, we don't use it here
PVector[] vel = new PVector[PARTICLE_COUNT];
int[] life = new int[PARTICLE_COUNT];

// Spawn mode
int spawnMode = 0; // 0 = spawn from left and right sides
                   // 1 = spawn from up, down, left and right sides 
                   // 2 = spawn from anywhere
              
//https://www.desmos.com/calculator/l3u8133jwj

//String[] options = new String[] {
//  "limit",
//  "gravity",
//  "magnitude",
//  "multiplier",
//  "variance",
//  "stream",
//  "followmouse",
//  "usepoints",
//  "motionblur" 
//};
//int selectedOption = 0;

PVector center;
 color c = color(200, 20, 20);
 int noiseScale = 1000;
 float mode = PI;
 int seed = millis();
 int propertiesTimer;
 
 
Slider test;
 
void setup()
{
  
  size(1000,1000);
  //fullScreen();
  background(0);
  blendMode(BLEND);
  
  textFont(createFont("Consolas", FONT_SIZE));
  
  noiseSeed(10);
  
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    pos[x] = GetParticleSpawnPosition(x);
    vel[x] = new PVector(random(-1.0, 1.0), random(-1.0, 1.0));
    acc[x] = new PVector(0, 0);
    life[x] = (int) random(10, 500);
  }
  
  center = new PVector(width/2, height/2);
  propertiesTimer = millis() + 1500;
  
  test = new Slider(new PVector(15, 15), 100, 50, 10, 50, 0, 100, 50); 
  
  fill(255);
  noFill();
  noStroke();
}

void draw()
{
  
  noiseScale = 255;
  //println(noiseScale);
  
  //background(0);
  
  noStroke();
  fill(0, 20);
  rect(0, 0, width, height);
  
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    PVector position = pos[x];
    float angle = noise(position.x/(noiseScale * 2.5), position.y/(noiseScale * 2.5))*HALF_PI*(noiseScale * 2.5);//4000//2500//noise(position.x/map(mouseY, 0, height, 1, 500), position.y/map(mouseX, 0, width, 1, 500)); //200 //50
    vel[x].x = cos(angle);//cos(angle);
    vel[x].y = sin(angle);//sin(angle);
    
    
    vel[x].mult(0.8);//2);
    pos[x].add(vel[x]); // accessing vel here, bad!
    
    fill(map(angle, 0, 1, 0, 255), map(vel[x].x, 0, 1, 0, 255), map(vel[x].y, 0, 1, 0, 255),life[x]);
    
    if (x == 12)
    {
      //println(">angle<" + angle);
      //println(">vel.x<" + vel[x].x);
      //println(">vel.y<" + vel[x].y);
      ellipse(pos[x].x, pos[x].y, 6, 6);
    }
    else
    {
      ellipse(pos[x].x, pos[x].y, 2, 2);
      //point(pos[x].x, pos[x].y);
    }
    
    //acc[x].mult(0);
    if (life[x] < 0) {
      pos[x] = GetParticleSpawnPosition(x);
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
  
  if (propertiesTimer > millis()) {
    DrawPropertiesWindows();  
  }
  
  //println("fps: " + frameRate);
  test.draw();
}

void mousePressed()
{
  seed = millis();
  propertiesTimer = millis() + 1500;
  noiseSeed(seed);  
  
  if (test.isPressed()) 
  {
    test.pressed = true;  
  }
}

void mouseReleased()
{
  test.pressed = false;  
}

String[] options = new String[] {
  "seed",
  "scale",
  "spawn",
  "multiplier",
  "variance",
  "stream",
  "followmouse",
  "usepoints",
  "motionblur" 
};
int selectedOption = 0;

void DrawPropertiesWindows()
{
  int x = 20;
  int y = 20;
  
  //fill(0);
  //rect(0, 0, 300, 150);
  fill(255);
  text("Noise Properties", x, y); y += FONT_SIZE;
  text("----------------", x, y); y += FONT_SIZE;
  text("seed = " + seed, x, y); y += FONT_SIZE; 
  text("scale = " + noiseScale, x, y); y += FONT_SIZE;
  text("spawn type = " + spawnMode, x, y); y += FONT_SIZE;
}

PVector GetParticleSpawnPosition(int particleIndex)
{
  PVector pos = new PVector(random(0, width), 0);
  switch (spawnMode)
  {
    case 0:
    {
      pos = new PVector(random(0, width), 0);
      println("h");
      break;
    }
    case 1:
    {
      println("h2");
      if (particleIndex % 2 == 0) {
        pos = new PVector(random(width), 0);
      } else {  
        pos = new PVector(0, random(height)); 
      }
      break;
    }
    case 2:
    {
      println("h3");
      pos = new PVector(random(0, width), random(0, height)); 
      break;
    }
    default:
    {
      pos = new PVector(random(0, width), 0);
      break;
    }
    
  }
  return pos;
}


class Slider
{
  PVector sliderPosition = new PVector(0, 0);
  PVector knobPosition = new PVector(0, 0);
  
  int knob_width, knob_height;
  int slider_width, slider_height;
  
  float max, min;
  float value;
  
  boolean pressed;
  
  Slider(PVector p, int sw, int sh, int kw, int kh, float min_value, float max_value, float start_value)
  { 
    slider_width = sw;
    slider_height = sh;
    
    knob_width = kw;
    knob_height = kh;
    
    min = min_value;
    max = max_value;
    value = start_value;
    
    sliderPosition = p;
    determineKnobPosition();
    
  }
  
  void determineKnobPosition() 
  {
    knobPosition.x = map(value, min, max, sliderPosition.x, sliderPosition.x + slider_width);
    knobPosition.y = sliderPosition.y;
  }
  
  void draw()
  { 
   
    
    determineKnobPosition();
    
        float newValue = constrain(mouseX, sliderPosition.x, sliderPosition.x + slider_width);
    if (pressed) {
      knobPosition.x = map(newValue, min, max, sliderPosition.x, sliderPosition.x + slider_width);
    }
    
    // Draw slider bar itself
    if (pressed) {
      fill(255, 0, 0);
    } else {
      fill(255);  
    }
    rect(sliderPosition.x, sliderPosition.y, slider_width, slider_height);
    
    // Draw knob representing our value
    fill(0, 255, 0);
    rect(knobPosition.x - (knob_width/2), knobPosition.y, knob_width, knob_height);
  }
  
  boolean isPressed()
  {
    return (knobPosition.x + knob_width > mouseX)
          && (mouseX >= knobPosition.x)
          && (knobPosition.y+knob_height >= mouseY) 
          && (mouseY >= knobPosition.y);
  }
  
}
