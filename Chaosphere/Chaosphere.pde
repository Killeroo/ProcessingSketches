/////////////////////////////////////////////////////////////////////////////////////
///                                  Bayblade                                    ///
/////////////////////////////////////////////////////////////////////////////////////
///                                                                               ///
/// Written by Matthew Carney (1st Aug 2019)                                      ///
///     [matthewcarney64@gmail.com] [https://github.com/Killeroo]                 ///
/////////////////////////////////////////////////////////////////////////////////////

final int ORBIT_COUNT = 1000;

int[] orbits_x = new int[ORBIT_COUNT];
int[] orbits_y = new int[ORBIT_COUNT];
color[] colors = new color[ORBIT_COUNT];
int[] angles = new int[ORBIT_COUNT];

void setup()
{
  size(1000, 1000);
  background(0);
  
  // Set everything up
  for (int i = 0; i < ORBIT_COUNT; i++) {
    orbits_x[i] = (int) random(10, 500);   
    orbits_y[i] = (int) random(10, 500);
    colors[i] = color(0, random(255), random(255)); //color(random(200), random(255), random(150));//
    angles[i] = (int) random(0, 360);
  }
}

void draw()
{
  // Motion blur
  noStroke();
  fill(0, 20);
  rect(0, 0, width, height);
  //background(0);
  
  // Cap the angles at 360 degrees, if over reset back to 0
  for (int x = 0; x < ORBIT_COUNT; x++) {
    int value = angles[x];
    if (value < 360) { 
      value++;
    } else { 
      value = 0; 
    }
    angles[x] = value;
  }
  
  // Keep ourselves centered
  pushMatrix();
  translate(width/2, height/2);
  
  // Draw each of our points
  for (int c = 0; c < ORBIT_COUNT; c++) {
    fill(colors[c]);
    
    // We achieve the effect by drawing a bunch of uneven ovals at different rates
    ellipse(sin(radians(angles[c] * 2)) * orbits_x[c], cos(radians(angles[c])) * orbits_x[c], 4, 4);
    //point(sin(radians(i)) * orbits[c], cos(radians(i)) * orbits[c]);
    //ellipse(sin(radians(i)) * orbits[c], cos(radians(i)) * orbits_x[c], 4, 4);
    //ellipse(sin(radians(i)) * orbits[c], cos(radians(i)) * orbits[c], 4, 4);
  }
  println((int)map(mouseX, 0, width, 0, 15));
  popMatrix();
}
