//https://www.openprocessing.org/sketch/16975

void setup() 
{
  size(800, 600);  
}
float turns = 0;
float x = 0;
int y = 0;

void draw() 
{
  //background(255);
  //drawTree(400, 500, -90, 9);
  noStroke();
   fill(255, 40);
    rect(0, 0, width, height);
  
  x = lerp(x, mouseX, 0.0001);
  float seed = map(x, 0, width, 1.0, 2.0);//-0.1218, 0.1218);

  turns =  1.5 * cos(seed);
  println("++++++" + turns + "+++++++");
  drawSpiral(width/2, height/2, map(mouseX, 0, width, 0, 1), 40, 0, 100);
}

void drawTree(int x1, int y1, float angle, int depth) 
{
  if (depth == 0) return;
  int x2 = x1 + (int) (cos(radians(map(mouseX, 0, height, 0, 10) + angle)) * depth * 10.0);
  int y2 = y1 + (int) (sin(radians(angle)) * depth * 10.0);
  
  line(x1, y1, x2, y2);
  
  drawTree(x2, y2, angle - 20, depth - 1);
  drawTree(x2, y2, angle + 20, depth - 1);
}

void drawSpiral(float x1, float y1, float turns, float len, float angle, int depth)
{
  //println("==================");
  //println("Depth: " + depth);
  //println("Turns: "+ turns);
  //println("angle: "+angle);
  //println("==================");
  
  if (depth == 0) return;
  
  if (depth % 2 == 0) {
    stroke(178, 119, 65);  
  } else if (depth % 3 == 0) {
    stroke(255, 122, 0);
  } else {
    stroke(0, 143, 178);
  }
  
  float x2 = x1 + len * cos(angle);
  float y2 = y1 - len * sin(angle);
  
  line(x1, y1, x2, y2);
  line(x1, y1, x1 - len * cos(angle), y1 + len * sin(angle));
  line(x1, y2, x2, y1);
  
  float nextAngle = angle + PI / (float) turns;
  
  drawSpiral(x2, y2, turns, len+ (float) 180/len, nextAngle, depth - 1);
  
}
