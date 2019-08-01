void setup() 
{
  size(500, 500); 
}
int x;
void draw()
{
  
background(0);

if(x<360){x++;}
pushMatrix();
translate(width/2,height/2);// bring zero point to the center

stroke(255, 255, 0);

point (sin(radians(x))*50,cos(radians(x))*50);
point (sin(radians(x))*25,cos(radians(x))*25);

stroke(255);

point (sin(radians(x))*50,cos(radians(x))*25);//<ellipse
popMatrix();


}
