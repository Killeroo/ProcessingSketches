//https://forum.processing.org/two/discussion/6783/making-a-slider

// array to hold all sliders
Test[] instances =  new Test[3]; 
 
void setup() {
  size(200, 600);
  noStroke(); 
  // init them: (xPos, yPos, width, height)
  instances[0] = new Test(20, 20, 40, 20);
  instances[1] = new Test(80, 20, 40, 20);
  instances[2] = new Test(140, 20, 40, 20);
}
 
void draw() {
  background(100);
 
  //call run method...
  for (Test t:instances)
    t.run();
}
 
 
void mousePressed() {
 
  //lock if clicked
  for (Test t:instances)
  {
    if (t.isOver())
      t.lock = true;
  }
}
 
void mouseReleased() {
 
  //unlock
  for (Test t:instances)
  {
    t.lock = false;
  }
}
 
 
class Test {
  //class vars
  float x;
  float y;
  float w, h;
  float initialY;
  boolean lock = false;
 
  //constructors
 
  //default
  Test () {
  }
 
  Test (float _x, float _y, float _w, float _h) {
 
    x=_x;
    y=_y;
    initialY = y;
    w=_w;
    h=_h;
  }
 
 
  void run() {
 
    // bad practice have all stuff done in one method...
    float lowerY = height - h - initialY;
 
    // map value to change color..
    float value = map(y, initialY, lowerY, 120, 255);
 
    // map value to display
    float value2 = map(value, 120, 255, 100, 0);
 
    //set color as it changes
    color c = color(value);
    fill(c);
 
    // draw base line
    rect(x, initialY, 4, lowerY);
 
    // draw knob
    fill(200);
    rect(x, y, w, h);
 
    // display text
    fill(0);
    text(int(value2) +"%", x+5, y+15);
 
    //get mouseInput and map it
    float my = constrain(mouseY, initialY, height - h - initialY );
    if (lock) y = my;
  }
 
  // is mouse ove knob?
  boolean isOver()
  {
    return (x+w >= mouseX) && (mouseX >= x) && (y+h >= mouseY) && (mouseY >= y);
  }
}
/*Scrollbar bar;

void setup() 
{
  size(1000, 1000);
  
  bar = new Scrollbar(0, 20, width, 10, 50, 100, 16);
}

void draw() 
{
  background(255);
  
  bar.update();
  bar.display();
}

class Scrollbar 
{
  PVector pos, size;
  PVector new_pos = new PVector();
  float new_pos_x = 0;
  float value_min, value_max;
  float value_cur;
  boolean locked, over;
  int lerp_value; // lerp value
  
  Scrollbar (int pos_x, int pos_y, 
             int size_x, int size_y, 
             float val_min, float val_max,
             int l)
  {
    pos = new PVector(pos_x, pos_y);
    size = new PVector(size_x, size_y);
    
    value_min = val_min;
    value_max = val_max;
    
    value_cur = pos.x + size.x / 2 - size.y / 2;
    
    lerp_value = l;
  }
  
  void update()
  {
    if (over()) {
      println("over");
      over = true;  
    } else {
      println("not over");
      over = false;
    }
    
    if (mousePressed && over) {
      locked = true;  
    }
    
    if (!mousePressed) {
      locked = false;  
    }
    
    if (locked) {
      new_pos.x = constrain(mouseX - size.x / 2, value_min, value_max);
    }
    
    if (abs(new_pos.x - value_cur) > 1) {
      value_cur = value_cur + (new_pos.x - value_cur) / lerp_value;  
    }
      
  }
  
  void display() 
  {
    fill(255);
    rect(pos.x, pos.y, size.x, size.y);
    if (over || locked) {
      fill(153, 102, 0);  
    } else {
      fill(102, 102, 102);
    }
    rect(value_cur, pos.y, size.y, size.y);
    println(value_cur);
  }
  
  boolean over()
  {
    if (mouseX > pos.x && mouseX < pos.x + size.x
        && mouseY > pos.y && mouseY < pos.y + size.y) {
      return true;      
    } else {
      return false;  
    }
  }
}
*/
