class Triangle
{
  PVector A, B, C;
  
  Triangle(PVector p1, PVector p2, PVector p3)
  {
    A = p1;
    B = p2;
    C = p3;
  }
  
  void display()
  {
    vertex(A.x, A.y);
    vertex(B.x, B.y);
    vertex(C.x, C.y);
  }
}