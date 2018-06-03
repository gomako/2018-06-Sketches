
ArrayList<Vehicle> vehicles;
int num = 200;

color[] colors = { #5c6565, #bc9e7f, #3b5e79, #d9df85, #906b74, #d6d495, #de5e4c, #d5497f, #d58b7d };
PVector target;


void setup() {
  size(600,600,P3D);

  target = new PVector(width/2, height/2);
  vehicles = new ArrayList<Vehicle>();
  //pixelDensity(displayDensity());
  
  for(int i=0; i < num; i++) {
    vehicles.add(new Vehicle(random(width), random(height)));
  }

  background(42);
  // Init Video recording and effects
   initVidAndFX();
}

void draw() {
  
   background(42);

  for (Vehicle vehicle : vehicles) {
  	// vehicle.flee();
    vehicle.separate(vehicles);
  	vehicle.update();
  	vehicle.draw();	
  }

  // Do the effects
    doVidAndFX();
}
