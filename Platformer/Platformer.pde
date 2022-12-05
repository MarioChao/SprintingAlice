// Project 1: Create a Platformer Game in Java //<>//

// Tiles size
static float tileSize = 50;
static float tileScale = tileSize / 128.0;
static float moveScale = tileSize / 25.0;

// Windows
static float RIGHT_MARGIN = 500 - tileSize;
static float LEFT_MARGIN = 200 + tileSize;
static float VERTICAL_MARGIN = tileSize * 3;

float viewX = 0, viewY = 0;

// Void height
static float VOID_HEIGHT = tileSize * 66;

// Settings
boolean printMap = false;
boolean showHitbox = false;

// Sprites
Player player;
HashMap<Integer, Sprite> spriteList;
ArrayList<Sprite> platforms, bgDeco, bgDeco2;
ArrayList<Sprite> items;
ArrayList<Sprite> creatures;
ArrayList<Sprite> goals;
Sprite coinHud, heartHud;

// Movements
//  Horizontal
float defaultMoveSpeed = 3 * moveScale;
//float moveSpeed;

//  Vertical
float defaultJumpPower = 6 * moveScale;
//float jumpPower;

// UIs
// Fonts
PFont ComicSansMS;

// Booleans
boolean isGameOver = false, isGameEnd = false,
isGameLoading = false, isGameLoaded = false,
isNewLevel = false, loadingDb;

//  Conditions
boolean touchingGround;
int leavingGround;

// Frames
int touchingGoalFrames;

// SETUP
void setup() {
  // Windows
  size(1000, 600);
  //fullScreen();
  
  // Images
  imageMode(CENTER); //<>//
  player = new Player("data/player.png", (tileSize * 0.93) / 80);
  createSpriteList();
  coinHud = new Sprite("data/hud/hudCoin.png", tileScale * 2);
  heartHud = new Sprite("data/hud/hudHeart_full.png", tileScale * 2);
  
  // Preset level and spawns
  levelId = initialLevel;
  initLevelSettings();
  initSpawnLocation();
  setLevel(levelId);
  
  // Init coordinate and attributes
  player.initPlayer();
  
  // UIs
  //  Fonts
  ComicSansMS = createFont("ComicSansMS", tileSize);
  
  // Booleans
  //  Debounces
  dbRight = false;
  dbLeft = false;
  dbUp = false;
  dbDown = false;
  dbSpace = false;
  
  //  Conditions
  touchingGround = false;
  leavingGround = 0;
  
  // Frames
  touchingGoalFrames = 0;
}

// DRAW
void draw() {
  // Game check
  translate(0, 0);
  if (isGameOver) {
    textAlign(CENTER);
    textFont(ComicSansMS);
    fill(255, 0, 0);
    text("GAME OVER", width / 2, height / 2);
    fill(0);
    text("Press Space to restart", width / 2, height / 2 + tileSize);
    noLoop();
  } else if (isGameEnd) {
    textAlign(CENTER);
    textFont(ComicSansMS);
    fill(0, 255, 0);
    text("YOU REACHED THE END!", width / 2, height / 2 - tileSize);
    fill(0);
    text("THANK YOU FOR PLAYING!", width / 2, height / 2);
    noLoop();
  } else if (isGameLoading) {
    textAlign(CENTER);
    textFont(ComicSansMS);
    fill(0);
    text("Loading...", width / 2, height - tileSize);
    isGameLoading = false;
    isGameLoaded = false;
    loadingDb = false;
  } else if (!isGameLoaded) {
    if (!loadingDb) {
      loadingDb = true;
      levelId = initialLevel;
      if (isNewLevel) {
        player.initPlayerPos();
        player.initPlayerPowerup();
      } else {
        player.initPlayer();
        coins = 0;
      }
      setLevel(levelId);
      loadingDb = false;
      touchedGoal = false;
    }
  } else if (courseClear) {
    if (touchingGoalFrames == 0) {
      textAlign(CENTER);
      textFont(ComicSansMS);
      textSize(tileSize * 2);
      fill(255, 190, 0);
      text("Course Clear!", width / 2, height / 2);
    }
    if (touchingGoalFrames >= 0 && touchingGoalFrames < 60 * 2) {
      touchingGoalFrames++;
    } else if (touchingGoalFrames > 0) {
      textAlign(CENTER);
      textFont(ComicSansMS);
      fill(0);
      text("Loading next level...", width / 2, height - tileSize);
      touchingGoalFrames = -1;
    } else {
      touchingGoalFrames = 0;
      nextLevel();
      courseClear = false;
    }
  } else if (isGameLoaded) {
    draw2();
  }
}
void draw2() {
  // Resize
  cameraZoom();
  
  // Values
  // -Horizontal component
  double kP = (touchingGround ? 0.07 : 0.045);
  double error = 0;
  if ((player.isDucking && touchingGround)) {
    error = -player.getSpeedX();
  } else if ((dbRight || dbLeft) && !(dbRight && dbLeft)) {
    if (dbRight) error = player.moveSpeed - player.getSpeedX();
    else if (dbLeft) error = -player.moveSpeed - player.getSpeedX();
  } else if (!player.isDucking) {
    error = -player.getSpeedX();
  }
  player.setSpeedX(player.getSpeedX() + (float) (error * kP));
  
  // -Vertical component
  // --Jump
  player.resolveJump();
  
  // Move and check physics
  fallCollide(player, platforms); // Move player
  checkItemCollisions(player, items); // Check items
  for (Sprite goal : player.getCollided(goals)) { // Check goals
    ((Goal) goal).onTouch();
    break;
  }
  touchingGround = checkTouchGround(player, platforms);
  
  // Player death
  if (player.getY() > VOID_HEIGHT) {
    player.onDeath();
  }
  
  // Move screen
  scroll();
  
  // Draw
  // -Clear screen
  //background(255); 
  background(backgroundColor.getOrDefault(levelId, new Color(230, 230, 230)).getRGB());
  
  // -Load map
  for (Sprite tile : platforms) {
    tile.display();
  }
  
  // -Load items
  for (Sprite item : items) {
    item.display();
    ((AnimatedSprite) item).updateAnimation();
  }
  
  // -Load deco
  for (Sprite deco : bgDeco) {
    deco.display();
  }
  for (Sprite deco : bgDeco2) {
    deco.display();
  }
  
  // -Load goals
  for (Sprite goal : goals) {
    goal.display();
    ((AnimatedSprite) goal).updateAnimation();
  }
  
  // -Enemies
  for (Sprite c : creatures) {
    c.display();
    ((AnimatedSprite) c).updateAnimation();
    ((Enemy) c).move(platforms);
    ((Enemy) c).checkHit(player);
    if (c.getY() > VOID_HEIGHT) {
      c.setVisibility(false);
    }
  }
  
  // -Player
  player.display();
  ((AnimatedSprite) player).updateAnimation();
  
  // -GUIs / HUDs
  // --Lives
  heartHud.setX(viewX + tileSize * 1.5);
  heartHud.setY(viewY + tileSize * 1.5);
  textAlign(LEFT);
  textFont(ComicSansMS);
  fill(255, 0, 0);
  text(String.format("× %d", player.lives), viewX + tileSize * 2.5, viewY + tileSize * 1.75);
  heartHud.display();
  // --Coins
  coinHud.setX(viewX + tileSize * 1.5);
  coinHud.setY(viewY + tileSize * 3.5);
  coinHud.display();
  fill(255, 255, 0);
  text(String.format("× %d", coins), viewX + tileSize * 2.5, viewY + tileSize * 3.75);
  
  // -Debug
  if (showHitbox) {
    // Tiles
    stroke(255, 0, 0);
    fill(0, 0);
    for (Sprite tile : platforms) {
      rect(tile.getLeft(), tile.getTop(), tile.getW(), tile.getH());
    }
    // Creatures
    stroke(255, 255, 0);
    for (Sprite creature : creatures) {
      rect(creature.getLeft(), creature.getTop(), creature.getW(), creature.getH());
    }
    // Player
    stroke(0, 255, 0);
    rect(player.getLeft(), player.getTop(), player.getW(), player.getH());
  }
}

// Create a list of sprites
void createSpriteList() {
  spriteList = new HashMap<Integer, Sprite> ();
  spriteList.put(1, new Sprite("data/brown_brick.png", tileScale));
  spriteList.put(2, new Sprite("data/red_brick.png", tileScale));
  spriteList.put(3, new Sprite("data/crates/boxCrate_double.png", tileScale));
  spriteList.put(4, new Sprite("data/crates/boxCrate_single.png", tileScale));
  spriteList.put(5, new Sprite("data/crates/boxCrate.png", tileScale));
  
  spriteList.put(101, new Coin("data/coins/normalCoinUnscaled/mergedimage.png", tileSize / 240));
  spriteList.put(102, new PowerUp("data/moon_full.png", tileSize / 90));
  spriteList.put(103, new PowerUp("data/cloud1.png", tileSize / 190));
  
  spriteList.put(201, new Sprite("data/sun.png", tileSize / 90 * 2));
  
  spriteList.put(301, new Sprite("data/snow.png", tileScale));
  spriteList.put(311, new Sprite("data/signRight.png", tileScale));
  spriteList.put(312, new Sprite("data/signLeft.png", tileScale));
  
  spriteList.put(401, new BlueSlime("data/enemies/slimeBlue/slimeBlue.png", 0, 0, tileScale, 0.5, 0, new EnemySettings(true)));
  spriteList.put(402, new BlueSlime("data/enemies/slimeBlue/slimeBlue.png", 0, 0, tileScale, 0.5, 0, new EnemySettings(false)));
  spriteList.put(403, new BlackFly("data/enemies/flyBlack/fly.png", 0, 0, tileScale, 0, 0, new EnemySettings(false, true, true)));
  
  spriteList.put(1001, new Goal("data/flags/flagGreen1.png", "Green", tileScale));
  spriteList.put(1100, new Goal("data/flags/flagPole.png", "Pole", tileScale));
}

// Create platforms sprite from CSV file
void createPlatforms(String filename) {
  platforms = new ArrayList<Sprite> ();
  items = new ArrayList<Sprite> ();
  bgDeco = new ArrayList<Sprite> ();
  bgDeco2 = new ArrayList<Sprite> ();
  creatures = new ArrayList<Sprite> ();
  goals = new ArrayList<Sprite> ();
  float x, y;
  String[] lines = loadStrings(filename);
  for (int row = 0; row < lines.length; row++) {
    String[] values = split(lines[row], ",");
    for (int col = 0; col < values.length; col++) {
      // Get value
      String value = values[col];
      if (value.length() == 0) continue;
      if ("1234567890".indexOf(value.charAt(0)) == -1) {
        value = value.substring(1);
      }
      if (value.length() == 0) continue;
      if(printMap) print(value);
      // Get coordinate
      x = col * tileSize + tileSize / 2.0;
      y = row * tileSize + tileSize / 2.0;
      // Apply sprite
      int index = Integer.parseInt(value);
      if (index == 0 || !spriteList.containsKey(index)) continue;
      Sprite o = spriteList.get(index);
      Sprite s = new AnimatedSprite(o.getImg(), x, y, o.getScale());
      if (index <= 100) {
        platforms.add(s);
      } else if (index <= 200) {
        if (index == 101) {
          Coin c = new Coin(s.getImg(), x, y, s.getScale());
          items.add(c);
        } else if (index == 102){
          PowerUp p = new JumpBoost(s.getImg(), x, y, s.getScale());
          items.add(p);
        } else if (index == 103) {
          PowerUp p = new SpeedBoost(s.getImg(), x, y, s.getScale());
          items.add(p);
        } else {
          items.add(s);
        }
      } else if (index <= 300) {
        bgDeco.add(s);
      } else if (index <= 400) {
        bgDeco2.add(s);
      } else if (index <= 500) {
        Sprite enemy = new Enemy(o.getImg(), x, y, o.getScale(), o.getSpeedX(), o.getSpeedY());
        if (index == 401) {
          enemy = new BlueSlime(o.getImg(), x, y, o.getScale(), o.getSpeedX(), o.getSpeedY(), ((Enemy) o).getEnemyInfo());
        } else if (index == 402) {
          enemy = new BlueSlime(o.getImg(), x, y, o.getScale(), o.getSpeedX(), o.getSpeedY(), ((Enemy) o).getEnemyInfo());
        } else if (index == 403) {
          enemy = new BlackFly(o.getImg(), x, y, o.getScale(), o.getSpeedX(), o.getSpeedY(), ((Enemy) o).getEnemyInfo());
        }
        creatures.add(enemy);
      } else {
        Goal g = new Goal(s.getImg(), ((Goal) o).getType(), x, y, s.getScale());
        goals.add(g);
      }
    }
    if (printMap) println();
  }
}

// Check touched items
void checkItemCollisions(Sprite plyr, ArrayList<Sprite> items) {
  ArrayList<Sprite> col_list = plyr.getCollided(items);
  for (Sprite collided : col_list) {
    collided.setVisibility(false);
  }
}
