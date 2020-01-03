// Originally was supposed to mimick the exploding plume death effect in the game Control
// with a fast burst of particles that suddenly slows down.
// tried to get more fancy and make it explode in the direction the mouse is dragged but failed
// below are, in comments, are all my failed attempts.
// So instead made a small swarm of particles that explodes, it's a bit messy, enjoy.
// Mat, 3/1/2020

final int PARTICLE_COUNT = 1000;

Particle[] particles = new Particle[PARTICLE_COUNT];
PVector direction = PVector.random2D();
PVector point;
PVector center;

void setup()
{
  background(255);
  size(1000, 1000);
  center = new PVector(width/2, height/2);
  
  generateExplosion(new PVector(width/2, height/2));//, 45);
}

void draw()
{
  // Weird new slow motion blur:
  //if (frameCount % 4 == 0) {filter(BLUR);}
  
  // Motion blur
  noStroke();
  fill(255, 20);
  rect(0, 0, width, height);
  
  // Draw explosion target
  //noStroke();
  //fill(0, 255, 0);
  //ellipse(point.x, point.y,  30, 30);
  
  // Update particles
  for (int x = 0; x < PARTICLE_COUNT; x++) {//PARTICLE_COUNT; x++){//PARTICLE_COUNT; x++) {
    particles[x].update();
    particles[x].draw();
  }
  
  //float radius = 200;
  //for (int i = 1; i <= 360; i++) {
  //  float x = point.x + (radius * cos(i));
  //  float y = point.y + (radius * sin(i));
  //  fill(255, 0, 20);
  //  ellipse(x, y, 10, 10);
  //}
  
  //float theta = abs(degrees(atan2(point.y - center.y, point.x - center.x)));
  //float x = radius * cos(theta);
  //float y = radius * sin(theta);
  //fill(255, 200, 0);
  //ellipse(x, y, 20, 20);
  
  //if (end != null) 
  //{
    // println(time);
    //stroke(0, map(abs(time), 0, 1000, 0, 255), 0);
    //line(start.x, start.y, end.x, end.y); 
    
    //float angle = PVector.angleBetween(start, end);
    //PVector v1 = new PVector(10, 20);
    //PVector v2 = new PVector(60, 80);
    //angle += TWO_PI;
    
    //float run = end.x - start.x; // lower part of slope
    //float rise = end.y - start.y;
    //float slope = rise / run;
    //float angle = 0;
    
    //if (run >= 0 && rise >=0) { angle = degrees(atan(slope)); }
    //else if (run < 0 && rise > 0) { angle = degrees(atan(slope)) + 180; }
    //else if (run < 0 && rise <= 0) { angle = degrees(atan(slope)) + 180; }
    //else if (run >= 0 && rise < 0) { angle = degrees(atan(slope)) + 360; }
    ////float angle = degrees(atan(slope));
    
    //float angle = degrees(PVector.angleBetween(v1, v2));
    //println(angle);
    //println("----");
    //println(start);
    //println(end);
    //println(angle);
    // lower time = greater radius
    // longer line = more spread
  //}
}

//int time = 0;
//PVector start = null;
//PVector end = null;
void mousePressed()
{
  
  //generateExplosion(new PVector(mouseX, mouseY));
  //start = new PVector(mouseX, mouseY);
  //end = null;
  //time = millis();
}

PVector previousMouse = new PVector(0, 0);

void mouseDragged()
{
  // lerp
  //PVector circleLocation = new PVector(0, 0);
  
  //circleLocation.x = lerp(previousMouse.x, mouseX, 0.25);
  //circleLocation.y = lerp(previousMouse.y, mouseY, 0.0025);
  //fill(0);
  //ellipse(circleLocation.x, circleLocation.y, 5, 5);
  //previousMouse = new PVector(mouseX, mouseY); 
  //fill(0);
  //ellipse(mouseX, mouseY, 5, 5);
}

void mouseReleased()
{
  //end = new PVector(mouseX, mouseY);
  //time -= millis();
  
  // Work out the angle the mouse was dragged in
  //float run = end.x - start.x; // lower part of slope
  //float rise = end.y - start.y; // upper part of slope
  //float slope = rise / run;
  //float angle = 0;
  
  //if (run >= 0 && rise >=0) { angle = degrees(atan(slope)); }
  //else if (run < 0 && rise > 0) { angle = degrees(atan(slope)) + 180; }
  //else if (run < 0 && rise <= 0) { angle = degrees(atan(slope)) + 180; }
  //else if (run >= 0 && rise < 0) { angle = degrees(atan(slope)) + 360; }
  
  //float theta = degrees(atan2(end.y - start.y, end.x - start.x));
  
  ////angle -= 90;
  //if (theta < 0) {
  //  theta = abs(theta)+90;  
  //}
  
  //println(theta);
  generateExplosion(new PVector(mouseX, mouseY));//theta);
}

void generateExplosion(PVector origin)//), float angle)
{
  float fuse = (int) random(10, 50);
  println(fuse);
  float r = 50;
  
  // Generate in a circle
  for (int i = 0; i < PARTICLE_COUNT; i++) {
    float ang = random(1, 360);
    float x = origin.x + (r * cos((PI/120) * ang));
    float y = origin.y + (r * sin((PI/120) * ang));
    Particle p =  new Particle(new PVector(x, y), new PVector(width/2, height/2));
    p.explosionTimer = (int)fuse;
    particles[i] = p;
  }
  
  //float radius = random(200, 450);
  //angle = random(1, 360);
  //float maxAngle = random(60, 200);
  
  //for (int i = 1; i <= 90; i++) {
  //  float a = random(30);
  //  float x = origin.x + (radius * cos(angle + (PI/120) * a)); // center.x + (radius * cos(angle + ((PI/120) * i))); // It was all going well but I dont know why PI/120 makes the angle make sense but hey
  //  float y = origin.y + (radius * sin(angle + (PI/120) * a));
  //  particles[i-1] = new Particle(new PVector(origin.x, origin.y), new PVector(x, y));  //width/2, height/2), new PVector(x, y));  
  //}
  
  //for (int i = 0; i < PARTICLE_COUNT; i++) {
  //  PVector spawn = new PVector((width/2) + random(-30, 30), height/2 + random(-30, 30));
  //  float a = random(maxAngle);
  //  float x = origin.x + (radius * cos(angle + (PI/120) * a)); // cos(angle + (PI/120) * a)); // center.x + (radius * cos(angle + ((PI/120) * i))); // It was all going well but I dont know why PI/120 makes the angle make sense but hey
  //  float y = origin.y + (radius * sin(angle + (PI/120) * a));//sin(angle + (PI/120) * a));
  //  //new PVector(origin.x, origin.y)
  //  particles[i] = new Particle(spawn, new PVector(x, y));  //width/2, height/2), new PVector(x, y));  
  //}
  
  //float r = 200;
  //for (int i = 1; i <= 360; i++) {
  //  float x = origin.x + (r * cos((PI/120) * i));
  //  float y = origin.y + (r * sin((PI/120) * i));
  //  fill(map(i, 1, 360, 0, 255), 0, 20);
  //  ellipse(x, y, 10, 10);
  //}
  
  //// Create new particles
  //for (int i = 0; i < PARTICLE_COUNT; i++) {
    
  //  stroke(255, 100, 0);
  //  int our_angle = int(angle + random(-2, 2));
  //  println(our_angle);
    
  //  float x = center.x + (radius * cos(our_angle)); 
  //  float y = center.y + (radius * sin(our_angle));
  //  //float currentPointY = point.y + random(350);
  //  particles[i] = new Particle(new PVector(width/2, height/2), new PVector(x, y));//currentPointX, currentPointY));
  //  line(center.x, center.y, x, y);
  //}
  
  ////float angle2 = 0;
  ////for (int i = 1; i <= 360; i++) {
  ////  float x = center.x + (radius * cos(angle2 + i));
  ////  float y = center.y + (radius * sin(angle2 + i));
  ////  particles[i-1] = new Particle(new PVector(width/2, height/2), new PVector(x, y));
  ////}
  
  //float x = center.x + (radius * cos(angle));
  //float y = center.y + (radius * sin(angle));
  //point = new PVector(x, y);
}

class Particle 
{
  PVector pos;
  PVector vel;
  PVector acc;
  PVector target;
  int life;
  int explosionTimer =  17; // when to explode
  boolean exploded = false;
  float life_tick; // When to slow down
  boolean done = false; // Done is used as part of the explosion sequence (sorry)
  
  Particle(PVector p, PVector dir)
  {
    life = 200;
    pos = p;
    target = dir;
    vel = new PVector(0, 0);
    life_tick = random(155, 180);
  }
  
  void update()
  { 
    //PVector mouse = new PVector(mouseX, mouseY);
    
    // Accelerate toward target
    PVector mouse = new PVector(random(-5, 5) + width/2, random(-5, 5) + height/2);
    if (exploded)
    {
      mouse = target;
    }
    acc = PVector.sub(mouse, pos);
    
    // Slow down all particles
    if (explosionTimer <= 0 && !exploded) {
      
      acc.mult(random(5, 7));
      //vel.div(20);
      target = new PVector(random(width), random(height));
      exploded = true;
    } 
    
    if (life < life_tick && !done)
    {
      vel.div(20);
      done = true;
    } else if (!done) {
    // Accelerate particls normally if not slowed
    //if (!exploded) {
      acc.setMag(random(0.5 , 1));// 0.05));//7));//0.05));    
      vel.add(acc);  
    }
    
    pos.add(vel);  
    explosionTimer--;
    life--;
  }
  
  void draw() 
  {
    noStroke();
    
    if (done) {
      fill(map(abs(vel.x), -2, 1, 0, 255), map(abs(vel.y)*10, 0, 10, 0, 250), 0); 
      
    } else {
      fill(map(abs(vel.mag()), 0, 20, 0, 255), 0, 50);//, life);
    }
    ellipse(pos.x, pos.y, 2, 2);
    
    
    //fill(0, 200, 244);
    //ellipse(target.x, target.y, 4, 4);
  }
}
