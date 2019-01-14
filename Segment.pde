class Segment {
  boolean horizontal;
  PVector p1, p2;
  ArrayList<PVector> rawPoints;
  ArrayList<PVector> points;
  ArrayList<PVector> nextPoints;  
  boolean dragging;
  PVector active;
  int selected;
  int activeIdx;
  Segment linked;
  boolean linkReversed;
  boolean orderReversed;
  float mag;

  Segment(PVector p1, PVector p2, boolean orderReversed) {
    this.p1 = p1;
    this.p2 = p2;
    this.orderReversed = orderReversed;
    mag = dist(p1.x, p1.y, p2.x, p2.y);
    rawPoints = new ArrayList<PVector>();
    points = new ArrayList<PVector>();
    points.add(new PVector(0, 0));
    points.add(new PVector(mag, 0));
    nextPoints = new ArrayList<PVector>();
    nextPoints.add(new PVector(0, 0));
    nextPoints.add(new PVector(mag, 0));
    dragging = false;
    linked = null;
    linkReversed = false;
    horizontal = false;    
    deselect();
  }
  
  Segment(PVector p1, PVector p2) {
    this(p1, p2, false);
  }
  
  void link(Segment other, boolean reverse) {
    linked = other;
    linkReversed = reverse;
  }

  void setHorizontal(boolean horizontal) {
    this.horizontal = horizontal;
  }

  void lerpNext(float lerpFactor) {
    for (int i=0; i<points.size(); i++) {
      setPoint(i, lerp(points.get(i).x, nextPoints.get(i).x, lerpFactor),
                  lerp(points.get(i).y, nextPoints.get(i).y, lerpFactor), 
                  true);
    }
  }

  void setPoint(int idx, float x, float y, boolean sendLinked) {
    setPoint(idx, x, y, sendLinked, false);
  }

  void setPoint(int idx, float x, float y, boolean sendLinked, boolean isNext) {
    if (isNext) {
      nextPoints.get(idx).set(x, y);
    } else {
      points.get(idx).set(x, y);
    }
    if (linked != null && sendLinked) {
      if (linkReversed) {
        linked.setPoint(linked.points.size()-1-idx, mag-x, y, false, isNext);
      } else {
        linked.setPoint(idx, x, y, false, isNext);
      }
    }
  }
  
  void insertPoint(int idx, float x, float y, boolean sendLinked) {
    insertPoint(idx, x, y, sendLinked, false);
  }
  
  void insertPoint(int idx, float x, float y, boolean sendLinked, boolean isNext) {
    if (isNext) {
      nextPoints.add(idx, new PVector(x, y));
    } else {
      points.add(idx, new PVector(x, y));
    }    
    if (linked != null && sendLinked) {
      if (linkReversed) {
        linked.insertPoint(linked.points.size()-idx, mag-x, y, false, isNext);
      } else {
        linked.insertPoint(idx, x, y, false, isNext);
      }
    }
  }
  
  void draw(boolean highlight, boolean flipX, boolean flipY) {
    float ang = atan2(p2.y-p1.y, p2.x-p1.x); 
    float mag = dist(p1.x, p1.y, p2.x, p2.y);
    
    rawPoints.clear();
    
    noFill();
    if (highlight) {
      stroke(255, 225);
    } else {
      stroke(0, 0, 255, 120);
    }
  
    pushMatrix();
    translate(p1.x, p1.y);
    rotate(ang);
    
    beginShape();
    for (int i=0; i<points.size(); i++) {
      if (horizontal) {
        float x = (flipX&&!flipY)||(flipY&&!flipX) ? mag - points.get(i).x : points.get(i).x;
        float y = flipY ? -points.get(i).y : points.get(i).y;
        rawPoints.add(new PVector(modelX(x, y, 0), modelY(x, y, 0)));
        vertex(x, y);
      } else {
        float x = (flipY&&!flipX)||(flipX&&!flipY) ? mag - points.get(i).x : points.get(i).x;
        float y = flipX ? -points.get(i).y : points.get(i).y;
        rawPoints.add(new PVector(modelX(x, y, 0), modelY(x, y, 0)));
        vertex(x, y);
      }        
    }
    endShape();
    
    noStroke();  
    if (active != null && highlight) {
      fill(255, 255, 0);
      ellipse(active.x, active.y, 5, 5);
    }
    else if (selected>-1 && highlight) {
      fill(255, 0, 255);
      if (horizontal) {
        ellipse((flipX&&!flipY)||(flipY&&!flipX) ? mag - points.get(selected).x : points.get(selected).x,
                flipY ? -points.get(selected).y : points.get(selected).y, 5, 5);
      } else {
        ellipse((flipY&&!flipX)||(flipX&&!flipY) ? mag - points.get(selected).x : points.get(selected).x,
                flipX ? -points.get(selected).y : points.get(selected).y, 5, 5);
      }        
    }
    
    popMatrix();
  }
  
  ArrayList<PVector> getVertices() {
    ArrayList<PVector> returnPts = new ArrayList<PVector>();
    for (int i=0; i<rawPoints.size(); i++) {
      int idx = orderReversed ? rawPoints.size()-1-i: i;
      PVector p = rawPoints.get(idx);
      returnPts.add(p);
    }
    return returnPts;
  }
 
  void deselect() {
    active = null;
    activeIdx = -1;
    selected = -1;
  }

  float mouseMoved(float mx, float my, float minDist) {
    float ang = atan2(p2.y-p1.y, p2.x-p1.x); 
    deselect();
    
    for (int p=0; p<points.size()-1; p++) {
      PVector t1 = points.get(p);
      PVector t2 = points.get(p+1);

      float dt = dist(t1.x, t1.y, t2.x, t2.y);
      int n = int(dt / SEG_DIST);
      
      for (int i=0; i<n; i++) {
        float r = map(i, 0, n-1, 0, 1);
        PVector t = PVector.lerp(t1, t2, r);
        
        float magt = dist(0, 0, t.x, t.y);
        float angt = atan2(t.y, t.x);
        float x = p1.x + magt * cos(ang+angt);
        float y = p1.y + magt * sin(ang+angt);
        float d = dist(x, y, mx, my) * ((i==0||i==n-1)?CORNER_BIAS:1.0);
        
        if (d < minDist && d < MIN_MOUSE_DIST) {
          minDist = d;
          if (i==0) {
            deselectAll();
            selected = p;
          } else if (i==n-1){
            deselectAll();
            selected = p+1;
          } else {
            deselectAll();
            activeIdx = p+1;
            active = t;  
          }
        }
      }
    }    
    return minDist;
  }

  void mousePressed(float mx, float my) {
    if (selected != -1) {
      dragging = true;
    } else if (active != null) {
      insertPoint(activeIdx, active.x, active.y, true);
      selected = activeIdx;
      active = null;
      activeIdx = -1;
      dragging = true;
    } 
  }
  
  void mouseReleased(float mx, float my) {
    dragging = false;
  }

  void mouseDragged(float mx, float my) {
    if (dragging) {
      float magt = dist(p1.x, p1.y, mx, my);
      float ang = atan2(p2.y-p1.y, p2.x-p1.x);
      float angt = atan2(my-p1.y, mx-p1.x);
      float x = magt * cos(angt-ang);
      float y = magt * sin(angt-ang);
      setPoint(selected, x, y, true);
    }
  }
  
}
