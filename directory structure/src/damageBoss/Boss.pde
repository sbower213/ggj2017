import processing.sound.*;

class Boss {
  float health = 500;
  
  void drawBoss() {
    colorMode(RGB);
    stroke(255);
    fill(0,0,255);
    rect(0, 20, health / 500.0 * width,20);
  }
  
  void damage(float d) {
    health -= d;
  }
}