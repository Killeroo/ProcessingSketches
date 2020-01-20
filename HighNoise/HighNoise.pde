final int PARTICLE_COUNT = 5000;
final int FONT_SIZE = 20;

PVector[] pos = new PVector[PARTICLE_COUNT];
PVector[] vel = new PVector[PARTICLE_COUNT];
int[] life = new int[PARTICLE_COUNT];

String[] options = new String[] {
  "scale",
  "spawn",
  "multiplier",
  "mode",
  "motionblur" 
};
int selectedOption = 0;

int spawnMode = 0; // 0 = spawn from left and right sides
                   // 1 = spawn from up, down, left and right sides 
                   // 2 = spawn from anywhere 
int noiseScale = 255;
float mode = PI; // TWO_PI 
int seed = millis();
float multiplier = 0.8;
int propertiesTimer;
 
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
    life[x] = (int) random(10, 500);
  }
  
  propertiesTimer = millis() + 1500;
  
  fill(255);
  noFill();
  noStroke();
}

void draw()
{
  
  
  
  noStroke();
  fill(0, 20);
  rect(0, 0, width, height);
  
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    PVector position = pos[x];
    
    // Get noise direction
    float angle = noise(position.x/(noiseScale * 2.5), position.y/(noiseScale * 2.5))*HALF_PI*(noiseScale * 2.5);//4000//2500//noise(position.x/map(mouseY, 0, height, 1, 500), position.y/map(mouseX, 0, width, 1, 500)); //200 //50
    vel[x].x = cos(angle);//cos(angle);
    vel[x].y = sin(angle);//sin(angle);
    
    // Add to velocity and position
    vel[x].mult(multiplier);//0.8);//2);
    pos[x].add(vel[x]); // accessing vel here, bad!
    
    // Colour
    fill(map(angle, 0, 1, 0, 255), map(vel[x].x, 0, 1, 0, 255), map(vel[x].y, 0, 1, 0, 255),life[x]);
    
    // Draw
    ellipse(pos[x].x, pos[x].y, 2, 2);
    
    // Kill and respawn if out of life
    if (life[x] < 0) {
      pos[x] = GetParticleSpawnPosition(x);
      life[x] = (int) random(450, 900);//random(250, 300); 
    } else {
      life[x]--;
    }

    // Wrap around bounds check
    if (pos[x].x < 0) pos[x].x = 1000;
    if (pos[x].x > 1000) pos[x].x = 0;
    if (pos[x].y < 0) pos[x].y = 1000;
    if (pos[x].y > 1000) pos[x].y = 0;
  }
  
  if (propertiesTimer > millis()) {
    DrawPropertiesWindows();  
  }
  
}

void mousePressed()
{
  seed = millis();
  propertiesTimer = millis() + 1500;
  noiseSeed(seed);  
  
}

void keyPressed()
{
    // Hacky and long but works, suck it DRY.
  switch (keyCode)
  { 
    case DOWN:
      selectedOption++;
      if (selectedOption > options.length) {
        selectedOption = 0;  
      }
      break;
    case UP:
      selectedOption--;
      if (selectedOption < 0) {
        selectedOption = options.length;  
      }
      break;
    case RIGHT:
      if (options[selectedOption] == "scale") {
        noiseScale += 2;
      } else if (options[selectedOption] == "spawn") {
        spawnMode++;
        if (spawnMode > 2) spawnMode = 0;
      } else if (options[selectedOption] == "multiplier") {
        multiplier += 0.1;
      }
      break;
    case LEFT:
      if (options[selectedOption] == "scale") {
        noiseScale -= 2;
      } else if (options[selectedOption] == "spawn") {
        spawnMode--;
        if (spawnMode < 0) spawnMode = 2;
      } else if (options[selectedOption] == "multiplier") {
        multiplier -= 0.1;
      }
      break;
  } 
}


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
  
  for (int i = 0; i < options.length; i++) {
    switch(options[i]) 
    {
      
    }
  }
  
  text("scale = " + noiseScale, x, y); y += FONT_SIZE;
  text("multiplier = " + multiplier, x, y); y+= FONT_SIZE;
  text("spawn type = " + spawnMode, x, y); y += FONT_SIZE;
  //text(nfc(frameRate) + " fps", x, y); y += FONT_SIZE; 
}

PVector GetParticleSpawnPosition(int particleIndex)
{
  PVector pos = new PVector(random(0, width), 0);
  switch (spawnMode)
  {
    case 0:
    {
      pos = new PVector(random(0, width), 0);
      break;
    }
    case 1:
    {
      if (particleIndex % 2 == 0) {
        pos = new PVector(random(width), 0);
      } else {  
        pos = new PVector(0, random(height)); 
      }
      break;
    }
    case 2:
    {
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
