
Vehicle[] vehicles = new Vehicle[100];
color[] colors = { #5c6565, #bc9e7f, #3b5e79, #d9df85, #906b74, #d6d495, #de5e4c, #d5497f, #d58b7d };
PVector target;


void setup() {
  size(600,600,P3D);
  target = new PVector();

  //pixelDensity(displayDensity());
  
  for(int i=0; i < vehicles.length; i++) {
    vehicles[i] = new Vehicle(random(width), random(height));
  }



  background(42);

  // Init Video recording and effects
   initVidAndFX();
}

void draw() {
  
   background(42);
  
  target.set(mouseX, mouseY);

  for(int i=0; i < vehicles.length; i++) {
    vehicles[i].seek();
    vehicles[i].update();
    vehicles[i].draw();
  }

  fill(255);
  ellipse(target.x, target.y, 30, 30);

  // Do the effects
    doVidAndFX();
}
