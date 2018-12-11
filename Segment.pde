float MIN_MOUSE_DIST = 20;
float CORNER_BIAS = 0.5;
float SEG_DIST = 2.0;

class Segment {

  PVector p1, p2;
  ArrayList<PVector> points;
  boolean dragging;
  PVector active;
  int selected;
  int activeIdx;
  Segment linked;
  boolean linkReversed;
  float mag;

  Segment(PVector p1, PVector p2) {
    this.p1 = p1;
    this.p2 = p2;
    mag = dist(p1.x, p1.y, p2.x, p2.y);
    points = new ArrayList<PVector>();
    points.add(new PVector(0, 0));
    points.add(new PVector(mag, 0));
    dragging = false;
    linked = null;
    linkReversed = false;
    deselect();
  }
  
  void link(Segment other, boolean reverse) {
    linked = other;
    linkReversed = reverse;
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
  
  void setPoint(int idx, float x, float y, boolean sendLinked) {
    points.get(idx).set(x, y);
    if (linked != null && sendLinked) {
      if (linkReversed) {
        linked.setPoint(linked.points.size()-1-idx, mag-x, y, false);
      } else {
        linked.setPoint(idx, x, y, false);
      }
    }
  }
  
  void insertPoint(int idx, float x, float y, boolean sendLinked) {
    points.add(idx, new PVector(x, y));
    if (linked != null && sendLinked) {
      if (linkReversed) {
        linked.insertPoint(linked.points.size()-idx, mag-x, y, false);
      } else {
        linked.insertPoint(idx, x, y, false);
      }
    }
  }

  void tellme() {
    for (int p=0; p<points.size(); p++) {
      println(p+" : "+points.get(p).x+", "+points.get(p).y+" ");
    }
  }

  void draw(boolean highlight, boolean rev) {
    float ang = atan2(p2.y-p1.y, p2.x-p1.x); 
    float mag = dist(p1.x, p1.y, p2.x, p2.y);

    noFill();
    if (highlight) {
      stroke(255, 225);
    } else if (rev) {
      stroke(255, 0, 0, 200);
    } else {
      stroke(255, 100);
    }
  
    pushMatrix();
    translate(p1.x, p1.y);
    rotate(ang);
    beginShape();
    vertex(rev ? mag : 0, 0);
    for (int i=0; i<points.size(); i++) {
      vertex(rev ? mag - points.get(i).x : points.get(i).x, points.get(i).y);
      if (highlight) {
        //ellipse(rev ? mag - points.get(i).x : points.get(i).x, points.get(i).y, 5, 5);
      }
    }
    vertex(rev ? 0 : mag, 0);
    endShape();
    
    noStroke();  
    if (active!=null && highlight) {
      fill(255, 255, 0);
      ellipse(rev ? mag - points.get(selected).x : active.x, active.y, 5, 5);
    }
    else if (selected>-1 && highlight) {
      fill(255, 0, 255);
      ellipse(rev ? mag - points.get(selected).x : points.get(selected).x, points.get(selected).y, 5, 5);
    }

    popMatrix();
    
    
  }
}
