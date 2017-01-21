int xspacing = 1;   // How far apart should each horizontal location be spaced
int w;              // Width of entire wave
int constant = 0;
int[] timesPressed = new int[5];
boolean[] keyHeld = new boolean[5];

float theta = 0.0;  // Start angle at 0
float amplitude = 75.0;  // Height of wave
float period = 500.0;  // How many pixels before the wave repeats
float dx;  // Value for incrementing X, a function of period and xspacing
float[] yvalues;  // Using an array to store height values for the wave
int yValHead = 0;


void setup() {
  size(640, 360);
  w = width+16;
  dx = (TWO_PI / period) * xspacing;
  yvalues = new float[w/xspacing];
}

void draw() {
  background(0);
  calcWave();
  renderWave();
  if(keyPressed == true) {
    
    println(key);
  }
}

void calcWave() {
  // Increment theta (try different values for 'angular velocity' here
  theta += 0.02;

  // For every x value, calculate a y value with sine function
  float x = millis();
  float scale = 100;
  println((x - timesPressed[0]));
  yvalues[yvalues.length - yValHead - 1] = amplitude *((keyHeld[0] ? sin(1/scale*(x - timesPressed[0])) : 0)+
   (keyHeld[1] ? sin(2/scale*(x - timesPressed[1])) : 0)+
    (keyHeld[2] ? sin(4/scale*(x - timesPressed[2])) : 0)+
     (keyHeld[3] ? sin(2/scale*(x - timesPressed[3])) : 0)+
      (keyHeld[4] ? sin(1/scale*(x - timesPressed[4])) : 0));
  yValHead += 1;
  yValHead = yValHead % yvalues.length;
}

void renderWave() {
  //noStroke();
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

void keyPressed(){
  if(key == 'q') {
     constant = 1;
     if (!keyHeld[0]) {
       timesPressed[0] = millis();
     }
     keyHeld[0] = true;
  } else if (key == 'w') {
    constant = 2;
    if (!keyHeld[1]) {
      timesPressed[1] = millis();
    }
    
    keyHeld[1] = true;
  } else if (key == 'e') {
    constant = 4;
    if (!keyHeld[2]) {
       timesPressed[2] = millis();
     }
    keyHeld[2] = true;
  } else if (key == 'r') {
    constant = 8;
    if (!keyHeld[3]) {
       timesPressed[3] = millis();
     }
    keyHeld[3] = true;
  } else if (key == 't') {
    constant = 16;
    if (!keyHeld[4]) {
       timesPressed[4] = millis();
     }
    keyHeld[4] = true;
  } else {
    constant = 0;
  }
}

void keyReleased(){
  if(key == 'q') {
    constant = 0;
    keyHeld[0] = false;   
  } else if (key == 'w') {
    constant = 0;
    keyHeld[1] = false;
  } else if (key == 'e') {
    constant = 0;
    keyHeld[2] = false;
  } else if (key == 'r') {
    constant = 0;
    keyHeld[3] = false;
  } else if (key == 't') {
    constant = 0;
    keyHeld[4] = false;
  } else {
    constant = 0;
  }
}