//alright lets process some things

import processing.sound.*;
import java.util.Map;

SqrOsc[] squares;

SinOsc[] sines;

HashMap<String, Float> map;
HashMap<String, Integer> p1ButtonToNumMap;
HashMap<String, Integer> p2ButtonToNumMap;
HashMap<Integer, String> numToNoteMap;
HashMap<String, Integer> noteToNumMap;

ArrayList<Integer> p1EventTimes;
ArrayList<String> p1EventNotes;

ArrayList<Integer> p2EventTimes;
ArrayList<String> p2EventNotes;

boolean[] p1CurrPlaying = {false, false, false, false, false, false};
boolean[] p2CurrPlaying = {false, false, false, false, false, false};

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
  
  p1ButtonToNumMap = new HashMap<String,Integer>();
  
  p1ButtonToNumMap.put("q", 0);  //q
  p1ButtonToNumMap.put("w", 1); //w
  p1ButtonToNumMap.put("e", 2); //e
  p1ButtonToNumMap.put("r", 3);  //r
  p1ButtonToNumMap.put("t", 4);  //t
  p1ButtonToNumMap.put("y", 5); //y
  p1ButtonToNumMap.put("Q", 0);  //q
  p1ButtonToNumMap.put("W", 1); //w
  p1ButtonToNumMap.put("E", 2); //e
  p1ButtonToNumMap.put("R", 3);  //r
  p1ButtonToNumMap.put("T", 4);  //t
  p1ButtonToNumMap.put("Y", 5); //y
  
  p2ButtonToNumMap = new HashMap<String,Integer>();
  
  p2ButtonToNumMap.put("g", 0);  //q
  p2ButtonToNumMap.put("h", 1); //w
  p2ButtonToNumMap.put("j", 2); //e
  p2ButtonToNumMap.put("k", 3);  //r
  p2ButtonToNumMap.put("l", 4);  //t
  p2ButtonToNumMap.put(";", 5); //y
  p2ButtonToNumMap.put("G", 0);  //q
  p2ButtonToNumMap.put("H", 1); //w
  p2ButtonToNumMap.put("J", 2); //e
  p2ButtonToNumMap.put("K", 3);  //r
  p2ButtonToNumMap.put("L", 4);  //t
  p2ButtonToNumMap.put(":", 5); //y
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
    boolean[] notesPlaying = new boolean[squares.length * 2];
    int[] timesPlaying = new int[squares.length * 2];
    float t = time - (x * 4.0 / 3 / w * travelTime);
    
    for (int i = 0; i < p1EventTimes.size(); i++) {
      if (p1EventTimes.get(i) > t)
        break;
      if (noteToNumMap.containsKey(p1EventNotes.get(i))) {
        int indx = noteToNumMap.get(p1EventNotes.get(i));
        notesPlaying[indx] = !notesPlaying[indx];
        timesPlaying[indx] = p1EventTimes.get(i);
      }
    }
    
    if (x >= w * .75) {
      for (int i = 0; i < p2EventTimes.size(); i++) {
        if (p2EventTimes.get(i) > t + travelTime)
          break;
        if (noteToNumMap.containsKey(p2EventNotes.get(i))) {
          int indx = noteToNumMap.get(p2EventNotes.get(i));
          notesPlaying[indx + squares.length] = !notesPlaying[indx + squares.length];
          timesPlaying[indx + squares.length] = p2EventTimes.get(i);
        }
      }
    }
    
    float yvalue = amplitude *
     ((notesPlaying[0] ? sin(1/period*(t - timesPlaying[0])) : 0)+
       (notesPlaying[1] ? sin(2/period*(t - timesPlaying[1])) : 0)+
        (notesPlaying[2] ? sin(4/period*(t - timesPlaying[2])) : 0)+
         (notesPlaying[3] ? sin(8/period*(t - timesPlaying[3])) : 0)+
          (notesPlaying[4] ? sin(16/period*(t - timesPlaying[4])) : 0)+
           (notesPlaying[5] ? sin(32/period*(t - timesPlaying[5])) : 0)-
        ((notesPlaying[6] ? sin(1/period*(t - timesPlaying[6])) : 0)+
         (notesPlaying[7] ? sin(2/period*(t - timesPlaying[7])) : 0)+
          (notesPlaying[8] ? sin(4/period*(t - timesPlaying[8])) : 0)+
           (notesPlaying[9] ? sin(8/period*(t - timesPlaying[9])) : 0)+
            (notesPlaying[10] ? sin(16/period*(t - timesPlaying[10])) : 0)+
             (notesPlaying[11] ? sin(32/period*(t - timesPlaying[11])) : 0)));
    if (prev != -1313131) {
      line(x - xspacing, prev, x, height / 2 + yvalue);
    }
    prev = height / 2 + yvalue;
  }
}

void keyPressed() {
  if (p1ButtonToNumMap.containsKey("" + key)) {
    int num = p1ButtonToNumMap.get("" + key);
    
    if (!p1CurrPlaying[num]) {
      p1CurrPlaying[num] = true;
      
      String note = numToNoteMap.get(num);
      squares[num].play(map.get(note), .4);
      
      p1EventTimes.add(millis());
      p1EventNotes.add(note);
    }
  }
  
  if (p2ButtonToNumMap.containsKey("" + key)) {
    int num = p2ButtonToNumMap.get("" + key);
    
    if (!p2CurrPlaying[num]) {
      p2CurrPlaying[num] = true;
      
      String note = numToNoteMap.get(num);
      sines[num].play(map.get(note), .4);
      
      p2EventTimes.add(millis());
      p2EventNotes.add(note);
    }
  }
}

void keyReleased() {
  if (p1ButtonToNumMap.containsKey("" + key)) {
    int num = p1ButtonToNumMap.get("" + key);
    
    p1CurrPlaying[num] = false;
    
    String note = numToNoteMap.get(num);
    squares[num].stop();
    
    p1EventTimes.add(millis());
    p1EventNotes.add(note);
  }
  
  if (p2ButtonToNumMap.containsKey("" + key)) {
    int num = p2ButtonToNumMap.get("" + key);
    
    p2CurrPlaying[num] = false;
    
    String note = numToNoteMap.get(num);
    sines[num].stop();
    
    p2EventTimes.add(millis());
    p2EventNotes.add(note);
  }
}