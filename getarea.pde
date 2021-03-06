ArrayList vertList;
color bgColor = color(127);
color openColor = color(255,0,0);
color closedColor = color(0,0,255);
color otherColor = color(255);
PFont font;
int fontSize = 24;
boolean isClosed = false;
float hitDist = 10;
boolean carryVert = false;
int vertToCarry = 0;

void setup() {
  size(640, 480, P2D);
  vertList = new ArrayList();
  font = createFont("Arial", fontSize*2);
  textFont(font);
  textSize(fontSize);
  textAlign(CENTER);
  ellipseMode(CENTER);
  stroke(0);
  strokeWeight(1);
}


void draw() {
  background(bgColor);
  
  if (vertList.size() == 2) {
    PVector pl1 = (PVector) vertList.get(1);
    PVector pl2 = (PVector) vertList.get(0);
    line(pl1.x, pl1.y, pl2.x, pl2.y);
  }
    
  fill(otherColor);
  beginShape();
  for (int i = 0; i < vertList.size(); i++) {
    PVector p = (PVector) vertList.get(i);
    vertex(p.x, p.y);
  }
  if (isClosed) {
    endShape(CLOSE);
  } else {
    endShape();
  }
  
  for (int i = 0; i < vertList.size(); i++) {
    PVector p = (PVector) vertList.get(i);
    
    if (!isClosed && mousePressed && hitDetect(p.x, p.y, hitDist, hitDist, mouseX, mouseY, hitDist, hitDist)) {
      carryVert = true;
      vertToCarry = i;
    }
    
    if (isClosed()) {
      fill(closedColor);
    } else if (!isClosed() && i==0) {
      fill(openColor);
    } else {
      fill(otherColor);
    }
    
    int s = 10;
    PVector po = (PVector) vertList.get(0);
    if (i == 0 && vertList.size() > 1 && !isClosed && hitDetect(mouseX, mouseY, hitDist, hitDist, po.x, po.y, hitDist, hitDist)) {
      s = 15;
    }
    ellipse(p.x, p.y, s, s);
  }
  
  if (carryVert) {
    PVector pv = new PVector(mouseX, mouseY);
    vertList.set(vertToCarry, pv);
  }
    
  if (isClosed()) {
    fill(0);
    PVector center = findCenter();
    text(getArea(), center.x, center.y);// + (fontSize/2));
  }
}

void keyPressed() {
  if (key == ' ') reset();
}

void mousePressed() {
  if (!isClosed() && !carryVert) {
    PVector p = new PVector(mouseX, mouseY);
    vertList.add(p);
    snapClosed(hitDist);
  } else if (isClosed()) {
    reset();
  }
}

void mouseReleased() {
  carryVert = false;
}

void reset() {
    vertList = new ArrayList();
    isClosed = false;
}

boolean isClosed() {
  /*
  if (vertList.size() > 1) {
    PVector pFirst = (PVector) vertList.get(0);
    PVector pLast = (PVector) vertList.get(vertList.size()-1);
    if (pFirst == pLast && vertList.size() > 1) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
  */
  return isClosed;
}

void snapClosed(float dist) {
  PVector pFirst = (PVector) vertList.get(0);
  PVector pLast = (PVector) vertList.get(vertList.size()-1);
  if (vertList.size() > 1 && hitDetect(pFirst.x, pFirst.y, dist, dist, pLast.x, pLast.y, dist, dist)) {
    vertList.remove(vertList.size()-1);
    //vertList.add(pFirst);
    isClosed = true;
  }
}

int getArea() {
  // http://www.mathopenref.com/coordpolygonarea.html
  float returns = 0;
  
  for (int i=0; i<vertList.size(); i++) {
    PVector p = (PVector) vertList.get(i);
    PVector pNext;
    if (i < vertList.size()-1) {
      pNext = (PVector) vertList.get(i+1);
    } else {
      pNext = (PVector) vertList.get(0);
    }
    returns += ((p.x * pNext.y) - (p.y * pNext.x));
  }
  
  return (int) abs(round(returns * 0.5));
}

PVector findCenter() {
  float x = 0;
  float y = 0;
  for (int i=0; i<vertList.size(); i++) {
      PVector p = (PVector) vertList.get(i);
      x += p.x;
      y += p.y;
  }
  x /= vertList.size();
  y /= vertList.size();
  return new PVector(x, y);
}

boolean hitDetect(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
  w1 /= 2;
  h1 /= 2;
  w2 /= 2;
  h2 /= 2; 
  if(x1 + w1 >= x2 - w2 && x1 - w1 <= x2 + w2 && y1 + h1 >= y2 - h2 && y1 - h1 <= y2 + h2) {
    return true;
  } 
  else {
    return false;
  }
}