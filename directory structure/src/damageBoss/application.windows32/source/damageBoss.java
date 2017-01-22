import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 
import java.util.Map; 
import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class damageBoss extends PApplet {

//alright lets process some things




SqrOsc[] squares;

SawOsc[] sines;

HashMap<String, Float> map;
HashMap<String, Integer> p1ButtonToNumMap;
HashMap<String, Integer> p2ButtonToNumMap;
HashMap<Integer, String> numToNoteMap;
HashMap<String, Integer> noteToNumMap;

boolean[] p1CurrPlaying;
boolean[] p2CurrPlaying;

int health;
int turnStart;
float damageCounter;
float damageToBoss;
float damageToPlayer;
float runningPlayerDamage;
int intervalNotesPlayed;
int millisPerBeat = 400;
int lastMillis;
float delta;

Wave playerWave;
Boss boss;
Wave bossWave1, bossWave2;
FilePlayer filePlayer1, filePlayer2, bassPlayer, backgroundPlayer, jinglePlayer;

int turn;
int barsPerTurn = 8;
boolean switchedPlayers;
boolean nextPhase;

int flashFrames;

SoundFile[] clicks;
int clickCtr;
int nextClick;

String[] riff1s = {"riff_1a.txt", "riff_2a.txt", "riff_3a.txt"};
String[] riff2s = {"riff_1b.txt", "riff_2b.txt", "riff_3b.txt"};
int curRiff;

boolean started, learning = false;
PImage logo;

boolean p1Active;
boolean p2Active;

boolean over = false;
boolean lost = false;
boolean[] tutPhases = {false,false,false};

float uiScale;
float widthScale;

boolean delay1Over;
boolean delay2Over;
boolean delay;
int delayStart;

public void setup() {
  
  //size(800, 360);
  background(255);

  uiScale = height / 360;
  widthScale = width / 800.0f;

  logo = loadImage("logo.png");

  squares = new SqrOsc[6];
  for (int i = 0; i < squares.length; i++) {
    squares[i] = new SqrOsc(this);
  }

  sines = new SawOsc[6];
  for (int i = 0; i <  sines.length; i++) {
    sines[i] = new SawOsc(this);
  }

  filePlayer1 = new FilePlayer();
  filePlayer2 = new FilePlayer();

  clicks = new SoundFile[]{new SoundFile(this, "mid.mp3"), new SoundFile(this, "hi.mp3"), 
    new SoundFile(this, "mid.mp3"), new SoundFile(this, "lo.mp3")};

  map = new HashMap<String, Float>();

  map.put("d", 146.83f);
  map.put("ds", 155.56f);
  map.put("e", 164.81f);  //q
  map.put("f", 174.61f);
  map.put("fs", 185.00f); //w
  map.put("g", 196.00f);
  map.put("gs", 207.65f); //e
  map.put("a", 220.00f);  //r
  map.put("as", 233.08f);
  map.put("b", 246.94f);  //t
  map.put("c", 261.63f);
  map.put("cs", 277.18f); //y

  noteToNumMap = new HashMap<String, Integer>();

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

  p1ButtonToNumMap = new HashMap<String, Integer>();

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

  p2ButtonToNumMap = new HashMap<String, Integer>();

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

  lastMillis = millis();
  delay = true;

  // Background player code
  SqrOsc[] bassSquares = new SqrOsc[6];
  for (int i = 0; i < squares.length; i++) {
    bassSquares[i] = new SqrOsc(this);
  }

  SawOsc[] bassSines = new SawOsc[6];
  for (int i = 0; i <  sines.length; i++) {
    bassSines[i] = new SawOsc(this);
  }
  bassPlayer = new FilePlayer(.1f, 4 * millisPerBeat * 8, -1);
  bassPlayer.setSong("song2_reformatted.txt", bassSquares, bassSines);


  SqrOsc[] backSquares = new SqrOsc[6];
  for (int i = 0; i < squares.length; i++) {
    backSquares[i] = new SqrOsc(this);
  }

  SawOsc[] backSines = new SawOsc[6];
  for (int i = 0; i <  sines.length; i++) {
    backSines[i] = new SawOsc(this);
  }
  backgroundPlayer = new FilePlayer(.1f, 4 * millisPerBeat * 8, 0);
  backgroundPlayer.setSong("song_reformatted.txt", backSquares, backSines);
  
  jinglePlayer = new FilePlayer(.1f, 0, 0);
}

public void startGame() {
  health = 1000;
  turnStart = 0;
  damageCounter = 0;
  intervalNotesPlayed = 0;

  p1Active = false;
  p2Active = false;

  curRiff = 0;
  clickCtr = 0;

  flashFrames = 0;
  turn = 0;
  switchedPlayers = false;
  nextPhase = false;

  turnStart = millis();
  clickCtr = millis();
  delayStart = millis();
  delay = true;
  delay1Over = false;
  delay2Over = false;

  playerWave = new Wave(75.0f, 300, 2, width, barsPerTurn * millisPerBeat);   //4/4 so * 4, but / 2
  bossWave1 = new Wave(75.0f, 300, 2, width / 2, barsPerTurn * millisPerBeat);   //4/4 so * 4, but / 2
  bossWave2 = new Wave(75.0f, 300, 2, width / 2, barsPerTurn * millisPerBeat);   //4/4 so * 4, but / 2
  boss = new Boss();

  p1CurrPlaying = new boolean[6];
  p2CurrPlaying = new boolean[6];

  backgroundPlayer.reset();
  bassPlayer.reset();
  
  boss.x = width / 2;
  boss.y = height / 3;
  boss.r = 100 * uiScale;
}

public void draw() {
  background(0);
  delta = (millis() - lastMillis) / 1000.0f;
  lastMillis = millis();


  if (!started) {
    if(learning) {
      drawTutorial();
    } else {
      textSize(16 * uiScale);
      textAlign(CENTER);
      fill(255, 255, 255, 0);
      stroke(255, 255, 255, 255);
      // Fix for centering later?
      image(logo, 0, (height - width / 800.0f * 360) / 2, width, width / 800.0f * 360);
  
      rect(300 * widthScale,130 * uiScale,200 * widthScale,90  * uiScale);
      rect(300 * widthScale, 230 * uiScale, 200 * widthScale, 90 * uiScale);
      fill(255,255,255,255);
  //    text("WAVE BATTLE", 400, 60);
      text("START GAME", 400 * widthScale, 180 * uiScale);
      text("HOW TO PLAY", 400 * widthScale, 280 * uiScale);
      
      if (over) {
        if (lost) {
          fill(255, 0, 0);
          text("YOU LOSE", 400 * widthScale, 60 * uiScale);
          jinglePlayer.playSong(null);
          
        } else {
          fill(0, 255, 255);
          text("YOU WIN", 400 * widthScale, 60 * uiScale);
          jinglePlayer.playSong(null);
        }
      }
    }
  } else {
    if (millis() > clickCtr) {
      clicks[nextClick].play();
      clickCtr += millisPerBeat;
      nextClick++;
      nextClick %= 4;
    }
    backgroundPlayer.playSong(null);
    bassPlayer.playSong(null);


    if (turn % 2 == 0) {
      drawUI();
      
      if (turn == 2) {
        scale(-1, 1);
        translate(-width, 0);
      }
      translate(0, height * 2 / 3);
      playerWave.drawWave();
      playerWave.drawOpponent();
      translate(0, -height * 2 / 3);
      
      if (turn == 2) {
        translate(width, 0);
        scale(-1, 1);
      }

      drawUI();

      boss.drawBoss();

      countBossDamage();
      
      if (!delay1Over || delay2Over) {
        int countdown = 8 - (millis() - delayStart)/millisPerBeat;

        fill(255, 255, 255, 255);
        text(countdown, width/2, height/4);
      }
      
      if (!delay1Over && millis() - turnStart > millisPerBeat * barsPerTurn) {
        if (turn == 0) {
          p1Active = true;
          p2Active = false;
        } else {
          p1Active = false;
          p2Active = true;
        }
        
        delay1Over = true;
        println("delay 1 over");
      }
      
      if (delay2Over) {
        stroke(0, 0, 255);
        for (int i = 0; i < damageToBoss / 10; i++) {
          float t = (millis() - i * 100 - turnStart - millisPerBeat * barsPerTurn * 3) / (millisPerBeat * barsPerTurn * .4f);
          t = sqrt(t);
          
          if (t > 0 && t < 1) {
            float x = (boss.x - width * 3.0f / 4) * t + width * 3.0f / 4;
            float y = (boss.y - height * 2.0f / 3) * t + height * 2.0f / 3;
            
            line(x, y, x + 20 * uiScale, y);
            line(x, y, x, y + 20 * uiScale);
          }
        }
      }

      if (!switchedPlayers && millis() - turnStart > millisPerBeat * barsPerTurn * 2) {
        for (int i = 0; i < squares.length; i++)
          squares[i].stop();
        for (int i = 0; i < sines.length; i++)
          sines[i].stop();
        playerWave.stopAll();

        switchedPlayers = true;
        flashFrames = 4;

        filePlayer1.setSong(riff1s[curRiff], squares, sines);
        filePlayer2.setSong(riff2s[curRiff], squares, sines);
        curRiff++;
        curRiff %= riff1s.length;
        if (turn == 0) {
          p1Active = false;
          p2Active = true;
        } else {
          p1Active = true;
          p2Active = false;
        }
        
      }

      if (flashFrames > 0) {
        fill(255, 255 * flashFrames / 4.0f);
        rect(0, 0, width, height);
        flashFrames--;
      }

      if (!delay2Over && millis() - turnStart > millisPerBeat * barsPerTurn * 3) {
        for (int i = 0; i < squares.length; i++)
          squares[i].stop();
        for (int i = 0; i < sines.length; i++)
          sines[i].stop();
        playerWave.stopAll();

        p1Active = false;
        p2Active = false;
        //delay = true;
        //delayStart = millis();
        delay2Over = true;
        delayStart = millis();
        println("delay 2 start");
        
        damageToBoss = damageCounter * (intervalNotesPlayed + 1) * .6f;
        
        damageBoss();
      }
      
      if (millis() - turnStart > millisPerBeat * barsPerTurn * 4) {
        turn ++;
        turn %= 4;
        turnStart = millis();
        switchedPlayers = false;
        filePlayer1.reset();
        filePlayer2.reset();
        //if (turn == 1) {
        bossWave1.travelTime = 2 * barsPerTurn * millisPerBeat;
        bossWave2.travelTime = 1 * barsPerTurn * millisPerBeat;
        /*} else {
         bossWave2.travelTime = 2 * barsPerTurn * millisPerBeat;
         bossWave1.travelTime = 4 * barsPerTurn * millisPerBeat;
         }*/
      }
    } else {
      stroke(255, 0, 0);
      for (int i = 0; i < runningPlayerDamage * 1 / 3; i++) {
        line(width - abs(sin(i) * width / 4) * min(i, 4), height - abs(cos(i) * height / 4) * min(i, 4),
          width - abs(sin(i + .14f) * width / 4) * min(i, 4), height - abs(cos(i + .17f) * height / 4) * min(i, 4));
          
        line(abs(sin(i) * width / 4) * min(i, 4), height - abs(cos(i) * height / 4) * min(i, 4),
          abs(sin(i + .14f) * width / 4) * min(i, 4), height - abs(cos(i + .17f) * height / 4) * min(i, 4));
      }
      
      drawUI();
      
      translate(width/2, height / 2);
      scale(-1, 1);
      bossWave1.drawWave();
      bossWave1.drawOpponent();
      scale(-1, 1);
      
      bossWave2.drawWave();
      bossWave2.drawOpponent();

      translate(-width/2, -height / 2);
      
      boss.drawBoss();

      filePlayer1.playSong(bossWave1);
      if (switchedPlayers)
        filePlayer2.playSong(bossWave2);

      damagePlayer();

      if (!switchedPlayers && millis() - turnStart > millisPerBeat * 8) {
        for (int i = 0; i < squares.length; i++)
          squares[i].stop();
        for (int i = 0; i < sines.length; i++)
          sines[i].stop();
        bossWave1.stopP2();
        bossWave2.stopP2();
        
        switchedPlayers = true;

        filePlayer2.reset();
      }

      if (!nextPhase && millis() - turnStart > millisPerBeat * 16) {
        for (int i = 0; i < squares.length; i++)
          squares[i].stop();
        for (int i = 0; i < sines.length; i++)
          sines[i].stop();
        bossWave1.stopP2();
        bossWave2.stopP2();
        
        nextPhase = true;
        flashFrames = 4;

        p1Active = true;
        p2Active = true;
      }

      if (flashFrames > 0) {
        fill(255, 255 * flashFrames / 4.0f);
        rect(0, 0, width, height);
        flashFrames--;
      }

      if (millis() - turnStart > millisPerBeat * barsPerTurn * 4) {
        for (int i = 0; i < squares.length; i++)
          squares[i].stop();
        for (int i = 0; i < sines.length; i++)
          sines[i].stop();
        bossWave1.reset();
        bossWave2.reset();
        turn ++;
        turn %= 4;
        println("turn: " + turn);
        turnStart = millis();
        switchedPlayers = false;
        nextPhase = false;
        delayStart = millis();
        delay1Over = false;
        delay2Over = false;
        p1Active = false;
        p2Active = false;
        runningPlayerDamage = 0;
      }
    }

    if (health < 0) {
      over = true;
      lost = true;
      started = false;
      backgroundPlayer.reset();
      bassPlayer.reset();
      jinglePlayer.setSong("loss.txt", backgroundPlayer.squares, backgroundPlayer.sines);
      jinglePlayer.reset();
    } else if (boss.health < 0) {
      over = true;
      lost = false;
      started = false;
      backgroundPlayer.reset();
      bassPlayer.reset();
      jinglePlayer.setSong("win.txt", backgroundPlayer.squares, backgroundPlayer.sines);
      jinglePlayer.reset();
    }
  }
}

public void drawUI() {
  fill(255, 0, 0);
  rect(0, 0, health / 1000.0f * width, uiScale * 20);

  int keyWidth = (int)(width * .4f);
  drawKey(p1Active, keyWidth);
  translate(width - keyWidth, 0);
  drawKey(p2Active, keyWidth);
  translate(-(width - keyWidth), 0);
}

public void drawKey(boolean active, int keyWidth) {
  float offset = cos((float)(millis() - clickCtr) / millisPerBeat * 2 * PI) * .01f;
  //translate(-width * offset / 2, -height * offset / 2);
  //scale(1.01 + offset);

  colorMode(HSB);
  for (int j = 0; j < 6; j++) {
    if (active) {
      fill(42 * j, 255, 255);
      noStroke();
    } else {
      stroke(42 * j, 255, 255);
      noFill();
    }

    ellipse(keyWidth / 6.0f * j + keyWidth / 12.0f, height - 30 * uiScale, uiScale * 60 * (1 + offset), uiScale * 60 * (1 + offset));
  }
}

public void damagePlayer() {
  float t = millis();
  float opp1Height = bossWave1.p2Height(t);
  float p1Height = bossWave1.p1Height(t - bossWave1.travelTime);
  
  damageToPlayer = 0;

  if (!bossWave1.matched(t - bossWave1.travelTime)) {
    damageToPlayer += max(abs(opp1Height - p1Height) / 20 - 2, 0) * 1.5f;
  }

  float opp2Height = bossWave2.p2Height(t);
  float p2Height = bossWave2.p1Height(t - bossWave2.travelTime);

  if (!bossWave2.matched(t - bossWave2.travelTime)) {
    damageToPlayer += max(abs(opp2Height - p2Height) / 20 - 2, 0) * 1.5f;
  }
  
  health -= damageToPlayer;
  
  runningPlayerDamage += damageToPlayer;
}

public void damageBoss() {
  boss.damage(damageToBoss);
  intervalNotesPlayed = 0;
  damageCounter = 0;
}

public void countBossDamage() {
  float t = millis();
  float oppHeight = playerWave.p2Height(t);

  if (playerWave.matched(t - playerWave.travelTime)) {
    damageCounter += abs(oppHeight) * delta;
  }
}

public void mousePressed() {

  if(!started && mouseX <= 500 * widthScale && mouseX >= 300 * widthScale
    && mouseY <= 210 * uiScale && mouseY >= 120 * uiScale) {
    // Enter start game conditions here.
    started = true;
    
    startGame();
  }
  if(!started && mouseX <= 500 * widthScale && mouseX >= 300 * widthScale
    && mouseY >= 230 * uiScale && mouseY <= 320 * uiScale) {
      learning = true;
      tutPhases[0] = true;
      //drawTutorial();
  } else if(learning && tutPhases[0] && mouseX <= 700 * widthScale && mouseX >= 600 * widthScale
    && mouseY >= 150 * uiScale && uiScale <= 200 * uiScale) {
      tutPhases[0] = false;
      tutPhases[1] = true;
  } else if(learning && tutPhases[1] && mouseX <= 700 * widthScale && mouseX >= 600 * widthScale
    && mouseY >= 150 * uiScale && uiScale <= 200 * uiScale) {
     tutPhases[1] = false;
     learning = false;
  }
}

public void keyPressed() {
  //println("pressed " + key);

  if (p1Active && p1ButtonToNumMap.containsKey("" + key)) {
    int num = p1ButtonToNumMap.get("" + key);

    if (!p1CurrPlaying[num]) {
      p1CurrPlaying[num] = true;

      String note = numToNoteMap.get(num);
      squares[num].play(map.get(note), .2f);

      intervalNotesPlayed += 1;

      if (turn == 0)
        playerWave.p1PlayNote(note);
      else if (turn == 2)
        playerWave.p2PlayNote(note);
      else
        bossWave1.p2PlayNote(note);
    }
  }

  if (p2Active && p2ButtonToNumMap.containsKey("" + key)) {
    int num = p2ButtonToNumMap.get("" + key);

    if (!p2CurrPlaying[num]) {
      p2CurrPlaying[num] = true;

      String note = numToNoteMap.get(num);
      sines[num].play(map.get(note), 1);

      if (turn == 2)
        playerWave.p1PlayNote(note);
      else if (turn == 0)
        playerWave.p2PlayNote(note);
      else
        bossWave2.p2PlayNote(note);
    }
  }
}

public void keyReleased() {
  //println("released " + key);
  if (p1ButtonToNumMap.containsKey("" + key)) {
    int num = p1ButtonToNumMap.get("" + key);
    
    if (p1Active || p1CurrPlaying[num]) {
  
      p1CurrPlaying[num] = false;
  
      String note = numToNoteMap.get(num);
      squares[num].stop();
  
      if (turn == 0)
        playerWave.p1PlayNote(note);
      else if (turn == 2)
        playerWave.p2PlayNote(note);
      else
        bossWave1.p2PlayNote(note);
    }
  }

  if (p2ButtonToNumMap.containsKey("" + key)) {
    int num = p2ButtonToNumMap.get("" + key);
    
    if (p2Active || p2CurrPlaying[num]) {
  
      p2CurrPlaying[num] = false;
  
      String note = numToNoteMap.get(num);
      sines[num].stop();
  
      if (turn == 2)
        playerWave.p1PlayNote(note);
      else if (turn == 0)
        playerWave.p2PlayNote(note);
      else
        bossWave2.p2PlayNote(note);
    }
  }
}

public void drawTutorial(){
  if(tutPhases[0]) {
    
    int keyWidth = (int)(width * .4f);
    //println(keyWidth);
    drawKey(true, keyWidth);
    translate(width - keyWidth, 0);
    drawKey(false, keyWidth);
    translate(-(width - keyWidth),0);
    colorMode(RGB);
    fill(255,255,255,255);
    stroke(255,255,255,255);
    text("FOR PLAYER 1", 400 * widthScale, 50 * uiScale);
    fill(0,0,0,255);
    text("Q", 25 * widthScale, 330 * uiScale);
    text("W", 80 * widthScale, 330 * uiScale);
    text("E", 130 * widthScale, 330 * uiScale);
    text("R", 185 * widthScale, 330 * uiScale);
    text("T", 240 * widthScale, 330 * uiScale);
    text("Y", 290 * widthScale, 330 * uiScale);
    rect(600 * widthScale, 150 * uiScale, 100 * widthScale, 50 * uiScale);
    fill(255,255,255,255);
    text("NEXT",650 * widthScale, 180 * uiScale);
    
    
  } else if(tutPhases[1]) {
    int keyWidth = (int)(width * .4f);
    //println(keyWidth);
    drawKey(false, keyWidth);
    translate(width - keyWidth, 0);
    drawKey(true, keyWidth);
    translate(-(width - keyWidth),0);
    colorMode(RGB);
    fill(255,255,255,255);
    stroke(255,255,255,255);
    text("FOR PLAYER 2", 400 * widthScale, 50 * uiScale);
    fill(0,0,0,255);
    text("G", 505 * widthScale, 330 * uiScale);
    text("H", 560 * widthScale, 330 * uiScale);
    text("J", 615 * widthScale, 330 * uiScale);
    text("K", 665 * widthScale, 330 * uiScale);
    text("L", 720 * widthScale, 330 * uiScale);
    text(";", 770 * widthScale, 330 * uiScale);
    rect(600 * widthScale, 150 * uiScale, 100 * widthScale, 50 * uiScale);
    fill(255,255,255,255);
    text("FINISH",650 * widthScale, 180 * uiScale);
  }
}


class Boss {
  float health = 500;
  
  float x, y, r;
  
  public void drawBoss() {
    colorMode(RGB);
    stroke(255);
    fill(0,0,255);
    rect(0, uiScale * 20, health / 500.0f * width,uiScale * 20);
    
    float rotation = millis() * 2 * PI / (millisPerBeat * 4);
    noFill();
    float rtR = r / sqrt(2);
    translate(x, y);
    rotate(rotation);
    triangle(0, - r, - rtR, rtR, rtR, rtR);
    rotate(-2 * rotation);
    triangle(0, - r, - rtR, rtR, rtR, rtR);
    rotate(rotation);
    translate(-x, -y);
  }
  
  public void damage(float d) {
    health -= d;
  }
}
class FilePlayer {
  int[] eventTimes;
  String[] eventNotes;
  int eventIndex;
  String[] lines;
  String songfile;
  SqrOsc[] squares;
  SawOsc[] sines;
  boolean[] currPlaying;
  int resetTime;
  float volume;
  int loopTime;
  int octave;
  
  public FilePlayer() {
    volume = .2f;
    loopTime = 0;
    octave = 0;
  }
  
  public FilePlayer(float v, int lt, int oc) {
    volume = v;
    loopTime = lt;
    octave = oc;
  }
  
  public void setSong(String filename,SqrOsc[] setSquares, SawOsc[] setSines) {
    int loadMPB = 300;
    
    squares = setSquares;
    sines = setSines;
    
    lines = loadStrings(filename);
    
    eventTimes = new int[lines.length];
    eventNotes = new String[lines.length];
    
    for(int i=0; i < lines.length; i++){
      String[] line = splitTokens(lines[i]);
      
      eventTimes[i] = PApplet.parseInt(line[1]) * millisPerBeat / loadMPB;
      eventNotes[i] = line[0];
      
    }
    currPlaying = new boolean[6];
    for(int j = 0; j < currPlaying.length; j++) {
      currPlaying[j] = false;
    }
  }
  
  
  public void reset() {
    resetTime = millis();
    eventIndex = 0;
    
    for (int i = 0; i < squares.length; i++) {
      squares[i].stop();
      sines[i].stop();
    }
  }
  
  public void playSong(Wave wave){
    while(eventIndex < eventTimes.length && millis() - resetTime >= eventTimes[eventIndex]){
      String noteName = eventNotes[eventIndex];
      float noteFreq = map.get(noteName) * pow(2, octave);
      
      if(noteName.equals("e")){
        if(currPlaying[0]){
          squares[0].stop();
          //numPlaying--;
          currPlaying[0] = false;
          if(wave != null) {
            wave.p1PlayNote("e");
          }
          
        } else {
          currPlaying[0] = true;
          //numPlaying += 1;
          squares[0].play(noteFreq, volume);
          //timesPressed[0] = millis();
          if(wave != null) {
            wave.p1PlayNote("e");
          //wave.p2PlayNote("e");
          }
          
        }
      }else if(noteName.equals("fs")){
        if(currPlaying[1]){
          squares[1].stop();
          //numPlaying--;
          currPlaying[1] = false;
          if(wave != null) {
            wave.p1PlayNote("fs");
          }
          
        } else {
          currPlaying[1] = true;
          //numPlaying += 1;
          squares[1].play(noteFreq, volume);
          //timesPressed[1] = millis();
          if(wave != null) {
            wave.p1PlayNote("fs");
          }
          
          //wave.p2PlayNote("fs");
        }
      }else if(noteName.equals("gs")){
        if(currPlaying[2]){
          squares[2].stop();
          //numPlaying--;
          currPlaying[2] = false;
          if(wave != null) {
            wave.p1PlayNote("gs");
          }
          
        } else {
          currPlaying[2] = true;
          //numPlaying += 1;
          squares[2].play(noteFreq, volume);
          //timesPressed[2] = millis();
          if(wave != null) {
            wave.p1PlayNote("gs");
          }
          
          //wave.p2PlayNote("gs");
        }
      }else if(noteName.equals("a")){
        if(currPlaying[3]){
          squares[3].stop();
          //numPlaying--;
          currPlaying[3] = false;
          if(wave != null) {
            wave.p1PlayNote("a");
          }
          
        } else {
          currPlaying[3] = true;
          //numPlaying += 1;
          
          squares[3].play(noteFreq, volume);
          //timesPressed[3] = millis();
          if(wave != null) {
            wave.p1PlayNote("a");
          }
          
          //wave.p2PlayNote("a");
        }
      }else if(noteName.equals("b")){
        if(currPlaying[4]){
          squares[4].stop();
          //numPlaying--;
          currPlaying[4] = false;
          if(wave != null) {
            wave.p1PlayNote("b");
          }
          
        } else {
          currPlaying[4] = true;
          //numPlaying += 1;
          squares[4].play(noteFreq, volume);
          //timesPressed[4] = millis();
          if(wave != null) {
            wave.p1PlayNote("b");
          }
          
          //wave.p2PlayNote("b");
        }
      }else if(noteName.equals("cs")){
        if(currPlaying[5]){
          squares[5].stop();
          //numPlaying--;
          currPlaying[5] = false;
          if(wave != null) {
            wave.p1PlayNote("cs");
          }
          
        } else {
          currPlaying[5] = true;
          //numPlaying += 1;
          squares[5].play(noteFreq, volume);
          //timesPressed[5] = millis();
          if(wave != null) {
            wave.p1PlayNote("cs");
          }
          
          //wave.p2PlayNote("cs");
        }
      }
      
      eventIndex++;
    }
    ////println("lt: " + loopTime);
    if(loopTime > 0 && millis() - resetTime > loopTime) {
      reset();
    }
  }
}
class Wave {

  ArrayList<Integer> p1EventTimes;
  ArrayList<String> p1EventNotes;
  
  ArrayList<Integer> p2EventTimes;
  ArrayList<String> p2EventNotes;
  
  float amplitude;
  float period;
  
  int xspacing;   // How far apart should each horizontal location be spaced
  int w;              // Width of entire wave
  int travelTime;  //millis
  
  public Wave(float a, float p, int xs, int _w, int tt) {
    p1EventTimes = new ArrayList<Integer>();
    p2EventTimes = new ArrayList<Integer>();
    
    p1EventNotes = new ArrayList<String>();
    p2EventNotes = new ArrayList<String>();
    
    amplitude = a;
    period = p;
    xspacing = xs;
    w = _w;
    travelTime = tt;
  }
  
  public void reset() {
    p1EventTimes = new ArrayList<Integer>();
    p2EventTimes = new ArrayList<Integer>();
    
    p1EventNotes = new ArrayList<String>();
    p2EventNotes = new ArrayList<String>();
  }
  
  public void drawWave() {
    noFill();
    stroke(255);
    colorMode(HSB);
    
    int time = millis();
    
    float prev = 0;
    for (int x = 0; x < w; x += xspacing) {
      float t = getTime(x, time);
      
      float yvalue = p1Height(t);
      if (x > w * .75f) {
        if (matched(t)) {
          yvalue = 0;
        } else {
          yvalue -= p2Height(t + travelTime);
        }
      }
      
      boolean[] p1NotesPlaying = new boolean[squares.length];
      for (int i = 0; i < p1EventTimes.size(); i++) {
        if (p1EventTimes.get(i) > t)
          break;
        if (noteToNumMap.containsKey(p1EventNotes.get(i))) {
          int indx = noteToNumMap.get(p1EventNotes.get(i));
          p1NotesPlaying[indx] = !p1NotesPlaying[indx];
        }
      }
      
      if (x > 0) {
        int notes = 0;
        for (int i = 0; i < 6; i++) {
          notes += (p1NotesPlaying[i] ? 1 : 0);
        }
        
        int hue = 0;
        for (int i = 0; i < 6; i++) {
          hue += (p1NotesPlaying[i] ? 1  : 0) * 42 * i;
        }
        if (notes > 0) hue /= notes;
        
        int sat = notes == 0 ? 0 : 255;
                  
        stroke(hue, sat, 255);
        
        line(x - xspacing, prev, x, yvalue);
      }
      prev = yvalue;
    }
  }

  public float getTime(float x) {
    return getTime(x, millis());
  }
  
  public float getTime(float x, float time) {
    return time - (x * 4.0f / 3 / w * travelTime);
  }
  
  public boolean matched(float t) {
    boolean[] p1NotesPlaying = new boolean[squares.length];
    for (int i = 0; i < p1EventTimes.size(); i++) {
      if (p1EventTimes.get(i) > t)
        break;
      if (noteToNumMap.containsKey(p1EventNotes.get(i))) {
        int indx = noteToNumMap.get(p1EventNotes.get(i));
        p1NotesPlaying[indx] = !p1NotesPlaying[indx];
      }
    }
    
    boolean[] p2NotesPlaying = new boolean[squares.length];
    for (int i = 0; i < p2EventTimes.size(); i++) {
      if (p2EventTimes.get(i) > t + travelTime)
        break;
      if (noteToNumMap.containsKey(p2EventNotes.get(i))) {
        int indx = noteToNumMap.get(p2EventNotes.get(i));
        p2NotesPlaying[indx] = !p2NotesPlaying[indx];
      }
    }
    
    boolean equal = true;
    for (int i = 0;  i < squares.length; i++) {
      equal = (p1NotesPlaying[i] == p2NotesPlaying[i]);
      if (!equal)
        break;
    }
    return equal;
  }
  
  public void stopP2() {
    int t = millis();
    
    boolean[] p2NotesPlaying = new boolean[squares.length];
    for (int i = 0; i < p2EventTimes.size(); i++) {
      if (p2EventTimes.get(i) > t)
        break;
      if (noteToNumMap.containsKey(p2EventNotes.get(i))) {
        int indx = noteToNumMap.get(p2EventNotes.get(i));
        p2NotesPlaying[indx] = !p2NotesPlaying[indx];
      }
    }
    
    for (int i = 0; i < p2NotesPlaying.length; i++) {
      if (p2NotesPlaying[i])
        p2PlayNote(numToNoteMap.get(i));
    }
  }
  
  public void stopP1() {
    int t = millis();
    
    boolean[] p1NotesPlaying = new boolean[squares.length];
    for (int i = 0; i < p1EventTimes.size(); i++) {
      if (p1EventTimes.get(i) > t)
        break;
      if (noteToNumMap.containsKey(p1EventNotes.get(i))) {
        int indx = noteToNumMap.get(p1EventNotes.get(i));
        p1NotesPlaying[indx] = !p1NotesPlaying[indx];
      }
    }
    
    for (int i = 0; i < p1NotesPlaying.length; i++) {
      if (p1NotesPlaying[i])
        p1PlayNote(numToNoteMap.get(i));
    }
  }
  
  public void stopAll() {
    //reset();
    stopP1();
    stopP2();
  }

  public float p1Height(float t) {
    boolean[] notesPlaying = new boolean[squares.length];
    int[] timesPlaying = new int[squares.length];
    for (int i = 0; i < p1EventTimes.size(); i++) {
      if (p1EventTimes.get(i) > t)
        break;
      if (noteToNumMap.containsKey(p1EventNotes.get(i))) {
        int indx = noteToNumMap.get(p1EventNotes.get(i));
        notesPlaying[indx] = !notesPlaying[indx];
        timesPlaying[indx] = p1EventTimes.get(i);
      }
    }
    
    return amplitude *
       ((notesPlaying[0] ? sin(1/period*(t - timesPlaying[0])) : 0)+
         (notesPlaying[1] ? sin(2/period*(t - timesPlaying[1])) : 0)+
          (notesPlaying[2] ? sin(4/period*(t - timesPlaying[2])) : 0)+
           (notesPlaying[3] ? sin(8/period*(t - timesPlaying[3])) : 0)+
            (notesPlaying[4] ? sin(16/period*(t - timesPlaying[4])) : 0)+
             (notesPlaying[5] ? sin(32/period*(t - timesPlaying[5])) : 0));
  }
  
  public float p2Height(float t) {
    boolean[] notesPlaying = new boolean[squares.length];
    int[] timesPlaying = new int[squares.length];
    for (int i = 0; i < p2EventTimes.size(); i++) {
      if (p2EventTimes.get(i) > t)
        break;
      if (noteToNumMap.containsKey(p2EventNotes.get(i))) {
        int indx = noteToNumMap.get(p2EventNotes.get(i));
        notesPlaying[indx] = !notesPlaying[indx];
        timesPlaying[indx] = p2EventTimes.get(i);
      }
    }
  
    return amplitude *
       ((notesPlaying[0] ? sin(1/period*(t - timesPlaying[0])) : 0)+
         (notesPlaying[1] ? sin(2/period*(t - timesPlaying[1])) : 0)+
          (notesPlaying[2] ? sin(4/period*(t - timesPlaying[2])) : 0)+
           (notesPlaying[3] ? sin(8/period*(t - timesPlaying[3])) : 0)+
            (notesPlaying[4] ? sin(16/period*(t - timesPlaying[4])) : 0)+
             (notesPlaying[5] ? sin(32/period*(t - timesPlaying[5])) : 0));
  }

  public void drawOpponent() {
    float x = w * .75f;
    float t = millis();
    float oppHeight = p2Height(t);
    float p1Height = p1Height(t - travelTime);
    
    colorMode(RGB);
    stroke(255, 0, 0);
    line(x, -oppHeight, x, p1Height);
    stroke(255);
    ellipse(x, -oppHeight, 16, 16);
  }
  
  public void p1PlayNote(String note) {
      p1EventTimes.add((int)(((int)(millis() / (millisPerBeat / 4)) + 1) * (millisPerBeat / 4)));
      p1EventNotes.add(note);
  }
  
  public void p2PlayNote(String note) {
      p2EventTimes.add((int)(((int)(millis() / (millisPerBeat / 4)) + 1) * (millisPerBeat / 4)));
      p2EventNotes.add(note);
  }
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "damageBoss" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
