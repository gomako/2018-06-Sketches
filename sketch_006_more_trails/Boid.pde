class Boid {

  Trail trail;
  PVector loc;
  PVector vel;
  PVector acc;
  float maxSpeed;
  float maxForce;
  float w = 12;
  float h = 4;
  float desiredSeparation = 500;
  float neighbourDist = 20;

  ArrayList<PVector> points;
  int numPoints = 10;

  Boid(float x, float y, float z) {
    trail = new Trail();
    loc = new PVector(x, y, z);
    vel = new PVector(random(-1, 1), random(-1, 1));
    acc = new PVector(0,0);
    maxSpeed = random(20,30);
    maxForce = random(0.5, 1.5);
    points = new ArrayList<PVector>();
  }

  void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    // edges();
    draw();
  }

  // Flocking behaviour
  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);
    PVector ali = align(boids);
    PVector coh = cohesion(boids);
    PVector seek = seek(target);
    
    sep.mult(sepMult);
    ali.mult(aliMult);
    coh.mult(cohMult);
    seek.mult(seekMult);

    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
    applyForce(seek);

    // if(dist(loc.x,loc.y,loc.z,target.x,target.y,target.z) < 10) {
    //   target.set(random(-targetBounds,targetBounds),random(-targetBounds,targetBounds),random(-targetBounds,targetBounds));
    // }
  }

  // Align 
  PVector align(ArrayList<Boid> boids) {
    PVector sum = new PVector(0,0,0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(loc,other.loc);
      if ((d > 0) && (d < neighbourDist)) {
        sum.add(other.vel);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(maxSpeed);
      PVector steer = PVector.sub(sum,vel);
      steer.limit(maxForce);
      return steer;
    } else {
      return new PVector(0,0,0);
    }
  }

  // Cohesion
  PVector cohesion(ArrayList<Boid> boids) {
    PVector sum = new PVector(0,0,0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(loc,other.loc);
      if ((d > 0) && (d < neighbourDist)) {
        sum.add(other.loc); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } else {
      return new PVector(0,0,0);
    }
  }

  // Seek behaviour
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, loc);
    desired.normalize();
    desired.mult(maxSpeed);
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxForce);
    return steer;
  }

  // Flee behaviour
  PVector flee(PVector target) {
    PVector desired = PVector.sub(target, loc);
    desired.normalize();
    desired.mult(maxSpeed);
    desired.mult(-1);
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxForce);
    return steer;
  }

  // Separate behaviour
  PVector separate(ArrayList<Boid> boids) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0,0,0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(loc,other.loc);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(loc,other.loc);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxSpeed);
      steer.sub(vel);
      steer.limit(maxForce);
    }
    return steer;
  }

  void update() {
    vel.add(acc);
    vel.limit(maxSpeed);
    loc.add(vel);
    acc.mult(0);
    points.add(loc);
    trail.update(loc, vel);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acc.add(force);
  }

  void draw() {
    trail.draw();
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