class Game {

  Map map;
  Player[] players;
  Enemy[] enemies;
  Player focusPlayer;
  CollisionDetection collisionDetection;
  Camera camera;
  
  float offsetX;
  float offsetY;
  float originalWindowWidth;
  float originalWindowHeight;
  
  final float MAX_ZOOM = 1.5;
  final float MIN_ZOOM = 0.5;
  
  Game() {
    originalWindowWidth = width;
    originalWindowHeight = height;
    map = new Map(120, 39);
    offsetX = map.startX;
    offsetY = map.startY;
    
    map.preloadMap();

    players = new Player[1];
    players[0] = new Player(60*16, 20*16, 64, 64);
    //players[1] = new Player(width/2 + 100, height/2, 30, 40);
    focusPlayer = players[0];
    
    enemies = new Enemy[1];
    enemies[0] = new Goomba(new PVector(width/2 + 200, height/2), 30, 40, 1);
    camera = new Camera(map.startX, map.startY);
    
    collisionDetection = new CollisionDetection();
  }
  
  void run() {
    tick();
    render();
  }
  
  void render() {
    map.render();
    for(Player i : players) {
      if(i.dead) continue;
      i.render(offsetX, offsetY);
    }
    for(Enemy i : enemies) {
      i.render(offsetX, offsetY);
    }
  }
  
  void tick() {
    for(Player i : players) {
      if(i.dead) continue;
      i.tick();      
    }/*
    for(Enemy i : enemies) {
      if(i.getClass() == Goomba.class) {
        if(i.position.x > focusPlayer.position.x) i.movementSpeed = -1;
        else if(i.position.x < focusPlayer.position.x) i.movement.x = 1;
      }
      i.tick();
      if(i.dead) {
        i.position = new PVector(width/2 + 200, height/2);
        i.dead = false;
      }
    }
    */
    collisionDetection.playerMap(players, map);
    collisionDetection.enemyMap(enemies, map);
    collisionDetection.playerEnemy(players, enemies);
    updateMapOffsets();    
  }
  
  void updateMapOffsets() {
    camera.updateOffsets(focusPlayer.position.x, focusPlayer.position.y);
    map.startX = offsetX;
    map.startY = offsetY;
  }
  
  void mousePressed() {
    map.mousePressed();
  }
  
  void keyPressed() {
    if(keyCode == 81) focusPlayer = players[1];
    if(keyCode == 69) focusPlayer = players[0];
    focusPlayer.keyPressed();
    
  }
  
  void keyReleased() {
    focusPlayer.keyReleased();
  }
  
}
