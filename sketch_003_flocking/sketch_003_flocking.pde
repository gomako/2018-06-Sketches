
Flock flock;

int num = 500;

color[] colors = { #5c6565, #bc9e7f, #3b5e79, #d9df85, #906b74, #d6d495, #de5e4c, #d5497f, #d58b7d };
PVector target;


void setup() {
  size(600,600,P3D);
  target = new PVector(width/2, height/2);
  //pixelDensity(displayDensity());
  
  flock = new Flock();
  
  for(int i=0; i < num; i++) {
    flock.addBoid(new Boid(random(0, width), random(0,height)));
  }

  background(42);
  // Init Video recording and effects
   initVidAndFX();
}

void draw() {
  
   background(42);

  //target.set(mouseX, mouseY);

  flock.run();

  // Do the effects
    doVidAndFX();
}
