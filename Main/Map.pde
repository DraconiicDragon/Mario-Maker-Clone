class Map {
  PImage tileTexture[];
  Tile tiles[][];
  int mapWidth;
  int mapHeight;
  float startX;
  float startY;
  float tileSize = 64;
  String map;
  
  Map(String map) {
    this.map = map;
    BufferedReader fileReader = createReader(map);
    String line;
    try {
      line = fileReader.readLine();
      String[] ids = split(line, " ");
      mapWidth = int(ids[0]);
      mapHeight = int(ids[1]);
      tiles = new Tile[mapHeight][mapWidth];
      int x = 0;
      int y = 0;
      while((line = fileReader.readLine()) != null) {
        ids = split(line, " ");      
        for(String i : ids) {   
          tiles[y][x] = new Tile(int(i), new PVector(x*tileSize, y*tileSize));
          x++;
        }
        x = 0;
        y++;
        
      }
    } catch(IOException e) {
      e.printStackTrace();
    }
    
    startX = (width - tileSize * mapWidth) / 2;
    startY = (height - tileSize * mapHeight) / 2;
    tileTexture = new PImage[3];
    tileTexture[0] = loadImage("tiles/0.png");
    tileTexture[1] = loadImage("tiles/1.png");
    tileTexture[2] = loadImage("tiles/2.png");
  }
  
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
