static class CollisionDetection {
  
  static Map map;
  
  static void changeMap(Map newMap) {
    map = newMap;
  }
  
  static void playerXMap(Player player) {
    if(player.movement.x > 0) {
      int x = map.getXCoordenate(player.position.x + player.width);
      int y1 = map.getYCoordenate(player.position.y);
      int y2 = map.getYCoordenate(player.position.y + player.height);
      if(x == -1 || y1 == -1 || y2 == -1) {
        player.die();
        return;
      }
      for(int j = y1; j < y2; j++) {          
        if(map.tiles[j][x].isSolid()) {
          player.position.x = map.tiles[j][x].position.x - player.width;
          player.movement.x = 0;
        }
      }       
    }
    if(player.movement.x < 0) {
      int x = map.getXCoordenate(player.position.x);     
      int y1 = map.getYCoordenate(player.position.y);
      int y2 = map.getYCoordenate(player.position.y + player.height);
      if(x == -1 || y1 == -1 || y2 == -1) {
        player.die();
        return;
      }
      for(int j = y1; j < y2; j++) {
        if(map.tiles[j][x].isSolid()) {
          player.position.x = map.tiles[j][x].position.x + map.tileSize;
          player.movement.x = 0;
        }
      }
    }
  }
  
  static void playerYMap(Player player) {
    if(player.movement.y > 0) {
      int y = map.getYCoordenate(player.position.y + player.height);
      int x1 = map.getXCoordenate(player.position.x);
      int x2 = map.getXCoordenate(player.position.x + player.width-1);
      if(y == -1 || x1 == -1 || x2 == -1) {
        player.die();
        return;
      }
      for(int j = x1; j <= x2; j++) {
        if(map.tiles[y][j].isSolid()) {
          player.position.y = map.tiles[y][j].position.y - player.height;
          player.downCollision();
        }
      }
    }
    if(player.movement.y < 0) {
      int y = map.getYCoordenate(player.position.y);
      int x1 = map.getXCoordenate(player.position.x);
      int x2 = map.getXCoordenate(player.position.x + player.width-1);
      if(y == -1 || x1 == -1 || x2 == -1) {
        player.die();
        return;
      }
      for(int j = x1; j <= x2; j++) {
        if(map.tiles[y][j].isSolid()) {
          player.position.y = map.tiles[y][j].position.y + map.tileSize;
          player.upCollision();
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
        if(x == -1 || y1 == -1 || y2 == -1) {
          i.dead = true;
          return;
        }
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
        if(x == -1 || y1 == -1 || y2 == -1) {
          i.dead = true;
          return;
        }
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
        if(y == -1 || x1 == -1 || x2 == -1) {
          i.dead = true;
          return;
        }
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
        if(y == -1 || x1 == -1 || x2 == -1) {
          i.dead = true;
          return;
        }
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
              p.movement.y = -p.JUMP_HEIGHT;
              continue;
            }
          }          
          p.takeDamage();           
        }
      }
    }
  }
}
