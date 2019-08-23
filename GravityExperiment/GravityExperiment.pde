void setup()
{
  
}

void draw()
{
  
}

  // Equation to work out gravity between 2 points (sun and earth here)
  //-------------------------------
  // ma = GMm|r|/r^2
  // lil m = earth mass
  // big M = sun's mass
  // a = acceleration, which is the product of the equation
  // G = gravitational constant of the universe (EG 0.06)
  // r = distance between sun and earth
  // |r| = normalised distance between sun and earth
  // ^2 = squared
  
  // NOTE: 
  // - This is for 1D, to make 3D (or 2D) make a and r PVectors
  // - The equation returns the acceleration to be applied to the velocity of the object with the mass from the left
  // - The m on both sides cancel each other out
  // - |r| timesed by the other properties on the left 
  
  // HOW TO:
  // 1) get direction of force (by normalising the distance between the 2 objects (being careful you don't normalise a 0 length distance))
  // PVector line_to = PVector.sub(this.pos, p.pos); // (line from p.pos to this.pos), 
  // line_to.normalise() // get direction, regardless of strength of force
  // 2) work out force your going to apply (you want to be attracted in the right direction)
  // gravity(essentially a constant)(can this value here based on the mass of the object) / squared[line_to(unnormalised)(magnitude (which is the distance between points))]
  // [advice: can use a function to returned normalised value]
  
  // WHAT TO DO NEXT:
  // - Start small, simulate earth and the moon. 2 objects and examine the velocities involved and how to make a stable oribit
  
  // Timestep:
  // Interval between frames (smaller time step more accurate), used to basically ensure that
  // the simulation updates at a fixed rate, even if there are infrequent times between frames.
  // Done by keeping track of the time between frames and only caculating at a fixed rate.
  // Can be non normal time
  
  //EG
  //  velocity.add(acceleration * timestep);
  //  pos.add(velocity);
  //  acceleration.mult(0);
