//alright lets process some things

import processing.sound.*;
import java.util.Map;

SqrOsc[] squares;

SinOsc[] sines;

HashMap<String, Float> map;
HashMap<String, Integer> buttonToNumMap;
HashMap<Integer, String> numToNoteMap;
HashMap<String, Integer> noteToNumMap;

ArrayList<Integer> p1EventTimes;
ArrayList<String> p1EventNotes;

ArrayList<Integer> p2EventTimes;
ArrayList<String> p2EventNotes;

boolean[] currPlaying = {false, false, false, false, false, false};

float amplitude = 75.0;
float period = 300;
int health = 1000;
float dx;  // Value for incrementing X, a function of period and xspacing
int xspacing = 2;   // How far apart should each horizontal location be spaced
int w;              // Width of entire wave
int travelTime = 2000;  //millis

void setup() {
  size(800, 360);
  background(255);
  
  squares = new SqrOsc[6];
  for (int i = 0; i < squares.length; i++) {
    squares[i] = new SqrOsc(this);
  }
  
  sines = new SinOsc[6];
  for (int i = 0; i <  sines.length; i++) {
    sines[i] = new SinOsc(this);
  }
  
  w = 640+16;
  dx = (TWO_PI / period) * xspacing;
  
  p1EventTimes = new ArrayList<Integer>();
  p2EventTimes = new ArrayList<Integer>();
  
  p1EventNotes = new ArrayList<String>();
  p2EventNotes = new ArrayList<String>();
  
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
  
  buttonToNumMap = new HashMap<String,Integer>();
  
  buttonToNumMap.put("q", 0);  //q
  buttonToNumMap.put("w", 1); //w
  buttonToNumMap.put("e", 2); //e
  buttonToNumMap.put("r", 3);  //r
  buttonToNumMap.put("t", 4);  //t
  buttonToNumMap.put("y", 5); //y
  buttonToNumMap.put("Q", 0);  //q
  buttonToNumMap.put("W", 1); //w
  buttonToNumMap.put("E", 2); //e
  buttonToNumMap.put("R", 3);  //r
  buttonToNumMap.put("T", 4);  //t
  buttonToNumMap.put("Y", 5); //y
  
  noteToNumMap = new HashMap<String,Integer>();
  
  noteToNumMap.put("e", 0);  //q
  noteToNumMap.put("fs", 1); //w
  noteToNumMap.put("gs", 2); //e
  noteToNumMap.put("a", 3);  //r
  noteToNumMap.put("b", 4);  //t
  noteToNumMap.put("cs", 5); //y
  
  numToNoteMap = new HashMap<Integer, String>();
  
  numToNoteMap.put(0, "e");  //q
  numToNoteMap.put(1, "fs"); //w
  numToNoteMap.put(2, "gs"); //e
  numToNoteMap.put(3, "a");  //r
  numToNoteMap.put(4, "b");  //t
  numToNoteMap.put(5, "cs"); //y
}

void draw() {
  background(0);
  
  drawWave();
}

void drawWave() {
  noFill();
  stroke(255);
  
  int time = millis();
  
  float prev = -131313;
  for (int x = 0; x < w; x += xspacing) {
    boolean[] notesPlaying = new boolean[squares.length];
    int[] timesPlaying = new int[squares.length];
    float t = time - (x * 1.0 / w * travelTime);
    
    for (int i = 0; i < p1EventTimes.size(); i++) {
      if (p1EventTimes.get(i) > t)
        break;
      if (noteToNumMap.containsKey(p1EventNotes.get(i))) {
        int indx = noteToNumMap.get(p1EventNotes.get(i));
        notesPlaying[indx] = !notesPlaying[indx];
        timesPlaying[indx] = p1EventTimes.get(i);
      }
    }
    
    float yvalue = amplitude *
     ((notesPlaying[0] ? sin(1/period*(t - timesPlaying[0])) : 0)+
       (notesPlaying[1] ? sin(2/period*(t - timesPlaying[1])) : 0)+
        (notesPlaying[2] ? sin(4/period*(t - timesPlaying[2])) : 0)+
         (notesPlaying[3] ? sin(8/period*(t - timesPlaying[3])) : 0)+
          (notesPlaying[4] ? sin(16/period*(t - timesPlaying[4])) : 0)+
           (notesPlaying[5] ? sin(32/period*(t - timesPlaying[5])) : 0));
    if (prev != -1313131) {
      line(x - xspacing, prev, x, height / 2 + yvalue);
    }
    prev = height / 2 + yvalue;
  }
}

void keyPressed() {
  if (buttonToNumMap.containsKey("" + key)) {
    int num = buttonToNumMap.get("" + key);
    
    if (!currPlaying[num]) {
      currPlaying[num] = true;
      
      String note = numToNoteMap.get(num);
      squares[num].play(map.get(note), .4);
      
      p1EventTimes.add(millis());
      p1EventNotes.add(note);
    }
  }
}

void keyReleased() {
  if (buttonToNumMap.containsKey("" + key)) {
    int num = buttonToNumMap.get("" + key);
    
    currPlaying[num] = false;
    
    String note = numToNoteMap.get(num);
    squares[num].stop();
    
    p1EventTimes.add(millis());
    p1EventNotes.add(note);
  }
}