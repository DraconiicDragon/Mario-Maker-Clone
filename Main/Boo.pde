class Boo extends Enemy {
  
  boolean direction;
  boolean frozen;
  
  Boo(PVector position) {
    super(position, 64, 64, 1);
    sprites = new PImage[2];
    sprites[0] = loadImage("enemies/boo_0.png");
    sprites[1] = loadImage("enemies/boo_1.png");
    direction = false;
    frozen = false;
  }
  
  void tick(Player player) {
    if((position.x > player.position.x && player.direction) || (position.x < player.position.x && !player.direction)) {
      movement.x = 0;
      movement.y = 0;
      frozen = true;
      return;
    }
    
    if(position.x > player.position.x) {
      direction = false;
      movementSpeedX = -1;
    }
    else if(position.x < player.position.x) {
      movementSpeedX = 1;
      direction = true;
    }
    if(position.y > player.position.y) movementSpeedY = -1;
    else if(position.y < player.position.y) movementSpeedY = 1;
    frozen = false;
    movement.y = lerp(movement.y, movementSpeedY, 0.1);
    movement.x = lerp(movement.x, movementSpeedX, 0.1);
    super.tick(player);
  }
  
  void render(float offsetX, float offsetY) {
    PImage sprite = sprites[1];
    
    if(frozen) sprite = sprites[0];
    
    if(direction) {
      pushMatrix();
      scale(-1, 1);
      image(sprite, -(position.x+offsetX+width), position.y+offsetY);
      popMatrix();
    }
    else {
      image(sprite, position.x+offsetX, position.y+offsetY);
    }
  }
}
