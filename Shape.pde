
class Shape {
  
  Segment top, left;
  Segment bottom, right;
  
  Shape(PVector tl, PVector tr, PVector bl) {
    
    top = new Segment(new PVector(tl.x, tl.y), new PVector(tr.x, tr.y));
    left = new Segment(new PVector(bl.x, bl.y), new PVector(tl.x, tl.y));
    
    PVector br = new PVector(tr.x, bl.y);
    bottom = new Segment(new PVector(bl.x, bl.y), new PVector(br.x, br.y));
    right = new Segment(new PVector(br.x, br.y), new PVector(tr.x, tr.y));
    
    top.link(bottom, true);
    bottom.link(top, true);
    left.link(right, true);
    right.link(left, true);
  }
  

  void deselect() {
    top.deselect();
    bottom.deselect();
    left.deselect();
    right.deselect();
  }
  
  void draw(boolean highlight, boolean reversed) {
    top.draw(highlight, reversed);
    right.draw(highlight, reversed);
    bottom.draw(highlight, reversed);
    left.draw(highlight, reversed);
  }
  
  void tellme() {
    println("top");
    top.tellme();
    println("bottom");
    bottom.tellme();
  }
  
  void mouseMoved(int mx, int my) {
    float minDist = 1e8;
    minDist = top.mouseMoved(mx, my, minDist);
    minDist = bottom.mouseMoved(mx, my, minDist);
    minDist = left.mouseMoved(mx, my, minDist);
    minDist = right.mouseMoved(mx, my, minDist);
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
