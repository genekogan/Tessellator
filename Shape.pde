
class Shape {
  
  Segment top, left;
  Segment bottom, right;
  
  Shape(PVector tl, PVector tr, PVector bl) {
    top = new Segment(tl, tr);
    left = new Segment(bl, tl);
    
    PVector br = new PVector(tr.x, bl.y);
    bottom = new Segment(bl, br);
    right = new Segment(br, tr);
    
    
    ArrayList<PVector> points = new ArrayList<PVector>();
    points.add(new PVector(10, -20));
    points.add(new PVector(60, 30));
    points.add(new PVector(90, -10));
    points.add(new PVector(120, -20));
    points.add(new PVector(150, 15));
    
    points = new ArrayList<PVector>();
    points.add(new PVector(0, 0));
    points.add(new PVector(tr.x-tl.x, 0));
    
    top.setPoints(points);
    bottom.setPoints(points);



    ArrayList<PVector> points2 = new ArrayList<PVector>();
    points2.add(new PVector(10, -20));
    points2.add(new PVector(60, 30));
    points2.add(new PVector(90, -10));
    points2.add(new PVector(120, -20));
    points2.add(new PVector(150, 15));
    
    points2 = new ArrayList<PVector>();
    points2.add(new PVector(0, 0));
    points2.add(new PVector(br.x-bl.x, 0));
    
    left.setPoints(points2);
    right.setPoints(points2);

  }
  
  void deselect() {
    top.deselect();
    bottom.deselect();
    left.deselect();
    right.deselect();
  }
  
  void draw() {
    top.draw();
    right.draw();
    bottom.draw();
    left.draw();
  }
  
  
  
  void mouseMoved(int mx, int my) {
    top.mouseMoved(mx, my);
    bottom.mouseMoved(mx, my);
    left.mouseMoved(mx, my);
    right.mouseMoved(mx, my);
  }
  
  void mousePressed(int mx, int my) {
    top.mousePressed(mx, my);
    bottom.mousePressed(mx, my);
    left.mousePressed(mx, my);
    right.mousePressed(mx, my);
  }
  
  void mouseReleased(int mx, int my) {
    top.mouseReleased(mx, my);
    bottom.mouseReleased(mx, my);
    left.mouseReleased(mx, my);
    right.mouseReleased(mx, my);
  }
  
  void mouseDragged(int mx, int my) {
    top.mouseDragged(mx, my);
    bottom.mouseDragged(mx, my);
    left.mouseDragged(mx, my);
    right.mouseDragged(mx, my);
  }
}
