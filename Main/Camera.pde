class Camera {
  float offsetX, offsetY;
  float offsetXLimit;
  float offsetYLimit;
  
  Camera(float offsetX, float offsetY) {
    this.offsetX = offsetX;
    this.offsetY = offsetY;
    
    offsetXLimit = 2 * offsetX;
    offsetYLimit = 2 * offsetY;
  }
  
  void updateOffsetsLimit(float offsetX, float offsetY) {
    offsetXLimit = 2 * offsetX;
    offsetYLimit = 2 * offsetY;
  }
  
  void updateOffsets(float newX, float newY) {
    offsetX = width/2 - newX;
    game.offsetX = offsetX;
    if(offsetX > 0) game.offsetX = 0;
    if(offsetX < offsetXLimit) game.offsetX = offsetXLimit;
    
    offsetY = height/2 - newY;
    game.offsetY = offsetY;
    if(offsetY > 0) game.offsetY = 0;
    if(offsetY < offsetYLimit) game.offsetY = offsetYLimit;    
  }
}
