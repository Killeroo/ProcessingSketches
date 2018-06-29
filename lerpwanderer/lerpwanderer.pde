// Non-static (lerp on a specific vector)
Wanderer thing = new Wanderer();
PVector v;

void setup() {
  size(1000, 1000);
  v = new PVector(0.0, 0.0);
}

void draw() 
{  
  noStroke();
  fill(255, 50); //50
  rect(0, 0, width, height);
  
  thing.update();
  thing.display();
}

class Wanderer 
{
  PVector loc;
  PVector target;
  int interval;
  
  // Rotating internals
  float angle;
  float theta;
  float theta2;
  
  Wanderer() 
  {
    loc = new PVector(width/2, height/2);
    target = new PVector(random(width), random(height));
    interval = millis() + (int) random(750, 1500);
  }
  
  void update()
  {
     if (millis() > interval) {
       interval = millis() + (int) random(750, 1500);
       target = new PVector(random(width), random(height));
     }
     
     loc.x = lerp(loc.x, target.x, 0.025);
     loc.y = lerp(loc.y, target.y, 0.025);
  }

  void display() 
  {
    stroke(constrain(loc.dist(target), 0, 255),0, 0);
    
    //constrain(loc.dist(target), 0, 255);
    
    noFill();
    
    pushMatrix();
    translate(loc.x, loc.y);
    rotate(theta);
    theta += TWO_PI/500;
    
    rect(0, 0, 100, 100);
    
    
    rect(50, 50, 100, 100);
    
    rect(100, 100, 100, 100);
    
    rect(100, 0, 100, 100);
    rect(0, 100, 100, 100);
    
    for (int x = 0; x < 10; x++) {
      //ellipse(0, 0, 30, 30);  
    }
    
    rect(-50, -50, 100, 100);
    
    rect(-100, -100, 100, 100);
    
    rect(-100, 0, 100, 100);
    
    rect(0, -100, 100, 100);
    
    popMatrix();
    
  }
}
