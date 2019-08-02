final int COUNT = 5;

// The particle properties don't _need_ to be unfolded like this
PVector[] points = new PVector[COUNT];
PVector[] velocities = new PVector[COUNT];

void setup()
{
  size(500, 500);
  background(255);
  
  for (int i = 0; i < COUNT; i++) {
    points[i] = new PVector(random(width), random(height));  
    velocities[i] = new PVector(random(-0.75, 0.75), random(-0.75, 0.75));
  }
}

void draw()
{
  background(255);
  
  for (int x = 0; x < COUNT; x++) {
    velocities[x].add(new PVector(0, 0));
  }
  
  for (int x = 0; x < COUNT; x++) {
    points[x].add(velocities[x]);
    
    // 'Bounce' off walls
    if (points[x].x < 0) velocities[x].x *= -1;
    if (points[x].x > width)velocities[x].x *= -1;
    if (points[x].y < 0) velocities[x].y *= -1;
    if (points[x].y > height) velocities[x].y *= -1;
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
