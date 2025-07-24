class Player {
  
  PVector position;
  PVector truePosition;
  float width, height;
  
  PImage small_mario[];
  PImage super_mario[];
  boolean direction;
  int walkAnimation;
  int frameCont;
  
  int health;
  boolean dead;
  
  
  PVector movement;
  boolean up, down, left, right;
  boolean jumping;
  
  final float GRAVITY = 10;
  final float VERTICAL_ACCELERATION = 0.1;
  final float JUMP_SPEED = 30;
  final float MOVEMENT_SPEED = 5;
  
  Player(float x, float y, float width, float height) {
    small_mario = new PImage[2];
    small_mario[0] = loadImage("players/small_mario_0.png");
    small_mario[1] = loadImage("players/small_mario_1.png");
    position = new PVector(x, y);
    this.width = width;
    this.height = height;
    movement = new PVector(0, 0);
    jumping = true;
    direction = true;
    walkAnimation = 0;
    health = 1;
  }
    
  void tick() {
    movement.y = lerp(movement.y, GRAVITY, 0.1);
    movement.x = lerp(movement.x, 0, 0.1);
    
    if(right) {
      movement.x = lerp(movement.x, MOVEMENT_SPEED, 0.2);
      direction = true;
    }
    else if(left) {
      movement.x = lerp(movement.x, -MOVEMENT_SPEED, 0.2);
      direction = false;
    }
    if(up && !jumping) {
       movement.y = lerp(movement.y, -JUMP_SPEED, 0.8);
       jumping = true;
    }
  }
  
  void render(float scale, float offsetX, float offsetY) {
    if(direction) {
      pushMatrix();
      scale(-1, 1);
      image(small_mario[walkAnimation], -(position.x*scale+offsetX+width), position.y*scale+offsetY, width*scale, height*scale);
      popMatrix();
    }
    else {
      image(small_mario[walkAnimation], position.x*scale+offsetX, position.y*scale+offsetY, width*scale, height*scale);
    }
    frameCont++;
    if(frameCont > 10) {
      frameCont = 0;
      if(left || right) {
        walkAnimation++;
        if(walkAnimation > 1) walkAnimation = 0;
      }
    }
  }
  
  void takeDamage() {
    health--;
    if(health <= 0) {
      dead = true;
      movement.x = 0;
      movement.y = 0;
    }
  }
  
  void keyPressed() {
    if(keyCode == 68) right = true;
    else if(keyCode == 65) left = true;
    
    if(keyCode == 32) up = true;
    else if(keyCode == 83) down = true;
  }
  
  void keyReleased() {
    if(keyCode == 68) {
      right = false;
      walkAnimation = 0;
    }
    else if(keyCode == 65) {
      left = false;
      walkAnimation = 0;
    }   
    if(keyCode == 32) up = false;
    else if(keyCode == 83) down = false;
  }
  
  
}
