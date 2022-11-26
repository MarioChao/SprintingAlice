// Project 1: Create a Platformer Game in Java

// Tiles size
static float tileSize = 50;
static float tileScale = tileSize / 128.0;
static float moveScale = tileSize / 25.0;

// Windows
float RIGHT_MARGIN = 500 - tileSize;
float LEFT_MARGIN = 200 + tileSize;
float VERTICAL_MARGIN = tileSize;

final static int windowWidth = 1000;
final static int windowHeight = 600;
float viewX = 0, viewY = 0;

// Void height
float VOID_HEIGHT = tileSize * 66;

// Spawn location
float[][] spawnLocation;

// Level
int levelId = 1;

// Settings
boolean showHitbox = true;

// Sprites
Sprite player;
HashMap<Integer, Sprite> spriteList;
ArrayList<Sprite> platforms, bgDeco, bgDeco2;
ArrayList<Sprite> items;
ArrayList<Sprite> creatures;
ArrayList<Sprite> goals;
Sprite coinUi;

// Movements
//  Horizontal
float moveSpeed;

//  Vertical
float jumpPower;

// UIs
// Fonts
PFont ComicSansMS;

// Booleans
//  Debounces
boolean dbRight, dbLeft, dbUp, dbDown;
boolean dbSpace;
boolean dbMapChng;

//  Conditions
boolean touchingGround;
int leavingGround;

// SETUP
void setup() {
  // Windows
  size(1000, 600);
  //fullScreen();
  
  // Images
  imageMode(CENTER); //<>//
  player = new Player("data/player.png", (tileSize - 2) / 80);
  createSpriteList();
  coinUi = new Sprite("data/hudCoin.png", (tileSize * 2) / 128);
  
  
  // Preset level and spawns
  levelId = 3;
  setLevel(levelId);
  initSpawnLocation();
  
  // Init coordinate
  initPlayer();
  
  // Movements
  //  Horizontal
  moveSpeed = 3 * moveScale;
  
  //  Vertical
  jumpPower = 6 * moveScale;
  
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
  dbMapChng = false;
  
  //  Conditions
  touchingGround = false;
  leavingGround = 0;
}

void setLevel(int lvl){
  if (lvl == 1) createPlatforms("data/maps/map1.csv");
  if (lvl == 3) createPlatforms("data/maps/map3.csv");
}

// DRAW
void draw() {
  // Values
  //  Horizontal component
  double kP = (touchingGround ? 0.07 : 0.045);
  double error = 0;
  if ((dbRight || dbLeft) && !(dbRight && dbLeft)) {
    if (dbRight) error = moveSpeed - player.getSpeedX();
    else if (dbLeft) error = -moveSpeed - player.getSpeedX();
  } else {
    error = -player.getSpeedX();
  }
  player.setSpeedX(player.getSpeedX() + (float) (error * kP));
  
  //  Vertical component
  //player.addSpeedY(gravityAcclr);
  //   Jump
  ((Player) player).resolveJump();
  
  // Move and check physics
  fallCollide(player, platforms);
  checkItemCollisions(player, items);
  player.addY(5);
  touchingGround = player.getCollided(platforms).size() > 0;
  player.addY(-5);
  
  // Player death
  if (player.getY() > VOID_HEIGHT) {
    onDeath();
  }
  
  // Move screen
  scroll();
  
  // Draw
  // -Clear screen
  //background(255); 
  background(230);
  
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
  }
  
  // -Enemies
  for (Sprite c : creatures) {
    c.display();
    ((AnimatedSprite) c).updateAnimation();
    ((Enemy) c).move(platforms);
    ((Enemy) c).checkHit(player);
    if (c.getY() > VOID_HEIGHT) {
      c.setVisibility(false);
      c = null;
    }
  }
  
  // -Player
  player.display();
  ((AnimatedSprite) player).updateAnimation();
  
  // -UIs
  // --Coins
  coinUi.setX(viewX + tileSize * 1.5);
  coinUi.setY(viewY + tileSize * 1.5);
  coinUi.display();
  textAlign(LEFT);
  textFont(ComicSansMS);
  fill(255, 255, 0);
  text(String.format("× %d", coins), viewX + tileSize * 2.5, viewY + tileSize * 1.75);
  
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
  spriteList.put(3, new Sprite("data/crate.png", tileScale));
  
  spriteList.put(101, new Coin("data/coins/normalCoinUnscaled/mergedimage.png", tileSize / 240));
  
  spriteList.put(201, new Sprite("data/sun.png"));
  
  spriteList.put(301, new Sprite("data/snow.png", tileScale));
  
  spriteList.put(401, new BlueSlime("data/enemies/slimeBlue/slimeBlue.png", 0, 0, tileScale, 0.5, 0, true));
  spriteList.put(402, new BlueSlime("data/enemies/slimeBlue/slimeBlue.png", 0, 0, tileScale, 0.5, 0, false));
  
  spriteList.put(1001, new Sprite("data/flags/flagGreen1.png", tileScale));
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
      print(value);
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
        } else {
          items.add(s);
        }
      } else if (index <= 300) {
        bgDeco.add(s);
      } else if (index <= 400) {
        bgDeco2.add(s);
      } else if (index <= 500) {
        if (index == 401) {
          Sprite enemy = new BlueSlime(o.getImg(), x, y, o.getScale(), o.getSpeedX(), o.getSpeedY(), ((Enemy) o).getWillWalkOff());
          creatures.add(enemy);
        } else if (index == 402) {
          Sprite enemy = new BlueSlime(o.getImg(), x, y, o.getScale(), o.getSpeedX(), o.getSpeedY(), ((Enemy) o).getWillWalkOff());
          creatures.add(enemy);
        }
      } else {
        goals.add(s);
      }
    }
    println();
  }
}

// Set spawn location
void initSpawnLocation() {
  spawnLocation = new float[5][2]; // 5 levels, {x, y}
  spawnLocation[0][0] = tileSize * 29.5;
  spawnLocation[0][1] = tileSize * 51.5;
  spawnLocation[2][0] = tileSize * 1.5;
  spawnLocation[2][0] = tileSize * 17.5;
}

// Reset Player Position
void initPlayer() {
  player.setX(spawnLocation[levelId - 1][0]);
  player.setY(spawnLocation[levelId - 1][1]);
  player.setSpeedX(0);
  player.setSpeedY(0);
  viewX = tileSize * 1000;
  viewY = spawnLocation[levelId - 1][1] - tileSize * 16.5;
  dbRight = dbLeft = dbUp = dbDown = dbSpace = false;
}

// On Death
void onDeath() {
  initPlayer();
}

// Keyboard inputs
void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      if (dbRight) return;
      dbRight = true;
    }
    if (keyCode == LEFT) {
      if (dbLeft) return;
      dbLeft = true;
    }
    if (keyCode == UP) {
      if (dbUp) return;
      dbUp = true;
    }
    if (keyCode == DOWN) {
      if (dbDown) return;
      dbDown = true;
    }
  }
  if (key == ' ') {
    if (dbSpace) return;
    dbSpace = true;
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      if (!dbRight) return;
      dbRight = false;
    }
    if (keyCode == LEFT) {
      if (!dbLeft) return;
      dbLeft = false;
    }
    if (keyCode == UP) {
      if (!dbUp) return;
      dbUp = false;
    }
    if (keyCode == DOWN) {
      if (!dbDown) return;
      dbDown = false;
    }
  }
  if (key == ' ') {
    if (!dbSpace) return;
    dbSpace = false;
  }
}

void checkItemCollisions(Sprite plyr, ArrayList<Sprite> items) {
  ArrayList<Sprite> col_list = plyr.getCollided(items);
  for (Sprite collided : col_list) {
    collided.setVisibility(false);
  }
}

// Scroll screen
void scroll() {
  float rightBoundary = viewX + width - RIGHT_MARGIN;
  if (player.getRight() > rightBoundary) {
    viewX += player.getRight() - rightBoundary;
  }
  float leftBoundary = viewX + LEFT_MARGIN;
  if (player.getLeft() < leftBoundary) {
    viewX -= leftBoundary - player.getLeft();
  }
  float topBoundary = viewY + VERTICAL_MARGIN;
  if (player.getTop() < topBoundary) {
    viewY -= topBoundary - player.getTop();
  }
  float bottomBoundary = viewY + height - VERTICAL_MARGIN;
  if (player.getBottom() > bottomBoundary) {
    viewY += player.getBottom() - bottomBoundary;
  }
  translate(-viewX, -viewY);
}
