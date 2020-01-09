final int PARTICLE_COUNT = 2000;
Particle[] particles = new Particle[PARTICLE_COUNT];

// Customisable particle properties
float mag = 0.2;
float limit = 7;

enum CustomisableStats
{
  limit,
  gravity,
  magnitude,
  multiplier,
  variance {
    @Override
    public CustomisableStats next() {
      return values()[0];  
    }
  };
  
  public CustomisableStats next() {
    return values()[ordinal() + 1];
  }
}

CustomisableStats selectedStat = CustomisableStats.limit;

void setup()
{
  background(255);
  size(1000, 1000);
  
  textFont(createFont("Consolas", 15));
  
  ResetParticles();
}

void draw()
{
  //background(255);
  
  noStroke();
  fill(255, 20);
  rect(0, 0, width, height);
  
  for (int x = 0; x < 2000; x++) {
    particles[x].update();
    particles[x].draw();
  }  
  
  DrawDebugStats();
}


void mousePressed()
{
    mag += 0.1;
}

void keyPressed()
{
  switch(key)
  {
    case 'r':
      ResetParticles();
      break;

  }

  switch (keyCode)
  { 
    case DOWN:
      println("down");
      break;
    case UP:
      println("UP");
      break;
  }
}

void ResetParticles()
{
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    particles[x] = new Particle(new PVector(width/2, height/2));
  }
}

void DrawDebugStats() 
{
  int x = 20;
  int y = 20;
  int fontSize = 15;
  
  fill(0);
  text("Stats", x, y); y += fontSize;
  text("-----------", x, y); y += fontSize;
  
  for (CustomisableStats stat : CustomisableStats.values()) {
    switch (stat) 
    {
      case CustomisableStats.limit:
        break;
    }
  }
  //text("count = " + particles.length, x, y); y += fontSize;
  text("velocity limit = " + limit, x, y); y += fontSize;
  text("gravity = " + limit, x, y); y += fontSize;
  text("acceleration magnitude = " + mag, x, y); y += fontSize;
  text("acceleration multiplier = " + limit, x, y); y += fontSize;
  text("acceleration variance = " + limit, x, y); y += fontSize;
}

class Particle 
{
  PVector pos;
  PVector vel;
  PVector acc;
  int life = 350;
  
  Particle(PVector p)
  {
    pos = p;
    vel = new PVector(0, 0);
    
    // Oldie but a goldie (hacked together splatter pattern)
    //vel = new PVector(dir.x + PVector.random2D().x, dir.y + PVector.random2D().y).mult(random(0, 15));
  }
  
  void update()
  {
    // Attract to mouse position
    acc = PVector.sub(new PVector(mouseX, mouseY), pos);  
    acc.setMag(mag);
    acc.mult(random(0.08, 1.02));
    vel.add(acc);
    vel.limit(limit);
    
    // Small pull downwards (gravity
    vel.add(new PVector(0, 0.01));
    pos.add(vel);  
    life--;
  }
  
  void draw() 
  {
    stroke(map(abs(vel.y), 0, 2, 0, 255), 0, 0);
    stroke(map(abs(vel.x), 0, 2, 0, 255), 0, 0);
    point(pos.x, pos.y);
  }
}
