import org.openkinect.processing.*;
KinectTracker tracker;
PImage bodyTracker;
PImage display;
/**********minim***********/
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
Minim       minim;
AudioPlayer swing;
BeatDetect  beat;
BeatListener bl;
FFT         fft;

int ampIndexLeft, ampIndexRight;
PVector leftVel = new PVector(0, 0);
PVector rightVel = new PVector(0, 0);
PVector beatPoint = new PVector();
float lt1=random(1), rt1=random(1);
int timer = 0;
/**********minim***********/

/**********fireEffect***********/
ArrayList<ParticleLaunch> particleSystem;


void setup() {
  fullScreen();
  //size(1280, 640, P2D);
  background(0);
  tracker = new KinectTracker(this);
  ////////////////////////////////////////
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("192.168.0.8", 12000);//192.168.0.8
  ////////////////////////////////////////////////////
  minim = new Minim(this);
  swing = minim.loadFile("newSwing.wav", 1024);
  swing.play();
  fft = new FFT( swing.bufferSize(), swing.sampleRate() );
  // a beat detection object song SOUND_ENERGY mode with a sensitivity of 10 milliseconds
  beat = new BeatDetect();
  bl = new BeatListener(beat, swing);
  //********define the left and right flowField**********//
  leftFF = new flowField(new PVector(0, 0));
  rightFF = new flowField(new PVector(width, height));
  //////////////fire/////////////////////
  particleSystem = new ArrayList<ParticleLaunch>();
}

void draw() {
  println(frameRate, ampValue);
  fill(0, 5);
  rect(0, 0, width, height);
  lt1+=0.01;
  rt1+=0.0001;
  //colorMode(RGB);
  //contains the mix of both the left and right channels of the file
  fft.forward(swing.mix);  //fft.specSize() == 513
  for (int i = 0; i<fft.specSize(); i++) {
    if (fft.getBand(ampIndexLeft)<fft.getBand(i)) {
      ampIndexLeft = i;
    }
  }
  leftVel.x = ampIndexLeft;
  leftFF.PX=leftVel.x+width*noise(lt1);
  leftVel.y = fft.getBand(ampIndexLeft);
  if (leftVel.y<height/2) {
    leftFF.PY=leftVel.y*5;
  } 
  if (leftFF.PY>height) {
    leftFF.PY = leftVel.y-height;
  }
  leftFF.dragSegment(0, leftFF.PX, leftFF.PY);
  for (int j=0; j<leftFF.x.length-1; j++) {
    leftFF.dragSegment(j+1, leftFF.x[j], leftFF.y[j]);
  }
  rightFF.dragSegment(0, width-leftFF.PX, height-leftFF.PY);
  for (int j=0; j<leftFF.x.length-1; j++) {
    rightFF.dragSegment(j+1, rightFF.x[j], rightFF.y[j]);
  }
  //////**********beatDectation*************//
  beat.detect(swing.mix);
  noStroke();
  if (beat.isOnset()) {
    timer ++;
    drawSplatter(random(width), random(height), (int)random(80, 120), 10);
  }
  /////////////////////////////////////////////////
  /*******Run the tracking analysis********/
  ////******show contour********////
  if (keyPressed && keyCode == DOWN) {
    float posX = map(pitchValue, 50, 300, 0, width);
    float posY = map(ampValue, 30, 70, 0, height);
    particleSystem.add(new ParticleLaunch(new PVector(posX, posY)));
    int index = particleSystem.size()-1;
    ParticleLaunch newOne = (ParticleLaunch)particleSystem.get(index);
    newOne.addParticle();
    /////**update and display and dead on all launch*****/////
    for (int j = particleSystem.size()-1; j>=0; j--) {
      ParticleLaunch pl = (ParticleLaunch)particleSystem.get(j);
      pl.update();
      pl.display();
      if (pl.plDead) {
        particleSystem.remove(j);
      }
    }
  }
}