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

boolean[] p1CurrPlaying = {false, false, false, false, false, false};
boolean[] p2CurrPlaying = {false, false, false, false, false, false};

int health = 1000;

Wave wave;
FilePlayer filePlayer;

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
  
  wave = new Wave(75.0, 300, 2, 656, 2000);
  
  map = new HashMap<String,Float>();
  
  filePlayer = new FilePlayer();
  filePlayer.setSong("song2_reformatted.txt",squares,sines);
  
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
  
  wave.drawWave();
  
  wave.drawOpponent();
  
  drawUI();
  filePlayer.playSong(wave);
}

void drawUI() {
  
  fill(255,0,0);
  rect(0, 0, health / 1000.0 * width,20);
  
  colorMode(HSB);
  for (int j = 0; j < 6; j++) {
    fill(42 * j, 255, 255);
    noStroke();
    
    ellipse(width / 6.0 * j + width / 12.0, height - 30, 60, 60);
  }
}

void keyPressed() {
  if (p1ButtonToNumMap.containsKey("" + key)) {
    int num = p1ButtonToNumMap.get("" + key);
    
    if (!p1CurrPlaying[num]) {
      p1CurrPlaying[num] = true;
      
      String note = numToNoteMap.get(num);
      squares[num].play(map.get(note), .4);
      
      wave.p1PlayNote(note);
    }
  }
  
  if (p2ButtonToNumMap.containsKey("" + key)) {
    int num = p2ButtonToNumMap.get("" + key);
    
    if (!p2CurrPlaying[num]) {
      p2CurrPlaying[num] = true;
      
      String note = numToNoteMap.get(num);
      sines[num].play(map.get(note), .4);
      
      wave.p2PlayNote(note);
    }
  }
}

void keyReleased() {
  if (p1ButtonToNumMap.containsKey("" + key)) {
    int num = p1ButtonToNumMap.get("" + key);
    
    p1CurrPlaying[num] = false;
    
    String note = numToNoteMap.get(num);
    squares[num].stop();
      
    wave.p1PlayNote(note);
  }
  
  if (p2ButtonToNumMap.containsKey("" + key)) {
    int num = p2ButtonToNumMap.get("" + key);
    
    p2CurrPlaying[num] = false;
    
    String note = numToNoteMap.get(num);
    sines[num].stop();
      
    wave.p2PlayNote(note);
  }
}