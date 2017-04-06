import java.util.Random;
Random generator = new Random();

void drawSplatter(float x, float y, int radius, int level){
  noStroke();
  float R = 140+level*15*noise(lt1); 
  fill (R, 0,0);
  ellipse(x, y, radius, radius);
  if (level > 1) {
    level = level - 1;
    //int num = 0;
    int num = (int)map((leftVel.y+rightVel.y), 0, 200, 2,4);
    for(int i=0; i<num; i++) { 
      float a = random(0, TWO_PI);
      float nx = x + cos(a) * 6.0 * level; 
      float ny = y + sin(a) * 6.0 * level; 
      drawSplatter(nx, ny, radius/2, level); 
    }
  }
}