void setup()
{
  size(1000, 1000);  
  noLoop();
}

void draw()
{
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      float noiseAmount = noise(x/5, y/20);//x/0.2, y/5);//stroke(255, 0, 0);
      stroke(map(noiseAmount, 0, 1, 0, 255));
      point(x, y);  
    }
  }
}
