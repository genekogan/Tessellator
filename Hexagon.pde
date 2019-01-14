class Hexagon extends BaseShape {
  boolean reverseX;
  boolean reverseY;
  int ridge;
  
  Hexagon(int w, int h, int ridge, boolean reverseX, boolean reverseY) {
    super(w, h);
    
    this.reverseX = reverseX;
    this.reverseY = reverseY;
    this.ridge = ridge;
    
    Segment top = new Segment(new PVector(-w/2+ridge, -h/2), new PVector(w/2-ridge, -h/2));
    Segment bottom = new Segment(new PVector(-w/2+ridge, h/2), new PVector(w/2-ridge, h/2), true);
    Segment tl = new Segment(new PVector(-w/2+ridge, -h/2), new PVector(-w/2-ridge, 0), true);
    Segment tr = new Segment(new PVector(w/2+ridge, 0), new PVector(w/2-ridge, -h/2), true);
    Segment bl = new Segment(new PVector(-w/2+ridge, h/2), new PVector(-w/2-ridge, 0));
    Segment br = new Segment(new PVector(w/2+ridge, 0), new PVector(w/2-ridge, h/2));

    top.setHorizontal(true);
    bottom.setHorizontal(true);
    
    top.link(bottom, reverseY);
    bottom.link(top, reverseY);
    tl.link(br, reverseX);
    tr.link(bl, reverseX);
    bl.link(tr, reverseX);
    br.link(tl, reverseX);
    
    segments.add(top);
    segments.add(tr);
    segments.add(br);
    segments.add(bottom);
    segments.add(bl);
    segments.add(tl);
  }
  
  PVector getCenter(int c, int r) {
    return new PVector(c * w, r * h + (c%2==1?h/2:0));
  }

  void draw(PVector center, boolean highlight, int c, int r) {
    boolean flipY = reverseX ? c % 2 == 1 : false;
    boolean flipX = reverseY ? r % 2 == 1 : false;
    float ang = 0;  
    super.draw(center, highlight, flipX, flipY, ang);
  }
  
}
