ArrayList stars;

void setup(){
  size(500,500);
  background(0);
  //background stars
  stars = new ArrayList();
  for(int i = 1; i <= 300; i++){
    stars.add(new star());
  }
  
  //background(0);
  ////background stars
  //for(int i = 0; i <= stars.size()-1; i++){
  //  star starUse = (star) stars.get(i);
  //  starUse.display();
  //}
}
void draw(){
  background(0);
  //background stars
  for(int i = 0; i <= stars.size()-1; i++){
    star starUse = (star) stars.get(i);
    starUse.display();
  }
}

class star {
  int xPos, yPos, starSize;
  float flickerRate, light;
  boolean rise;
  star(){
    flickerRate = random(2,3);//5); 
    starSize = int(2);//random(2,5));
    xPos = int(random(0,500 - starSize));
    yPos = int(random(0,500 - starSize));
    light = random(10,245);
    rise = true;
  }
  void display(){
    if(light >= 245){
      rise = false;
    }
    if(light <= 10){
      flickerRate = random(2,5);
      starSize = int(random(2,5));
      rise = true;
      xPos = int(random(0,500 - starSize));
      yPos = int(random(0,500 - starSize));
    }
    if(rise == true){
      light += flickerRate;
    }
    if(rise == false){
      light -= flickerRate;
    }
    fill(light);
    rect(xPos, yPos,starSize,starSize);
  }
}

/* Orginal:
// source: https://www.openprocessing.org/sketch/65037#

ArrayList stars;

void setup(){
  size(500,500);
  background(0);
  //background stars
  stars = new ArrayList();
  for(int i = 1; i <= 300; i++){
    stars.add(new star());
  }
}
void draw(){
  background(0);
  //background stars
  for(int i = 0; i <= stars.size()-1; i++){
    star starUse = (star) stars.get(i);
    starUse.display();
  }
}

class star {
  int xPos, yPos, starSize;
  float flickerRate, light;
  boolean rise;
  star(){
    flickerRate = random(2,5); 
    starSize = int(random(2,5));
    xPos = int(random(0,500 - starSize));
    yPos = int(random(0,500 - starSize));
    light = random(10,245);
    rise = true;
  }
  void display(){
    if(light >= 245){
      rise = false;
    }
    if(light <= 10){
      flickerRate = random(2,5);
      starSize = int(random(2,5));
      rise = true;
      xPos = int(random(0,500 - starSize));
      yPos = int(random(0,500 - starSize));
    }
    if(rise == true){
      light += flickerRate;
    }
    if(rise == false){
      light -= flickerRate;
    }
    fill(light);
    rect(xPos, yPos,starSize,starSize);
  }
}
*/