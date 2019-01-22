float MIN_MOUSE_DIST = 20;
float CORNER_BIAS = 0.5;
float SEG_DIST = 2.0;

// TODO
// x export mask
// - fix triangles
// x numColors
// x parallelograms
// - draw mouse points
//-----------
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
  color(0, 0, 255),
  color(255, 0, 255),
  color(255, 255, 0),
  color(0, 255, 255)
};

BaseShape s;
int C, R;
int w, h;
int nc, nr;
PVector active;
ArrayList<RawShape> rawShapes;
PGraphics pg;

void setup( ) {
  size(1280, 1280, P3D);////, P3D);  
  pg = createGraphics(width, height, P2D);
  
  w = 240/2;
  h = 240/2;
  
  nc = 2+2*ceil(width / w);
  nr = 2+2*ceil(height / h);
  
  s = new Hexagon(w, h, 20, false, false);
  //s = new Triangle(w, h);
  //s = new Rectangle(w, h, -20, false, false, false);


  // find best active shape
  C = nc/2; 
  R = nr/2;
  active = new PVector();
  float minDist = 1e8;
  for (int c=0; c<nc; c++) {
    for (int r=0; r<nr; r++) {
      PVector ctr = s.getCenter(c, r);
      float d = dist(ctr.x, ctr.y, width/2, height/2);
      if (d < minDist) {
        minDist = d;
        C = c;
        R = r;
      }
    }
  }
  
  if (C%2==1) C-=1;
  if (R%2==1) R-=1;
  
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
  //pg.background(colors[1]);
  pg.background(0);
  for (int i=0; i<rawShapes.size(); i++) {
    int r = int(floor(i/nr));
    int c = i % nr;
    color clr = colors[(c+r)%2];
    if (s instanceof Hexagon) {
      //clr = colors[(r%3 + ((r+c)%2==1?0:0))%3];
      clr = colors[(c%3 + (r%2==0?1:0))%3];
    }
    else if (s instanceof Rectangle || s instanceof Triangle) {
      int idx = (c%2==1?2:0) + (r%2==1?1:0);
      int idxR = floor(c/2)%2;
      idx = (c%2==1?2:0) + (r%2==1?1-idxR:idxR);
      clr = colors[idx%4];
    }
    pg.beginShape();
    pg.noStroke();
    pg.fill(clr);
    //if (true&& r==R && c==C) 
    {
    for (PVector p : rawShapes.get(i).points) {
      pg.vertex(p.x, p.y);
    }
    }
    pg.endShape(CLOSE);
    pg.fill(255);
    //pg.text(str(r) + ", " + str(c%2) + ", " + str(r%2==1?2:0 + c%2==1?1:0), rawShapes.get(i).points.get(0).x, rawShapes.get(i).points.get(0).y);
  }
  pg.endDraw();
}

void drawActive() {
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
      popMatrix();
    }
  }
}

void highlightActive() {
  beginShape();
  stroke(255);
  strokeWeight(3);
  noFill();
  for (PVector p : rawShapes.get(nr*C+R).points) {
    vertex(p.x, p.y);
  }
  endShape(CLOSE);
}

void draw() {
  background(0);
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
