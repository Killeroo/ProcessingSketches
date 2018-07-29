/////////////////////////////////////////////////////////////////////////////////////
///                                  Circles                                      ///
/////////////////////////////////////////////////////////////////////////////////////
/// Randomly rotating circles                                                     ///      
///                                                                               ///
/// Written by Matthew Carney (29th July 2018)                                    ///
///     [matthewcarney64@gmail.com] [https://github.com/Killeroo]                 ///
///                                                                               ///
/// Rewrite and refactor of:                                                      ///
///       https://www.openprocessing.org/sketch/399338                            ///
///                                                                               ///
/// Inspired by:                                                                  ///
///       https://codepen.io/cmegown/pen/OEJEKv                                   ///  
/////////////////////////////////////////////////////////////////////////////////////

/* Sketch properties */
final int CIRCLES = 30;//15;
final int CIRCLE_WIDTH = 10;
final float ANGLE_INCREMENT = 0.05;
final float ROTATION_SPEED = 30.0; // (Higher = slower)
final float COLOUR_CHANGE_MAX = 0.7;
final float COLOUR_CHANGE_MIN = 0.2;

float angle = 0;
float[] diameters = new float[CIRCLES];
ColourGenerator[] colours = new ColourGenerator[CIRCLES];

void setup()
{
    size(1000, 1000, P3D);
    //colorMode(HSB, 150);
    noFill();
    strokeWeight(CIRCLE_WIDTH);
    
    // Setup circles with varying sizes based on width
    for (int i = 0; i < CIRCLES; i++) {         
      diameters[i] = CIRCLES * width / 50.0 - i * width / 50.0;
      colours[i] = new ColourGenerator();
    }
}
    
void draw()
{
    background(0); // Clear background
    translate(width/2, height/2, 0); // Center on middle of screen
    
    // Draw the circles
    for (int i = 0; i < CIRCLES; i++){
        stroke(colours[i].R, colours[i].G, colours[i].B); // Set colour

        // Draw each circle independantly of previous position
        pushMatrix();
        rotateY((i/60.0) * angle * HALF_PI + angle);  
        ellipse(0, 0, diameters[i], diameters[i]);
        popMatrix();
        
        colours[i].update();// Updated colour
    }
  
    angle += ANGLE_INCREMENT; // Increment angle

}


class ColourGenerator
{
  float R, G, B;
  float Rspeed, Gspeed, Bspeed;
  
  ColourGenerator()
  {
    init();
  }
  
  public void init()
  {
    // Random starting colour
    R = random(255);
    G = random(255);
    B = random(255);
    
    // Random transition
    Rspeed = (random(1) > 0.5 ? 1 : -1) * random(COLOUR_CHANGE_MIN, COLOUR_CHANGE_MAX);
    Gspeed = (random(1) > 0.5 ? 1 : -1) * random(COLOUR_CHANGE_MIN, COLOUR_CHANGE_MAX);
    Bspeed = (random(1) > 0.5 ? 1 : -1) * random(COLOUR_CHANGE_MIN, COLOUR_CHANGE_MAX); 
  }
  
  public void update()
  {
    // Random transition (keep within RGB colour range)
    Rspeed = ((R += Rspeed) > 255 || (R < 0)) ? -Rspeed : Rspeed;
    Gspeed = ((G += Gspeed) > 255 || (G < 0)) ? -Gspeed : Gspeed;
    Bspeed = ((B += Bspeed) > 255 || (B < 0)) ? -Bspeed : Bspeed;
  }
}