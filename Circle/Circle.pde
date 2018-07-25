//https://www.openprocessing.org/sketch/399338
//https://codepen.io/cmegown/pen/OEJEKv
float a=0;
int[] b=new int[15];
float[] d=new float[15];
float[] r=new float[15];

void setup(){
    size(480,480,P3D);
    colorMode(HSB,150);
    noFill();
    strokeWeight(2);   
    for (int i=0;i<15;i++) {         
      b[i]=150-5*i;
      d[i]=15*width/20.0-i*width/20.0;
      r[i]=(i/60.0)*HALF_PI;
    }
}
    
void draw(){
    background(0); 
    translate(width/2,height/2,0);   
    for (int i=0;i<15;i++){ // 15 concentric circles
        pushMatrix();
        stroke(100,150,b[i]);
        rotateY((i/60.0)*a*HALF_PI+a);      
        ellipse(0,0,d[i],d[i]);
        //rotateX(r[i]*a+a);
        ellipse(0,0,d[i],d[i]);
        rotateZ((i/60.0)*a*HALF_PI+a);
        ellipse(0,0,d[i],d[i]);
        popMatrix();
}
    a+=.05;
}