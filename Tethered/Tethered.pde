final int COUNT = 7;

// The particle properties don't _need_ to be unfolded like this
PVector[] points = new PVector[COUNT];
PVector[] velocities = new PVector[COUNT];

void setup()
{
  size(500, 500);
  background(255);
  
  // Setup points and initial velocities
  for (int i = 0; i < COUNT; i++) {
    points[i] = new PVector(random(width), random(height));  
    velocities[i] = new PVector(random(-0.75, 0.75), random(-0.75, 0.75));
  }
}

void draw()
{
  background(255);

  // Add velocity to position
  for (int x = 0; x < COUNT; x++) {
    points[x].add(velocities[x]);
    
    // 'Bounce' off walls
    if (points[x].x < 0) velocities[x].x *= -1;
    if (points[x].x > width)velocities[x].x *= -1;
    if (points[x].y < 0) velocities[x].y *= -1;
    if (points[x].y > height) velocities[x].y *= -1;
  }
  
  // Draw points and lines between them
  PVector start = null;
  PVector end = null;
  for (int x = 0; x < COUNT; x++) {
    // Draw a line between current and previous point
    if (end != null) {
      stroke(0);
      line(points[x].x, points[x].y, end.x, end.y);
      if (x+1 < COUNT) {
        bezier(points[x].x, points[x+1].x, end.x, end.y, points[x].y, points[x+1].y, end.x, end.y);
      }
    } else {
      // Save the start point so we can draw a line back to it at the end
      start = new PVector(points[x].x, points[x].y);
    }
    
    // Draw le circle
    fill(0);
    ellipse(points[x].x, points[x].y, 2, 2);
    
    // Save our position for next iteration
    end = new PVector(points[x].x, points[x].y);
  }
  
  // Draw final line from end to start point
  fill(255, 0, 0);
  line(start.x, start.y, end.x, end.y);
}
