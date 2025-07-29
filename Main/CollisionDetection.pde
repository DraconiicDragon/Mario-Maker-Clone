class CollisionDetection {
 
  void playerMap(ArrayList<Player> players, Map map) {
    for(Player i : players) {
           
      if(i.movement.x > 0) {
        int x = map.getXCoordenate(i.position.x + i.width);
        int y1 = map.getYCoordenate(i.position.y);
        int y2 = map.getYCoordenate(i.position.y + i.height);
        for(int j = y1; j < y2; j++) {
          if(map.tiles[j][x].isSolid()) {
            i.position.x = map.tiles[j][x].position.x - i.width;
            i.movement.x = 0;
          }
        }       
      }
      
      if(i.movement.x < 0) {
        int x = map.getXCoordenate(i.position.x);     
        int y1 = map.getYCoordenate(i.position.y);
        int y2 = map.getYCoordenate(i.position.y + i.height);        
        for(int j = y1; j < y2; j++) {
          if(map.tiles[j][x].isSolid()) {
            i.position.x = map.tiles[j][x].position.x + map.tileSize;
            i.movement.x = 0;
          }
        }
      }
                 
      if(i.movement.y > 0) {
        int y = map.getYCoordenate(i.position.y + i.height);
        int x1 = map.getXCoordenate(i.position.x);
        int x2 = map.getXCoordenate(i.position.x + i.width - 1);
        for(int j = x1; j <= x2; j++) {
          if(map.tiles[y][j].isSolid()) {
            i.position.y = map.tiles[y][j].position.y - i.height;
            i.jumping = false;
          }
        }
      }
      
      if(i.movement.y < 0) {
        int y = map.getYCoordenate(i.position.y);
        int x1 = map.getXCoordenate(i.position.x);
        int x2 = map.getXCoordenate(i.position.x + i.width - 1);       
        for(int j = x1; j <= x2; j++) {
          if(map.tiles[y][j].isSolid()) i.position.y = map.tiles[y][j].position.y + map.tileSize;
        }
      }     
    }
  }
  
  void enemyMap(ArrayList<Enemy> enemies, Map map) {
    for(Enemy i : enemies) {
      
      if(i.getClass() == Boo.class) continue;
                 
      if(i.movement.x > 0) {
        int x = map.getXCoordenate(i.position.x + i.width);
        int y1 = map.getYCoordenate(i.position.y);
        int y2 = map.getYCoordenate(i.position.y + i.height);
        for(int j = y1; j < y2; j++) {
          if(map.tiles[j][x].isSolid()) {
            i.position.x = map.tiles[j][x].position.x - i.width;
          }
        }       
      }
      
      if(i.movement.x < 0) {
        int x = map.getXCoordenate(i.position.x);     
        int y1 = map.getYCoordenate(i.position.y);
        int y2 = map.getYCoordenate(i.position.y + i.height);        
        for(int j = y1; j < y2; j++) {
          if(map.tiles[j][x].isSolid()) {
            i.position.x = map.tiles[j][x].position.x + map.tileSize;
          }
        }
      }
      
      if(i.movement.y > 0) {
        int y = map.getYCoordenate(i.position.y + i.height);
        int x1 = map.getXCoordenate(i.position.x);
        int x2 = map.getXCoordenate(i.position.x + i.width);
        for(int j = x1; j <= x2; j++) {
          if(map.tiles[y][j].isSolid()) {
            i.position.y = map.tiles[y][j].position.y - i.height;
            i.downCollision = true;
          }
        }
      }
      
      if(i.movement.y < 0) {
        int y = map.getYCoordenate(i.position.y);
        int x1 = map.getXCoordenate(i.position.x);
        int x2 = map.getXCoordenate(i.position.x + i.width);       
        for(int j = x1; j <= x2; j++) {
          if(map.tiles[y][j].isSolid()) i.position.y = map.tiles[y][j].position.y + map.tileSize;
        }
      }     
    }  
  }
  
  void playerEnemy(ArrayList<Player> players, ArrayList<Enemy> enemies) {
    for(Enemy e : enemies) {
      if(e.dead) continue;
      for(Player p : players) {
        if(e.position.x + e.width > p.position.x && e.position.x < p.position.x + p.width && e.position.y + e.height > p.position.y && e.position.y < p.position.y + p.height) {         
          if(e.getClass() == Goomba.class) {
            if(p.position.y + p.height < e.position.y + e.height * 0.8) {
              e.takeDamage();
              p.movement.y = -p.JUMP_SPEED;
              continue;
            }
          }          
          p.takeDamage();           
        }
      }
    }
  }
}
