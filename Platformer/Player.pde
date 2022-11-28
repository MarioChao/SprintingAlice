// Animated Player Class & player functions

public class Player extends AnimatedSprite {
  // Attributes
  private PImage[] jumpLeft, jumpRight;
  private PImage[] duckLeft, duckRight;
  protected boolean isJumping, isDucking;
  private float leavingLimit = 0;
  private int lives = 3;
  float moveSpeed = defaultMoveSpeed;
  float jumpPower = defaultJumpPower;
  
  // Constructors
  public Player(PImage img, float x, float y, float scale) {
    super(img, x, y, scale);
    setStandRight(new PImage[] {
      loadImage("data/player/player_stand.png")
    });
    setStandLeft(new PImage[] {
      loadImage("data/player/reversed/player_stand.png")
    });
    setMoveRight(new PImage[] {
      loadImage("data/player/player_walk1.png"),
      loadImage("data/player/player_walk2.png")
    });
    setMoveLeft(new PImage[] {
      loadImage("data/player/reversed/player_walk1.png"),
      loadImage("data/player/reversed/player_walk2.png")
    });
    jumpRight = new PImage[] {
      loadImage("data/player/player_jump.png")
    };
    jumpLeft = new PImage[] {
      loadImage("data/player/reversed/player_jump.png")
    };
    duckRight = new PImage[] {
      loadImage("data/player/player_duck.png")
    };
    duckLeft = new PImage[] {
      loadImage("data/player/reversed/player_duck.png")
    };
    
    super.frameDelay = 6;
    super.movingError = 0.2;
  }
  public Player(PImage img, float scale) {
    this(img, 0, 0, scale);
  }
  public Player(String filename, float x, float y, float scale) {
    this(loadImage(filename), x, y, scale);
  }
  public Player(String filename, float scale) {
    this(filename, 0, 0, scale);
  }
  
  // Methods
  public void resolveJump(boolean forceFullJump) {
    if (touchingGround) {
      isJumping = false;
    }
    if (dbSpace) {
      if (touchingGround && getSpeedY() >= 0) {
        setSpeedY(-jumpPower * 0.75);
        leavingGround = 1;
        if (forceFullJump) leavingLimit = 18;
        else leavingLimit = min(abs(getSpeedX() / moveScale * 6), 18);
        isJumping = true;
      }
      else if (leavingGround >= leavingLimit) {
        leavingGround = 0;
      }
      else if (leavingGround > 0) {
        addSpeedY(-gravityAcceleration);
        leavingGround++;
        isJumping = true;
      }
    } else {
      leavingGround = 0;
    }
  }
  public void resolveJump() {
    resolveJump(false);
  }
  
  //  Animation
  @Override
  public void selectDirection() {
    isNeutral = false;
    if (getSpeedX() > movingError) {
      super.direction = Direction.RIGHT_FACING;
    } else if (getSpeedX() < -movingError) {
      super.direction = Direction.LEFT_FACING;
    } else {
      isNeutral = true;
    }
    isDucking = dbDown;
  }
  
  @Override
  public void selectCurrentImages() {
    if (super.direction == Direction.RIGHT_FACING) {
      if (isDucking) setCurrentImages(duckRight);
      else if (isJumping) setCurrentImages(jumpRight);
      else if (isNeutral) setCurrentImages(getStandRight());
      else setCurrentImages(getMoveRight());
    } else if (super.direction == Direction.LEFT_FACING) {
      if (isDucking) setCurrentImages(duckLeft);
      else if (isJumping) setCurrentImages(jumpLeft);
      else if (isNeutral) setCurrentImages(getStandLeft());
      else setCurrentImages(getMoveLeft());
    }
  }
  
  // Reset Player
  void initPlayer() {
    initPlayerPos();
    moveSpeed = defaultMoveSpeed;
    jumpPower = defaultJumpPower;
    lives = 3;
  }
  
  // Reset Player Position
  void initPlayerPos() {
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
    lives--;
    if (lives < 1) {
      isGameOver = true;
      return;
    }
    initPlayerPos();
  }
}
