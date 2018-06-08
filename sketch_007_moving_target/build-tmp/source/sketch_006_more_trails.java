import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import ch.bildspur.postfx.builder.*; 
import ch.bildspur.postfx.pass.*; 
import ch.bildspur.postfx.*; 
import com.hamoid.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sketch_006_more_trails extends PApplet {

  

  ControlP5 cp5;
  Boolean showControls = false;

Flock flock;

int num = 600;

int[] colors = { 0xff5c6565, 0xffbc9e7f, 0xff3b5e79, 0xffd9df85, 0xff906b74, 0xffd6d495, 0xffde5e4c, 0xffd5497f, 0xffd58b7d };
PVector target;
float a;
float sepMult = 1.5f;
float aliMult = 1.0f;
float cohMult = 1.0f;
float seekMult = 1.0f;

public void setup() {
  
  target = new PVector(0,0,0);
  //pixelDensity(displayDensity());
  
  cp5 = new ControlP5(this);
  cp5.addSlider("sepMult").setPosition(10, 10).setSize(200, 20).setRange(0.1f, 3).setValue(1.5f);
  cp5.addSlider("aliMult").setPosition(10, 30).setSize(200, 20).setRange(0.1f, 3).setValue(1);
  cp5.addSlider("cohMult").setPosition(10, 50).setSize(200, 20).setRange(0.1f, 3).setValue(1);
  cp5.addSlider("seekMult").setPosition(10, 70).setSize(200, 20).setRange(0.1f, 3).setValue(1);
  cp5.hide();

  flock = new Flock();
  
  for(int i=0; i < num; i++) {
    flock.addBoid(new Boid(random(-width/2, width/2), random(-height/2,height/2), random(-width/2,width/2)));
  }
  // Init Video recording and effects
  initVidAndFX();
}

public void draw() {
  
  background(colors[0]);  
  translate(width*.5f, height*.5f);
  rotateY(a*.15f);
  rotateX(a*.05f);
  ambientLight(102, 102, 102);
  pointLight(230, 230, 230, 0, 0, 0);
  flock.run();
  
  a+=0.075f;
  
  // Do the effects
  doVidAndFX();

  sepMult = noise(a*10)*7;
  // aliMult = noise(a*10)*2;
  // cohMult = noise(a*10)*2;
  seekMult = noise(a*20);

}
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
    maxSpeed = random(9,12);
    maxForce = random(0.2f, 0.4f);
    points = new ArrayList<PVector>();
  }

  public void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    // edges();
    draw();
  }

  // Flocking behaviour
  public void flock(ArrayList<Boid> boids) {
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
  }

  // Align 
  public PVector align(ArrayList<Boid> boids) {
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
  public PVector cohesion(ArrayList<Boid> boids) {
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
  public PVector seek(PVector target) {
    PVector desired = PVector.sub(target, loc);
    desired.normalize();
    desired.mult(maxSpeed);
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxForce);
    return steer;
  }

  // Flee behaviour
  public PVector flee(PVector target) {
    PVector desired = PVector.sub(target, loc);
    desired.normalize();
    desired.mult(maxSpeed);
    desired.mult(-1);
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxForce);
    return steer;
  }

  // Separate behaviour
  public PVector separate(ArrayList<Boid> boids) {
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

  public void update() {
    vel.add(acc);
    vel.limit(maxSpeed);
    loc.add(vel);
    acc.mult(0);
    points.add(loc);
    trail.update(loc, vel);
  }

  public void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acc.add(force);
  }

  public void draw() {
    trail.draw();
  }


  public void edges() {
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
class Flock {
  ArrayList<Boid> boids;

  Flock() {
    boids = new ArrayList<Boid>();
  }

  public void run() {
    for (Boid b : boids) {
      b.run(boids);
    }
  }
  
  public void addBoid(Boid b) {
    boids.add(b);
  }
}
class Trail {
	PVector loc, vel;
	int clr = colors[(int)random(colors.length-1)];
	ArrayList<PVector> pts;
	int maxPts = (int)random(10,61);
	// color clr = color(map(maxPts, 10, 61, 170,60));
	float w = random(1, 4);
	Trail() {
		pts = new ArrayList<PVector>();
		loc = new PVector();
		vel = new PVector();
	}
	public void update(PVector _loc, PVector _vel) {
		loc.set(_loc);
		vel.set(_vel);
		// This is not the way to do this, I need to do something like
		// have a linked list of points that make up a skeleton or some IK
		// like thing. This is something I really need to crack.
		if(pts.size() <= maxPts) {
			pts.add(loc.copy());
		} else {
			pts.remove(0);
			pts.add(loc.copy());
		}

	}
	public void draw() {
		noStroke();
		fill(clr);
		// noFill();
		// stroke(clr);
	  beginShape(TRIANGLE_STRIP);
		  for (int i=1; i<pts.size(); i++) {
		    PVector start =  pts.get(i-1);
		    PVector end = pts.get(i);
		    PVector normal = PVector.sub(start, end);
		    normal.normalize();
		    normal.rotate(HALF_PI);
		    
		    float tx = sin(normal.heading()) * w;
		    float ty = cos(normal.heading()) * w;
		    
		    float bx = sin(normal.heading()+PI) * w;
		    float by = cos(normal.heading()+PI) * w;
		    vertex(tx + start.x, ty + start.y, start.z);
		    vertex(bx + start.x, by + start.y, start.z);
		  }
		  endShape();
		}

		// for (int i = pts.size()-1; i >= 1; --i) {
		// 	PVector start = pts.get(i-1);
		// 	PVector end = pts.get(i);
		// 	line(start.x, start.y, start.z, end.x, end.y, end.z);
		// }
}
// Effects



PostFX fx;

// Recording

VideoExport videoExport;
Boolean recording = false;

/// Boilerplate

public void doVidAndFX() {
  fx.render()
    .noise(0.1f, 10) 
    .bloom(.5f, 18, 10.0f)
    .rgbSplit(20)
    .compose();


  if (recording) {
    videoExport.saveFrame();
  }
}

public void initVidAndFX() {
  // Init video export
  videoExport = new VideoExport(this, "out.mp4");
  videoExport.setFrameRate(30);
  videoExport.startMovie();
  frameRate(30);

  // Init effetcs
  fx = new PostFX(this);
}


public void keyPressed() {
  if (key == ' ') {
    recording = !recording;
  }
  if(key == 'h') {
    if(showControls) {
      cp5.show();
    } else {
      cp5.hide();      
    }
    showControls = !showControls;
  }
}
  public void settings() {  size(600,600,P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_006_more_trails" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
