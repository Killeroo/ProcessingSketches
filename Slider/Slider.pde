Scrollbar bar;

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
