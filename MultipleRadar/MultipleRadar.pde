

final int ORBIT_COUNT = 500;
final int ARMS = 20;

int[] orbits_x = new int[ORBIT_COUNT];
int[] arms = new int[ARMS];

void setup()
{
  size(1000, 1000);
  background(0);
  
  // Set everything up
  for (int i = 0; i < ORBIT_COUNT; i++) {
    orbits_x[i] = i;//(int) random(10, 500);   
  }
  l =25;
  x = 125;
  y = 200;
  
  for (int x = 0; x < ARMS; x++) {
    arms[x] = (int) random(360);  
  }
}

int i;
int l;
int x;
int y;
void draw()
{
  // Motion blur
  noStroke();
  fill(0, 20);
  rect(0, 0, width, height);
  
  // Cap the angles at 360 degrees, if over reset back to 0
  
  for (int x = 0; x < ARMS; x++) {
    int value = arms[x];
    if (value < 360) {
      value++;  
    } else {
      value = 0;  
    }
    arms[x] = value;
  }
  
  // Keep ourselves centered
  pushMatrix();
  translate(width/2, height/2);
  
  // Draw each of our points
  
      //fill (random(255), random(255), random(255));
  for (int c = 0; c < ORBIT_COUNT; c++) {
    
    for (int y = 0; y < ARMS; y++) {
      fill(255, 0, 0);
      
      ellipse(sin(radians(arms[y])) * orbits_x[c], cos(radians(arms[y])) * orbits_x[c], 4, 4);
    }
    //fill(0, 255, 0);
    //ellipse(sin(radians(i)) * orbits_x[c], cos(radians(i)) * orbits_x[c], 4, 4);
    
    //fill (255, 0, 0);
    //ellipse(sin(radians(l)) * orbits_x[c], cos(radians(l)) * orbits_x[c], 4, 4);
    
    //fill (255, 255, 0);
    //ellipse(sin(radians(x)) * orbits_x[c], cos(radians(x)) * orbits_x[c], 4, 4);
    
    //fill (0, 255, 0);
    //ellipse(sin(radians(y)) * orbits_x[c], cos(radians(y)) * orbits_x[c], 4, 4);
    //point(sin(radians(i)) * orbits[c], cos(radians(i)) * orbits[c]);
    //ellipse(sin(radians(i)) * orbits[c], cos(radians(i)) * orbits_x[c], 4, 4);
    //ellipse(sin(radians(i)) * orbits[c], cos(radians(i)) * orbits[c], 4, 4);
  }
  
  popMatrix();
}
