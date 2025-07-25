Game game;

void setup() {
  fullScreen();
  game = new Game();
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
