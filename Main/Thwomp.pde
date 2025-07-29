class Thwomp extends Enemy {
  
  float originalPositionY;
  int frameCont;
  
  Thwomp(PVector position) {
    super(position, 96, 128, 1);
    sprites = new PImage[1];
    sprites[0] = loadImage("enemies/thwomp_0.png");
    originalPositionY = position.y;
    frameCont = 0;
  }
  
  void tick(Player player) {
    if(downCollision) {
      movement.y = 0;      
      frameCont++;
      if(frameCont > 50) {
        position.y += -3;
      }
    } else if(player.position.x + player.width/2 > position.x && player.position.x + player.width/2 < position.x + width && player.position.y > position.y) {
      movement.y = 25;
    }
    if(position.y < originalPositionY) {
      position.y = originalPositionY;
      frameCont = 0;
      downCollision = false;
    }
    super.tick(player);
  }
  
  void render(float offsetX, float offsetY) {
    image(sprites[0], position.x+offsetX, position.y+offsetY);
  }
}
