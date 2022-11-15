// Project 1: Create a Platformer Game in Java

// Windows
float RIGHT_MARGIN = 500;
float LEFT_MARGIN = 200;
float VERTICAL_MARGIN = 20;
float viewX = 0, viewY = 0;

// Tiles size
float tileSize = 25;
float tileScale = tileSize / 128.0;

// Void height
float VOID_HEIGHT = tileSize * 66;

// Spawn location
float[][] spawnLocation;

// Level
int levelId = 1;

// Settings
boolean showHitbox = false;

// Sprites
Sprite player;
HashMap<Integer, Sprite> spriteList;
ArrayList<Sprite> platforms, bgDeco;
ArrayList<AnimatedSprite> items;

// Movements
//  Horizontal
float moveSpeed;

//  Vertical
float gravityAcclr;
float jumpPower;

// Booleans
//  Debounces
boolean dbRight, dbLeft, dbUp, dbMapChng;

//  Conditions
boolean touchingGround;
int leavingGround;
float leavingLimit;

// SETUP
void setup() {
  // Windows
  size(1000, 600);
  
  // Images
  imageMode(CENTER);
  //player = new Sprite("data/player.png", (tileSize - 2) / 60); //<>//
  player = new Player("data/player.png", (tileSize - 2) / 60);
  createSpriteList();
  createPlatforms("data/maps/map1.csv");
  
  // Preset level and spawns
  initSpawnLocation();
  levelId = 1;
  
  // Init coordinate
  initPlayer();
  
  // Movements
  //  Horizontal
  moveSpeed = 3;
  
  //  Vertical
  gravityAcclr = 9.8 / 60;
  jumpPower = 6;
  
  // Booleans
  //  Debounces
  dbRight = false;
  dbLeft = false;
  dbUp = false;
  dbMapChng = false;
  
  //  Conditions
  touchingGround = false;
  leavingGround = 0;
}

// DRAW
void draw() {
  // Values
  //  Horizontal component
  double kP = touchingGround ? 0.07 : 0.045;
  double error = 0;
  if ((dbRight || dbLeft) && !(dbRight && dbLeft)) {
    if (dbRight) error = moveSpeed - player.getSpeedX();
    else if (dbLeft) error = -moveSpeed - player.getSpeedX();
  } else {
    error = -player.getSpeedX();
  }
  player.setSpeedX(player.getSpeedX() + (float) (error * kP));
  
  //  Vertical component
  player.addSpeedY(gravityAcclr);
  //   Jump
  if (dbUp) {
    if (touchingGround && player.getSpeedY() >= 0) {
      player.setSpeedY(-jumpPower * 0.75);
      leavingGround = 1;
      leavingLimit = abs(player.getSpeedX() * 6);
    }
    else if (leavingGround >= leavingLimit) {
      leavingGround = 0;
    }
    else if (leavingGround > 0) {
      player.addSpeedY(-gravityAcclr);
      leavingGround++;
    }
  } else {
    leavingGround = 0;
  }
  
  // Move and check physics
  resolvePlatformCollisions(player, platforms);
  checkItemCollisions(player, items);
  
  // Player death
  if (player.getY() > VOID_HEIGHT) {
    onDeath();
  }
  
  // Move screen
  scroll();
  
  // Draw
  //  Clear screen
  //background(255); 
  background(230);
  
  //  Load map
  for (Sprite tile : platforms) {
    tile.display();
  }
  
  //  Load items
  for (Sprite item : items) {
    item.display();
    ((AnimatedSprite) item).updateAnimation();
  }
  
  //  Load deco
  for (Sprite deco : bgDeco) {
    deco.display();
  }
  
  //  Player
  player.display();
  ((AnimatedSprite) player).updateAnimation();
  
  //  Debug
  if (showHitbox) {
    // Tiles
    stroke(255, 0, 0);
    for (Sprite tile : platforms) {
      rect(tile.getLeft(), tile.getTop(), tile.getW(), tile.getH());
    }
    // Player
    stroke(0, 255, 0);
    fill(0, 0);
    rect(player.getLeft(), player.getTop(), player.getW(), player.getH());
  }
}

// Create a list of sprites
void createSpriteList() {
  spriteList = new HashMap<Integer, Sprite>();
  spriteList.put(1, new Sprite("data/brown_brick.png", tileScale));
  spriteList.put(2, new Sprite("data/red_brick.png", tileScale));
  spriteList.put(3, new Sprite("data/crate.png", tileScale));
  
  spriteList.put(101, new Coin("data/coins/normalCoinUnscaled/mergedimage.png", tileSize / 240));
  
  spriteList.put(201, new Sprite("data/sun.png"));
  spriteList.put(202, new Sprite("data/snow.png", tileScale));
}

// Create platforms sprite from CSV file
void createPlatforms(String filename) {
  platforms = new ArrayList<Sprite>();
  items = new ArrayList<AnimatedSprite>();
  bgDeco = new ArrayList<Sprite>();
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
          AnimatedSprite as = new AnimatedSprite(s.getImg(), x, y, s.getScale());
          items.add(as);
        }
      } else if (index <= 300) {
        bgDeco.add(s);
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
 
}

// Reset Player Position
void initPlayer() {
  player.setX(spawnLocation[levelId - 1][0]);
  player.setY(spawnLocation[levelId - 1][1]);
  player.setSpeedX(0);
  player.setSpeedY(0);
  viewX = tileSize * 1000;
  viewY = spawnLocation[levelId - 1][1] - tileSize * 16.5;
  dbRight = dbLeft = dbUp = false;
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
  }
}

// Move and check collisions
void resolvePlatformCollisions(Sprite plyr, ArrayList<Sprite> walls) {
  // Move in the y-direction
  plyr.updateY();
  // Resolve vertical collision
  touchingGround = false;
  ArrayList<Sprite> col_list = plyr.getCollided(walls);
  if (col_list.size() > 0) {
    float mostTop, mostBottom;
    mostTop = col_list.get(0).getTop();
    mostBottom = col_list.get(0).getBottom();
    for (Sprite collided : col_list) {
      mostTop = min(mostTop, collided.getTop());
      mostBottom = max(mostBottom, collided.getBottom());
    }
    // Touching ground
    if (plyr.getSpeedY() > 0) {
      plyr.setBottom(mostTop);
      touchingGround = true;
    }
    // Touching roof
    else if (player.getSpeedY() < 0) {
      plyr.setTop(mostBottom);
    }
    plyr.setSpeedY(0);
  }
  
  // Move in the x-direction
  plyr.updateX();
  // Resolve horizontal collision
  col_list = plyr.getCollided(walls);
  if (col_list.size() > 0) {
    float mostRight, mostLeft;
    mostRight = col_list.get(0).getRight();
    mostLeft = col_list.get(0).getLeft();
    for (Sprite collided : col_list) {
      mostRight = max(mostRight, collided.getRight());
      mostLeft = min(mostLeft, collided.getLeft());
    }
    // Touching right wall
    if (plyr.getSpeedX() > 0) {
      plyr.setRight(mostLeft);
    }
    // Touching left wall
    else if (player.getSpeedX() < 0) {
      plyr.setLeft(mostRight);
    }
    plyr.setSpeedX(0);
  }
}

void checkItemCollisions(Sprite plyr, ArrayList<AnimatedSprite> items) {
  ArrayList<AnimatedSprite> col_list = plyr.getCollidedAnim(items);
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
