class Triangle extends BaseShape {
    
  Triangle(int w, int h) {
    super(w, h);
    
    Segment bl = new Segment(new PVector(-w/2, h/2), new PVector(0, h/2), true);
    Segment br = new Segment(new PVector(w/2, h/2), new PVector(0, h/2));
    Segment tl = new Segment(new PVector(0, -h/2), new PVector(-w/2, h/2), true);
    Segment tr = new Segment(new PVector(0, -h/2), new PVector(w/2, h/2));
    
    bl.setHorizontal(true);
    br.setHorizontal(true);
    
    bl.link(br, false);
    br.link(bl, false);    
    tl.link(tr, true);
    tr.link(tl, true);
   
    segments.add(tl);
    segments.add(tr);
    segments.add(br);
    segments.add(bl);
  }
  
  PVector getCenter(int c, int r) {
    return new PVector(c * w/2 + (r%2==1 ? w/2 : 0), r * h);
    //return new PVector(c * w*1.2, r * h);
  }

  void draw(PVector center, boolean highlight, int c, int r) {    
    boolean flipX = c % 2 == 1;
    boolean flipY = false;//c % 2 == 1;
    float ang = c % 2 == 1 ? PI : 0;
    //super.draw(center, highlight, flipX, flipY, ang);
    
    pushMatrix();
    translate(center.x, center.y);
    rotate(ang);
    
    if (!flipX) {
      segments.get(0).draw(highlight, flipX, flipY);
      segments.get(1).draw(highlight, flipX, flipY);
      segments.get(2).draw(highlight, false, flipY);
      segments.get(3).draw(highlight, false, flipY);
    } else {
      segments.get(2).draw(highlight, flipX, flipY);
      segments.get(3).draw(highlight, flipX, flipY);
      segments.get(0).draw(highlight, flipX, flipY);
      segments.get(1).draw(highlight, flipX, flipY);
      
    }
    
    popMatrix();
  }
  
}
