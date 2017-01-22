import processing.sound.*;

class Boss {
  float health = 500;
  
  float x, y, r;
  
  void drawBoss() {
    colorMode(RGB);
    stroke(255);
    fill(0,0,255);
    rect(0, uiScale * 20, health / 500.0 * width,uiScale * 20);
    
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
  
  void damage(float d) {
    health -= d;
  }
}