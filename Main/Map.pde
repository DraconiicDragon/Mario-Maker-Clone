class Map {
  PImage tileTexture[];
  Tile tiles[][];
  int mapWidth;
  int mapHeight;
  float startX;
  float startY;
  float tileSize = 64;
  String mapName;
  
  ArrayList<Enemy> enemies;
    
  Map(String mapName) {
    this.mapName = mapName;  
    mapHeight = 40;
    mapWidth = 120;
    tiles = new Tile[40][120];
    loadMap();
        
    startX = (width - tileSize * mapWidth) / 2;
    startY = (height - tileSize * mapHeight) / 2;
    tileTexture = new PImage[3];
    tileTexture[0] = loadImage("tiles/0.png");
    tileTexture[1] = loadImage("tiles/1.png");
    tileTexture[2] = loadImage("tiles/2.png");
  }
  
  void saveMap() {
    JSONArray saveFile = new JSONArray();
    
    for(int i = 0; i < mapHeight; i++) {
      for(int j = 0; j < mapWidth; j++) {
        
        // Skip saving air tiles
        if(tiles[i][j].id == 0) continue;
        
        JSONObject tile = new JSONObject();
        tile.setInt("id", tiles[i][j].id);
        tile.setInt("x", j);
        tile.setInt("y", i);
        saveFile.append(tile);
      }
    }
    //saveJSONArray(saveFile, "data/maps/" + mapName + "/tiles.json");
    saveJSONArray(saveFile, "data/" + mapName + "_tiles.json"); 
  }
  
  void loadMap() {
    //JSONArray saveFile = loadJSONArray("/maps/" + mapName + "/tiles.json");
    for(int i = 0; i < mapHeight; i++) {
      for(int j = 0; j < mapWidth; j++) {
        tiles[i][j] = new Tile(0, new PVector(j*tileSize, i*tileSize));
      }
    }
    JSONArray saveFile = loadJSONArray(mapName + "_tiles.json");
    
    for(int i = 0; i < saveFile.size(); i++) {
      JSONObject tile = saveFile.getJSONObject(i);
      int x = tile.getInt("x");
      int y = tile.getInt("y");
      int id = tile.getInt("id");
      tiles[y][x] = new Tile(id, new PVector(x*tileSize, y*tileSize));
    }
  }
  
  /*
  void saveMap() {
    PrintWriter fileWriter = createWriter("data/" + map);
    fileWriter.println(mapWidth + " " + mapHeight);
    for(int i = 0; i < mapHeight; i++) {
      for(int j = 0; j < mapWidth; j++) {
         fileWriter.print(tiles[i][j].id);
         if(j != mapWidth-1) fileWriter.print(" ");
      }
      if(i != mapHeight-1) fileWriter.println();
    }
    fileWriter.close();
  }
  */
  
  void render() {
    float x = startX, y = startY;
    for(Tile[] i : tiles) {
      for(Tile j : i) {        
        if(x > 0 - tileSize && x < width && y > 0 - tileSize && y < height) image(tileTexture[j.id], x, y); 
        x += tileSize;
      }
      y += tileSize;
      x = startX;
    }
  }
  
  int getXCoordenate(float x) { 
    int mx = int((x) / tileSize);
    if(mx < mapWidth && mx >= 0) return mx;
    return -1;
  }
  
  int getYCoordenate(float y) {
    int my = int((y) / tileSize);
    if(my < mapHeight && my >= 0) return my;
    return -1;
  }
  
  void mousePressed(int selectedTile) {
    float x = (mouseX - startX) / tileSize;
    float y = (mouseY - startY) / tileSize;
    if(x < 0 || y < 0 || x > mapWidth || y > mapHeight) return;
    changeTile(int(x), int(y), selectedTile);
  }
  
  void changeTile(int x, int y, int selectedTile) {
    tiles[y][x].id = selectedTile;
  }

}
