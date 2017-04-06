class ParticleLaunch {
  ArrayList<Particle> particles;
  PVector loc;
  boolean plDead = false;
  ParticleLaunch(PVector location) {
    loc = location.get();
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    for (int i = 0; i<30; i++) {
      particles.add(new Particle(loc.x, loc.y));
    }
  }


  void display() {
    for (Particle p : particles) {
      p.display();
    }
  }

  void update() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update();
      if (p.isDead()) {
        particles.remove(i);
      }
      if (particles.size()<5) {
        plDead = true;
      }
    }
  }
}