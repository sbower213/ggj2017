//alright lets process some things

import processing.sound.*;

SqrOsc squareQ;
SqrOsc squareW;
SqrOsc squareE;
SqrOsc squareR;
SqrOsc squareT;
SqrOsc squareY;

int numPlaying = 0;
boolean[] currPlaying = {false, false, false, false, false, false};

void setup() {
  size(640, 360);
  background(255);
  
  // Create square wave oscillator.
  squareQ = new SqrOsc(this);
  squareW = new SqrOsc(this);
  squareE = new SqrOsc(this);
  squareR = new SqrOsc(this);
  squareT = new SqrOsc(this);
  squareY = new SqrOsc(this);
}


void keyPressed() {
  println(key);
  println(numPlaying);
    /*if(key == 'q' || key == 'Q') {
      squareQ.play(131);
    } else if(key == 'w' || key == 'W') {
      squareW.play(392);
    } else if(key == 'e' || key == 'E') {
      squareE.play(587);
    } else if(key == 'r' || key == 'R') {
      squareR.play(880);
    } else if(key == 't' || key == 'T') {
      squareT.play(1319);
    }*/
    if(key == 'q' || key == 'Q') {
      if(!currPlaying[0]){
        currPlaying[0] = true;
        numPlaying += 1;
      squareQ.play(262, .4);
      }
    } else if(key == 'w' || key == 'W') {
      if(!currPlaying[1]){
        currPlaying[1] = true;
        numPlaying += 1;
      squareW.play(294, .4);
      }
    } else if(key == 'e' || key == 'E') {
      if(!currPlaying[2]){
        currPlaying[2] = true;
        numPlaying += 1;
      squareE.play(330, .4);
      }
    } else if(key == 'r' || key == 'R') {
      if(!currPlaying[3]){
        currPlaying[3] = true;
        numPlaying += 1;
      squareR.play(392, .4);
      }
    } else if(key == 't' || key == 'T') {
      if(!currPlaying[4]){
        currPlaying[4] = true;
        numPlaying += 1;
      squareT.play(440, .4);
      }
    } else if(key == 'y' || key == 'Y') {
      if(!currPlaying[5]){
        currPlaying[5] = true;
        numPlaying += 1;
      squareY.play(523, .4);
      }
    }
}

void keyReleased(){
    if(key == 'q' || key == 'Q') {
      currPlaying[0] = false;
      numPlaying -= 1;
      squareQ.stop();
    } else if(key == 'w' || key == 'W') {
      currPlaying[1] = false;
      numPlaying -= 1;
      squareW.stop();
    } else if(key == 'e' || key == 'E') {
      currPlaying[2] = false;
      numPlaying -= 1;
      squareE.stop();
    } else if(key == 'r' || key == 'R') {
      currPlaying[3] = false;
      numPlaying -= 1;
      squareR.stop();
    } else if(key == 't' || key == 'T') {
      currPlaying[4] = false;
      numPlaying -= 1;
      squareT.stop();
    } else if(key == 'y' || key == 'Y') {
      currPlaying[5] = false;
      numPlaying -= 1;
      squareY.stop();
    }
}

void draw(){
  /*if(!keyPressed){
    
    squareQ.stop();
    squareW.stop();
    squareE.stop();
    squareR.stop();
    squareT.stop();
    squareY.stop();
  }*/
}