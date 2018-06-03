class Vehicle {

  PVector loc;
  PVector vel;
  PVector acc;
  float maxSpeed;
  float maxForce;
  float w = 12;
  float h = 4;
  color clr = colors[(int)random(colors.length)];

  Vehicle(float x, float y) {
    loc = new PVector(x, y);
    vel = new PVector();
    acc = new PVector();
    maxSpeed = random(2,5);
    maxForce = random(0.01, 0.2);
  }

  void flee() {
    PVector desired = PVector.sub(target,loc);
    desired.normalize();
    desired.mult(-maxSpeed);
    PVector steer = PVector.sub(desired,vel);
    steer.limit(maxForce);
    applyForce(steer);
  }

  void seek() {
    PVector desired = PVector.sub(target,loc);
    desired.normalize();
    desired.mult(maxSpeed);
    PVector steer = PVector.sub(desired,vel);
    steer.limit(maxForce);
    applyForce(steer);
  }

  void update() {
    
    edges();
    vel.add(acc);
    vel.limit(maxSpeed);
    loc.add(vel);
    acc.mult(0);
  }

  void draw() {
    float theta = vel.heading() + PI/2;
    fill(clr);
    noStroke();
    pushMatrix();
    translate(loc.x,loc.y);
    rotate(theta);
    beginShape();
    vertex(0, -w);
    vertex(-h, w);
    vertex(h, w);
    endShape(CLOSE);
    popMatrix();
    
  }


  void applyForce(PVector force) {
    acc.add(force);
  }



  void edges() {
    if (loc.x >= width) {
      loc.x = 0; 
    }

    if (loc.x < 0) { 
      loc.x = width;
    }

    if (loc.y >= height) {
      loc.y = 0; 
    }

    if (loc.y < 0) { 
      loc.y = height;
    }
  }

}
