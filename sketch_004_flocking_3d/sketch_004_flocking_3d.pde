
Flock flock;

int num = 2000;

color[] colors = { #5c6565, #bc9e7f, #3b5e79, #d9df85, #906b74, #d6d495, #de5e4c, #d5497f, #d58b7d };
PVector target;
float a;


void setup() {
  size(600,600,P3D);
  target = new PVector(0,0,0);
  //pixelDensity(displayDensity());
  sphereDetail(12);
  flock = new Flock();
  
  for(int i=0; i < num; i++) {
    flock.addBoid(new Boid(random(-width/2, width/2), random(-height/2,height/2), random(-width/2,width/2)));
  }

  background(42);
  // Init Video recording and effects
   initVidAndFX();
}

void draw() {
  
  background(42);  
  translate(width*.5, height*.5);
  rotateY(a);
  ambientLight(102, 102, 102);
  pointLight(200, 200, 200, 0, 0, 0);
  flock.run();
  a+=0.01;
  // Do the effects
  doVidAndFX();
}
