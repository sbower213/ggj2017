class Boss {
  float health = 1000;
  
  void drawBoss() {
    colorMode(RGB);
    stroke(255);
    fill(0,0,255);
    rect(0, 20, health / 1000.0 * width,20);
  }
  
  void damage(float d) {
    health -= d;
  }
}