class Trail {
	PVector loc, vel;
	color clr = colors[(int)random(colors.length-1)];
	ArrayList<PVector> pts;
	int maxPts = (int)random(10,61);
	// color clr = color(map(maxPts, 10, 61, 170,60));
	float w = random(1, 4);
	Trail() {
		pts = new ArrayList<PVector>();
		loc = new PVector();
		vel = new PVector();
	}
	void update(PVector _loc, PVector _vel) {
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
	void draw() {
		noStroke();
		fill(clr);
		// noFill();
		// stroke(clr);
	  beginShape(TRIANGLE_STRIP);
		  for (int i=1; i<pts.size(); i++) {
		  	
		  	float t = map(i, 0, pts.size(), 0, w*2);
		    
		    PVector start =  pts.get(i-1);
		    PVector end = pts.get(i);
		    PVector normal = PVector.sub(start, end);
		    normal.normalize();
		    normal.rotate(HALF_PI);
		    
		    float tx = sin(normal.heading()) * t;
		    float ty = cos(normal.heading()) * t;
		    
		    float bx = sin(normal.heading()+PI) * t;
		    float by = cos(normal.heading()+PI) * t;
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
