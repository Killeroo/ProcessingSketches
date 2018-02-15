/////////////////////////////////////////////////////////////////////////////////////
///                              GalaxyGenerator                                  ///
/////////////////////////////////////////////////////////////////////////////////////
/// Galaxy Generator, press any key to spawn a random interstellar creation!      ///         ///
///                                                                               ///
/// Controls:                                                                     /// 
///     'l' to hide text, 'd' for debug stats and 'm' to toggle motion blur       ///
///                                                                               ///
/// Written by Matthew Carney (13th Feb 2018)                                     ///
///     [matthewcarney64@gmail.com] [https://github.com/Killeroo]                 ///
///                                                                               ///
/// Original galaxy code and inspiration:                                         ///
//       https://www.openprocessing.org/sketch/165663                             ///
/////////////////////////////////////////////////////////////////////////////////////

/* Galaxy generation properties */
final int SPEED_UPPER_LIMIT = 8;
final int SPEED_LOWER_LIMIT = 3;
final int CENTER_SIZE_MAX = 25;
final int CENTER_SIZE_MIN = 15;
final int DENSITY_MAX = 300;
final int DENSITY_MIN = 100;
final int STAR_COUNT_MAX = 250;
final int STAR_COUNT_MIN = 150;

/* Star background properties */
final int STAR_COUNT = 50;
final int MIN_FLICKER_RATE = 1;
final int MAX_FLICKER_RATE = 2; 

/* Stats text properties */
final int FONT_SIZE = 11;
final int START_X = 20;
final int START_Y = 20;

/* Background Prtoperties */
final int BACKGROUND_COLOUR = 0; // Black
final int MOTION_BLUR = 20;

// Internal variables
Galaxy gal = new Galaxy();
StarBackdrop backdrop;
StatsText stats = new StatsText();
boolean showText = true;
boolean motionBlur = true;

void setup()
{
  size(600,600);
  background(0);
  pixelDensity(displayDensity());
  
  // Setup text
  textFont(createFont("Consolas", FONT_SIZE));
  
  // Setup backdrop
  backdrop = new StarBackdrop();
  
  // Load some galaxy properties
  int seed = millis();
  gal.randomize(seed);
  stats.update(seed);
}

void draw()
{

  // Draw background
  drawBackground();
  
  // Display stars first
  backdrop.display();
  
  // Draw galaxy
  gal.display();
  
  if (showText)
    // Draw stats
    stats.display();
 
}

void keyPressed()
{
  switch(key)
  {
    case 'l':
      showText = !showText;
      break;
    case 'd':
      stats.showDebugInfo = !stats.showDebugInfo;
      break;
    case 'm':
      motionBlur = !motionBlur;
      break;
    default:
      // Generate random galaxy
      int seed = millis();
      gal.randomize(seed);
      stats.update(seed);
  }
}

void mousePressed()
{
  int seed = millis();
  gal.randomize(seed);  
  stats.update(seed);
}

void drawBackground()
{
  if (motionBlur) {
    // Background with motion blur
    noStroke();
    fill(BACKGROUND_COLOUR, MOTION_BLUR);
    rect(0, 0, width, height);
  } else {
    // Normal background
    background(BACKGROUND_COLOUR);
  }
}

float amplify(float n) {
  return constrain(2 * n, 0, 255);
}

class StatsText
{
  // Galaxy stats
  String name;
  String age;
  String starCount, planetCount;
  int lifeCount;
  int habitablePlanets, blackHoleCount;
  int civilizations, deadCivilizations;
  
  // Debug stats
  float speed;
  float galacticCenter;
  float offset_1, offset_2, offset_3;
  int density;
  int baseParticles;
  int particles;
  int seed;
  int r, g, b;
  String rotation;
  
  // Secret message stuff
  String secretMsg;
  String secretMsgValue;
  
  // Stats properties
  boolean showDebugInfo = false;
  int size = FONT_SIZE;
  int startPos;
  
  void display()
  {
    int x = START_X;
    int y = START_Y;
    
    fill(255);
    text("GalaxyGen v1.0", x, y); y += FONT_SIZE;
    text("-------------------", x, y); y += FONT_SIZE;
    text("Name: " + name, x, y); y += FONT_SIZE;
    text("Age: " + age + "B years", x, y); y += FONT_SIZE;
    text("Stars: " + starCount, x, y); y += FONT_SIZE;
    text("Planets: " + planetCount, x, y); y += FONT_SIZE;
    text("Habitable planets: " + habitablePlanets, x, y); y += FONT_SIZE;
    if (civilizations > 0) {
      text("Galactic Civilizations: " + civilizations, x, y); y += FONT_SIZE;
    }
    if (deadCivilizations > 0) {
      text("Collapsed Civilizations: " + deadCivilizations, x, y); y += FONT_SIZE;
    }
    text("Alien species: " + nfc(random(1,2), 4) + "E" + lifeCount, x, y); y += FONT_SIZE;
    float chance = random(0,1);
    if (chance <= 0.50f) {
      y += FONT_SIZE;text(secretMsg + secretMsgValue, x, y); y += FONT_SIZE;
    }
    
    if (showDebugInfo) {
      y+= FONT_SIZE; // Leave gap between stats
      text("Simulation stats", x, y); y += FONT_SIZE;
      text("-------------------", x, y); y += FONT_SIZE;
      text("Particles: " + particles + " (" + baseParticles +  ")", x, y); y += FONT_SIZE;
      text("Speed: " + speed, x, y); y += FONT_SIZE;
      text("Density: " + density, x, y); y += FONT_SIZE;
      text("Rotation: " + rotation, x, y); y += FONT_SIZE;
      text("Center size: " + galacticCenter, x, y); y += FONT_SIZE;
      text("Colour: [R:" + r + " G:" + g + " B:" + b + "]", x, y); y += FONT_SIZE;
      text("Offset: 1:" + offset_1 + " 2:" + offset_2 + " 3:" + offset_3, x, y); y += FONT_SIZE;
      text("Seed: " + seed, x, y); y += FONT_SIZE;
    }
    
    y+= FONT_SIZE; // Leave gap between stats
    text("'D' for debug info, 'L' to hide log", x, y); y += FONT_SIZE;
    text("'M' to toggle motion blur", x, y); y += FONT_SIZE;
    y += FONT_SIZE;text("Press any key to generate new galaxy", x, y); y += FONT_SIZE;
  }
  
  // Update text with new seed
  void update(int s)
  {
    /* Galaxy Stats Generation */
    // Generate stats and facts about galaxy
    
    // Create new galaxy name
    // Greek alphabet
    String[] baseNames = new String[] { "alpha", "beta", "gamma", "delta", "epsilon",
                                    "zeta", "eta", "theta", "iota", "kappa", "lambda",
                                    "mu", "nu", "xi", "omicron", "pi", "rho", "sigma",
                                    "tau", "upsilon", "phi", "chi", "psi", "omega" };
    //http://mylanguages.org/latin_adjectives.php
    String[] componentNames = new String[] { "tener", "vetus", "sonans", "parum", "malus",
                                          "latus", "velox", "gravis", "altus", "ater" };
    //https://en.wikipedia.org/wiki/Samoan_language#Alphabet
    String[] numbers = new String[] { "noa", "tasi", "lua", "tolu", "fa", "lima", "ono",
                                       "fiti", "valu", "iva", "afe", "mano" };
    name = baseNames[(int)random(0, baseNames.length)] + "_" + componentNames[(int)random(0, componentNames.length)];
    float chance = random(0, 1);
    if (chance <= 0.10f) { // Use numbers array 10% of the time
      name += "_" + numbers[(int) random(0, numbers.length)];  
    } else {
      name += "_" + (int) random(0, 99);
    }
    
    // Work out age
    float gal_age = random(0, 35);
    age = nfs(gal_age, 1, 1);
    
    // Star count
    int stars = (gal.stars * 3) * (100 + (int) random(111, 999));
    starCount = nfc(stars);
    
    // Work out number of planets
    int planets = stars * (int) random(8, 15);
    planetCount = nfc(planets);
    
    // Derive how many civilizations
    chance = random(0, 1);
    civilizations = 0;
    deadCivilizations = 0;
    if (chance <= 0.10f) { // 5% for live cilivilizations
      civilizations = (int) random(0, 8);
    }
    if (chance <= 0.2f) { // 20% for dead civilizations
      deadCivilizations = civilizations > 0 ? civilizations * (int) random(0, 11) : (int)gal_age * (int) random(0, 20);
    }
    
    // Habitable planets = 0.01% percent of planets
    habitablePlanets = (int) (gal_age*(planets*(0.01f/100f)));
    
    // Life count
    lifeCount = (int) random(4,15);
    
    /* Debug stuff */
    // Load debug stats from galaxy object
    speed = gal.speed;
    galacticCenter = gal.centerSize;
    density = gal.density;
    baseParticles = gal.stars;
    particles = gal.stars * 3;
    seed = s;
    rotation = gal.clockwiseRotation ? "Clockwise" : "Anti-Clockwise";
    r = gal.red;
    g = gal.green;
    b = gal.blue;
    offset_1 = gal.offset[0];
    offset_2 = gal.offset[1];
    offset_3 = gal.offset[2];
    
    // Secret messages:
    switch ((int) random(0,42)) {
      case 0:
        secretMsg = "Alien Cat Species Found: ";
        secretMsgValue = nfc((int) random(1, 255), 0);
        break;
      case 1:
        secretMsg = "Masked Vigilantes: ";
        secretMsgValue = nfc((int) random(1, 10), 0);
        break;
      case 2:
        secretMsg = "Deities detected: ";
        secretMsgValue = nfc((int) random(1, 4), 0);
        break;
      case 3:
        secretMsg = "Mass Extinction Events: ";
        secretMsgValue = nfc((int) random(5, 15), 0);
        break;
      case 4:
        secretMsg = "Galactic Conquests: ";
        secretMsgValue = nfc((int) random(5, 10), 0);
        break;
      case 5:
        secretMsg = "En-Route Galactic Pilgrimages: ";
        secretMsgValue = nfc((int) random(1, 3), 0);
        break;
      case 6:
        secretMsg = "Utopias detected: ";
        secretMsgValue = nfc((int) random(1, 4), 0);
        break;
      case 7:
        secretMsg = "Orbital stations: ";
        secretMsgValue = nfc((int) random(1, 3000), 0);
        break;
      case 8:
        secretMsg = "Trantor state: ";
        secretMsgValue = ((int) random(1, 2)) == 1 ? "Fallen" : "Active";
        break;
      case 9:
        secretMsg = "Active Pirate Fleets: ";
        secretMsgValue = nfc((int) random(0, 100), 0);
        break;
      case 10:
        secretMsg = "GSV count: ";
        secretMsgValue = nfc((int) random(1, 15), 0);
        break;
      case 12:
        secretMsg = "Xenomorphs found: ";
        secretMsgValue = nfc((int) random(1, 100), 0);
        break;
      case 13:
        secretMsg = "Background midi-chlorians: ";
        secretMsgValue = nfc((int) random(10000), 0);
        break;
      case 14:
        secretMsg = "Asteroid fatalities: ";
        secretMsgValue = nfc((int) random(10000, 5000000), 0);
        break;
      case 15:
        secretMsg = "Asteroids: ";
        secretMsgValue = Double.toString(5999234324d * (double)random(1, 999));
        break;        
      case 16:
        secretMsg = "Corrupt Military Corperations: ";
        secretMsgValue = nfc((int) random(1, 4), 0);
        break;
      case 17:
        secretMsg = "Small man wearing green & fighting monsters: ";
        secretMsgValue = "1";
        break;
      case 18:
        secretMsg = "Sentient pokemon: ";
        secretMsgValue = nfc((int) random(1, 5555), 0);
        break;
      case 19:
        secretMsg = "Space Otter Colonies: ";
        secretMsgValue = nfc((int) random(1, 200), 0);
        break;
      case 20:
        secretMsg = "Mass Effect Relays: ";
        secretMsgValue = nfc((int) random(1, 20), 0);
        break;  
      case 21:
        secretMsg = "Space Whale schools: ";
        secretMsgValue = nfc((int) random(1, 40), 0);
        break; 
      case 22:
        secretMsg = "Highest Schmit Pain Index bite: ";
        secretMsgValue = nfc((int) random(1, 10), 0);
        break; 
      case 23:
        secretMsg = "Jetisoned Weaboos: ";
        secretMsgValue = nfc((int) random(1, 99999), 0);
        break; 
      case 24:
        secretMsg = "Trade federations: ";
        secretMsgValue = nfc((int) random(1, 6), 0);
        break;  
      case 25:
        secretMsg = "Lifeforms still confused about Dark Matter: ";
        secretMsgValue = nfc((int) random(1, 255), 0);
        break;
      case 26:
        secretMsg = "Blackhole fatalities: ";
        secretMsgValue = Double.toString(2941233d * (double)random(1, 999));
        break;
      case 27:
        secretMsg = "God-like pokemon: ";
        secretMsgValue = nfc((int) random(1, 12), 0);
        break;  
      case 28:
        secretMsg = "Incorrect Creation Stories: ";
        secretMsgValue = nfc((int) random(1, 9999), 0);
        break;  
      case 29:
        secretMsg = "Singularity counter: ";
        secretMsgValue = nfc((int) random(1, 99), 0);
        break; 
      case 30:
        secretMsg = "Hours wasted thinking of captions: ";
        secretMsgValue = nfc((int) random(1, 999), 0);
        break;  
      case 31:
        secretMsg = "Oddly shaped worlds: ";
        secretMsgValue = nfc((int) random(1, 999), 0);
        break; 
      case 32:
        secretMsg = "Wormhole 'accidents': ";
        secretMsgValue = nfc((int) random(1000, 9999), 0);
        break; 
      case 33:
        secretMsg = "Space bums: ";
        secretMsgValue = Double.toString(599923d * (double)random(1, 999));
        break;
      case 34:
        String[] currents = { "Schmeckles", "dry nub nubs", "'Urbz", "Neurotoxins",
                              "Skulls", "Souls", "Space Diamonds", "Star Sand" };
        secretMsg = "Galactic currency: ";
        secretMsgValue = currents[(int) random(0, currents.length)];
        break;
      case 35:
        String[] elements = { "Carbon", "Helium", "Silicon", "Floride",
                              "Beryillium", "Fudge", "Steel", "Uranium" };
        secretMsg = elements[(int) random(0, elements.length)];
        secretMsgValue = "based life detected";
        break;
      case 36:
        secretMsg = "Warp Vomits: ";
        secretMsgValue = nfc((int) random(1, 20), 0);
        break;
      case 37:
        secretMsg = "Technical benevolence: ";
        secretMsgValue = "ACHIEVED";
        break;
      case 38:
        secretMsg = "Space Spider worlds: ";
        secretMsgValue = nfc((int) random(50, 75), 0);
        break;
      case 39:
        secretMsg = "Time gears: ";
        secretMsgValue = nfc((int) random(1, 10), 0);
        break;
      case 40:
        secretMsg = "Wigglytuff Guilds: ";
        secretMsgValue = nfc((int) random(1, 15), 0);
        break;
      case 41:
        secretMsg = "AI Revolts: ";
        secretMsgValue = nfc((int) random(5, 25), 0);
        break;
      case 42:
        secretMsg = "Space Cat Dieties: ";
        secretMsgValue = nfc((int) random(1, 5), 0);
        break;
    }

  }
  
}

class Galaxy
{
  float i, r, a, t; // Internals for drawing
  int red, green, blue, alpha; // Colours

  int density;
  int centerSize;
  int stars;
  float[] offset = new float[3];
  float speed;
  boolean clockwiseRotation;
    
  void display()
  {
    // Draw stars
    strokeWeight (2);
    stroke(amplify(red), green, blue, alpha);
    for (i=0; i<stars; i++) {
      a=noise2(i/65)*9+t/r;
      point((width/2)+cos(a)*(clockwiseRotation ? r : -r), (height/2)+sin(a)*r/2);
      r=abs(noise2(i)-offset[0])*density;
    }
    
    stroke(red, amplify(green), blue, alpha);
    for (i=0; i<stars; i++) {
      a=noise2(i/60)*9+t/r;
      point((width/2)+cos(a)*(clockwiseRotation ? r : -r), (height/2)+sin(a)*r/2.5);
      r=abs(noise2(i)-offset[1])*(density*2);
    }
  
    stroke(red, green, amplify(blue), alpha);
    for (i=0; i<stars; i++) { 
      a=noise2(i/55)*9+t/r;
      point((width/2)+cos(a)*(clockwiseRotation ? r : -r)*0.89, (height/2)+sin(a)*r/2.3);
      r=abs(noise2(i)-offset[2])*(density*3);
    }
    
    // Draw galaxy center
    noStroke();
    fill(amplify(red), amplify(green), amplify(blue), 10);
    ellipse(width/2,height/2, (centerSize)*3, (centerSize-(centerSize/3))*3);
    fill(amplify(red), amplify(green), amplify(blue), 25);
    ellipse(width/2,height/2, (centerSize)*2.5, (centerSize-(centerSize/3))*2.5);
    fill(amplify(red), amplify(green), amplify(blue), 50);
    ellipse(width/2,height/2, (centerSize)*2.25, (centerSize-(centerSize/3))*2.25);
    fill(255, 100);
    ellipse(width/2,height/2, (centerSize)*2, (centerSize-(centerSize/3))*2);
    fill(255, 150);
    ellipse(width/2,height/2, (centerSize)*1.5, (centerSize-(centerSize/3))*1.5);
    fill(255, 250);
    ellipse(width/2,height/2, (centerSize)*1, (centerSize-(centerSize/3))*1);
  
    t+=speed; 
  }
  
  void randomize(int seed)
  {
    // Generate new seed using current millis
    randomSeed(seed);
    
    // Generate colour values
    red = (int) random(255);
    green = (int) random(255);
    blue = (int) random(255);
    alpha = 250;  
    
    // Determine rotation
    if (seed % 2 == 0) { 
      clockwiseRotation = true;
    } else {
      clockwiseRotation = false;
    }
    
    // Generate new speed modifier
    speed = round(random(SPEED_LOWER_LIMIT, SPEED_UPPER_LIMIT));
    speed = speed /10;
    
    // Work out galaxy center size
    centerSize = (int) random(CENTER_SIZE_MIN, CENTER_SIZE_MAX);
    
    // Generate new density
    density = (int) random(DENSITY_MIN, DENSITY_MAX);
    
    // Work out new star count
    stars = (int) random(STAR_COUNT_MIN, STAR_COUNT_MAX);
    
    // Work out offset for each set of stars
    offset[0] = random(0.1, 0.3);
    offset[1] = random(0.3, 0.6);
    offset[2] = random(0.4, 0.5);
    
    // Reset the galaxy 
    this.reset();
  }
  
  void reset() 
  {
    i = 0;
    r = 0;
    a = 0;
    t = 0;
  }
  
  float noise2(float n)
  {
    randomSeed(round(n*100000));
    return random(1);
  }
}

class StarBackdrop
{
  ArrayList<Star> stars;
  
  StarBackdrop()
  {
    init();
  }
  
  void init()
  {
    // Keep seed random
    randomSeed(millis());
    
    // Fill star array
    stars = new ArrayList();
    for (int i = 1; i <= STAR_COUNT; i++) {
      stars.add(new Star());  
    }
  }
  
  void display()
  {
    // Keep seed random for stars
    randomSeed(millis());
    
    // Display each star
    for (int i = 0; i <= stars.size() - 1; i++) {
      Star curStar = (Star) stars.get(i);
      curStar.display();
    }
  }
}

class Star 
{
  int x, y;
  float flickerRate, light;
  boolean shining;
  
  Star()
  {
    create();
    light = random(10, 245);
  }
  
  void display()
  {
    // Stop shining when light
    // is beyond certain level
    if (light >= 245) {
      shining = false;
    }
    
    // Recreate star when below
    // a certain level of light
    if (light <= 10) {
      create();  
    }
    
    // Determine light level 
    // based on if star is shining or not
    if (shining) {
      light += flickerRate;
    } else if (!shining) {
      light -= flickerRate;
    }
    
    // Draw star itself
    stroke(255, 255, 255, light);
    point(x, y);
  }
  
  void create() 
  {
    // Create a star
    flickerRate = random(MIN_FLICKER_RATE, MAX_FLICKER_RATE);
    x = (int) (random(0, width));
    y = (int) (random(0, height));
    shining = true;
  }
}