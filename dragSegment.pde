flowField leftFF, rightFF;

class flowField {
  float[] x = new float[200];//the array length is the line length 
  float[] y = new float[200];
  float PX, PY;
  float segLength = random(3, 15);
  flowField(PVector initLoc) {
    for (int i=0; i<200; i++) {
      x[i]=initLoc.x;
      y[i]=initLoc.y;
    }
  }
  void dragSegment(int i, float xin, float yin) {
    float dx = xin - x[i];
    float dy = yin - y[i];
    float angle = atan2(dy, dx);  
    x[i] = xin - cos(angle) * segLength*noise(lt1);
    y[i] = yin - sin(angle) * segLength*noise(lt1);
    segment(x[i], y[i], angle);
  };

  void segment(float x, float y, float a) {
    strokeWeight(noise(rt1)*leftVel.y/20);
    float sw = noise(rt1)*leftVel.y/20;
    float delta = 30*noise(rt1);
    stroke(180+delta, 200+delta, 255, 70+delta);
    pushMatrix();
    translate(x, y);
    rotate(a);
    line(0, 0, segLength, 0);
    fill(255);
    popMatrix();
  }
}