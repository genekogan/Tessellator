class Rectangle extends BaseShape {
  boolean reverseX;
  boolean reverseY;
  boolean rotate;
  
  Rectangle(int w, int h, boolean reverseX, boolean reverseY, boolean rotate) {
    super(w, h);
    
    this.reverseX = reverseX;
    this.reverseY = reverseY;
    this.rotate = rotate;
    
    Segment top = new Segment(new PVector(-w/2, -h/2), new PVector(w/2, -h/2));
    Segment bottom = new Segment(new PVector(-w/2, h/2), new PVector(w/2, h/2), true);
    Segment left = new Segment(new PVector(-w/2, -h/2), new PVector(-w/2, h/2), true);
    Segment right = new Segment(new PVector(w/2, -h/2), new PVector(w/2, h/2));
    
    top.setHorizontal(true);
    bottom.setHorizontal(true);
    left.setHorizontal(false);
    right.setHorizontal(false);
    
    if (rotate) {
      top.link(left, reverseY);
      left.link(top, reverseX);
      bottom.link(right, reverseY);
      right.link(bottom, reverseX);
    } 
    else { 
      top.link(bottom, reverseY);
      bottom.link(top, reverseY);
      left.link(right, reverseX);
      right.link(left, reverseX);
    }
    
    segments.add(top);
    segments.add(right);
    segments.add(bottom);
    segments.add(left);
  }
  
    
  void draw(PVector center, boolean highlight, int c, int r) {
    boolean flipY = reverseX ? c % 2 == 1 : false;
    boolean flipX = reverseY ? r % 2 == 1 : false;
    
    float ang = 0;
    if (rotate && c%2==1 && r%2==0) ang = HALF_PI;
    else if (rotate && c%2==1 && r%2==1) ang = PI;
    else if (rotate && c%2==0 && r%2==1) ang = -HALF_PI;
    
    super.draw(center, highlight, flipX, flipY, ang);
  }
  
}
