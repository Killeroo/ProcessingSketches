ArrayList particles = new ArrayList();
Wanderer thing = new Wanderer();

void setup()
{
  size(1000, 1000);
  for (int i = 0; i < 5000; i++) {
    particles.add(new Particle(new PVector(random(width), random(height))));  
  }
}
int interval = 0;
//https://www.openprocessing.org/sketch/180734
void draw()
{
  background(0);
  //  noStroke();
  //fill(0, 25); //50
  //rect(0, 0, width, height);
  
  thing.update();
  
  if (millis() > interval) {
       interval = millis() + 1000;//(int) random(750, 1500);
       PVector target = new PVector((width/2)+random(-2.5,2.5), (height/2)+random(-2.5,2.5));//new PVector(random(width), random(height));
       
         for (int i = 0; i < particles.size(); i++) {
            Particle p = (Particle) particles.get(i);
            p.applyForce(target);
            //p.applyForce(target);
            //p.applyForce(target);
          }
     }
  
  for (int i = 0; i < particles.size(); i++) {
    Particle p = (Particle) particles.get(i);
    p.move();
    p.display();
  }
  
  
}
void mousePressed()
{

}
class ParticleSystem
{
    
  
}

class Particle
{
  PVector vel = new PVector(0, 0);
  PVector acc = new PVector(0, 0);
  PVector pos;
  int lifespan = 400;
  
  Particle(PVector p)
  {
    pos = new PVector (p.x, p.y);
    acc = new PVector (random(-0.1, 0.1), 0);
  }
  
  public void move()
  {
    vel.add(acc); // Apply acceleration
    pos.add(vel); // Apply our speed vector
    acc.mult(0);
    vel.mult(0.97);
    
    // Decrease particle lifespan
    //lifespan--;
  }
  
  public void applyForce(PVector forceLoc) 
  {
    PVector d = PVector.sub(forceLoc, pos);
    d.normalize();
    d.mult(9); //9
    acc = d;
  }
  
  public void display()
  {
    stroke(255, map(vel.mag(), 0, 20, 25, 150), map(vel.mag(), 0, 20, 50, 255), map(vel.mag(), 0, 20, 150, 200));
    point(pos.x, pos.y);
  }
  
  public boolean isDead()
  {
    if (lifespan < 0) {
      return true;
    } else {
      return false;
    }
  }
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
       
         for (int i = 0; i < particles.size(); i++) {
            //Particle p = (Particle) particles.get(i);
            //p.applyForce(target);
          }
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
