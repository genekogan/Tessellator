Shape s;

void setup( ) {
  size(1280, 800);
  
  
  
  PVector tl = new PVector(width/2-100, height/2-100);
  PVector tr = new PVector(width/2+150, height/2-100);
  PVector bl = new PVector(width/2-100, height/2+150);
  
  s = new Shape(tl, tr, bl);
    
    
    
  

}

void draw() {
  background(0);
  for (int c=-3; c<6; c++) {
    for (int r=-3; r<6; r++) {
      int x = c*250;
      int y = r*250;
      pushMatrix();
      translate(x, y);
      if (c==0 && r==0)
        s.draw();
      popMatrix();
    }
  }
}

void deselectAll() {
  s.deselect();
}

void mouseMoved() {
  s.mouseMoved(mouseX, mouseY);
}

void mousePressed() {
  s.mousePressed(mouseX, mouseY);
}

void mouseReleased() {
  s.mouseReleased(mouseX, mouseY);
}

void mouseDragged() {
  s.mouseDragged(mouseX, mouseY);
}
