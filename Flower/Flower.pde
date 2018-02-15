////////////////////////////////////////////////////////////////////////
///                        Aimee's Flower                            ///
////////////////////////////////////////////////////////////////////////
///                                                                  ///
/// Written by Matthew Carney =^-^= (20.4.2016)                      ///
///                                                                  ///
///       Inspired by this anonymous piece of genius                 ///
///       http://www.openprocessing.org/sketch/16970                 ///
///                                                                  ///
////////////////////////////////////////////////////////////////////////

// Test height changing

final int MAX_BRANCHES = 8;

float x, y; // Positions of mouse when clicked with mouse easing
float posX, posY; // Positions of mouse when clicked
int time;
int subBranches = 5; // Number of sub branches to draw
int length = 2;

ColorGenerator colorGen = new ColorGenerator();                      

void setup() { 
    size(750, 750);
    background(255);  //set background white
    colorMode(RGB);   //set colors to Hue, Saturation, Brightness mode
    frameRate(60);
    surface.setTitle("Flower");
     time = millis();
    noStroke();
    smooth();
}

void draw() {  // draw loop  
    
    colorGen.update();
  
    text("Aimee's Flower (V1.1)", 10, 20);
  
    noStroke();
    fill(255, 20);
    rect(0, 0, width, height);
    fill(0);
  
    // Grow every 10 minutes
    if (millis() > time + 600000) {
      if (subBranches == MAX_BRANCHES) {
        subBranches = 5;  
        length = 1;
      }
      subBranches++;
      length++;
      time = millis();
      colorGen.init();
    }
    
    if (x == 0 && y == 0){
      // Random start position
      x = random(0, 700);
      y = random (200, 600);
      posX = x;
      posY = y;
    } else {
      // Smooth mouse movement with linear interpolation
      x = lerp(x, posX, 0.05);
      y = lerp(y, posY, 0.05);
    }
    
    // Draw flower
    drawFlowerBranch(width / 2, height / 2 + 200, 2 + x / 100, 25 + (length * 7), PI / 2, 5, subBranches, false); // Draw left side
    drawFlowerBranch(width / 2, height / 2 + 200, 2 + x / 100, 25 + (length * 7), PI / 2, 5, subBranches, true); // Draw right side
    
}

// Recursive branch drawing function
void drawFlowerBranch(float startX, float startY, float curlCoefficient, float branchLen, float baseAngle, int mainBranchRecursions, int subBranchRecursions, boolean rightSide) {
  //colorGen.update();
  
  // Colour branch segment
  if (mainBranchRecursions % 2 == 0) { // if recursion is even
    stroke(0);
  } else {
    stroke(colorGen.R, colorGen.G, colorGen.B);//colorRanges[hour][mainBranchRecursions - 1]); // Color range determined by hour of day, color used determined by main branch recursions
  }
  
  // If we are still drawing main branches
  if (mainBranchRecursions > 0) {
    float nextX, nextY, nextAngle; // Stores position and angle of next branch segment
    
    // Calculate branch position diffently depending on which side of flower we are drawing
    if (rightSide) {
      // Get next branch starting point by using baseAngle to calculate new position in regards to general flower curve
      nextX = startX - branchLen * cos(baseAngle);
      nextY = startY - branchLen * sin(baseAngle);
    } else {
      nextX = startX + branchLen * cos(baseAngle);
      nextY = startY - branchLen * sin(baseAngle);
    }
    
    line(startX, startY, nextX, nextY); // Draw line from start point to start point of next branch segment
    
    nextAngle = baseAngle + PI / curlCoefficient; // Work out next branch segment (again working out angle in regards to overall flower curvature)
    
    // If we are still drawing sub branches
    if (subBranchRecursions > 0) {
      // Draw a sub branch
      drawFlowerBranch(nextX, nextY, curlCoefficient + 5, branchLen, y * baseAngle / 300, mainBranchRecursions, subBranchRecursions - 1, rightSide);
    }
    
    // Draw a main branch
    drawFlowerBranch(nextX, nextY, curlCoefficient / 2, branchLen / 2, nextAngle, mainBranchRecursions - 1, subBranchRecursions, rightSide);
    
    // NOTE:
    // Sub branches and main branches are drawn in slightly different ways, sub branches half coeff and branch len each recursion
    // so the recursion is not infinite with no variation. Main branches also use the next predicted angle in curve, sub branch angle is
    // calculated differently. This is because unlike main branches, sub branches are recursed into each time a new main branch is made, ie
    // they arent as big (angle and length wise)
  }
}

void mouseMoved() {//Dragged() {
  // Only update mouse positions when mouse is dragged
  posX = mouseX; 
  posY = mouseY;
}

void keyPressed() {
  if (key == ENTER) {
    //colorGen.init();
      if (subBranches == MAX_BRANCHES) {
        subBranches = 5;  
        length = 1;
      }
      subBranches++;
      length++;
  }
}

void mouseClicked() {
  colorGen.init();
}

class ColorGenerator
{
  final static float MIN_SPEED = 0.7;// Min speed of color change
  final static float MAX_SPEED = 1.5; // Max speed of color change
  float R, G, B; // Starting color combination
  float Rspeed , Gspeed, Bspeed; // Speed of color transition
  
  ColorGenerator()
  {
    init();
  }
  
  public void init()
  {
    // Generate base start colours
    R = noise(random(255));
    G = random(255);
    B = random(255);
    
    // transition to new related colour
    Rspeed = (random(1) > 0.5 ? 1 : -1) * random(MIN_SPEED, MAX_SPEED);
    Gspeed = (random(1) > 0.5 ? 1 : -1) * random(MIN_SPEED, MAX_SPEED);
    Bspeed = (random(1) > 0.5 ? 1 : -1) * random(MIN_SPEED, MAX_SPEED);
  }
  
  public void update()
  {
    // Change color but keep the colour ranges withing the RGB 255 bounds
    Rspeed = ((R += Rspeed) > 255 || (R < 0)) ? -Rspeed : Rspeed;
    Gspeed = ((G += Rspeed) > 255 || (G < 0)) ? -Gspeed : Gspeed;
    Bspeed = ((B += Rspeed) > 255 || (B < 0)) ? -Bspeed : Bspeed;
  }
}