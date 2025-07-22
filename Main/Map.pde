class Map {
  Tile tiles[][];
  int mapWidth;
  int mapHeight;
  float startX;
  float startY;
  float tileSize = 16;
  float scale;
  
  Map(int mapWidth, int mapHeight, float scale) {
    this.mapWidth = mapWidth;
    this.mapHeight = mapHeight;
    this.scale = tileSize*scale;
    
    tiles = new Tile[mapHeight][mapWidth];
    
    startX = (width - this.scale * mapWidth) / 2;
    startY = (height - this.scale * mapHeight) / 2;
  }
  
  void preloadMap() {
    for(int i = 0; i < mapHeight; i++) {
      for(int j = 0; j < mapWidth; j++) {
        if(i == mapHeight-1) tiles[i][j] = new Tile(1, new PVector(j*tileSize, i*tileSize), 0);
        else tiles[i][j] = new Tile(0, new PVector(j*tileSize, i*tileSize), 255);  
      }
    }
  }
  
  void updateScale(float scale) {
    this.scale = tileSize*scale;
    startX = (width - this.scale * mapWidth) / 2;
    startY = (height - this.scale * mapHeight) / 2;
  }
  
  void render() {
    float x = startX, y = startY;
    for(Tile[] i : tiles) {
      for(Tile j : i) {
        fill(j.tileColor);
        rect(x, y, scale, scale);
        x += scale;
      }
      y += scale;
      x = startX;
    }
  }
  
  int getXCoordenate(float x) {
    return int((x) / tileSize);
  }
  
  int getYCoordenate(float y) {
    return int((y) / tileSize);
  }
  
  void mousePressed() {
    float x = (mouseX - startX) / scale;
    float y = (mouseY - startY) / scale;
    if(x < 0 || y < 0 || x > mapWidth || y > mapHeight) return;
    changeTile(int(x), int(y));
  }
  
  void changeTile(int x, int y) {
    tiles[y][x].id = 1;
    tiles[y][x].tileColor = 0;
  }

}
