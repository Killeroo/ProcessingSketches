// Inspired by the fevered imagination of this:
//https://www.openprocessing.org/sketch/16975

float turns = 0.7999999;
float x = 0;
float posX = 75;

void setup() 
{
  size(800, 600);  
}

void draw() 
{
  // Motion blur
  noStroke();
  fill(255, 40);
  rect(0, 0, width, height);
  
  // Lerp mouse position when dragged and use it to seed the angle of the spiral
  x = lerp(x, posX, 0.0001);
  float seed = map(x, 0, width, 1.0, 2.0);//-0.1218, 0.1218);
  turns =  1.5 * cos(seed);
  
  // Recursive spiral function
  drawSpiral((width/2) - 40, height/2, turns, 40, 0, 100);
}

void mouseDragged() {
  posX = mouseX;
}

void drawSpiral(float x1, float y1, float turns, float len, float angle, int depth)
{
  // Stop recursing when we are at depth 0
  if (depth == 0) return;
  
  // Add some colour
  if (depth % 2 == 0) {
    stroke(178, 119, 65);  
  } else if (depth % 3 == 0) {
    stroke(255, 122, 0);
  } else {
    stroke(0, 143, 178);
  }
  
  // Work out start of next branch
  float x2 = x1 + len * cos(angle);
  float y2 = y1 - len * sin(angle);
  
  // Draw da branch
  line(x1, y1, x2, y2);
  line(x1, y1, x1 - len * cos(angle), y1 + len * sin(angle));
  line(x1, y2, x2, y1);
  
  // Work out angle of next branch
  float nextAngle = angle + PI / (float) turns;
  
  // Recurse back into ourselves
  drawSpiral(x2, y2, turns, len+ (float) 180/len, nextAngle, depth - 1);
  
}
