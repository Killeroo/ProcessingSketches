//https://www.openprocessing.org/sketch/399338
//https://codepen.io/cmegown/pen/OEJEKv
float a=0;
int[] b=new int[15];
float[] d=new float[15];
float[] r=new float[15];
ColourGenerator[] c = new ColourGenerator[15];

void setup(){
    size(480,480,P3D);
    colorMode(HSB,150);
    noFill();
    strokeWeight(10);//2);   
    for (int i=0;i<15;i++) {         
      b[i]=150-5*i;
      d[i]=15*width/20.0-i*width/20.0;
      r[i]=(i/60.0)*HALF_PI;
      c[i]=new ColourGenerator();
    }
}
    
void draw(){
    background(0); 
    translate(width/2,height/2,0);   
    for (int i=0;i<15;i++){ // 15 concentric circles
        stroke(c[i].R, c[i].G, c[i].B);
        
        pushMatrix();
        //stroke(100,150,b[i]);
        rotateY((i/60.0)*a*HALF_PI+a);      
        ellipse(0,0,d[i],d[i]);
        //rotateX(r[i]*a+a);
        ellipse(0,0,d[i],d[i]);
        rotateZ((i/60.0)*a*HALF_PI+a);
        ellipse(0,0,d[i],d[i]);
        popMatrix();
        
        c[i].update();
}
    a+=.05;
}

class ColourGenerator
{
  final static float MIN_SPEED = 0.2;//7;
  final static float MAX_SPEED = 0.7;//1.5;
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
    Rspeed = (random(1) > 0.5 ? 1 : -1) * random(MIN_SPEED, MAX_SPEED);
    Gspeed = (random(1) > 0.5 ? 1 : -1) * random(MIN_SPEED, MAX_SPEED);
    Bspeed = (random(1) > 0.5 ? 1 : -1) * random(MIN_SPEED, MAX_SPEED); 
  }
  
  public void update()
  {
    // Random transition (keep within RGB colour range)
    Rspeed = ((R += Rspeed) > 255 || (R < 0)) ? -Rspeed : Rspeed;
    Gspeed = ((G += Gspeed) > 255 || (G < 0)) ? -Gspeed : Gspeed;
    Bspeed = ((B += Bspeed) > 255 || (B < 0)) ? -Bspeed : Bspeed;
  }
}