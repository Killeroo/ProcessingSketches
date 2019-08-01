final int COUNT = 5;

// The particle properties don't _need_ to be unfolded like this
PVector[] points = new PVector[COUNT];
PVector[] vel = new PVector[COUNT];

void setup()
{
  size(1000, 1000);
  background(255);
  
  for (int i = 0; i < COUNT; i++) {
    points[i] = new PVector(random(width), random(height));  
    vel[i] = new PVector(random(-1, 1), random(-1, 1));
  }
}

void draw()
{
  background(255);
  
  for (int x = 0; x < COUNT; x++) {
    vel[x].add(new PVector(0, 0));
  }
  
  for (int x = 0; x < COUNT; x++) {
    points[x].add(vel[x]);
    
    // 'Bounce' off walls
    if (points[x].x < 0) vel[x].x *= -1;
    if (points[x].x > width)vel[x].x *= -1;
    if (points[x].y < 0) vel[x].y *= -1;
    if (points[x].y > height) vel[x].y *= -1;
  }
  
  PVector start = null;
  PVector end = null;
  for (int x = 0; x < COUNT; x++) {
    if (end != null) {
      stroke(0);
      line(points[x].x, points[x].y, end.x, end.y);
    } else {
      start = new PVector(points[x].x, points[x].y);
    }
    
    fill(0);
    ellipse(points[x].x, points[x].y, 2, 2);
    
    end = new PVector(points[x].x, points[x].y);
  }
  
  fill(255, 0, 0);
  line(start.x, start.y, end.x, end.y);
}
