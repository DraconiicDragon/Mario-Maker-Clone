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
  
  boolean isSolid() {
    if(this.id == 1) return true;
    return false;
  }

}
