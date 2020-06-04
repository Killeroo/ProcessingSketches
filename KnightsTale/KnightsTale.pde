final int SEGMENT_SIZE_X = 10;
final int SEGMENT_SIZE_Y = 10;

final int KNIGHT_MOVES_MAX = 2;
final int KNIGHT_MOVES_MIN = 1;
int gridWidth = 1;
int gridHeight = 1;

boolean running = true;

// Cleanup
// Make move function shorter
// add some color based on number difference

// TODO: variable start position
// TODO: Variable number layouts
// TODO: Variable knight move values (5 4)

// Change to array with fixed size
PVector[] grid;

Segment[][] board;

PVector knightCurrentIndex;
ArrayList<PVector> previousKnightMoves = new ArrayList<PVector>();

void setup()
{
  size(1000, 1000); 
  background(0);
  textSize(7);
  rectMode(CENTER);
  colorMode(HSB);
  strokeWeight(1);
  
  noFill();
  stroke(255, 0,0 );
  ellipse(width/2, height/2, 5, 5);
  
  // Work out width and height of grid (in segments
  gridWidth = width / SEGMENT_SIZE_X;
  gridHeight = height / SEGMENT_SIZE_Y;
  grid = new PVector[gridWidth * gridHeight];
  board = new Segment[gridWidth][gridHeight];
  
  // Create board
  PVector c = new PVector(-(SEGMENT_SIZE_X / 2), SEGMENT_SIZE_Y /2); 
  for (int x = 0; x < gridWidth; x++) { // Create along
    c.x += SEGMENT_SIZE_X;
    
    for (int y = 0; y < gridHeight; y++) { // Then create going down
      board[x][y] = new Segment(c.copy()); // Save the center of our segement
      c.y += SEGMENT_SIZE_Y;
    }
    
    // Reset y position
    c.y = SEGMENT_SIZE_Y / 2;
  }
  
  // Create our number spiral in the center
  spiral(gridWidth/2, gridHeight/2);
  
  // Start knight at center
  knightCurrentIndex = new PVector(gridWidth/2, gridHeight/2);
}

float c = 0;
void draw()
{
  stroke(255);
  
  if (!MoveKnight(knightCurrentIndex)) 
  {
    stroke(0, 255, 0);
    ellipse(board[(int)knightCurrentIndex.x][(int)knightCurrentIndex.y].center.x,
            board[(int)knightCurrentIndex.x][(int)knightCurrentIndex.y].center.y,
            20, 20);
    noLoop();
  }
  
  beginShape();
  PVector previousMove = new PVector(gridWidth/2, gridHeight/2);
  for (PVector move : previousKnightMoves)
  {
    fill(map(abs(previousMove.dist(move)), 0, 50, 0, 255), 255, 255);
    vertex(move.x, move.y);  
    
    previousMove = move.copy();
  }
  endShape();
}

boolean MoveKnight(PVector current_index)
{
  // So we need to check all the possible moves (there are 8)
  // unroll any loop because maybe it will help the speed
  // Anyway prepare for some dense conditional logic
  
  // Easier to access as ints
  int x = (int) current_index.x;
  int y = (int) current_index.y;
  
  int smallestNumber = -1;
  PVector indexWithSmallestNumber = new PVector(-1, -1);
  
  //ArrayList<Segment> canMoveTo = new ArrayList<Segment>();
  //ArrayList<Segment> potentialMoves = new ArrayList<Segment>();
  
  //potentialMoves.add(board[x + 2][y - 1]);
  //potentialMoves.add(board[x + 2][y + 1]);
  //potentialMoves.add(board[x - 1][y + 2]);
  //potentialMoves.add(board[x + 1][y + 2]);
  //potentialMoves.add(board[x - 2][y - 1]);
  //potentialMoves.add(board[x - 2][y + 1]);
  //potentialMoves.add(board[x - 1][y - 2]);
  //potentialMoves.add(board[x + 1][y - 2]);
  
  //Segment seg1 = board[x + 2][y - 1];
  //Segment seg2 = board[x + 2][y + 1];
  //Segment seg3 = board[x - 1][y + 2];
  //Segment seg4 = board[x + 1][y + 2];
  //Segment seg5 = board[x - 2][y - 1];
  //Segment seg6 = board[x - 2][y + 1];
  //Segment seg7 = board[x - 1][y - 2];
  //Segment seg8 = board[x + 1][y - 2];
  
  //if (!seg1.hit) 
  //{
  //  canMoveTo.add(seg1);
  //}
    
  //if (!seg2.hit) 
  //{
  //  canMoveTo.add(seg2);
  //}
    
  //if (!seg3.hit) 
  //{
  //  canMoveTo.add(seg3);
  //}
    
  //if (!seg4.hit) 
  //{
  //  canMoveTo.add(seg4);
  //}
    
  //if (!seg5.hit) 
  //{
  //  canMoveTo.add(seg5);
  //}
    
  //if (!seg6.hit) 
  //{
  //  canMoveTo.add(seg6);
  //}
    
  //if (!seg7.hit) 
  //{
  //  canMoveTo.add(seg7);
  //}
    
  //if (!seg8.hit) 
  //{
  //  canMoveTo.add(seg8);
  //}
  
  //if (canMoveTo.size() == 0)
  //{
  //  return false;  
  //}
  
  //int smallestNum = canMoveTo.get(0).number;
  //Segment smallestSeg = new Segment();
  //for (Segment seg : canMoveTo)
  //{
  //  if (seg.number < smallestNumber)
  //  {
  //    smallestNumber = seg.number;
  //  }
  //}
  
  //for (Segment seg : potentialMoves)
  //{
  //  if (seg.number == smallestNum)
  //  {
  //    seg.hit = true;
  //    previousKnightMoves.add(seg.center);
  //    knightCurrentIndex = seg.index;
  //    return true;
  //  }
  //}

  
  
  if (//InBoardBounds(x + 2, y - 1)
       board[x + 2][y - 1].hit == false
      && (board[x + 2][y - 1].number < smallestNumber || smallestNumber == -1))
  {
    smallestNumber = board[x + 2][y - 1].number;
    indexWithSmallestNumber.x = x + 2;
    indexWithSmallestNumber.y = y - 1;
  }
  //stroke(255, 255, 255);
  //ellipse(board[x + 2][y - 1].center.x, board[x + 2][y - 1].center.y, 10, 10); 
  
  if (//InBoardBounds(x + 2, y + 1)
     board[x + 2][y + 1].hit == false
    && (board[x + 2][y + 1].number < smallestNumber || smallestNumber == -1))
  {
    smallestNumber = board[x + 2][y + 1].number;
    indexWithSmallestNumber.x = x + 2;
    indexWithSmallestNumber.y = y + 1;
  }
  //stroke(255, 255, 255);
  //ellipse(board[x + 2][y + 1].center.x, board[x + 2][y + 1].center.y, 10, 10); 

  if (//InBoardBounds(x + 1, y + 2)
     board[x + 1][y + 2].hit == false
    && (board[x + 1][y + 2].number < smallestNumber || smallestNumber == -1))
  {
    smallestNumber = board[x + 1][y + 2].number;
    indexWithSmallestNumber.x = x + 1;
    indexWithSmallestNumber.y = y + 2;
  }  
  //stroke(255, 255, 255);
  //ellipse(board[x + 1][y + 2].center.x, board[x + 1][y + 2].center.y, 10, 10); 

  if (//InBoardBounds(x - 1, y + 2)
     board[x - 1][y + 2].hit == false
    && (board[x - 1][y + 2].number < smallestNumber || smallestNumber == -1))
  {
    smallestNumber = board[x - 1][y + 2].number;
    indexWithSmallestNumber.x = x - 1;
    indexWithSmallestNumber.y = y + 2;
  }  
  //stroke(255, 255, 255);
  //ellipse(board[x - 1][y + 2].center.x, board[x - 1][y + 2].center.y, 10, 10);
  
  if (//InBoardBounds(x - 2, y + 1)
     board[x - 2][y + 1].hit == false
    && (board[x - 2][y + 1].number < smallestNumber || smallestNumber == -1))
  {
    smallestNumber = board[x - 2][y + 1].number;
    indexWithSmallestNumber.x = x - 2;
    indexWithSmallestNumber.y = y + 1;
  }  
  //stroke(255, 255, 255);
  //ellipse(board[x - 2][y + 1].center.x, board[x - 2][y + 1].center.y, 10, 10);
  
  if (//InBoardBounds(x - 2, y - 1)
     board[x - 2][y - 1].hit == false
    && (board[x - 2][y - 1].number < smallestNumber || smallestNumber == -1))
  {
    smallestNumber = board[x - 2][y - 1].number;
    indexWithSmallestNumber.x = x - 2;
    indexWithSmallestNumber.y = y - 1;
  }  
  //stroke(255, 255, 255);
  //ellipse(board[x - 2][y - 1].center.x, board[x - 2][y - 1].center.y, 10, 10);

  if (//InBoardBounds(x - 1, y - 2)
     board[x - 1][y - 2].hit == false
    && (board[x - 1][y - 2].number < smallestNumber || smallestNumber == -1))
  {
    smallestNumber = board[x - 1][y - 2].number;
    indexWithSmallestNumber.x = x - 1;
    indexWithSmallestNumber.y = y - 2;
  }  
 // stroke(255, 255, 255);
  //ellipse(board[x - 1][y - 2].center.x, board[x - 1][y - 2].center.y, 10, 10);

  if (//InBoardBounds(x + 1, y - 2)
     board[x + 1][y - 2].hit == false
    && (board[x + 1][y - 2].number < smallestNumber || smallestNumber == -1))
  {
    smallestNumber = board[x + 1][y - 2].number;
    indexWithSmallestNumber.x = x + 1;
    indexWithSmallestNumber.y = y - 2;
  }  
  //stroke(255, 255, 255);
  //ellipse(board[x + 1][y - 2].center.x, board[x + 1][y - 2].center.y, 10, 10);

  if (indexWithSmallestNumber.x == -1.0)
  {
   return false; 
  }

  // Move the knight to the index with the smallest number
  println("---------------------------------");
  println(indexWithSmallestNumber);
  println(board[(int)indexWithSmallestNumber.x][(int)indexWithSmallestNumber.y].number);
  println(previousKnightMoves.size());
  
  board[(int)indexWithSmallestNumber.x][(int)indexWithSmallestNumber.y].hit = true;
  // Add index to previous moves
  previousKnightMoves.add(board[(int)indexWithSmallestNumber.x][(int)indexWithSmallestNumber.y].center.copy());
  knightCurrentIndex = indexWithSmallestNumber.copy();
  
  println(previousKnightMoves.size());
  
  return true;
}

// Create a number spiral on the board:
/*
  17--16--15--14--13   .
   |               |   .
  18   5---4---3  12   .
   |   |       |   |   .
  19   6   1---2  11   .
   |   |           |   .
  20   7---8---9--10   .
   |                   .
  21--22--23--24--25--26 
*/
// source: https://oeis.org/A316667
// This is long and could be made _a lot_ faster and shorter
void spiral(int index_x, int index_y)
{
  
  stroke(255);
  noFill();
  int increment = 1;
  
  int curr_index_x = index_x;
  int curr_index_y = index_y;
  
  int count = 1;
  
  // These determine our direction depending on which axis
  boolean down = false;
  boolean right = true; 
  
  
  board[curr_index_x][curr_index_y].number = count;
  //board[curr_index_x][curr_index_y].index = new PVector(curr_index_x, curr_index_y);
  board[curr_index_x][curr_index_y].hit = true;
  previousKnightMoves.add(board[curr_index_x][curr_index_y].center);
  count++;
  
  while(true)
  {
    for (int i = 0; i < increment; i++) 
    {
      if (right)
      {
         curr_index_x++;
         
          
        
         
         if (InBoardBounds(curr_index_x, curr_index_y))
         {
           //text(count, board[curr_index_x][curr_index_y].center.x, board[curr_index_x][curr_index_y].center.y, 10);
           // Assign current number (count) to segment at current index
           //println(board[curr_index_x][curr_index_y].center);
           board[curr_index_x][curr_index_y].number = count;
           // board[curr_index_x][curr_index_y].index = new PVector(curr_index_x, curr_index_y);
          // ellipse(board[curr_index_x][curr_index_y].center.x, board[curr_index_x][curr_index_y].center.y, 10, 10);
         }
         
         count++;
      } 
      else
      {
        curr_index_x--;
        
          
        
        if (InBoardBounds(curr_index_x, curr_index_y))
        {
         // text(count, board[curr_index_x][curr_index_y].center.x, board[curr_index_x][curr_index_y].center.y, 10);
          board[curr_index_x][curr_index_y].number = count;
       //   println(board[curr_index_x][curr_index_y].center);
//  board[curr_index_x][curr_index_y].index = new PVector(curr_index_x, curr_index_y);
         // ellipse(board[curr_index_x][curr_index_y].center.x, board[curr_index_x][curr_index_y].center.y, 10, 10);
        }
         
        count++;
      }
    }
    
    // Flip direction
    right = !right;
    
    for (int i = 0; i < increment; i++)
    {
      if (down)
      {
         curr_index_y++;
         
         //board[curr_index_x][curr_index_y].number = count;
          
        
         
         if (InBoardBounds(curr_index_x, curr_index_y))
         {
           //text(count, board[curr_index_x][curr_index_y].center.x, board[curr_index_x][curr_index_y].center.y, 10);
           board[curr_index_x][curr_index_y].number = count;
          // println(board[curr_index_x][curr_index_y].center);
  //board[curr_index_x][curr_index_y].index = new PVector(curr_index_x, curr_index_y);
           //ellipse(board[curr_index_x][curr_index_y].center.x, board[curr_index_x][curr_index_y].center.y, 10, 10);
         }
         
         count++;
      } 
      else
      {
        curr_index_y--;
        
//board[curr_index_x][curr_index_y].number = count;
         
        
        
        if (InBoardBounds(curr_index_x, curr_index_y))
        {
         // text(count, board[curr_index_x][curr_index_y].center.x, board[curr_index_x][curr_index_y].center.y, 10);
          board[curr_index_x][curr_index_y].number = count;
          //println(board[curr_index_x][curr_index_y].center);
  //board[curr_index_x][curr_index_y].index = new PVector(curr_index_x, curr_index_y);
         // ellipse(board[curr_index_x][curr_index_y].center.x, board[curr_index_x][curr_index_y].center.y, 10, 10);
        }
         
        count++;
      }
    }
    
    down = !down;
    
    // Break out if we have reach the end of board
    // Improve!
    if (abs(curr_index_x) > gridWidth && abs(curr_index_y) > gridHeight)
    {
      println("done");
      break; 
    }
    else 
    {
      println("----------------");
      println("increment", increment);
      println(curr_index_x, curr_index_y);  
    }
    
    
    
    increment += 1;
  }
}

boolean InBoardBounds(int index_x, int index_y)
{
   if (index_x > -1 && index_y > -1 
     && index_x < gridWidth && index_y < gridHeight)
   {
     return true;
   }
   return false;
}

//void mousePressed()
//{
//  PVector mousePosition = new PVector(mouseX, mouseY);
//  float distance = 0;
  
//  for (int x = 0; x < gridWidth; x++) {
//    for (int y = 0; y < gridHeight; y++) {
//      rect(board[x][y].center.x, board[x][y].center.y, 10, 10);
//      float distance = 
//    }
//  }
//}

class Segment
{
  boolean hit = false;
  int number = -1;
  PVector center;
  //PVector index;
  
  Segment() {}
  Segment(PVector pos)
  {
    center = pos;  
  }
}
