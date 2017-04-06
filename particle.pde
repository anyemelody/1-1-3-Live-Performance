float t1 = random(1);
float t2 = random(1);

class Particle {
  PVector loc, vel, acc;
  float lifespan;
  float initR = random(40, 60);
  float r;
  boolean highlight;//judge if red or grey

  Particle(float x, float y) {
    acc = new PVector(0, 0.05);
    vel = new PVector(random(-1, 1), random(-2, 0));
    loc = new PVector(x, y);
    lifespan = 300.0;
  }

  void run() {
    update();
    display();
  }


  // Method to update location
  void update() {
    acc.mult(noise(t1, t2));
    vel.add(acc);
    loc.add(vel);
    acc.mult(0);
    lifespan -= 3.0;
    r = map(lifespan, 360, 0, initR, 0);
  }

  // Method to display
  void display() {
    noStroke();
    colorMode(HSB, 360, 100, 100);
    float hue = map(lifespan, 300, 0, 60, 0);
    fill(hue, 100, 100, lifespan/3); 
    ellipse(loc.x, loc.y, r, r);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}