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


  Segment(PVector p1, PVector p2) {
    this.p1 = p1;
    this.p2 = p2;
    points = new ArrayList<PVector>();
    dragging = false;
    active = null;
    activeIdx = -1;
    selected = -1;
  }

  void setPoints(ArrayList<PVector> points) {
    this.points = points;
  }

  void deselect() {
  }

  void mouseMoved(float mx, float my) {
    float minDist = 1e8;


    float ang = atan2(p2.y-p1.y, p2.x-p1.x); 
    //    float mag = dist(p1.x, p1.y, p2.x, p2.y);

    active = null;
    activeIdx = -1;
    selected = -1;
    /*
    for (int p=0; p<points.size(); p++) {
      PVector t = points.get(p);

      float magt = dist(0, 0, t.x, t.y);
      float angt = atan2(t.y, t.x);
      float x = p1.x + magt * cos(ang+angt);
      float y = p1.y + magt * sin(ang+angt);
      float d = dist(x, y, mx, my);
      if (d < minDist && d < MIN_MOUSE_DIST) {
        active = p;
        minDist = d;
      }
    }
*/
    
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
            selected = p;
            activeIdx = -1;
            active = null;
          } else if (i==n-1){
            selected = p+1;
            activeIdx = -1;
            active = null;
          } else {
            selected = -1;
            activeIdx = p+1;
            active = t;  
          }
        }
      }
    }
  }

  void mousePressed(float mx, float my) {
    if (selected != -1) {
      dragging = true;
    } else if (active != null) {
      points.add(activeIdx, active);
      selected = activeIdx;
      active = null;
      activeIdx = -1;
    } else {
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
      points.get(selected).set(x, y);
    }
  }

  void draw() {
    float ang = atan2(p2.y-p1.y, p2.x-p1.x); 
    float mag = dist(p1.x, p1.y, p2.x, p2.y);
    pushMatrix();
    translate(p1.x, p1.y);
    rotate(ang);
    //line(0, 0, mag, 0);
    popMatrix();


    stroke(255, 150);
    noFill();


    pushMatrix();
    translate(p1.x, p1.y);
    rotate(ang);
    beginShape();
    vertex(0, 0);
    for (int i=0; i<points.size(); i++) {
      vertex(points.get(i).x, points.get(i).y);
      ellipse(points.get(i).x, points.get(i).y, 5, 5);
    }
    vertex(mag, 0);
    endShape();
    
    

    noStroke();
    
    fill(255, 255, 0);
    if (active!=null)
      ellipse(active.x, active.y, 5, 5);
      
    fill(255, 0, 255);
    if (selected > -1) {
      ellipse(points.get(selected).x, points.get(selected).y, 5, 5);
    }


    popMatrix();
  }
}
