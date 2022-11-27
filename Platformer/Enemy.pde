// Enemy Sprite

public class Enemy extends AnimatedSprite {
  // Attributes
  private boolean willWalkOff;
  private PImage[] hitRight, hitLeft;
  protected boolean isHit;
  private int hitFrames;
  
  // Constructors
  public Enemy(PImage img, float x, float y, float scale, float dx, float dy, boolean walkOff) {
    super(img, x, y, scale);
    setSpeedX(dx * moveScale);
    setSpeedY(dy);
    willWalkOff = walkOff;
    isHit = false;
    hitFrames = 0;
  }
  public Enemy(String filename, float x, float y, float scale, float dx, float dy, boolean walkOff) {
    this(loadImage(filename), x, y, scale, dx, dy, walkOff);
  }
  
  // Methods
  public boolean getWillWalkOff() {
    return willWalkOff;
  }
  public void move(ArrayList<Sprite> walls) {
    fallCollide(this, walls);
    if (willWalkOff) {
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
    if (hitFrames == 120) {
      setVisibility(false);
    } else if (isHit) {
      hitFrames++;
    } else if (isColliding(plyr) && plyr.getSpeedY() > 0) {
      isHit = true;
      hitFrames = 0;
      setSpeedX(0);
    }
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
  public BlueSlime(PImage img, float x, float y, float scale, float dx, float dy, boolean walkOff) {
    super(img, x, y, scale, dx, dy, walkOff);
    
    setStandLeft(new PImage[] {
      loadImage("data/enemies/slimeBlue/slimeBlue.png")
    });
    setStandRight(new PImage[] {
      loadImage("data/enemies/slimeBlue/reversed/slimeBlue.png")
    });
    setMoveLeft(new PImage[] {
      loadImage("data/enemies/slimeBlue/slimeBlue_move.png")
    });
    setMoveRight(new PImage[] {
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
  public BlueSlime(String filename, float x, float y, float scale, float dx, float dy, boolean walkOff) {
    this(loadImage(filename), x, y, scale, dx, dy, walkOff);
  }
}
