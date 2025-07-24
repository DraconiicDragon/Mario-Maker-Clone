Game game;

void setup() {
  size(1120, 630);
  surface.setResizable(true);
  //fullScreen();
  game = new Game();
  //noStroke();
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

void windowResized() {
  game.windowResized();
}
