
//Circle/particle representing class
class Circle {
  float x, y;
  float velX, velY = 0;
  float accX, accY = 0;
  float radius;
  Boolean isRed = false;
  Boolean gravity = true;
  Boolean exists = false;
  int index = 0;
  
  void calculateAcceleration() {
    accX = 0;
    accY = 0;
    
    accY -= gravitationalConstant;
  }
  
  void applyPhysics() {
    velX += accX;
    velY += accY;
    if(velX < -terminalVelocity) velX = -terminalVelocity;
    if(velX > terminalVelocity) velX = terminalVelocity;
    if(velY < -terminalVelocity) velY = -terminalVelocity;
    if(velY > terminalVelocity) velY = terminalVelocity;
    x += velX;
    y += velY;
  }
  
  void boundaryExclude() {
    float cacheX = x;
    float cacheY = y;
    if(x*pixelScaleFactor + radius*pixelScaleFactor > width/2) {
      x = (width/2)/pixelScaleFactor - radius;
    }
    else if (x*pixelScaleFactor - radius*pixelScaleFactor < -width/2) {
      x = (-width/2)/pixelScaleFactor + radius;
    }
    
    if(y*pixelScaleFactor + radius*pixelScaleFactor > height/2) {
      y = (height/2)/pixelScaleFactor - radius;
    }
    else if(y*pixelScaleFactor - radius*pixelScaleFactor < -height/2) {
      y = (-height/2)/pixelScaleFactor + radius;
    }
    
    velX -= 2 * (cacheX - x);
    velY -= 2 * (cacheY - y);
  }
  
  void render() {
    stroke(150, 255, 150);
    colorMode(HSB, 1000);
    fill((radius*300)%1000, 1000, 1000);
    
    if(isRed) fill(255, 0, 0);
    
    circle(width/2 + x*pixelScaleFactor, height/2 - y*pixelScaleFactor, radius*pixelScaleFactor * 2);
    colorMode(RGB, 255);
  }
  
  Boolean overlaps(Circle otherCircle) {
    float sumOfRadius = radius + otherCircle.radius;
    return (x-otherCircle.x)*(x-otherCircle.x) + (y-otherCircle.y)*(y-otherCircle.y) < sumOfRadius*sumOfRadius;
  }
  
  //Extremely roundabout way to optimize these calculations to protect my precious constructor from anything other than this.* = *; statements
  Boolean cacheXMaxExists = false;
  Boolean cacheYMaxExists = false;
  Boolean cacheXMinExists = false;
  Boolean cacheYMinExists = false;
  float cacheXMax, cacheYMax, cacheXMin, cacheYMin;
  
  float xMax() {
    if(!cacheXMaxExists) {
      cacheXMax = (width/2)/pixelScaleFactor - radius;
    }
    return cacheXMax;
  }
  
  float yMax() {
    if(!cacheYMaxExists) {
      cacheYMax = (height/2)/pixelScaleFactor - radius;
    }
    return cacheYMax;
  }
  
  float xMin() {
    if(!cacheXMinExists) {
      cacheXMin = (-width/2)/pixelScaleFactor + radius;
    }
    return cacheXMin;
  }
  
  float yMin() {
    if(!cacheYMinExists) {
      cacheYMin = (-height/2)/pixelScaleFactor + radius;
    }
    return cacheYMin;
  }
  
  float distance(Circle otherCircle) {
    return sqrt((x - otherCircle.x)*(x - otherCircle.x) + (y - otherCircle.y)*(y - otherCircle.y));
  }
  
  void addIndexToGrid() {
    float xWidth = xMax()-xMin();
    int xIndex = (int)(((x + xWidth/2) * gridWidth) / xWidth);
    xIndex = constrain(xIndex, 0, gridWidth-1);
    
    float yHeight = yMax()-yMin();
    int yIndex = (int)(((y + yHeight/2) * gridHeight) / yHeight);
    yIndex = constrain(yIndex, 0, gridHeight-1);
    
    indexGrid[xIndex][yIndex].add(index);
  }
  
  int[] getIndices() {
    float xWidth = xMax()-xMin();
    int xIndex = (int)(((x + xWidth/2) * gridWidth) / xWidth);
    xIndex = constrain(xIndex, 0, gridWidth-1);
    
    float yHeight = yMax()-yMin();
    int yIndex = (int)(((y + yHeight/2) * gridHeight) / yHeight);
    yIndex = constrain(yIndex, 0, gridHeight-1);
    
    return new int[] {xIndex, yIndex};
  }
  
  Circle(float x, float y, float velX, float velY, float radius, int index) {
    this.x = x;
    this.y = y;
    this.velX = velX;
    this.velY = velY;
    this.radius = radius;
    this.index = index;
  }
  
  Circle(float x, float y, float radius, int index) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.index = index;
  }
}
