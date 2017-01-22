import processing.sound.*;

class Boss {
  float health = 500;
  
  int[] eventTimes;
  String[] eventNotes;
  int eventIndex;
  String[] lines;
  String songfile;
  SqrOsc[] squares;
  SinOsc[] sines;
  boolean[] currPlaying;
  int resetTime;
  
  void drawBoss() {
    colorMode(RGB);
    stroke(255);
    fill(0,0,255);
    rect(0, 20, health / 500.0 * width,20);
  }
  
  void damage(float d) {
    health -= d;
  }
  
  void setSong(String filename,SqrOsc[] setSquares, SinOsc[] setSines) {
    int loadMPB = 300;
    
    squares = setSquares;
    sines = setSines;
    
    lines = loadStrings(filename);
    
    eventTimes = new int[lines.length];
    eventNotes = new String[lines.length];
    
    for(int i=0; i < lines.length; i++){
      String[] line = splitTokens(lines[i]);
      
      eventTimes[i] = int(line[1]) * millisPerBeat / loadMPB;
      eventNotes[i] = line[0];
      
    }
    currPlaying = new boolean[6];
    for(int j = 0; j < currPlaying.length; j++) {
      currPlaying[j] = false;
    }
  }
  
  
  void reset() {
    resetTime = millis();
    eventIndex = 0;
  }
  
  void playSong(Wave wave1, Wave wave2){
    while(eventIndex < eventTimes.length && millis() - resetTime >= eventTimes[eventIndex]){
      String noteName = eventNotes[eventIndex];
      float noteFreq = map.get(noteName);
      
      if(noteName.equals("e")){
        if(currPlaying[0]){
          squares[0].stop();
          //numPlaying--;
          currPlaying[0] = false;
          wave1.p1PlayNote("e");
          wave2.p1PlayNote("e");
        } else {
          currPlaying[0] = true;
          //numPlaying += 1;
          squares[0].play(noteFreq, .4);
          //timesPressed[0] = millis();
          wave1.p1PlayNote("e");
          wave2.p1PlayNote("e");
          //wave.p2PlayNote("e");
        }
      }else if(noteName.equals("fs")){
        if(currPlaying[1]){
          println("stopped fs");
          squares[1].stop();
          //numPlaying--;
          currPlaying[1] = false;
          wave1.p1PlayNote("fs");
          wave2.p1PlayNote("fs");
        } else {
          println("started fs");
          currPlaying[1] = true;
          //numPlaying += 1;
          squares[1].play(noteFreq, .4);
          //timesPressed[1] = millis();
          wave1.p1PlayNote("fs");
          wave2.p1PlayNote("fs");
          //wave.p2PlayNote("fs");
        }
      }else if(noteName.equals("gs")){
        if(currPlaying[2]){
          squares[2].stop();
          //numPlaying--;
          currPlaying[2] = false;
          wave1.p1PlayNote("gs");
          wave2.p1PlayNote("gs");
        } else {
          currPlaying[2] = true;
          //numPlaying += 1;
          squares[2].play(noteFreq, .4);
          //timesPressed[2] = millis();
          wave1.p1PlayNote("gs");
          wave2.p1PlayNote("gs");
          //wave.p2PlayNote("gs");
        }
      }else if(noteName.equals("a")){
        if(currPlaying[3]){
          println("stopped a");
          squares[3].stop();
          //numPlaying--;
          currPlaying[3] = false;
          wave1.p1PlayNote("a");
          wave2.p1PlayNote("a");
        } else {
          println("started a");
          currPlaying[3] = true;
          //numPlaying += 1;
          squares[3].play(noteFreq, .4);
          //timesPressed[3] = millis();
          wave1.p1PlayNote("a");
          wave2.p1PlayNote("a");
          //wave.p2PlayNote("a");
        }
      }else if(noteName.equals("b")){
        if(currPlaying[4]){
          squares[4].stop();
          //numPlaying--;
          currPlaying[4] = false;
          wave1.p1PlayNote("b");
          wave2.p1PlayNote("b");
        } else {
          currPlaying[4] = true;
          //numPlaying += 1;
          squares[4].play(noteFreq, .4);
          //timesPressed[4] = millis();
          wave1.p1PlayNote("b");
          wave2.p1PlayNote("b");
          //wave.p2PlayNote("b");
        }
      }else if(noteName.equals("cs")){
        if(currPlaying[5]){
          squares[5].stop();
          //numPlaying--;
          currPlaying[5] = false;
          wave1.p1PlayNote("cs");
          wave2.p1PlayNote("cs");
        } else {
          currPlaying[5] = true;
          //numPlaying += 1;
          squares[5].play(noteFreq, .4);
          //timesPressed[5] = millis();
          wave1.p1PlayNote("cs");
          wave2.p1PlayNote("cs");
          //wave.p2PlayNote("cs");
        }
      }
      
      eventIndex++;
    }
  }
}