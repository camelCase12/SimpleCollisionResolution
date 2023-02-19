
//Parameters
static Boolean showCalculationGrid = false;

//Number of particles
static int circleArrayLen = 300;

//The strength of left-click-and-drag throws
static float throwSensitivity = 0.1;

//The number of grid squares in optimization grid. 
//If the grid squares become too small relative to the particles, the calculations will break.
static int gridWidth = 45;
static int gridHeight = 45;

//'dampens' the elasticity of collisions, causing movement to quickly arrest. 1 means no dampening, 0 means maximum dampening.
static float dampeningFactor = 1;

//Minimum radius of particles being generated
static float minimumRadius = 0.8;

//Maximum radius of particles being generated
static float maximumRadius = 3;

//Linear scalar to multiply the underlying x-y plane by to get screen coordinates
static int pixelScaleFactor = 4;

//Number of times to iterate the exclusion algorithm (8 is usually plenty, larger means longer calculations)
static int iterations = 8;

//Larger number means quicker gravitational acceleration
static float gravitationalConstant = 0.03;

//Maximum velocity which objects are limited to
static float terminalVelocity = 4;

//Non-parameter static objects
static Circle[] circles;

static ArrayList<Integer>[][] indexGrid;

static int currentIndex = 0;

//Initialize screen and objects
void setup () {
 size(1000, 1000, P2D);
 
 background(0);
 
 circles = new Circle[circleArrayLen];
 
 indexGrid = new ArrayList[gridWidth][gridHeight];
 
 for(int i = 0; i < gridWidth; i++) {
   for(int j = 0; j < gridHeight; j++) {
     indexGrid[i][j] = new ArrayList<Integer>();
   }
 }
 
 frameRate(60);
}

//Caches previous mouse position for calculating movement
static int lastMouseX = 0;
static int lastMouseY = 0;

void draw() {
  background(0);
  
  //Create new particle if particle array is not full
  if(frameCount % 1 == 0 && currentIndex < circleArrayLen) {
    circles[currentIndex] = new Circle(-40, 40, 0.2, -.5, random(minimumRadius, maximumRadius), currentIndex);
    currentIndex++;
  }
  
  //Clear grid
  for(int i = 0; i < gridWidth; i++) {
   for(int j = 0; j < gridHeight; j++) {
     indexGrid[i][j].clear();
   }
  }
  
  //Iterate through array a single time to perform physics and interaction updates
  for(int i = 0; i < circleArrayLen; i++) {
    if(circles[i] == null) continue;
    
    if(mousePressed == true) {
      
      float mouseXDistance = mouseX - (circles[i].x*pixelScaleFactor + width/2);
      
      float mouseYDistance = mouseY - (height/2 - circles[i].y*pixelScaleFactor);
      
      if(abs(mouseXDistance) < 40 && abs(mouseYDistance) < 40) {
        circles[i].velX = (mouseX - lastMouseX) * throwSensitivity;
        circles[i].velY = (lastMouseY - mouseY) * throwSensitivity;
      }
    }
    
    circles[i].isRed = false;
    circles[i].calculateAcceleration();
    circles[i].applyPhysics();
    
    circles[i].boundaryExclude();
    
    circles[i].addIndexToGrid();
  }
  
  //Show calculation grid if necessary
  if(showCalculationGrid) {
    float unitWidth = width / (float)gridWidth;
    float unitHeight = height/ (float)gridHeight;
    
    for(int i = 0; i < gridWidth; i++) {
     for(int j = 0; j < gridHeight; j++) {
       fill(255, 255, 255, indexGrid[i][j].size()*30);
       rect(unitWidth*i, height-unitHeight*(j+1), unitWidth, unitHeight);
     }
    }
  }
  
  //Run correction algorithm based on grid optimization
  for(int k = 0; k < iterations; k++) {
    for(int i = 0; i < circleArrayLen; i++) {
      if(circles[i] == null) continue;
      
      int[] currentCircleGridIndices = circles[i].getIndices();
      
      ArrayList<Integer> candidateIndices = getCandidateCircleIndices(currentCircleGridIndices[0], currentCircleGridIndices[1]);
      
      for(int j = 0; j < candidateIndices.size(); j++) {
        if(i==candidateIndices.get(j)) continue;
        if(circles[i] == null || circles[candidateIndices.get(j)] == null) continue;
        
        calculateCorrections(circles[i], circles[candidateIndices.get(j)]);
      }
    }
  }
  
  //Draw all of the particles
  for(int i = 0; i < circleArrayLen; i++) {
    if(circles[i] == null) continue;
    circles[i].render();
  }
  
  //Update mouse position cache
  lastMouseX = mouseX;
  lastMouseY = mouseY;
}
