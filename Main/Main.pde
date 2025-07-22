Game game;

void setup() {
  size(160*7, 90*7);
  //fullScreen();
  game = new Game();
  noStroke();
}

void draw() {
  background(50);
  game.run();  
}

void mousePressed() {
  game.mousePressed();
}

void keyPressed() {
  game.keyPressed();
}

void keyReleased() {
  game.keyReleased();
}

void mouseWheel(MouseEvent event) {
  game.mouseWheel(event);
}
