ArrayList<Line> lines = new ArrayList<Line>();

ColourGenerator colour = new ColourGenerator();

void setup()
{
  background(0);
  size(1000, 1000);
  
  for (int i = 0; i < 250; i++)
  {
    lines.add(new Line());
  }
  
}

void draw()
{
  noStroke();
  fill(0, 10);
  rect(0, 0, width, height);
  
  for (Line l : lines)
  {
    l.Update();
    l.Draw();
  }
  
  colour.update();
}

class Line
{
  PVector pos = new PVector();
  float speed = 1;//random(1, 1.2);
  boolean straight = true;
  boolean down = false;
  boolean up = true;
  
  Line()
  {
    pos.x = 0;
    pos.y = random(0, height);
  }
  
  void Update()
  {
    float chance = random(0, 1);
    
    if (straight)
    {
      pos.x += speed;
      
      if (chance <= 0.01f)
      {
        straight = false; 
        
        float chance2 = random(0, 1);
        if (chance2 <= 0.5f)
        {
          up = false;
          down = true;
        }
        else
        {
          down = false;
          up = true;  
        }
      }
    }
    else
    {
      if (down)
      {
        pos.y += speed;
      }
      else
      {
        pos.y -= speed;
      }
      
      if (chance <= 0.05f)
      {
        straight = true;  
      }
    }
    
    if (pos.x > width || pos.y > height || pos.y < 0) pos = new PVector(0, random(0, height));
  }
  
  void Draw()
  {
    stroke(colour.R, colour.G, colour.B);
    point(pos.x, pos.y);
  }
}

class ColourGenerator
{
  final static float MIN_SPEED = 0.2;
  final static float MAX_SPEED = 0.7;
  float R, G, B;
  float Rspeed, Gspeed, Bspeed;
  
  ColourGenerator()
  {
    init();  
  }
  
  public void init()
  {
    // Starting colour
    R = random(255);
    G = random(255);
    B = random(255);
    
    // Starting transition speed
    Rspeed = (random(1) > 0.5 ? 1 : -1) * random(MIN_SPEED, MAX_SPEED);
    Gspeed = (random(1) > 0.5 ? 1 : -1) * random(MIN_SPEED, MAX_SPEED);
    Bspeed = (random(1) > 0.5 ? 1 : -1) * random(MIN_SPEED, MAX_SPEED);
  }
  
  public void update()
  {
    // Use transition to alter original colour (Keep within RGB bounds)
    Rspeed = ((R += Rspeed) > 255 || (R < 0)) ? -Rspeed : Rspeed;
    Gspeed = ((G += Gspeed) > 255 || (G < 0)) ? -Gspeed : Gspeed;
    Bspeed = ((B += Bspeed) > 255 || (B < 0)) ? -Bspeed : Bspeed;
  }
  
}
