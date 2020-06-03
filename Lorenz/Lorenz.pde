//https://github.com/CodingTrain/website/blob/master/CodingChallenges/CC_012_LorenzAttractor/Processing/CC_012_LorenzAttractor/CC_012_LorenzAttractor.pde
import peasy.*;

float x = 0.1;
float y = 0;
float z = 0;

final float a = 10;
final float b = 28;
final float c = 8.0 / 3.0;

ArrayList<PVector> points = new ArrayList<PVector>();
PeasyCam cam;

void setup()
{
  size(1000, 1000, P3D);  
  colorMode(HSB); // Hue Saturation Brightness
  background(0);
  cam = new PeasyCam(this, 500);
}

void draw()
{
  background(0);
  
  float dt = 0.01; // timestep
  
  // Work out next position using lorenz equation (https://en.wikipedia.org/wiki/Lorenz_system#Overview)
  float dx = (a * (y - x)) * dt;
  float dy = (x * (b - z) - y) * dt;
  float dz = (x * y - c * z) * dt;
  
  // Add to current position
  x += dx;
  y += dy;
  z += dz;
  
  // Save to points
  points.add(new PVector(x, y, z));
  
  
  translate(0, 0, -80);
  stroke(255);
  scale(5); // zoom in  
  noFill();
  
  // Draw all points
  float hue = 0;
  beginShape(); // Amazing hack :O
  for (PVector point : points) {
    stroke(hue, 255, 255); // Another easy hack for color change
    vertex(point.x, point.y, point.z);
    
    // Random offset
    // (causes 'wiggle')
    PVector offset = PVector.random3D(); // Gives us a normalize (0 -> 1) 'direction'
    offset.mult(0.1);
    point.add(offset);
    
    // Clamp hue over time
    hue += 0.1;
    if (hue > 255) {
      hue = 0;  
    }
  }
  endShape();
  println(x,y,z);
  

}
