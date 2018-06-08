  import controlP5.*;

  ControlP5 cp5;
  Boolean showControls = false;

Flock flock;

int num = 500;

color[] colors = { #5c6565, #bc9e7f, #3b5e79, #d9df85, #906b74, #d6d495, #de5e4c, #d5497f, #d58b7d };
PVector target;
float a;
float sepMult = 1.5;
float aliMult = 1.0;
float cohMult = 1.0;
float seekMult = 1.0;
float targetBounds = 300;

void setup() {
  size(600,600,P3D);
  target = new PVector(0,0,0);
  //pixelDensity(displayDensity());
  
  cp5 = new ControlP5(this);
  cp5.addSlider("sepMult").setPosition(10, 10).setSize(200, 20).setRange(0.1, 3).setValue(1.5);
  cp5.addSlider("aliMult").setPosition(10, 30).setSize(200, 20).setRange(0.1, 3).setValue(1);
  cp5.addSlider("cohMult").setPosition(10, 50).setSize(200, 20).setRange(0.1, 3).setValue(1);
  cp5.addSlider("seekMult").setPosition(10, 70).setSize(200, 20).setRange(0.1, 3).setValue(1);
  cp5.hide();

  flock = new Flock();
  
  for(int i=0; i < num; i++) {
    flock.addBoid(new Boid(random(-width/2, width/2), random(-height/2,height/2), random(-width/2,width/2)));
  }
  // Init Video recording and effects
  initVidAndFX();
}

void draw() {
  
  background(colors[0]);  

  // pushMatrix();
  // translate(width*.5, height*.5, -300);
  // translate(target.x,target.y,target.z);
  // fill(255,0,0);
  // sphere(10);
  // popMatrix();
  
  translate(width*.5, height*.5, -300);
  rotateY(a*.15);
  rotateX(a*.05);
  ambientLight(102, 102, 102);
  pointLight(230, 230, 230, 0, 0, 0);
  flock.run();
  
  a+=0.075;
  
  // Do the effects
  doVidAndFX();

  sepMult = noise(a*10)*7;
  // aliMult = noise(a*10)*2;
  // cohMult = noise(a*10)*2;
  seekMult = noise(a*20) * 3;
  

}
