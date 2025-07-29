abstract class Enemy {
  
  PVector position;
  float width, height;
  int health;
  PVector movement;
  float movementSpeedX;
  float movementSpeedY;
  boolean dead;
  int framesDead;
  PImage sprites[];
  boolean downCollision, upCollision, leftCollision, rightCollision;
  
  
  Enemy(PVector position, float width, float height, int health) {
    this.position = position;
    this.width = width;
    this.height = height;
    this.health = health;
    this.dead = false;
    this.framesDead = 0;
    movement = new PVector(0, 0);
  }
  
  void takeDamage() {
    health--;
    if(health <= 0) {
      dead = true;
      movement.x = 0;
      movement.y = 0;
    }
  }

  void tick(Player player) {
    position.x += movement.x;
    position.y += movement.y;
  }
  abstract void render(float offsetX, float offsetY);
  
}
