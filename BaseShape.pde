class BaseShape {
  ArrayList<Segment> segments;
  int w, h;
  
  BaseShape(int w, int h) {
    segments = new ArrayList<Segment>();
    this.w = w;
    this.h = h;
  }
  
  PVector getCenter(int c, int r) {
    return new PVector(c * w, r * h);
  }
  
  void deselect() {
    for (Segment s : segments) {
      s.deselect();
    }
  }
  
  void draw(PVector center, boolean highlight, boolean flipX, boolean flipY, float rotateAngle) {
    pushMatrix();
    translate(center.x, center.y);
    rotate(rotateAngle);    
    for (Segment s : segments) {
      s.draw(highlight, flipX, flipY);
    }
    popMatrix();
  }
  
  ArrayList<PVector> getVertices() {
    ArrayList<PVector> vertices = new ArrayList<PVector>();
    for (Segment s : segments) {
      vertices.addAll(s.getVertices());
    }
    return vertices;
  }
  
  void mouseMoved(int mx, int my) {
    float minDist = 1e8;
    for (Segment s : segments) {
      minDist = s.mouseMoved(mx, my, minDist);
    }
  }
  
  void mousePressed(int mx, int my) {
    for (Segment s : segments) {
      s.mousePressed(mx, my);
    }
  }
  
  void mouseReleased(int mx, int my) {
    for (Segment s : segments) {
      s.mouseReleased(mx, my);
    }
  }
  
  void mouseDragged(int mx, int my) {
    for (Segment s : segments) {
      s.mouseDragged(mx, my);
    }
  }
}
