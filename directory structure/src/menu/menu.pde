void setup(){
  size(800, 360);
  background(255);
}

void draw() {
  background(0);
  textSize(16);
  textAlign(CENTER);
  fill(255,255,255,0);
  stroke(255,255,255,255);
  // Fix for centering later?
  rect(300,130,200,90);
  fill(255,255,255,255);
  text("WAVE BATTLE", 400, 60);
  text("START GAME", 400, 180);
  
}

void mousePressed() {
  
  if(mouseX <= 500 && mouseX >= 300 && mouseY <= 210 && mouseY <= 210 && mouseY >= 120) {
    // Enter start game conditions here.
    println("START GAME");
  }
}