//alright lets process some things

import processing.sound.*;

SqrOsc squareQ;
SqrOsc squareW;
SqrOsc squareE;
SqrOsc squareR;
SqrOsc squareT;
SqrOsc squareY;

SinOsc sinQ;
SinOsc sinW;
SinOsc sinE;
SinOsc sinR;
SinOsc sinT;
SinOsc sinY;

int numPlaying = 0;
boolean[] currPlaying = {false, false, false, false, false, false};
boolean[] currIntercepting = {false, false, false, false, false, false};

int xspacing = 2;   // How far apart should each horizontal location be spaced
int w;              // Width of entire wave
int constant = 0;
int[] timesPressed = new int[6];
int[] oppTimesPressed = new int[6];

float theta = 0.0;  // Start angle at 0
float amplitude = 75.0;  // Height of wave
float scale = 1000;
float period = 500.0;  // How many pixels before the wave repeats
float dx;  // Value for incrementing X, a function of period and xspacing
float[] yvalues;  // Using an array to store height values for the wave
int yValHead = 0;

int health = 1000;

void setup() {
  size(800, 360);
  background(255);
  
  // Create square wave oscillator.
  squareQ = new SqrOsc(this);
  squareW = new SqrOsc(this);
  squareE = new SqrOsc(this);
  squareR = new SqrOsc(this);
  squareT = new SqrOsc(this);
  squareY = new SqrOsc(this);
  
  sinQ = new SinOsc(this);
  sinW = new SinOsc(this);
  sinE = new SinOsc(this);
  sinR = new SinOsc(this);
  sinT = new SinOsc(this);
  sinY = new SinOsc(this);
  
  w = 640+16;
  dx = (TWO_PI / period) * xspacing;
  yvalues = new float[w/xspacing];
}

void draw() {
  background(0);
  calcWave();
  renderWave();
  
  float x = millis();
  float oppY = amplitude *((currIntercepting[0] ? sin(1/scale*(x - oppTimesPressed[0])) : 0)+
   (currIntercepting[1] ? sin(2/scale*(x - oppTimesPressed[1])) : 0)+
    (currIntercepting[2] ? sin(4/scale*(x - oppTimesPressed[2])) : 0)+
     (currIntercepting[3] ? sin(8/scale*(x - oppTimesPressed[3])) : 0)+
      (currIntercepting[4] ? sin(16/scale*(x - oppTimesPressed[4])) : 0)+
       (currIntercepting[5] ? sin(32/scale*(x - oppTimesPressed[5])) : 0));
  
  int i = yvalues.length - yValHead - 2;
  if (i < 0) i += yvalues.length;
  health -= abs(oppY - yvalues[i]) / 20;
  
  stroke(255, 0, 0);
  
  line(656, height/2+oppY, 656, height/2+yvalues[i]);
  
  stroke(255);
  
  ellipse(656, height/2+oppY, 16, 16);
  
  fill(255,0,0);
  rect(0,0,health / 1000.0 * width,20);
}


void calcWave() {
  // Increment theta (try different values for 'angular velocity' here
  theta += 0.02;

  // For every x value, calculate a y value with sine function
  float x = millis();
  yvalues[yvalues.length - yValHead - 1] = amplitude *((currPlaying[0] ? sin(1/scale*(x - timesPressed[0])) : 0)+
   (currPlaying[1] ? sin(2/scale*(x - timesPressed[1])) : 0)+
    (currPlaying[2] ? sin(4/scale*(x - timesPressed[2])) : 0)+
     (currPlaying[3] ? sin(8/scale*(x - timesPressed[3])) : 0)+
      (currPlaying[4] ? sin(16/scale*(x - timesPressed[4])) : 0)+
       (currPlaying[5] ? sin(32/scale*(x - timesPressed[5])) : 0));
  yValHead += 1;
  yValHead = yValHead % yvalues.length;
}

void renderWave() {
  //noStroke();
  noFill();
  stroke(255);
  // A simple way to draw the wave with an ellipse at each location
  float prev = -13134;
  for (int x = 0; x < yvalues.length; x++) {
    int adj_index = (x - yValHead)%yvalues.length;
    if(adj_index < 0) {
      adj_index += yvalues.length;
    }
    if (prev != -13134)
      line((x - 1)*xspacing, prev, x*xspacing, height/2+yvalues[adj_index]);
    prev = height/2+yvalues[adj_index];
  }
}

void keyPressed() {
  if(key == 'q' || key == 'Q') {
    if(!currPlaying[0]){
      currPlaying[0] = true;
      numPlaying += 1;
      squareQ.play(262, .4);
     
      timesPressed[0] = millis();
    }
  } else if(key == 'w' || key == 'W') {
    if(!currPlaying[1]){
      currPlaying[1] = true;
      numPlaying += 1;
      squareW.play(294, .4);
      
      timesPressed[1] = millis();
    }
  } else if(key == 'e' || key == 'E') {
    if(!currPlaying[2]){
      currPlaying[2] = true;
      numPlaying += 1;
      squareE.play(330, .4);
      
      timesPressed[2] = millis();
    }
  } else if(key == 'r' || key == 'R') {
    if(!currPlaying[3]){
      currPlaying[3] = true;
      numPlaying += 1;
      squareR.play(392, .4);
      
      timesPressed[3] = millis();
    }
  } else if(key == 't' || key == 'T') {
    if(!currPlaying[4]){
      currPlaying[4] = true;
      numPlaying += 1;
      squareT.play(440, .4);
      
      timesPressed[4] = millis();
    }
  } else if(key == 'y' || key == 'Y') {
    if(!currPlaying[5]){
      currPlaying[5] = true;
      numPlaying += 1;
      squareY.play(523, .4);
      
      timesPressed[5] = millis();
    }
  }
  
  if(key == 'g' || key == 'G') {
    if(!currIntercepting[0]){
      currIntercepting[0] = true;
      numPlaying += 1;
      sinQ.play(262, .4);
      
      oppTimesPressed[0] = millis();
    }
  } else if(key == 'h' || key == 'H') {
    if(!currIntercepting[1]){
      currIntercepting[1] = true;
      numPlaying += 1;
      sinW.play(294, .4);
      
      oppTimesPressed[1] = millis();
    }
  } else if(key == 'j' || key == 'J') {
    if(!currIntercepting[2]){
      currIntercepting[2] = true;
      numPlaying += 1;
      sinE.play(330, .4);
      
      oppTimesPressed[2] = millis();
    }
  } else if(key == 'k' || key == 'K') {
    if(!currIntercepting[3]){
      currIntercepting[3] = true;
      numPlaying += 1;
      sinR.play(392, .4);
      
      oppTimesPressed[3] = millis();
    }
  } else if(key == 'l' || key == 'L') {
    if(!currIntercepting[4]){
      currIntercepting[4] = true;
      numPlaying += 1;
      sinT.play(440, .4);
      
      oppTimesPressed[4] = millis();
    }
  } else if(key == ';' || key == ':') {
    if(!currIntercepting[5]){
      currIntercepting[5] = true;
      numPlaying += 1;
      sinY.play(523, .4);
      
      oppTimesPressed[5] = millis();
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
  
  if(key == 'g' || key == 'G') {
    currIntercepting[0] = false;
    numPlaying -= 1;
    sinQ.stop();
  } else if(key == 'h' || key == 'H') {
    currIntercepting[1] = false;
    numPlaying -= 1;
    sinW.stop();
  } else if(key == 'j' || key == 'J') {
    currIntercepting[2] = false;
    numPlaying -= 1;
    sinE.stop();
  } else if(key == 'k' || key == 'K') {
    currIntercepting[3] = false;
    numPlaying -= 1;
    sinR.stop();
  } else if(key == 'l' || key == 'L') {
    currIntercepting[4] = false;
    numPlaying -= 1;
    sinT.stop();
  } else if(key == ';' || key == ':') {
    numPlaying -= 1;
    sinY.stop();
    currIntercepting[5] = false;
  }
}