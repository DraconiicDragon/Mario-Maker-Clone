class Tile {
  int id;
  PVector position;
  color tileColor;
  boolean solid;
  
  Tile(int id, PVector position, color tileColor) {
    this.id = id;
    this.position = position;
    this.tileColor = tileColor;
  }
  
  Tile(int id, color tileColor) {
    this.id = id;
    this.tileColor = tileColor;
  }
  
  PVector getPosition() {
    return position;
  }
  
  float getPositionX(int x, float scale) {
    return x*scale;
  }
  
  float getPositionY(int y, float scale) {
    return y*scale;
  }
  
  boolean isSolid() {
    if(this.id == 1) return true;
    else return false;
  }

}
