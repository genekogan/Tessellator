float MIN_MOUSE_DIST = 20;
float CORNER_BIAS = 0.5;
float SEG_DIST = 2.0;

// TODO
// - export mask
// - draw mouse points
//-----------
// - parallelograms
// - two complementary shapes (fish/bird)
// - not forcing corners
// - save
// - restart


class RawShape {
  ArrayList<PVector> points;
  RawShape(ArrayList<PVector> points) {
    this.points = points;
  }
}

color[] colors = new color[]{
  color(255, 0, 0), 
  color(0, 255, 0), 
  color(0, 0, 255)
};

BaseShape s;
int C, R;
int w, h;
int nc, nr;
PVector active;
ArrayList<RawShape> rawShapes;
PGraphics pg;

void setup( ) {
  size(1280, 1200, P3D);////, P3D);  
  pg = createGraphics(width, height, P2D);
  
  w = 100;
  h = 100;
  
  nc = 1+ceil(width / w);
  nr = 1+ceil(height / h);
  
  
  //s = new Hexagon(w, h, 20, false, false);
  //s = new Triangle(w, h);
  s = new Rectangle(w, h, false, false, true);
  // rct not ordered right
  
  C = nc/2; 
  R = nr/2;

  active = s.getCenter(C, R);
}

void makeShapes() {
  rawShapes = new ArrayList<RawShape>();
  
  for (int c=0; c<nc; c++) {
    for (int r=0; r<nr; r++) {
      PVector ctr = s.getCenter(c, r);
      boolean highlighted = (c==C && r==R);
      pushMatrix();
      if (s instanceof Rectangle) {
        ((Rectangle) s).draw(ctr, highlighted, c, r);
      } else if (s instanceof Triangle) {
        ((Triangle) s).draw(ctr, highlighted, c, r);
      } else if (s instanceof Hexagon) {
        ((Hexagon) s).draw(ctr, highlighted, c, r);
      }
      rawShapes.add(new RawShape(s.getVertices()));
      popMatrix();
    }
  }
}

void drawShapes() {
  pg.beginDraw();
  pg.clear();
  pg.background(colors[0]);
  for (int i=0; i<rawShapes.size(); i++) {
    int c = int(floor(i/nr));
    int r = i % nr;
    color clr = colors[(c+r)%2];
    pg.beginShape();
    pg.noStroke();
    pg.fill(clr);
    for (PVector p : rawShapes.get(i).points) {
      pg.vertex(p.x, p.y);
    }
    pg.endShape(CLOSE);
  }
  pg.endDraw();
}

void highlightActive() {
  beginShape();
  stroke(255);
  strokeWeight(3);
  noFill();
  for (PVector p : rawShapes.get(nr*R+C).points) {
    vertex(p.x, p.y);
  }
  endShape(CLOSE);
}

void draw() {
  makeShapes();
  drawShapes();
  highlightActive();
  image(pg, 0, 0);
}

void deselectAll() {
  s.deselect();
}
      
void mouseMoved() {
  s.mouseMoved((int)(mouseX-active.x), (int)(mouseY-active.y));
}

void mousePressed() {
  s.mousePressed((int)(mouseX-active.x), (int)(mouseY-active.y));
}

void mouseReleased() {
  s.mouseReleased((int)(mouseX-active.x), (int)(mouseY-active.y));
}

void mouseDragged() {
  s.mouseDragged((int)(mouseX-active.x), (int)(mouseY-active.y));
}

void keyPressed() {
  if (key=='1') {
    pg.save("frame.png");
  }
  //if (key==' ') {
  //  //s.startNext();
  //}
  //if (key=='a') {
  //  //s.randNext();
  //}
}
