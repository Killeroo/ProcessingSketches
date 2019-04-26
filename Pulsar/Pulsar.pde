ArrayList particles = new ArrayList();

void setup()
{
  size(1000, 1000);
  for (int i = 0; i < 5000; i++) {
    particles.add(new Particle(new PVector(random(width), random(height))));  
  }
}
int interval = 0;
//https://www.openprocessing.org/sketch/180734
boolean contracting = true;
void draw()
{
  //background(0);
    noStroke();
  fill(0, 75); //50
  rect(0, 0, width, height);
  
  if (millis() > interval) {
       interval = millis() + 1000;//(int) random(750, 1500);
       PVector target = new PVector(random(0, width), random(0, height));//new PVector(random(width), random(height));
   
       for (int i = 0; i < particles.size(); i++) {
          Particle p = (Particle) particles.get(i);
          //p.applyForce(target, 1.5);
        }
          
          contracting = !contracting;
     }
  
  if (contracting) {
    PVector target = new PVector((width/2)+random(-22.5,22.5), (height/2)+random(-22.5,22.5));
    for (int i = 0; i < particles.size(); i++) {
      Particle p = (Particle) particles.get(i);
      p.applyForce(target, 0.9);
    }
  }
  
  for (int i = 0; i < particles.size(); i++) {
    Particle p = (Particle) particles.get(i);
    p.move();
    p.display();
  }
  
  
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
    if (mousePressed) 
    {
      applyForce(new PVector(mouseX, mouseY), 0.9);  
    }
    vel.add(acc); // Apply acceleration
    pos.add(vel); // Apply our speed vector
    acc.mult(0);
    vel.mult(0.97);
  }
  
  public void applyForce(PVector forceLoc, float force) 
  {
    PVector d = PVector.sub(forceLoc, pos);
    d.normalize();
    d.mult(force);//0.9);
    acc = d;
  }
  int c = 50;
  boolean desc = false;
  public void display()
  {
    stroke( 
      c,
      map(vel.mag(), 0, 20, 50, 250), 
      map(pos.mag(), 0, width, 0, 255), //map(vel.mag(), 0, 20, 50, 255),
      map(vel.mag(), 0, 20, 150, 200)
    );
    
    if (c == 255) {
      desc = true;  
    } else if (c == 50) {
      desc = false;  
    }
    
    if (desc) {
      c--;  
    } else {
      c++;  
    }
      
    point(pos.x, pos.y);
  }
}
