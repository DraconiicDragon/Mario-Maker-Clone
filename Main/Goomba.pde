class Goomba extends Enemy {

  int frameCont;
  boolean reverseSprite;
  
  Goomba(PVector position) {
    super(position, 64, 64, 1);
    sprites = new PImage[2];
    sprites[0] = loadImage("enemies/goomba_0.png");
    sprites[1] = loadImage("enemies/goomba_1.png");
    reverseSprite = false;
    frameCont = 0;
  }
  
  void tick(Player player) {
    if(position.x > player.position.x) movementSpeedX = -1;
    else if(position.x < player.position.x) movementSpeedX = 1;
    movement.y = lerp(movement.y, 10, 0.1);
    movement.x = lerp(movement.x, movementSpeedX, 0.1);
    super.tick(player);
  }
  
  void render(float offsetX, float offsetY) {
    if(dead) {
      image(sprites[1], position.x+offsetX, position.y+offsetY);
      framesDead++;
      return;
    }
    if(reverseSprite) {
      pushMatrix();
      scale(-1, 1);
      image(sprites[0], -(position.x+offsetX+width), position.y+offsetY);
      popMatrix();
    }
    else {
      image(sprites[0], position.x+offsetX, position.y+offsetY);
    }
    frameCont++;
    if(frameCont > 10) {
      frameCont = 0;
      reverseSprite = !reverseSprite;
    }
  }
  
}
