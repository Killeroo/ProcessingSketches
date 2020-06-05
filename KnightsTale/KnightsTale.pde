// Implementation of the Trapped Knight integer sequence
// https://youtu.be/RGQe8waGJ4w
// More info: https://oeis.org/A316667
// Matthew Carney (matthewcarney64@gmail.com) 5th June 2020

// Other things that can be done:
// - Different chess pieces
// - Different number spiral patterns

// Size of each segment on the board (zoom in and out with these)
final int SEGMENT_SIZE_X = 5;//10;
final int SEGMENT_SIZE_Y = 5;//10;

// Control the amount the knight can move with these
// (I've included some interesting combos that I found
int knightMoveMax = 2;//4;//4;//3;//5;//2;
int knightMoveMin = 1;//2;//1;//1;//2;//1;

PVector currentKnightIndex;
ArrayList<Segment> previousKnightMoves = new ArrayList<Segment>();

Segment[][] board;
int boardWidth = 1;
int boardHeight = 1;
int currentColorMode = 3;

void setup()
{
  size(1000, 1000); 
  background(0);
  textSize(7);
  rectMode(CENTER);
  colorMode(HSB);
  strokeWeight(1);
  noFill();
  
  // Work out width and height of grid (in segments)
  boardWidth = width / SEGMENT_SIZE_X;
  boardHeight = height / SEGMENT_SIZE_Y;
  board = new Segment[boardWidth][boardHeight];
  
  // Create our underlying chess board for the knight to move along
  CreateBoard();
  
  // Create our number spiral in the center
  CreateNumberedSquareSpiral(boardWidth/2, boardHeight/2);
  
  // Start knight at center of board
  currentKnightIndex = new PVector(boardWidth/2, boardHeight/2);
}

// Frame time debugging stuff
int frame_start = 0;
int move_time = 0;
int draw_time = 0;
int frame_end = 0;
void draw()
{
  frame_start = millis();
  
  background(0);
  stroke(255);
  
  if (!MoveKnight(currentKnightIndex)) 
  {
    stroke(50, 255, 255);
    ellipse(board[(int)currentKnightIndex.x][(int)currentKnightIndex.y].center.x,
            board[(int)currentKnightIndex.x][(int)currentKnightIndex.y].center.y,
            20, 20);
            
    println("Sequence dead. Moves:", previousKnightMoves.size(), ", last number in sequence:", previousKnightMoves.get(previousKnightMoves.size()-1).number, ", last draw took", draw_time - move_time, "ms");

    // Wait 2 seconds and then reset
    delay(2000);
    Reset();
    return;
  }
  move_time = millis();
  
  //beginShape();
  Segment previousMove = previousKnightMoves.get(0);
  int count = 1;
  for (Segment move : previousKnightMoves)
  {
    // Color based on our current color mode
    ColorMode(currentColorMode, count, move.number);
    
    //vertex(move.x, move.y); 
    line(previousMove.center.x, previousMove.center.y, move.center.x, move.center.y);
    
    previousMove = move;
    count++;
  }
  //endShape();
  draw_time = millis();
  
  frame_end = millis();
  
  // Print out how long it took for the frame to run (performance testing)
  //println("move time", move_time - frame_start, "ms | draw time", draw_time - move_time, "ms | total", frame_end - frame_start);
}

boolean MoveKnight(PVector current_index)
{
  // So we need to check all the possible moves (there are 8)
  // Then we pick the move with the smallest number
  // unroll any loop because maybe it will help the speed
  // Anyway prepare for some dense conditional logic
  
  // Easier to access as ints
  int x = (int) current_index.x;
  int y = (int) current_index.y;
  
  int smallestNumber = -1;
  PVector indexWithSmallestNumber = new PVector(-1, -1);
  
  // Check each possible move
  if (InBoardBounds(x + knightMoveMax, y - knightMoveMin)
      && board[x + knightMoveMax][y - knightMoveMin].hit == false
      && (board[x + knightMoveMax][y - knightMoveMin].number < smallestNumber || smallestNumber == -1))
  {
    smallestNumber = board[x + knightMoveMax][y - knightMoveMin].number;
    indexWithSmallestNumber.x = x + knightMoveMax;
    indexWithSmallestNumber.y = y - knightMoveMin;
  }
  //stroke(255, 255, 255);
  //ellipse(board[x + 2][y - 1].center.x, board[x + 2][y - 1].center.y, 10, 10); 
  
  if (InBoardBounds(x + knightMoveMax, y + knightMoveMin)
      && board[x + knightMoveMax][y + knightMoveMin].hit == false
      && (board[x + knightMoveMax][y + knightMoveMin].number < smallestNumber || smallestNumber == -1))
  {
    smallestNumber = board[x + knightMoveMax][y + knightMoveMin].number;
    indexWithSmallestNumber.x = x + knightMoveMax;
    indexWithSmallestNumber.y = y + knightMoveMin;
  }
  //stroke(255, 255, 255);
  //ellipse(board[x + 2][y + 1].center.x, board[x + 2][y + 1].center.y, 10, 10); 

  if (InBoardBounds(x + knightMoveMin, y + knightMoveMax)
      && board[x + knightMoveMin][y + knightMoveMax].hit == false
      && (board[x + knightMoveMin][y + knightMoveMax].number < smallestNumber || smallestNumber == -1))
  {
    smallestNumber = board[x + knightMoveMin][y + knightMoveMax].number;
    indexWithSmallestNumber.x = x + knightMoveMin;
    indexWithSmallestNumber.y = y + knightMoveMax;
  }  
  //stroke(255, 255, 255);
  //ellipse(board[x + 1][y + 2].center.x, board[x + 1][y + 2].center.y, 10, 10); 

  if (InBoardBounds(x - knightMoveMin, y + knightMoveMax)
      && board[x - knightMoveMin][y + knightMoveMax].hit == false
      && (board[x - knightMoveMin][y + knightMoveMax].number < smallestNumber || smallestNumber == -1))
  {
    smallestNumber = board[x - knightMoveMin][y + knightMoveMax].number;
    indexWithSmallestNumber.x = x - knightMoveMin;
    indexWithSmallestNumber.y = y + knightMoveMax;
  }  
  //stroke(255, 255, 255);
  //ellipse(board[x - 1][y + 2].center.x, board[x - 1][y + 2].center.y, 10, 10);
  
  if (InBoardBounds(x - knightMoveMax, y + knightMoveMin)
      && board[x - knightMoveMax][y + knightMoveMin].hit == false
      && (board[x - knightMoveMax][y + knightMoveMin].number < smallestNumber || smallestNumber == -1))
  {
    smallestNumber = board[x - knightMoveMax][y + knightMoveMin].number;
    indexWithSmallestNumber.x = x - knightMoveMax;
    indexWithSmallestNumber.y = y + knightMoveMin;
  }  
  //stroke(255, 255, 255);
  //ellipse(board[x - 2][y + 1].center.x, board[x - 2][y + 1].center.y, 10, 10);
  
  if (InBoardBounds(x - knightMoveMax, y - knightMoveMin)
      && board[x - knightMoveMax][y - knightMoveMin].hit == false
      && (board[x - knightMoveMax][y - knightMoveMin].number < smallestNumber || smallestNumber == -1))
  {
    smallestNumber = board[x - knightMoveMax][y - 1].number;
    indexWithSmallestNumber.x = x - knightMoveMax;
    indexWithSmallestNumber.y = y - knightMoveMin;
  }  
  //stroke(255, 255, 255);
  //ellipse(board[x - 2][y - 1].center.x, board[x - 2][y - 1].center.y, 10, 10);

  if (InBoardBounds(x - knightMoveMin, y - knightMoveMax)
      && board[x - knightMoveMin][y - knightMoveMax].hit == false
      && (board[x - knightMoveMin][y - knightMoveMax].number < smallestNumber || smallestNumber == -1))
  {
    smallestNumber = board[x - knightMoveMin][y - knightMoveMax].number;
    indexWithSmallestNumber.x = x - knightMoveMin;
    indexWithSmallestNumber.y = y - knightMoveMax;
  }  
 // stroke(255, 255, 255);
  //ellipse(board[x - 1][y - 2].center.x, board[x - 1][y - 2].center.y, 10, 10);

  if (InBoardBounds(x + knightMoveMin, y - knightMoveMax)
      && board[x + 1][y - knightMoveMax].hit == false
      && (board[x + 1][y - knightMoveMax].number < smallestNumber || smallestNumber == -1))
  {
    smallestNumber = board[x + knightMoveMin][y - knightMoveMax].number;
    indexWithSmallestNumber.x = x + knightMoveMin;
    indexWithSmallestNumber.y = y - knightMoveMax;
  }  
  //stroke(255, 255, 255);
  //ellipse(board[x + 1][y - 2].center.x, board[x + 1][y - 2].center.y, 10, 10);

  // We can't move anywhere, bail out
  if (indexWithSmallestNumber.x == -1.0)
  {
   return false; 
  }

  // Move the knight to the index with the smallest number
  board[(int)indexWithSmallestNumber.x][(int)indexWithSmallestNumber.y].hit = true;
  
  // Add to previous moves
  previousKnightMoves.add(board[(int)indexWithSmallestNumber.x][(int)indexWithSmallestNumber.y]);
  currentKnightIndex = indexWithSmallestNumber.copy();
  
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
void CreateNumberedSquareSpiral(int index_x, int index_y)
{
  int increment = 1;
  
  int curr_index_x = index_x;
  int curr_index_y = index_y;
  
  // Current number we are on
  int count = 1;
  
  // These determine our direction depending on which axis
  boolean down = false;
  boolean right = true; 
  
  // Add the first square manually
  board[curr_index_x][curr_index_y].number = count;
  board[curr_index_x][curr_index_y].hit = true;
  previousKnightMoves.add(board[curr_index_x][curr_index_y]);
  count++;
  
  // Loop through adding and numbering squares in the spiral
  // This is all very hacky but we work through the board using the indexes.
  // We move in the same way as the diagram at the start of the function
  // We get the starting index and move out and around that point using an increment
  // in both axis, we determine which direction to move in using the down and right bool
  // variables. We access each segment, number it and move on, the count variable stores
  // the current number in the sequence.
  // We also avoid accessing segments outside the board bounds, we exit the function
  // Once we have reached the end of the board
  while(true)
  {
    // Move x axis first
    for (int i = 0; i < increment; i++) 
    {
      if (right)
      {
         curr_index_x++;
         
         if (InBoardBounds(curr_index_x, curr_index_y))
         {
           // Assign current number (count) to segment at current index
           board[curr_index_x][curr_index_y].number = count;
           board[curr_index_x][curr_index_y].hit = false;
           //text(count, board[curr_index_x][curr_index_y].center.x, board[curr_index_x][curr_index_y].center.y, 10);
         }
         
         count++;
      } 
      else
      {
        curr_index_x--;
        
        if (InBoardBounds(curr_index_x, curr_index_y))
        {
          board[curr_index_x][curr_index_y].number = count;
          board[curr_index_x][curr_index_y].hit = false;
          // text(count, board[curr_index_x][curr_index_y].center.x, board[curr_index_x][curr_index_y].center.y, 10);
        }
         
        count++;
      }
    }
    
    // Flip direction
    right = !right;
    
    // Y axis after
    for (int i = 0; i < increment; i++)
    {
      if (down)
      {
         curr_index_y++;
         
         if (InBoardBounds(curr_index_x, curr_index_y))
         {
           board[curr_index_x][curr_index_y].number = count;
           board[curr_index_x][curr_index_y].hit = false;
           //text(count, board[curr_index_x][curr_index_y].center.x, board[curr_index_x][curr_index_y].center.y, 10);
         }
         
         count++;
      } 
      else
      {
        curr_index_y--;
        
        if (InBoardBounds(curr_index_x, curr_index_y))
        {
          board[curr_index_x][curr_index_y].number = count;
          board[curr_index_x][curr_index_y].hit = false;
         // text(count, board[curr_index_x][curr_index_y].center.x, board[curr_index_x][curr_index_y].center.y, 10);
        }
         
        count++;
      }
    }
    
    down = !down;
    
    // Break out if we have reach the end of board
    // Improve!
    if (abs(curr_index_x) > boardWidth && abs(curr_index_y) > boardHeight)
    {
      break; 
    }
    
    increment += 1;
  }
}

void CreateBoard()
{
  // Setup our 'infinite' chess board
  PVector c = new PVector(-(SEGMENT_SIZE_X / 2), SEGMENT_SIZE_Y /2); 
  for (int x = 0; x < boardWidth; x++) { // Create along
    c.x += SEGMENT_SIZE_X;
    
    for (int y = 0; y < boardHeight; y++) { // Then create going down
      board[x][y] = new Segment(c.copy()); // Save the center of our segement
      c.y += SEGMENT_SIZE_Y;
    }
    
    // Reset y position
    c.y = SEGMENT_SIZE_Y / 2;
  }  
}

// Checks an index is in the board bounds
boolean InBoardBounds(int index_x, int index_y)
{
   if (index_x > -1 && index_y > -1 
     && index_x < boardWidth && index_y < boardHeight)
   {
     return true;
   }
   return false;
}

void ColorMode(int mode, int current_segment, int sequence_number)
{
  // Color based on.. 
  switch(mode)
  {
    case 1:
       // Position in the previous moves
       colorMode(HSB);
       stroke(map(current_segment, 1, 3000, 0, 255), 255, 255);
       break;
     case 2:
       // Position in the previous moves (mapped to different values)
       colorMode(HSB);
       stroke(map(current_segment, 1, 6000, 0, 255), 255, 255);
       break;
     case 3:
       // Number in sequence value
       colorMode(HSB);
       stroke(map(sequence_number, 1, 10000, 0, 255), 255, 255);
      break;
     case 4:
       // Position in previous moves
       colorMode(HSB);
       stroke(map(current_segment, 1, previousKnightMoves.size(), 0, 255), 255, 255);
       break;
  }
}

// Resets the sketch
void Reset()
{
  // Create new knight move sequences
  // Min based off max (doesn't matter really)
  // floor the values though so we don't use 0
  knightMoveMax = (int) random(2, 10);
  knightMoveMin = knightMoveMax == 2 ? 1 : (int) random(1, knightMoveMax-1);

  currentColorMode = round(random(1, 4));
  
  CreateBoard();
  CreateNumberedSquareSpiral(boardWidth/2, boardHeight/2);
  previousKnightMoves.clear();
  
  // Start knight at center of board
  currentKnightIndex = new PVector(boardWidth/2, boardHeight/2);
  
  println("------------------------------------");
  println("knight moveset:", knightMoveMax, ",", knightMoveMin,"(color=", currentColorMode, ")");
  
}

void mousePressed()
{
  Reset();
}

// Reprements a segment on the baord
class Segment
{
  boolean hit = false;
  int number = -1;
  PVector center; // Center of the segment
  
  Segment() {}
  Segment(PVector pos)
  {
    center = pos;  
  }
}
