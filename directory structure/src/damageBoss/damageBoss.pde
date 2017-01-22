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

boolean[] p1CurrPlaying;
boolean[] p2CurrPlaying;

int health;
int turnStart;
float damageCounter;
int intervalNotesPlayed;
int millisPerBeat = 400;
int lastMillis;
float delta;

Wave playerWave;
Boss boss;
Wave bossWave1, bossWave2;
FilePlayer filePlayer1, filePlayer2;

int turn;
int barsPerTurn = 4;
boolean switchedPlayers;
boolean nextPhase;

int flashFrames;

SoundFile[] clicks;
int clickCtr;
int nextClick;

String[] riff1s = {"riff_1a.txt", "riff_2a.txt", "riff_3a.txt"};
String[] riff2s = {"riff_1b.txt", "riff_2b.txt", "riff_3b.txt"};
int curRiff;

boolean started;
PImage logo;

boolean p1Active;
boolean p2Active;

boolean over = false;
boolean lost = false;

void setup() {
  size(800, 360);
  background(255);
  
  logo = loadImage("logo.png");
  
  squares = new SqrOsc[6];
  for (int i = 0; i < squares.length; i++) {
    squares[i] = new SqrOsc(this);
  }
  
  sines = new SinOsc[6];
  for (int i = 0; i <  sines.length; i++) {
    sines[i] = new SinOsc(this);
  }
  
  filePlayer1 = new FilePlayer();
  filePlayer2 = new FilePlayer();
  
  clicks = new SoundFile[]{new SoundFile(this, "mid.mp3"), new SoundFile(this, "hi.mp3"), 
            new SoundFile(this, "mid.mp3"), new SoundFile(this, "lo.mp3")};
  
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
  
  lastMillis = millis();
}

void startGame() {
  health = 1000;
  turnStart = 0;
  damageCounter = 0;
  intervalNotesPlayed = 0;
  
  p1Active = true;
  p2Active = false;
  
  curRiff = 0;
  clickCtr = 0;
  
  flashFrames = 0;
  turn = 0;
  switchedPlayers = false;
  nextPhase = false;
  
  turnStart = millis();
  clickCtr = millis();
  
  playerWave = new Wave(75.0, 300, 2, width, 2 * barsPerTurn * millisPerBeat);   //4/4 so * 4, but / 2
  bossWave1 = new Wave(75.0, 300, 2, width / 2, 2 * barsPerTurn * millisPerBeat);   //4/4 so * 4, but / 2
  bossWave2 = new Wave(75.0, 300, 2, width / 2, 2 * barsPerTurn * millisPerBeat);   //4/4 so * 4, but / 2
  boss = new Boss();
  
  p1CurrPlaying = new boolean[6];
  p2CurrPlaying = new boolean[6];
}

void draw() {
  background(0);
  delta = (millis() - lastMillis) / 1000.0;
  lastMillis = millis();
    
    
  if (!started) {
    textSize(16);
    textAlign(CENTER);
    fill(255,255,255,0);
    stroke(255,255,255,255);
    // Fix for centering later?
    image(logo, 0, 0, width, height);
    rect(300,130,200,90);
    fill(255,255,255,255);
//    text("WAVE BATTLE", 400, 60);
    text("START GAME", 400, 180);
    
    if (over) {
      if (lost) {
        fill(255, 0, 0);
        text("YOU LOSE", 400, 60);
      } else {
        fill(0, 255, 255);
        text("YOU WIN", 400, 60);
      }
    }
  } else {
    if(millis() > clickCtr){
      clicks[nextClick].play();
      clickCtr += millisPerBeat;
      nextClick++;
      nextClick %= 4;
    }
    
    if (turn % 2 == 0) {
      if (turn == 2) {
        scale(-1, 1);
        translate(-width, 0);
      }
      playerWave.drawWave();
      
      playerWave.drawOpponent();
      if (turn == 2) {
        translate(width, 0);
        scale(-1, 1);
      }
      
      drawUI();
      
      boss.drawBoss();
      
      countBossDamage();
      
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
        println("riff: " + curRiff);
        
        if (turn == 0) {
          p1Active = false;
          p2Active = true;
        } else {
          p1Active = true;
          p2Active = false;
        }
      }
      
      if (flashFrames > 0) {
        fill(255, 255 * flashFrames / 4.0);
        rect(0,0,width,height);
        flashFrames--;
      }
      
      if(millis() - turnStart > millisPerBeat * barsPerTurn * 4) {
        for (int i = 0; i < squares.length; i++)
          squares[i].stop();
        for (int i = 0; i < sines.length; i++)
          sines[i].stop();
        playerWave.stopAll();
        
        damageBoss();
        turn ++;
        turn %= 4;
        turnStart = millis();
        switchedPlayers = false;
        filePlayer1.reset();
        filePlayer2.reset();
        //if (turn == 1) {
          bossWave1.travelTime = 4 * barsPerTurn * millisPerBeat;
          bossWave2.travelTime = 2 * barsPerTurn * millisPerBeat;
        /*} else {
          bossWave2.travelTime = 2 * barsPerTurn * millisPerBeat;
          bossWave1.travelTime = 4 * barsPerTurn * millisPerBeat;
        }*/
        barsPerTurn = 6;
        
        p1Active = false;
        p2Active = false;
      }
    } else {
      bossWave1.drawWave();
      bossWave1.drawOpponent();
      
      translate(width, 0);
      scale(-1, 1);
      bossWave2.drawWave();
      bossWave2.drawOpponent();
      scale(-1, 1);
      translate(-width, 0);
      
      drawUI();
      
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
        bossWave1.stopAll();
        bossWave2.stopAll();
        
        switchedPlayers = true;
        
        filePlayer2.reset();
      }
      
      if (!nextPhase && millis() - turnStart > millisPerBeat * 16) {
        for (int i = 0; i < squares.length; i++)
          squares[i].stop();
        for (int i = 0; i < sines.length; i++)
          sines[i].stop();
        bossWave1.stopAll();
        bossWave2.stopAll();
        
        nextPhase = true;
        flashFrames = 4;
        
        p1Active = true;
        p2Active = true;
      }
      
      if (flashFrames > 0) {
        fill(255, 255 * flashFrames / 4.0);
        rect(0,0,width,height);
        flashFrames--;
      }
      
      if(millis() - turnStart > millisPerBeat * barsPerTurn * 4) {
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
        barsPerTurn = 4;
        switchedPlayers = false;
        nextPhase = false;
        
        if (turn == 0) {
          p1Active = true;
          p2Active = false;
        } else {
          p1Active = false;
          p2Active = true;
        }
      }
    }
    
    if (health < 0) {
      over = true;
      lost = true;
      started = false;
    } else if (boss.health < 0) {
      over = true;
      lost = false;
      started = false;
    }
  }
}

void drawUI() {
  fill(255,0,0);
  rect(0, 0, health / 1000.0 * width,20);
  
  int keyWidth = (int)(width * .4);
  drawKey(p1Active, keyWidth);
  translate(width - keyWidth, 0);
  drawKey(p2Active, keyWidth);
  translate(-(width - keyWidth), 0);
  
}

void drawKey(boolean active, int keyWidth) {
  float offset = cos((float)(millis() - clickCtr) / millisPerBeat * 2 * PI) * .01;
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
    
    ellipse(keyWidth / 6.0 * j + keyWidth / 12.0, height - 30, 60 * (1 + offset), 60 * (1 + offset));
  }
}

void damagePlayer() {
  float t = millis();
  float opp1Height = bossWave1.p2Height(t);
  float p1Height = bossWave1.p1Height(t - bossWave1.travelTime);
  
  if (!bossWave1.matched(t - bossWave1.travelTime)) {
    health -= max(abs(opp1Height - p1Height) / 20 - 2, 0);
  }
  
  float opp2Height = bossWave2.p2Height(t);
  float p2Height = bossWave2.p1Height(t - bossWave2.travelTime);
  
  if (!bossWave2.matched(t - bossWave2.travelTime)) {
    health -= max(abs(opp2Height - p2Height) / 20 - 2, 0);
  }
}

void damageBoss() {
  /*println("counter: " + damageCounter);
  println("modifier: " + (intervalNotesPlayed + 1));*/
  float damageToBoss = damageCounter * (intervalNotesPlayed + 1);
  boss.damage(damageToBoss);
  intervalNotesPlayed = 0;
  damageCounter = 0;
  /*println("Negative Damage: " + damageCounter);
  println("Number of notes stacked: " + intervalNotesPlayed);
  println("Damage to Boss: " + damageToBoss);
  println("********************************************************************");*/
}

void countBossDamage() {
  float t = millis();
  float oppHeight = playerWave.p2Height(t);
  
  if (playerWave.matched(t - playerWave.travelTime)) {
    damageCounter += abs(oppHeight) * delta;
  }
}

void mousePressed() {
  
  if(!started && mouseX <= 500 && mouseX >= 300 && mouseY <= 210 && mouseY <= 210 && mouseY >= 120) {
    // Enter start game conditions here.
    started = true;
    
    startGame();
  }
}

void keyPressed() {

  if (p1Active && p1ButtonToNumMap.containsKey("" + key)) {
    int num = p1ButtonToNumMap.get("" + key);
    
    if (!p1CurrPlaying[num]) {
      p1CurrPlaying[num] = true;
      
      String note = numToNoteMap.get(num);
      squares[num].play(map.get(note), .4);
      
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
      sines[num].play(map.get(note), .4);
      
      if (turn == 2)
        playerWave.p1PlayNote(note);
      else if (turn == 0)
        playerWave.p2PlayNote(note);
      else
        bossWave2.p2PlayNote(note);
        
    }
  }
}

void keyReleased() {
  if (p1Active && p1ButtonToNumMap.containsKey("" + key)) {
    int num = p1ButtonToNumMap.get("" + key);
    
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
  
  if (p2Active && p2ButtonToNumMap.containsKey("" + key)) {
    int num = p2ButtonToNumMap.get("" + key);
    
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