// Effects
import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;
PostFX fx;

// Recording
import com.hamoid.*;
VideoExport videoExport;
Boolean recording = false;

/// Boilerplate

void doVidAndFX() {
  fx.render()
    .noise(0.1, 10) 
    .bloom(.5, 18, 10.0)
    .rgbSplit(20)
    .compose();


  if (recording) {
    videoExport.saveFrame();
  }
}

void initVidAndFX() {
  // Init video export
  videoExport = new VideoExport(this, "out.mp4");
  videoExport.setFrameRate(30);
  videoExport.startMovie();
  frameRate(30);

  // Init effetcs
  fx = new PostFX(this);
}


void keyPressed() {
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
