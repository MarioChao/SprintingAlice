// Enemy Classes

// Enemy Settings Class
public class EnemySettings {
  // Attributes
  boolean willWalkOff;
  boolean canBeStepped;
  boolean canFly;
  
  // Constructors
  public EnemySettings(boolean walkOff, boolean beStepped, boolean fly) {
    willWalkOff = walkOff;
    canBeStepped = beStepped;
    canFly = fly;
  }
  public EnemySettings(boolean walkOff, boolean beStepped) {
    this(walkOff, beStepped, false);
  }
  public EnemySettings(boolean walkOff) {
    this(walkOff, true, false);
  }
  public EnemySettings() {
    this(true, true, false);
  }
}

// Enemy Class
public class Enemy extends AnimatedSprite {
  // Attributes
  private EnemySettings defaultInfo, enemyInfo;
  private PImage[] hitRight, hitLeft;
  protected boolean isHit;
  private int hitFrames;
  private float spawnX, spawnY;
  private float defaultSpeedX, defaultSpeedY;
  
  // Constructors
  public Enemy(PImage img, float x, float y, float scale, float dx, float dy, EnemySettings info) {
    super(img, x, y, scale);
    setSpeedX(dx * moveScale);
    setSpeedY(dy);
    defaultInfo = new EnemySettings(info.willWalkOff, info.canBeStepped, info.canFly);
    enemyInfo = new EnemySettings(info.willWalkOff, info.canBeStepped, info.canFly);
    isHit = false;
    hitFrames = 0;
    spawnX = x;
    spawnY = y;
    defaultSpeedX = dx;
    defaultSpeedY = dy;
    
    super.frameDelay = 30;
  }
  public Enemy(PImage img, float x, float y, float scale, float dx, float dy) {
    this(img, x, y, scale, dx, dy, new EnemySettings());
  }
  
  // Methods
  public void move(ArrayList<Sprite> walls) {
    // Gravity effect
    if (enemyInfo.canFly) resolveCollision(this, walls);
    else fallCollide(this, walls);
    // Move direction
    if (enemyInfo.willWalkOff) {
      if (checkMovingTouch(this, walls) || checkMovingTouch(this, creatures)) {
        setSpeedX(getSpeedX() * -1);
      }
    } else {
      if (checkMovingBoundary(this, walls) || checkMovingTouch(this, creatures)) {
        setSpeedX(getSpeedX() * -1);
      }
    }
  }
  public void checkHit(Sprite plyr) {
    if (!(enemyInfo.canBeStepped)) return;
    if (hitFrames == 120) {
      setVisibility(false);
    } else if (isHit) {
      hitFrames++;
    } else if (isColliding(plyr) && plyr.getSpeedY() > 0) {
      enemyInfo.canFly = false;
      isHit = true;
      hitFrames = 0;
      setSpeedX(0);
      
      touchingGround = true;
      player.resolveJump(true);
    }
  }
  public void respawn() {
    setVisibility(true);
    setX(spawnX);
    setY(spawnY);
    setSpeedX(defaultSpeedX);
    setSpeedY(defaultSpeedY);
    isHit = false;
    hitFrames = 0;
    enemyInfo.willWalkOff = defaultInfo.willWalkOff;
    enemyInfo.canBeStepped = defaultInfo.canBeStepped;
    enemyInfo.canFly = defaultInfo.canFly;
  }
  
  //  Mutators
  public void setHitRight(PImage[] hitRight) {
    this.hitRight = hitRight;
  }
  public void setHitLeft(PImage[] hitLeft) {
    this.hitLeft = hitLeft;
  }
  
  //  Accessors
  public PImage[] getHitRight() {
    return hitRight;
  }
  public PImage[] getHitLeft() {
    return hitLeft;
  }
  public EnemySettings getEnemyInfo() {
    return enemyInfo;
  }
  public boolean getWillWalkOff() {
    return enemyInfo.willWalkOff;
  }
  public boolean getCanBeStepped() {
    return enemyInfo.canBeStepped;
  }
  public boolean getCanFly() {
    return enemyInfo.canFly;
  }
  
  // Override
  @Override
  public void selectCurrentImages() {
    if (super.direction == Direction.RIGHT_FACING) {
      if (isHit) setCurrentImages(hitRight);
      else if (isNeutral) setCurrentImages(getStandRight());
      else setCurrentImages(getMoveRight());
    } else if (super.direction == Direction.LEFT_FACING) {
      if (isHit) setCurrentImages(hitLeft);
      else if (isNeutral) setCurrentImages(getStandLeft());
      else setCurrentImages(getMoveLeft());
    }
  }
}

public class BlueSlime extends Enemy {
  // Constructors
  public BlueSlime(PImage img, float x, float y, float scale, float dx, float dy, EnemySettings info) {
    super(img, x, y, scale, dx, dy, info);
    
    setStandLeft(new PImage[] {
      loadImage("data/enemies/slimeBlue/slimeBlue.png")
    });
    setStandRight(new PImage[] {
      loadImage("data/enemies/slimeBlue/reversed/slimeBlue.png")
    });
    setMoveLeft(new PImage[] {
      loadImage("data/enemies/slimeBlue/slimeBlue.png"),
      loadImage("data/enemies/slimeBlue/slimeBlue_move.png")
    });
    setMoveRight(new PImage[] {
      loadImage("data/enemies/slimeBlue/reversed/slimeBlue.png"),
      loadImage("data/enemies/slimeBlue/reversed/slimeBlue_move.png")
    });
    setHitLeft(new PImage[] {
      loadImage("data/enemies/slimeBlue/slimeBlue_hit.png")
    });
    setHitRight(new PImage[] {
      loadImage("data/enemies/slimeBlue/reversed/slimeBlue_hit.png")
    });
    
    setCurrentImages(getStandRight());
  }
  public BlueSlime(String filename, float x, float y, float scale, float dx, float dy, EnemySettings info) {
    this(loadImage(filename), x, y, scale, dx, dy, info);
  }
}

public class BlackFly extends Enemy {
  // Constructors
  public BlackFly(PImage img, float x, float y, float scale, float dx, float dy, EnemySettings info) {
    super(img, x, y, scale, dx, dy, info);
    
    setStandLeft(new PImage[] {
      loadImage("data/enemies/flyBlack/fly.png"),
      loadImage("data/enemies/flyBlack/fly_move.png")
    });
    setStandRight(new PImage[] {
      loadImage("data/enemies/flyBlack/reversed/fly.png"),
      loadImage("data/enemies/flyBlack/reversed/fly_move.png")
    });
    setMoveLeft(new PImage[] {
      loadImage("data/enemies/flyBlack/fly.png"),
      loadImage("data/enemies/flyBlack/fly_move.png")
    });
    setMoveRight(new PImage[] {
      loadImage("data/enemies/flyBlack/reversed/fly.png"),  
      loadImage("data/enemies/flyBlack/reversed/fly_move.png")
    });
    setHitLeft(new PImage[] {
      loadImage("data/enemies/flyBlack/fly_dead.png")
    });
    setHitRight(new PImage[] {
      loadImage("data/enemies/flyBlack/reversed/fly_dead.png")
    });
    
    setCurrentImages(getStandRight());
  }
  public BlackFly(String filename, float x, float y, float scale, float dx, float dy, EnemySettings info) {
    this(loadImage(filename), x, y, scale, dx, dy, info);
  }
}
