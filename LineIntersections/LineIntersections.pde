int intervals = 100;

PVector[] line1 = new PVector[intervals];
PVector[] line2 = new PVector[intervals];

PVector line1Start = new PVector(20, 100);
PVector line1End = new PVector(980, 100);

PVector line2Start = new PVector(20, 900);
PVector line2End = new PVector(980, 900);

void setup()
{
  size(1000,1000);
  background(255);
  noLoop();
  
  float spacingX = (line1End.x-line1Start.x)/intervals;
  for (int x =0; x < intervals; x++) 
  {
    line1[x] = new PVector((x * spacingX)+line1Start.x, line1Start.y);
  }
  
  spacingX = (line2End.x-line2Start.x)/intervals;
  for (int x = 0; x < intervals; x++) 
  {
    line2[x] = new PVector((x * spacingX)+line2Start.x, line2Start.y);
  }
  
}

void draw()
{
  stroke(0);
  line(line1Start.x, line1Start.y, line1End.x, line1End.y);
  line(line2Start.x, line2Start.y, line2End.x, line2End.y);
  
  stroke(255, 0, 0);
  for (PVector point : line1)
  {
    ellipse(point.x, point.y, 10, 10);
  }
  
  stroke(255,255, 0);
  for (PVector point : line2)
  {
    ellipse(point.x, point.y, 10, 10);
  }
  
    
  int line1Index = intervals-1;
  int line2Index = 0;
  
  for (int x = 0; x < intervals; x++)
  {
    println(line1Index);
    println(line2Index);
    println("=========");
    
    stroke(0);
    line(line1[line1Index].x, line1[line1Index].y, line2[line2Index].x, line2[line2Index].y);
    
    line1Index--;
    line2Index++;
  }
}
