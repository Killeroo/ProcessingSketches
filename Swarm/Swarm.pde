/////////////////////////////////////////////////////////////////////////////////////
///                                  Swarm                                        ///
/////////////////////////////////////////////////////////////////////////////////////
/// Swarming particle system, with simple customisation of particle properties    ///
/// ( I couldn't afford real sliders, sorry)                                      ///
///                                                                               ///
/// Written by Matthew Carney (10th Jan 2020)                                     ///
///     [matthewcarney64@gmail.com] [https://github.com/Killeroo]                 ///
///                                                                               ///
/////////////////////////////////////////////////////////////////////////////////////

final int PARTICLE_COUNT = 2000;
final int FONT_SIZE = 11;

Particle[] particles = new Particle[PARTICLE_COUNT];
boolean showText = true;

// Customisable particle properties
float mag = 0.2;
float limit = 7;
float gravity = 0.01;
float multiplier = 0.8;
float variance = 0.4;
boolean stream = false;
int motionblur = 20;
boolean followMouse = true;
boolean usePoints = false;

enum CustomisableStats
{
  limit {
    @Override
    public CustomisableStats previous() {
      return values()[8];  
    }
  },
  gravity,
  magnitude,
  multiplier,
  variance,
  stream,
  followmouse,
  usepoints,
  motionblur {
    @Override
    public CustomisableStats next() {
      return values()[0];  
    }
  };
  
  public CustomisableStats next() {
    return values()[ordinal() + 1];
  }
  
  public CustomisableStats previous() {
    return values()[ordinal() - 1];
  }
}

CustomisableStats selectedStat = CustomisableStats.limit;

// for javascript
//String[] options = new String[] {
//  "limit",
//  "gravity",
//  "magnitude",
//  "multiplier",
//  "variance",
//  "stream",
//  "followmouse",
//  "usepoints",
//  "motionblur" 
//};
//int selectedOption = 0;

void setup()
{
  background(255);
  size(1000, 1000);
  
  textFont(createFont("Consolas", FONT_SIZE));
  
  ResetParticles();
}

void draw()
{
  noStroke();
  fill(255, motionblur);
  rect(0, 0, width, height);
  
  for (int x = 0; x < 2000; x++) {
    particles[x].update();
    particles[x].draw();
    
    if (stream) {
      if (particles[x].life == 0) {
        particles[x] = new Particle(new PVector(width/2 + random(-5, 5), height/2 + random(-5, 5)));
      }
    }
  }  
  
  if (showText)
    DrawDebugStats();
}

void keyPressed()
{
  switch(key)
  {
    case 'r':
      background(255);
      ResetParticles();
      break;
    case 'h':
      showText = !showText;
      break;
    case 't':
      followMouse = !followMouse;
  }

  // Hacky and long but works, suck it DRY.
  switch (keyCode)
  { 
    case DOWN:
      selectedStat = selectedStat.next();
      //selectedOption++;
      //if (selectedOption > options.length) {
      //  selectedOption = 0;  
      //}
      break;
    case UP:
      selectedStat = selectedStat.previous();
      //selectedOption--;
      //if (selectedOption < 0) {
      //  selectedOption = options.length;  
      //}
      break;
    case RIGHT:
      if (selectedStat == CustomisableStats.limit) {
        limit += 1;
      } else if (selectedStat == CustomisableStats.gravity) {
        gravity += 0.01;
      } else if (selectedStat == CustomisableStats.magnitude) {
        mag += 0.1;
      } else if (selectedStat == CustomisableStats.multiplier) {
        multiplier += 0.1;
      } else if (selectedStat == CustomisableStats.variance) {
        variance += 0.1;
      } else if (selectedStat == CustomisableStats.stream) {
        stream = !stream;
      } else if (selectedStat == CustomisableStats.motionblur) {
        motionblur += 5;
      } else if (selectedStat == CustomisableStats.followmouse) {
        followMouse = !followMouse;
      } else if (selectedStat == CustomisableStats.usepoints) {
        usePoints = !usePoints;
      }
      break;
    case LEFT:
      if (selectedStat == CustomisableStats.limit) {
        limit -= 1;
      } else if (selectedStat == CustomisableStats.gravity) {
        gravity -= 0.01;
      } else if (selectedStat == CustomisableStats.magnitude) {
        mag -= 0.1;
      } else if (selectedStat == CustomisableStats.multiplier) {
        multiplier -= 0.1;
      } else if (selectedStat == CustomisableStats.variance) {
        variance -= 0.1;
      } else if (selectedStat == CustomisableStats.stream) {
        stream = !stream;
      } else if (selectedStat == CustomisableStats.motionblur) {
        motionblur -= 5;
      } else if (selectedStat == CustomisableStats.followmouse) {
        followMouse = !followMouse;
      } else if (selectedStat == CustomisableStats.usepoints) {
        usePoints = !usePoints;
      }
      //case RIGHT:
      //  if (options[selectedOption] == "limit") {
      //    limit += 1;
      //  } else if (options[selectedOption] == "gravity") {
      //    gravity += 0.01;
      //  } else if (options[selectedOption] == "magnitude") {
      //    mag += 0.1;
      //  } else if (options[selectedOption] == "multiplier") {
      //    multiplier += 0.1;
      //  } else if (options[selectedOption] == "variance") {
      //    variance += 0.1;
      //  } else if (options[selectedOption] == "stream") {
      //    stream = !stream;
      //  } else if (options[selectedOption] == "motionblur") {
      //    motionblur += 5;
      //  } else if (options[selectedOption] == "followmouse") {
      //    followMouse = !followMouse;
      //  } else if (options[selectedOption] == "usepoints") {
      //    usePoints = !usePoints;
      //  }
      //  break;
      //case LEFT:
      //  if (options[selectedOption] == "limit") {
      //    limit -= 1;
      //  } else if (options[selectedOption] == "gravity") {
      //    gravity -= 0.01;
      //  } else if (options[selectedOption] == "magnitude") {
      //    mag -= 0.1;
      //  } else if (options[selectedOption] == "multiplier") {
      //    multiplier -= 0.1;
      //  } else if (options[selectedOption] == "variance") {
      //    variance -= 0.1;
      //  } else if (options[selectedOption] == "stream") {
      //    stream = !stream;
      //  } else if (options[selectedOption] == "motionblur") {
      //    motionblur -= 5;
      //  } else if (options[selectedOption] == "followmouse") {
      //    followMouse = !followMouse;
      //  } else if (options[selectedOption] == "usepoints") {
      //    usePoints = !usePoints;
      //  }
      //  break;
  }
}

void ResetParticles()
{
  for (int x = 0; x < PARTICLE_COUNT; x++) {
    // Bit of variance in position to stop particles bunching up
    particles[x] = new Particle(new PVector(width/2 + random(-5, 5), height/2 + random(-5, 5)));
  }
}

// Poor mans sliders
void DrawDebugStats() 
{
  int x = 20;
  int y = 20;
  
  fill(0);
  text("Particle Properties", x, y); y += FONT_SIZE;
  text("-----------", x, y); y += FONT_SIZE;
  
  for (CustomisableStats stat : CustomisableStats.values()) {
    if (stat == selectedStat) {
      fill(255, 0, 0);
    } else {
      fill(0);
    }
    
    if (stat == CustomisableStats.limit) {
      text("velocity limit = " + limit, x, y); y += FONT_SIZE;
    } else if (stat == CustomisableStats.gravity) {
      text("gravity = " + gravity, x, y); y += FONT_SIZE;
    } else if (stat == CustomisableStats.magnitude) {
      text("acceleration magnitude = " + mag, x, y); y += FONT_SIZE;
    } else if (stat == CustomisableStats.multiplier) {
      text("acceleration multiplier = " + multiplier, x, y); y += FONT_SIZE;
    } else if (stat == CustomisableStats.variance) {
      text("acceleration variance = " + variance, x, y); y += FONT_SIZE;
    } else if (stat == CustomisableStats.stream) {
      text("streaming particles = " + (stream ? "ENABLED" : "DISABLE"), x, y); y += FONT_SIZE;
    } else if (stat == CustomisableStats.motionblur) {
      text("motion blur = " + motionblur, x, y); y += FONT_SIZE;
    } else if (stat == CustomisableStats.followmouse) {
      text("follow mouse = " + (followMouse ? "ENABLED" : "DISABLE"), x, y); y += FONT_SIZE;
    } else if (stat == CustomisableStats.usepoints) {
      text("draw using = " + (usePoints ? "POINTS" : "ELLIPSES"), x, y); y += FONT_SIZE;
    }
  }
  
  //for (int i = 0; i < options.length; i++) {
  //  if (selectedOption == i) {
  //    fill(255, 0, 0);
  //  } else {
  //    fill(0);
  //  }
    
  //  switch (options[i])
  //  {
  //    case "limit":
  //      text("velocity limit = " + limit, x, y); y += FONT_SIZE;
  //      break;
  //    case "gravity":
  //      text("gravity = " + gravity, x, y); y += FONT_SIZE;
  //      break;
  //    case "magnitude": 
  //      text("acceleration magnitude = " + mag, x, y); y += FONT_SIZE;
  //      break;
  //    case "multiplier":
  //      text("acceleration multiplier = " + multiplier, x, y); y += FONT_SIZE;
  //      break;
  //    case "variance":
  //      text("acceleration variance = " + variance, x, y); y += FONT_SIZE;
  //      break;
  //    case "stream":
  //      text("streaming particles = " + (stream ? "ENABLED" : "DISABLE"), x, y); y += FONT_SIZE;
  //      break;
  //    case "followmouse":
  //      text("follow mouse = " + (followMouse ? "ENABLED" : "DISABLE"), x, y); y += FONT_SIZE;
  //      break;
  //    case "usepoints":
  //      text("draw using = " + (usePoints ? "POINTS" : "ELLIPSES"), x, y); y += FONT_SIZE;
  //      break;
  //    case "motionblur":
  //      text("motion blur = " + motionblur, x, y); y += FONT_SIZE;
  //      break;
  //  }
  //}
  //text("count = " + particles.length, x, y); y += fontSize;
  
  fill(0);
  
  y += FONT_SIZE; text("Use UP and DOWN arrows to navigate", x, y); y += FONT_SIZE;
  text("LEFT and RIGHT arrows decrease and increase selected value", x, y); y += FONT_SIZE;
  text("'r' to reset particles, 'h' to hide text", x, y); y += FONT_SIZE;
  
}

class Particle 
{
  PVector pos;
  PVector vel;
  PVector acc;
  int life = (int) random(200, 500);//350;
  
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
    if (followMouse) {
      acc = PVector.sub(new PVector(mouseX, mouseY), pos);
    } else {
      acc = PVector.sub(new PVector(width/2, height/2), pos);
    }
    acc.setMag(mag);
    acc.mult(multiplier + random(variance));//random(0.08, 1.02));
    vel.add(acc);
    vel.limit(limit);
    
    // Small pull downwards (gravity
    vel.add(new PVector(0, gravity));
    pos.add(vel);  
    
    // keep life from dropping below 0
    if (life != 0) life--;
  }
  
  void draw() 
  {
    if (usePoints) {
      stroke(map(abs(vel.y), 0, 2, 0, 255), 0, 0);
      stroke(map(abs(vel.x), 0, 2, 0, 255), 0, 0);
      point(pos.x, pos.y);
    } else {
      fill(map(abs(vel.y), 0, 2, 0, 255), 0, 0);
      fill(map(abs(vel.x), 0, 2, 0, 255), 0, 0);
      ellipse(pos.x, pos.y, 2, 2);
    }
  }
}
