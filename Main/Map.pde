class Map {
  PImage tileTexture[];
  Tile tiles[][];
  int mapWidth;
  int mapHeight;
  float startX;
  float startY;
  float tileSize = 64;
  
  Map(int mapWidth, int mapHeight) {
    this.mapWidth = mapWidth;
    this.mapHeight = mapHeight;
    
    tileTexture = new PImage[2];
    tileTexture[0] = loadImage("tiles/0.png");
    tileTexture[1] = loadImage("tiles/1.png");
    
    tiles = new Tile[mapHeight][mapWidth];
    
    startX = (width - tileSize * mapWidth) / 2;
    startY = (height - tileSize * mapHeight) / 2;
  }
  
  void preloadMap() {
    for(int i = 0; i < mapHeight; i++) {
      for(int j = 0; j < mapWidth; j++) {
        if(i == mapHeight-1) tiles[i][j] = new Tile(1, new PVector(j*tileSize, i*tileSize), 0);
        else tiles[i][j] = new Tile(0, new PVector(j*tileSize, i*tileSize), 255);  
      }
    }
  }
  
  void render() {
    float x = startX, y = startY;
    for(Tile[] i : tiles) {
      for(Tile j : i) {        
        image(tileTexture[j.id], x, y);
        x += tileSize;
      }
      y += tileSize;
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
    float x = (mouseX - startX) / tileSize;
    float y = (mouseY - startY) / tileSize;
    if(x < 0 || y < 0 || x > mapWidth || y > mapHeight) return;
    changeTile(int(x), int(y));
  }
  
  void changeTile(int x, int y) {
    tiles[y][x].id = 1;
    tiles[y][x].tileColor = 0;
  }

}
