class Tile {
  int id;
  PVector position;
  boolean solid;
  
  Tile(int id, PVector position) {
    this.id = id;
    this.position = position;
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
