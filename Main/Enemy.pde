abstract class Enemy {
  
  PVector position;
  float width, height;
  int health;
  PVector movement;
  float movementSpeed;
  boolean dead;
  
  
  Enemy(PVector position, float width, float height, int health) {
    this.position = position;
    this.width = width;
    this.height = height;
    this.health = health;
    this.dead = false;
  }
  
  abstract void takeDamage();
  abstract void tick();
  abstract void render(float offsetX, float offsetY);
  
}
