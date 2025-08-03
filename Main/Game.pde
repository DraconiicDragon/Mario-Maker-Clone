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
  ArrayList<PGraphics> stageSelectStages;
  PVector stagesPosition[];
  String[] stagesPath;
  int selectedTile;
  
  PVector focusPosition;
  
  boolean menu;
  boolean pause;
  boolean editing;
  boolean stageSelect;
  int selectedStage;
  
  float offsetX;
  float offsetY;
  
  Game() {
    menu = true;
    pause = false;
    editing = false;
    stageSelect = false;
    
    stagesPosition = new PVector[8];
    stagesPath = new String[8];
    
    buttons = new PVector[2];
    stageSelectStages = new ArrayList<>();
    
    titleScreen = loadImage("titlescreen.png");
    onePlayerButton = loadImage("1_player_button.png");
    buttons[0] = new PVector(width/2-onePlayerButton.width/2, height*0.7);
    mapEditButton = loadImage("map_edit_button.png");
    buttons[1] = new PVector(width/2-mapEditButton.width/2, height*0.76);
    selectArrow = loadImage("select_arrow.png");
    
    selectedButton = 0;
    selectedStage = 0;
    createEditMenu();
    
    players = new ArrayList<>();
    enemies = new ArrayList<>();
       
    collisionDetection = new CollisionDetection();    
    createStageSelectMenu();
  }  
  
  void createEditMenu() {
    editMenu = createGraphics(width, 84);
    editMenu.beginDraw();
    editMenu.background(50);
    PImage image = loadImage("tiles/0.png");
    editMenu.image(image, 0+10, 10);
    
    image = loadImage("tiles/1.png");
    editMenu.image(image, 64+20, 10);
    
    image = loadImage("tiles/2.png");
    editMenu.image(image, 128+30, 10);
    
    image = loadImage("enemies/goomba_0.png");
    editMenu.image(image, 192+40, 10);
    
    image = loadImage("enemies/boo_0.png");
    editMenu.image(image, 256+50, 10);
    
    image = loadImage("enemies/thwomp_0.png");
    editMenu.image(image, 320+60, 10, 64, 64);
    
    image = loadImage("players/small_mario_0.png");
    editMenu.image(image, 384+70, 10);
    editMenu.endDraw();
  }
  
  void createStageSelectMenu() {
    stageSelectStages = new ArrayList<>();
    File folder = new File(dataPath("maps"));
    String[] fileNames = folder.list();
    int cont = 0;
    for(String i : fileNames) {
      String j[] = split(i, "_");
      if(j[1].equals("icon.png")) {
        stagesPath[cont] = j[0];
        PImage image = loadImage("maps/"+i);
        stageSelectStages.add(createGraphics(int(width*0.2), int(height*0.4)));
        stageSelectStages.get(cont).beginDraw();
        stageSelectStages.get(cont).image(image, 0, 0, width*0.2, height*0.4);
        stageSelectStages.get(cont).endDraw();     
        cont++;
      }
    }
    for(int i = cont; i < 8; i++) {
      stagesPath[i] = "";
      stageSelectStages.add(createGraphics(int(width*0.2), int(height*0.4)));
      stageSelectStages.get(i).beginDraw();
      stageSelectStages.get(i).rect(0, 0, width*0.2, height*0.4);
      stageSelectStages.get(i).endDraw();
    }
    float x = width*0.04, y = height*0.06;      
    for(int i = 0; i < 8; i++) {
      stagesPosition[i] = new PVector(x, y);
      x += width*0.24;
      if(x >= width) {
        x = width*0.04;
        y += height*0.46;
      }
    }
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
    if(stageSelect) {
      push();
      fill(255, 204, 197);
      rect(0, 0, width, height);
      fill(50);
      rect(stagesPosition[selectedStage].x-width*0.01, stagesPosition[selectedStage].y-height*0.01, width*0.22, height*0.42);
      for(int i = 0; i < 8; i++) {
        image(stageSelectStages.get(i), stagesPosition[i].x, stagesPosition[i].y);
      }   
      pop();
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
      push();
      fill(255, 255, 255, 126);
      rect(map.getXCoordenate(mouseX)*64, map.getYCoordenate(mouseY)*64, 64, 64);
      pop();
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
       
    
    if(stageSelect) return;
    updateOffsets();
    if(editing) return;
    
    // Stops the game if the main player dies
    if(focusPlayer.deathAnimationFrameCont*3 > 255) {      
      menu = true;
      return;
    }
    
    for(Player i : players) {
      if(i.dead) continue;
      i.tick();      
    }
   
    for(Enemy i : enemies) {
      
      // "Unloads" offscreen or dead enemies
      if(i.dead || i.position.x > focusPlayer.position.x + width/2 + 256 || i.position.x < focusPlayer.position.x - width/2 - 256) continue;
      
      i.tick(focusPlayer);
    }
    collisionDetection.enemyMap(enemies, map);
    collisionDetection.playerEnemy(players, enemies);       
  }
  
  void createNewMap() {
    PrintWriter fileWriter = createWriter("data/maps/"+ selectedStage +"_tiles.txt");
    fileWriter.println(120 + " "+ 40);
    for(int i = 0; i < 40; i++) {
      for(int j = 0; j < 120; j++) {
        fileWriter.print("0");
        if(j != 119) fileWriter.print(" ");
      }
      if(i != 39) fileWriter.println();
    }
    fileWriter.close();
    fileWriter = createWriter("data/maps/"+ selectedStage +"_entities.txt");
    fileWriter.println("0 0 class Main$Player");
    fileWriter.close();
    fileWriter = createWriter("data/maps/"+ selectedStage +"_icon.png");
    fileWriter.close();
    //stagesPath[selectedStage] = selectedStage+"";
    createStageSelectMenu();
  }
  
  void loadMap(String path) {
    if(path.equals("maps/")) {      
      createNewMap();
      path += selectedStage;
    }
    players = new ArrayList<>();
    enemies = new ArrayList<>();
    map = new Map(path);
    loadEntities(path+"_entities.txt");
    focusPlayer = players.get(0);    
    camera = new Camera(map.startX, map.startY); 
    CollisionDetection.changeMap(map);
  }
  
  void saveEntities() {
    PrintWriter fileWriter = createWriter("data/maps/"+selectedStage+"_entities.txt");
    for(Player i : players) {
      fileWriter.println(i.position.x + " " + i.position.y + " " + i.getClass());
    }
    for(Enemy i : enemies) {
      fileWriter.println(i.position.x + " " + i.position.y + " " + i.getClass());
    }
    fileWriter.close();
  }
  
  void loadEntities(String path) {
    BufferedReader fileReader = createReader(path);
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
    if(editing && selectedTile < 3) map.mousePressed(selectedTile);
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
          stageSelect = true;           
          return;
        } else if(selectedButton == 1) {          
          menu = false;
          pause = false;
          editing = true;
          stageSelect = true;
          focusPosition = new PVector(width/2, height/2);
          return;
        }
      }
    }
    if(stageSelect) {
      if(keyCode == 68 && selectedStage + 1 < 8) selectedStage++;
      if(keyCode == 65 && selectedStage - 1 >= 0) selectedStage--;
      if(keyCode == 87 && selectedStage - 4 >= 0) selectedStage -= 4;
      if(keyCode == 83 && selectedStage + 4 < 8) selectedStage += 4;
      if(keyCode == 32) {      
        menu = false;
        pause = false;
        stageSelect = false;
        loadMap("maps/"+stagesPath[selectedStage]);
        if(selectedButton == 0) focusPosition = focusPlayer.position;
      }
    }
    if(editing) {
      if(keyCode == 87) focusPosition.y -= 64;
      if(keyCode == 83) focusPosition.y += 64;
      if(keyCode == 68) focusPosition.x += 64;
      if(keyCode == 65) focusPosition.x -= 64;
       
      if(keyCode == 49) selectedTile = 0;
      if(keyCode == 50) selectedTile = 1;
      if(keyCode == 51) selectedTile = 2;
      if(keyCode == 52) selectedTile = 100;
      if(keyCode == 53) selectedTile = 101;
      if(keyCode == 54) selectedTile = 102;
      if(keyCode == 55) selectedTile = 103;
      
      if(keyCode == 10) {
        map.saveMap();
        saveEntities();
        
        editing = false;
        menu = true;
      }
      return;      
    }
    
    if(!menu && !editing && !pause && !stageSelect) {
      focusPlayer.keyPressed();
      if(keyCode == 10) {
        menu = true;
      }
    }
  }
  
  void keyReleased() {
    if(!menu && !editing && !pause && !stageSelect) focusPlayer.keyReleased();
  }
  
}
