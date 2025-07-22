class Player {
  
  PVector position;
  PVector truePosition;
  float width, height;
  
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
    position = new PVector(x, y);
    this.width = width;
    this.height = height;
    movement = new PVector(0, 0);
    jumping = true;
    health = 1;
  }
    
  void tick() {
    movement.y = lerp(movement.y, GRAVITY, VERTICAL_ACCELERATION);
    movement.x = lerp(movement.x, 0, 0.1);
    
    if(right) movement.x = MOVEMENT_SPEED;
    else if(left) movement.x = -MOVEMENT_SPEED;  
    if(up && !jumping) {
       movement.y = -JUMP_SPEED;
       jumping = true;
    }
  }
  
  void render(float scale, float offsetX, float offsetY) {
    fill(#13CE36);
    rect(position.x*scale+offsetX, position.y*scale+offsetY, width*scale, height*scale);
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
    if(keyCode == 68) right = false;
    else if(keyCode == 65) left = false;
    
    if(keyCode == 32) up = false;
    else if(keyCode == 83) down = false;
  }
  
  
}
