
public static ArrayList<Integer> getCandidateCircleIndices(int xIndex, int yIndex) {
  ArrayList<Integer> indices = new ArrayList<Integer>();
  
  ArrayList<Integer> xVariations = new ArrayList<Integer>();
  xVariations.add(-1); xVariations.add(0); xVariations.add(1);
  
  ArrayList<Integer> yVariations = new ArrayList<Integer>();
  yVariations.add(-1); yVariations.add(0); yVariations.add(1);
  
  if(xIndex == 0) xVariations.remove(Integer.valueOf(-1));
  if(xIndex == gridWidth-1) xVariations.remove(Integer.valueOf(1));
  if(yIndex == 0) yVariations.remove(Integer.valueOf(-1));
  if(yIndex == gridHeight-1) yVariations.remove(Integer.valueOf(1));
  
  for(int i = 0; i < xVariations.size(); i++) {
    for(int j = 0; j < yVariations.size(); j++) {
      for(int k = 0; k < indexGrid[xIndex+xVariations.get(i)][yIndex+yVariations.get(j)].size(); k++) {
        indices.add(indexGrid[xIndex+xVariations.get(i)][yIndex+yVariations.get(j)].get(k));
      }
    }
  }
  
  return indices;
}

public static float[] calculateCorrections(Circle a, Circle b) {
  float sumOfRadius = a.radius + b.radius;
    
  if(a.overlaps(b)) {
    //a.isRed = true;
    //a.isRed = true;
    
    float distance = a.distance(b);
    
    float overlap = sumOfRadius - distance;
    
    float moveRatio = overlap / distance;
    
    float xDiff = b.x - a.x;
    float yDiff = b.y - a.y;
    
    float xMoveI = (xDiff * moveRatio) / 2;
    float yMoveI = (yDiff * moveRatio) / 2;
    
    float xMoveJ = (xDiff * moveRatio) / 2;
    float yMoveJ = (yDiff * moveRatio) / 2;
    
    float xBoundCorrectionI = max(0, a.x - xMoveI - a.xMax()) - max(0, a.xMin() - (a.x - xMoveI));
    float xBoundCorrectionJ = max(0, b.x + xMoveJ - b.xMax()) - max(0, b.xMin() - (b.x + xMoveJ));
    
    xMoveI += xBoundCorrectionI;
    xMoveJ -= xBoundCorrectionI;
    
    xMoveI += xBoundCorrectionJ;
    xMoveJ -= xBoundCorrectionJ;
    
    float yBoundCorrectionI = max(0, a.y - yMoveI - a.yMax()) - max(0, a.yMin() - (a.y - yMoveI));
    float yBoundCorrectionJ = max(0, b.y + yMoveJ - b.yMax()) - max(0, b.yMin() - (b.y + yMoveJ));
    
    yMoveI += yBoundCorrectionI;
    yMoveJ -= yBoundCorrectionI;
    
    yMoveI += yBoundCorrectionJ;
    yMoveJ -= yBoundCorrectionJ;
    
    a.velX -= 2*xMoveI*dampeningFactor;
    a.x -= xMoveI;
    a.velY -= 2*yMoveI*dampeningFactor;
    a.y -= yMoveI;
    b.velX += 2*xMoveJ*dampeningFactor;
    b.x += xMoveJ;
    b.velY += 2*yMoveJ*dampeningFactor;
    b.y += yMoveJ;
  }
  
  return null;
}
