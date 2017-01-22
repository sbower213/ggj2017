//alright lets process some things

import processing.sound.*;
import java.util.Map;

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

HashMap<String,Float> map;
int[] eventTimes;
String[] eventNotes;
int eventIndex;

int numPlaying = 0;
boolean[] currPlaying = {false, false, false, false, false, false};
boolean[] currIntercepting = {false, false, false, false, false, false};

int xspacing = 2;   // How far apart should each horizontal location be spaced
int w;              // Width of entire wave
int constant = 0;
int[] timesPressed = new int[6];
int[] oppTimesPressed = new int[6];
ArrayList<Integer> playerEventTimes;
ArrayList<String> playerEventNotes;

int stepsPerFrame = 2;

float theta = 0.0;  // Start angle at 0
float amplitude = 75.0;  // Height of wave
float scale = 300;
float period = 500.0;  // How many pixels before the wave repeats
float dx;  // Value for incrementing X, a function of period and xspacing
float[] yvalues;  // Using an array to store height values for the wave
int[] notesAtTime;
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
  notesAtTime = new int[w/xspacing];
  
  map = new HashMap<String,Float>();
  
  map.put("d", 146.83);
  map.put("ds", 155.56);
  map.put("e", 164.81);  //q
  map.put("f", 174.61);
  map.put("fs", 185.00); //w
  map.put("g", 196.00);
  map.put("gs", 207.65); //e
  map.put("a", 220.00);  //r
  map.put("as", 233.08);
  map.put("b", 246.94);  //t
  map.put("c", 261.63);
  map.put("cs", 277.18); //y
  
  eventIndex = 0;
  playSong();
}

void draw() {
  background(0);
  calcWave();
  renderWave();
  
  //println("Mill: "+ millis());
  //println("Next Event: "+eventTimes[eventIndex]);
  while(eventIndex < eventTimes.length && millis() >= eventTimes[eventIndex]){
    String noteName = eventNotes[eventIndex];
    float noteFreq = map.get(noteName);
    
    if(noteName.equals("e")){
      if(currPlaying[0]){
        squareQ.stop();
        numPlaying--;
        currPlaying[0] = false;
      } else {
      currPlaying[0] = true;
      numPlaying += 1;
      squareQ.play(noteFreq, .4);
      timesPressed[0] = millis();
      }
    }else if(noteName.equals("fs")){
      if(currPlaying[1]){
        squareW.stop();
        numPlaying--;
        currPlaying[1] = false;
      } else {
      currPlaying[1] = true;
      numPlaying += 1;
      squareW.play(noteFreq, .4);
      timesPressed[1] = millis();
      }
    }else if(noteName.equals("gs")){
      if(currPlaying[2]){
        squareE.stop();
        numPlaying--;
        currPlaying[2] = false;
      } else {
      currPlaying[2] = true;
      numPlaying += 1;
      squareE.play(noteFreq, .4);
      timesPressed[2] = millis();
      }
    }else if(noteName.equals("a")){
      if(currPlaying[3]){
        squareR.stop();
        numPlaying--;
        currPlaying[3] = false;
      } else {
      currPlaying[3] = true;
      numPlaying += 1;
      squareR.play(noteFreq, .4);
      timesPressed[3] = millis();
      }
    }else if(noteName.equals("b")){
      if(currPlaying[4]){
        squareT.stop();
        numPlaying--;
        currPlaying[4] = false;
      } else {
      currPlaying[4] = true;
      numPlaying += 1;
      squareT.play(noteFreq, .4);
      timesPressed[4] = millis();
      }
    }else if(noteName.equals("cs")){
      if(currPlaying[5]){
        squareY.stop();
        numPlaying--;
        currPlaying[5] = false;
      } else {
      currPlaying[5] = true;
      numPlaying += 1;
      squareY.play(noteFreq, .4);
      timesPressed[5] = millis();
      }
    }
    
    eventIndex++;
  }
  
  
  
  float x = millis();
  float[] oppY = new float[stepsPerFrame];
     
  int currNotes = ((currIntercepting[0] ? 1 : 0)+
   (currIntercepting[1] ? 2 : 0)+
    (currIntercepting[2] ? 4 : 0)+
     (currIntercepting[3] ? 8 : 0)+
      (currIntercepting[4] ? 16 : 0)+
       (currIntercepting[5] ? 32 : 0));
  for(int j = 0; j < stepsPerFrame; j++) {
    oppY[j] = amplitude *((currIntercepting[0] ? sin(1/scale*(x - oppTimesPressed[0])) : 0)+
     (currIntercepting[1] ? sin(2/scale*(x - oppTimesPressed[1])) : 0)+
      (currIntercepting[2] ? sin(4/scale*(x - oppTimesPressed[2])) : 0)+
       (currIntercepting[3] ? sin(8/scale*(x - oppTimesPressed[3])) : 0)+
        (currIntercepting[4] ? sin(16/scale*(x - oppTimesPressed[4])) : 0)+
         (currIntercepting[5] ? sin(32/scale*(x - oppTimesPressed[5])) : 0));
     x -= 1.0 / frameRate;
  }
  
  int i = yvalues.length - yValHead - 1 - (int)(yvalues.length * .25);
  if (i < 0) i += yvalues.length;
  
  println("currNotes: " + currNotes);
  if (currNotes != notesAtTime[i])
    health -= max(abs(oppY[0] - yvalues[i]) / 20 - 2, 0);
  
  colorMode(RGB);
  stroke(255, 0, 0);
  
  line(656 * .75, height/2+oppY[0], 656 * .75, height/2+yvalues[i]);
  
  stroke(255);
  
  ellipse(656 * .75, height/2+oppY[0], 16, 16);
  
  
  for(int j = 0; j < stepsPerFrame; j++) {
    int index = i + j;
    if (index >= yvalues.length)
      index -= yvalues.length;
    if (currNotes != notesAtTime[i])
      yvalues[index] -= oppY[j];
    else
      yvalues[index] = 0;
  }
  
  fill(255,0,0);
  rect(0,0,health / 1000.0 * width,20);
  
  colorMode(HSB);
  for (int j = 0; j < 6; j++) {
    fill(42 * j, 255, 255);
    noStroke();
    
    ellipse(width / 6.0 * j + width / 12.0, height - 30, 60, 60);
  }
}


void calcWave() {
  // Increment theta (try different values for 'angular velocity' here
  theta += 0.02;

  // For every x value, calculate a y value with sine function
  float x = millis();
  for (int i = 0; i < stepsPerFrame; i++) {
    int index = yvalues.length - yValHead - 1 + i;
    if (index >= yvalues.length)
      index -= yvalues.length;
    yvalues[index] = amplitude *((currPlaying[0] ? sin(1/scale*(x - timesPressed[0])) : 0)+
     (currPlaying[1] ? sin(2/scale*(x - timesPressed[1])) : 0)+
      (currPlaying[2] ? sin(4/scale*(x - timesPressed[2])) : 0)+
       (currPlaying[3] ? sin(8/scale*(x - timesPressed[3])) : 0)+
        (currPlaying[4] ? sin(16/scale*(x - timesPressed[4])) : 0)+
         (currPlaying[5] ? sin(32/scale*(x - timesPressed[5])) : 0));
    x -= 1.0 / frameRate * stepsPerFrame;
    
    notesAtTime[index] = ((currPlaying[0] ? 1 : 0)+
     (currPlaying[1] ? 2 : 0)+
      (currPlaying[2] ? 4 : 0)+
       (currPlaying[3] ? 8 : 0)+
        (currPlaying[4] ? 16 : 0)+
         (currPlaying[5] ? 32 : 0));
  }
  yValHead += stepsPerFrame;
  yValHead = yValHead % yvalues.length;
}

void renderWave() {
  //noStroke();
  noFill();
  stroke(255);
  // A simple way to draw the wave with an ellipse at each location
  float prev = -13134;
  colorMode(HSB);
  for (int x = 0; x < yvalues.length; x++) {
    int adj_index = (x - yValHead)%yvalues.length;
    if(adj_index < 0) {
      adj_index += yvalues.length;
    }
    if (prev != -13134) {
      int notes = 0;
      for (int i = 0; i < 6; i++) {
        notes += (1 & (notesAtTime[adj_index] >> i));
      }
      
      int hue = 0;
      for (int i = 0; i < 6; i++) {
        hue += (1 & (notesAtTime[adj_index] >> i)) * 42 * i;
      }
      if (notes > 0) hue /= notes;
      
      int sat = notes == 0 ? 0 : 255;
                
      stroke(hue, sat, 255);
      
      line((x - 1)*xspacing, prev, x*xspacing, height/2+yvalues[adj_index]);
    }
    prev = height/2+yvalues[adj_index];
  }
}

void playSong(){
  String[] lines = loadStrings("song2_reformatted.txt");
  
  eventTimes = new int[lines.length];
  eventNotes = new String[lines.length];
  
  for(int i=0; i < lines.length; i++){
    String[] line = splitTokens(lines[i]);
    println(line[0]);
    
    eventTimes[i] = int(line[1]);
    eventNotes[i] = line[0];
    
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