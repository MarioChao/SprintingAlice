// Enemy Sprite

public class Enemy extends AnimatedSprite {
  // Attributes
  private boolean willWalkOff;
  
  // Constructors
  public Enemy(PImage img, float x, float y, float scale, float dx, float dy, boolean walkOff) {
    super(img, x, y, scale);
    setSpeedX(dx);
    setSpeedY(dy);
    willWalkOff = walkOff;
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
}

public class BlueSlime extends Enemy {
  public BlueSlime(PImage img, float x, float y, float scale, float dx, float dy, boolean walkOff) {
    super(img, x, y, scale, dx, dy, walkOff);
    
    standLeft = new PImage[] {
      loadImage("data/enemies/slimeBlue/slimeBlue.png")
    };
    standRight = new PImage[] {
      loadImage("data/enemies/slimeBlue/reversed/slimeBlue.png")
    };
    moveLeft = new PImage[] {
      loadImage("data/enemies/slimeBlue/slimeBlue_move.png")
    };
    moveRight = new PImage[] {
      loadImage("data/enemies/slimeBlue/reversed/slimeBlue_move.png")
    };
    
    currentImages = standRight;
  }
  public BlueSlime(String filename, float x, float y, float scale, float dx, float dy, boolean walkOff) {
    this(loadImage(filename), x, y, scale, dx, dy, walkOff);
  }
}
