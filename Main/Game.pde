class Game {

  Map map;
  ArrayList<Player> players;
  ArrayList<Enemy> enemies;
  Player focusPlayer;
  CollisionDetection collisionDetection;
  Camera camera;
  
  PImage titleScreen;
  PImage onePlayerButton;
  PImage mapEditButton;
  PImage selectArrow;
  
  int selectedButton;  
  PVector buttons[];
  
  PGraphics editMenu;
  int selectedTile;
  
  PVector focusPosition;
  
  boolean menu;
  boolean pause;
  boolean editing;
  
  float offsetX;
  float offsetY;
  
  Game() {
    menu = true;
    pause = false;
    editing = false;
    
    buttons = new PVector[2];
    
    titleScreen = loadImage("titlescreen.png");
    onePlayerButton = loadImage("1_player_button.png");
    buttons[0] = new PVector(width/2-onePlayerButton.width/2, height*0.7);
    mapEditButton = loadImage("map_edit_button.png");
    buttons[1] = new PVector(width/2-mapEditButton.width/2, height*0.76);
    selectArrow = loadImage("select_arrow.png");
    
    selectedButton = 0;
    createEditMenu();
    
    players = new ArrayList<>();
    enemies = new ArrayList<>();
    collisionDetection = new CollisionDetection();
    
    
    map = new Map("maps/0_tiles.txt");
    loadEntities();
    focusPlayer = players.get(0);    
    camera = new Camera(map.startX, map.startY);    
  }
  
  void createEditMenu() {
    editMenu = createGraphics(width, 84);
    editMenu.beginDraw();
    editMenu.background(50);
    PImage image = loadImage("tiles/0.png");
    editMenu.image(image, 0+10, 10);
    
    image = loadImage("tiles/1.png");
    editMenu.image(image, 64+20, 10);
    
    image = loadImage("enemies/goomba_0.png");
    editMenu.image(image, 128+30, 10);
    
    image = loadImage("enemies/boo_0.png");
    editMenu.image(image, 192+40, 10);
    
    image = loadImage("enemies/thwomp_0.png");
    editMenu.image(image, 256+50, 10, 64, 64);
    
    image = loadImage("players/small_mario_0.png");
    editMenu.image(image, 320+60, 10);
    editMenu.endDraw();
  }
  
  void run() {
    tick();
    render();
  }
  
  void render() {
    
    if(menu) {
      image(titleScreen, 0, 0, width, height);
      image(onePlayerButton, buttons[0].x, buttons[0].y);
      image(mapEditButton, buttons[1].x, buttons[1].y);
      image(selectArrow, buttons[selectedButton].x - selectArrow.width, buttons[selectedButton].y);
      return;
    }
    
    map.render();    
    for(Enemy i : enemies) {     
      // Stops rendering the enemy if hes dead for more than 20 frames
      if(i.framesDead > 20) continue;
      
      i.render(offsetX, offsetY);
    }
    
    for(Player i : players) {
      i.render(offsetX, offsetY);
    }
    
    if(editing) {
      if(offsetY < 0) image(editMenu, 0, 0);
      else if(offsetY == 0) image(editMenu, 0, height-84);
      return;
    }
    
    // Blackscreen overlay during death animation
    if(focusPlayer.deathAnimationFrameCont > 0) {
      fill(0, 0, 0, focusPlayer.deathAnimationFrameCont*3);
      rect(0, 0, width, height);
    }
  }
  
  void tick() {
       
    if(menu) return;
    
    updateOffsets();
       
    if(editing) return;
    
    // Stops the game if the main player dies
    if(focusPlayer.dead) {
      
      return;
    }
    
    for(Player i : players) {
      i.tick();      
    }
   
    for(Enemy i : enemies) {
      
      // "Unloads" offscreen or dead enemies
      if(i.dead || i.position.x > focusPlayer.position.x + width/2 + 256 || i.position.x < focusPlayer.position.x - width/2 - 256) continue;
      
      i.tick(focusPlayer);
    }
    collisionDetection.playerMap(players, map);
    collisionDetection.enemyMap(enemies, map);
    collisionDetection.playerEnemy(players, enemies);
       
  }
  
  void saveEntities() {
    PrintWriter fileWriter = createWriter("data/maps/0_entities.txt");
    for(Player i : players) {
      fileWriter.println(i.position.x + " " + i.position.y + " " + i.getClass());
    }
    for(Enemy i : enemies) {
      fileWriter.println(i.position.x + " " + i.position.y + " " + i.getClass());
    }
    fileWriter.close();
  }
  
  void loadEntities() {
    BufferedReader fileReader = createReader("maps/0_entities.txt");
    String line;
    try {
      while((line = fileReader.readLine()) != null) {
        String[] data = split(line, " ");     
        float x = float(data[0]);
        float y = float(data[1]);
        String entityType = data[3];
        addEntityToList(x, y, entityType);
      }
    } catch(IOException e) {
      e.printStackTrace();
    }
  }
  
  void addEntityToList(float x, float y, String entityType) {
    if(entityType.equals("Main$Player")) players.add(new Player(x, y));
    else if(entityType.equals("Main$Goomba")) enemies.add(new Goomba(new PVector(x, y)));
    else if(entityType.equals("Main$Boo")) enemies.add(new Boo(new PVector(x, y)));
    else if(entityType.equals("Main$Thwomp")) enemies.add(new Thwomp(new PVector(x, y)));
  }
  
  // Updates the camera offset and the map offset
  void updateOffsets() {
    camera.updateOffsets(focusPosition.x, focusPosition.y);
    map.startX = offsetX;
    map.startY = offsetY;
  }
  
  void mousePressed() {
    if(editing && selectedTile < 2) map.mousePressed(selectedTile);
    if(editing && selectedTile > 99) {
      
      if(selectedTile == 100) enemies.add(new Goomba(new PVector(mouseX-offsetX, mouseY-offsetY)));
      else if(selectedTile == 101) enemies.add(new Boo(new PVector(mouseX-offsetX, mouseY-offsetY)));
      else if(selectedTile == 102) enemies.add(new Thwomp(new PVector(mouseX-offsetX, mouseY-offsetY)));
      else if(selectedTile == 103) {
        focusPlayer.position.x = mouseX-offsetX;
        focusPlayer.position.y = mouseY-offsetY;
      }
    }
  }
  
  void keyPressed() {
    println(keyCode);
    if(menu) {
      if(keyCode == 87) {
      selectedButton--;
      if(selectedButton < 0) selectedButton = 0;
      }
      else if(keyCode == 83) {
        selectedButton++;
        if(selectedButton > 1) selectedButton = 1;
      }
      if(keyCode == 32) {
        if(selectedButton == 0) {
          menu = false;
          pause = false;
          editing = false;
          focusPosition = focusPlayer.position;
          return;
        } else if(selectedButton == 1) {
          menu = false;
          pause = false;
          editing = true;
          focusPosition = new PVector(width/2, height/2);
          return;
        }
      }
    }
    if(editing) {
      if(keyCode == 87) focusPosition.y -= 64;
      if(keyCode == 83) focusPosition.y += 64;
      if(keyCode == 68) focusPosition.x += 64;
      if(keyCode == 65) focusPosition.x -= 64;
       
      if(keyCode == 49) selectedTile = 0;
      if(keyCode == 50) selectedTile = 1;
      if(keyCode == 51) selectedTile = 100;
      if(keyCode == 52) selectedTile = 101;
      if(keyCode == 53) selectedTile = 102;
      if(keyCode == 54) selectedTile = 103;
      
      if(keyCode == 10) {
        map.saveMap();
        saveEntities();
        
        editing = false;
        menu = true;
      }
      return;      
    }
    
    if(!menu && !editing && !pause) focusPlayer.keyPressed();    
  }
  
  void keyReleased() {
    focusPlayer.keyReleased();
  }
  
}
