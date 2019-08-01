final int ORBIT_COUNT = 1000;

int[] orbits_x = new int[ORBIT_COUNT];

void setup()
{
  size(1000, 1000);
  background(0);
  
  // Set everything up
  for (int i = 0; i < ORBIT_COUNT; i++) {
    orbits_x[i] = i;//(int) random(10, 500);   
  }
}

int i;
void draw()
{
  // Motion blur
  noStroke();
  fill(0, 20);
  rect(0, 0, width, height);
  
  // Cap the angles at 360 degrees, if over reset back to 0
  if (i < 360) { i++; } else { i = 0; }
  
  // Keep ourselves centered
  pushMatrix();
  translate(width/2, height/2);
  
  // Draw each of our points
  
  for (int c = 0; c < ORBIT_COUNT; c++) {
    
    fill(0, 255, 0);
    ellipse(sin(radians(i)) * orbits_x[c], cos(radians(i)) * orbits_x[c], 4, 4);
    

  }
  
  popMatrix();
}
