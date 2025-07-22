class CollisionDetection {
 
  void playerMap(Player[] players, Map map) {
    for(Player i : players) {
      PVector newPosition = i.position.copy();
      
      newPosition.x += i.movement.x;
      
      if(i.movement.x > 0) {
        int x = map.getXCoordenate(newPosition.x + i.width);
        int y1 = map.getYCoordenate(newPosition.y);
        int y2 = map.getYCoordenate(newPosition.y + i.height);
        for(int j = y1; j < y2; j++) {
          if(map.tiles[j][x].isSolid()) {
            newPosition.x = map.tiles[j][x].position.x - i.width;
            i.movement.x = 0;
          }
        }       
      }
      
      if(i.movement.x < 0) {
        int x = map.getXCoordenate(newPosition.x);     
        int y1 = map.getYCoordenate(newPosition.y);
        int y2 = map.getYCoordenate(newPosition.y + i.height);        
        for(int j = y1; j < y2; j++) {
          if(map.tiles[j][x].isSolid()) {
            newPosition.x = map.tiles[j][x].position.x + map.tileSize;
            i.movement.x = 0;
          }
        }
      }
      
      newPosition.y += i.movement.y;
      
      if(i.movement.y > 0) {
        int y = map.getYCoordenate(newPosition.y + i.height);
        int x1 = map.getXCoordenate(newPosition.x);
        int x2 = map.getXCoordenate(newPosition.x + i.width);
        for(int j = x1; j <= x2; j++) {
          if(map.tiles[y][j].isSolid()) {
            newPosition.y = map.tiles[y][j].position.y - i.height;
            i.jumping = false;
          }
        }
      }
      
      if(i.movement.y < 0) {
        int y = map.getYCoordenate(newPosition.y);
        int x1 = map.getXCoordenate(newPosition.x);
        int x2 = map.getXCoordenate(newPosition.x + i.width);       
        for(int j = x1; j <= x2; j++) {
          if(map.tiles[y][j].isSolid()) newPosition.y = map.tiles[y][j].position.y + map.tileSize;
        }
      }     
      i.position = newPosition;
    }
  }
  
  void enemyMap(Enemy[] enemies, Map map) {
    for(Enemy i : enemies) {
      PVector newPosition = i.position.copy();
      
      newPosition.x += i.movement.x;
      
      if(i.movement.x > 0) {
        int x = map.getXCoordenate(newPosition.x + i.width);
        int y1 = map.getYCoordenate(newPosition.y);
        int y2 = map.getYCoordenate(newPosition.y + i.height);
        for(int j = y1; j < y2; j++) {
          if(map.tiles[j][x].isSolid()) {
            newPosition.x = map.tiles[j][x].position.x - i.width;
          }
        }       
      }
      
      if(i.movement.x < 0) {
        int x = map.getXCoordenate(newPosition.x);     
        int y1 = map.getYCoordenate(newPosition.y);
        int y2 = map.getYCoordenate(newPosition.y + i.height);        
        for(int j = y1; j < y2; j++) {
          if(map.tiles[j][x].isSolid()) {
            newPosition.x = map.tiles[j][x].position.x + map.tileSize;
          }
        }
      }
      
      newPosition.y += i.movement.y;
      
      if(i.movement.y > 0) {
        int y = map.getYCoordenate(newPosition.y + i.height);
        int x1 = map.getXCoordenate(newPosition.x);
        int x2 = map.getXCoordenate(newPosition.x + i.width);
        for(int j = x1; j <= x2; j++) {
          if(map.tiles[y][j].isSolid()) {
            newPosition.y = map.tiles[y][j].position.y - i.height;
          }
        }
      }
      
      if(i.movement.y < 0) {
        int y = map.getYCoordenate(newPosition.y);
        int x1 = map.getXCoordenate(newPosition.x);
        int x2 = map.getXCoordenate(newPosition.x + i.width);       
        for(int j = x1; j <= x2; j++) {
          if(map.tiles[y][j].isSolid()) newPosition.y = map.tiles[y][j].position.y + map.tileSize;
        }
      }     
      i.position = newPosition;
    }  
  }
  
  void playerEnemy(Player[] players, Enemy[] enemies) {
    for(Enemy e : enemies) {
      for(Player p : players) {
        if(e.position.x + e.width > p.position.x && e.position.x < p.position.x + p.width && e.position.y + e.height > p.position.y && e.position.y < p.position.y + p.height) {         
          if(e.getClass() == Goomba.class) {
            if(p.position.y + p.height < e.position.y + e.height * 0.8) {
              e.takeDamage();
              continue;
            }
          }          
          p.takeDamage();           
        }
      }
    }
  }
}
