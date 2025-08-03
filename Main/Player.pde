class Player {
  
  PVector position;
  PVector truePosition;
  float width, height;
  
  PImage small_mario[];
  PImage super_mario[];
  boolean direction;
  int walkAnimation;
  int frameCont;
  int deathAnimationFrameCont;
  int deathAnimationHeight;
  
  int health;
  boolean dead;
  
  
  PVector movement;
  boolean up, down, left, right;
  boolean jumping;
  
  final float GRAVITY = 20;
  final float JUMP_HEIGHT = 80;
  final float MOVEMENT_SPEED = 15;
  
  Player(float x, float y) {
    small_mario = new PImage[5];
    small_mario[0] = loadImage("players/small_mario_0.png");
    small_mario[1] = loadImage("players/small_mario_1.png");
    small_mario[2] = loadImage("players/small_mario_2.png");
    small_mario[3] = loadImage("players/small_mario_3.png");
    small_mario[4] = loadImage("players/small_mario_4.png");
    position = new PVector(x, y);
    this.width = 64;
    this.height = 64;
    movement = new PVector(0, 0);
    jumping = true;
    direction = true;
    walkAnimation = 0;
    health = 1;
  }
  
  void upCollision() {
    movement.y = 0;
  }
  
  void downCollision() {
    jumping = false;
    movement.y = 0;
  }
  
  void die() {
    dead = true;
    movement.x = 0;
    movement.y = 0;
  }
  
  void takeDamage() {
    health--;
    if(health <= 0) {
      die();
    }
  }
    
  void tick() {
    movement.y = lerp(movement.y, GRAVITY, 0.1);
       
    if(right) {
      movement.x = lerp(movement.x, MOVEMENT_SPEED, 0.02);
      direction = true;
    }
    else if(left) {
      movement.x = lerp(movement.x, -MOVEMENT_SPEED, 0.02);
      direction = false;
    } else {
      movement.x = lerp(movement.x, 0, 0.1);
    }
    if(up && !jumping) {
       movement.y = lerp(movement.y, -JUMP_HEIGHT, 0.8);
       jumping = true;
    }    
  }
  
  void render(float offsetX, float offsetY) {
    if(dead) {
      deathAnimationFrameCont++;
      if(deathAnimationFrameCont < 40) deathAnimationHeight -= 3;
      else deathAnimationHeight += 5;
      image(small_mario[4], position.x+offsetX, position.y+offsetY+deathAnimationHeight);      
      return;
    }
    PImage animation = small_mario[walkAnimation];
        
    if(movement.y != 0) {
      animation = small_mario[3];
    } else if((direction && movement.x < 0) || (!direction && movement.x > 0) && abs(movement.x) > 10) {
      animation = small_mario[2];
    }
    
    if(direction) {
      pushMatrix();
      scale(-1, 1);
      image(animation, -(position.x+offsetX+width), position.y+offsetY);
      popMatrix();
    }
    else {
      image(animation, position.x+offsetX, position.y+offsetY);
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
