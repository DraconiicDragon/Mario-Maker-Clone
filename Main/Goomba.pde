class Goomba extends Enemy {
  
  Goomba(PVector position, float width, float height, int health) {
    super(position, width, height, health);
    movement = new PVector(0, 0);
  }
  
  void tick() {
    movement.y = lerp(movement.y, 10, 0.1);
    movement.x = lerp(movement.x, movementSpeed, 0.1);
  }
  
  void render(float scale, float offsetX, float offsetY) {
    fill(#EA2121);
    rect(position.x*scale+offsetX, position.y*scale+offsetY, this.width*scale, this.height*scale);
  }
  
  void takeDamage() {
    health--;
    if(health <= 0) dead = true;
  }
}
