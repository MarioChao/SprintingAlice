// Animated Sprite

//  Enumerators
public enum Direction {
  RIGHT_FACING,
  LEFT_FACING
};

public class AnimatedSprite extends Sprite {
  // Attributes
  private PImage[] currentImages, previousImages;
  private PImage[] standRight, standLeft, moveLeft, moveRight;
  private Direction direction;
  private int index;
  private int frame;
  private int frameDelay;
  protected float movingError;
  protected boolean isNeutral;
  
  // Constructors
  public AnimatedSprite(PImage img, float x, float y, float scale) {
    super(img, x, y, scale);
    direction = Direction.RIGHT_FACING;
    index = 0;
    frame = 0;
    frameDelay = 5;
    movingError = 0;
  }
  public AnimatedSprite(PImage img, float x, float y) {
    this(img, x, y, 1);
  }
  public AnimatedSprite(PImage img, float scale) {
    this(img, 0, 0, scale);
  }
  public AnimatedSprite(PImage img) {
    this(img, 0, 0, 1);
  }
  public AnimatedSprite(String filename, float x, float y, float scale) {
    this(loadImage(filename), x, y, scale);
  }
  public AnimatedSprite(String filename, float x, float y) {
    this(filename, x, y, 1);
  }
  public AnimatedSprite(String filename, float scale) {
    this(filename, 0, 0, scale);
  }
  public AnimatedSprite(String filename) {
    this(filename, 0, 0, 1);
  }
  
  // Methods
  //  Updates animation to facing left, right, etc. and go through frames
  public void updateAnimation() {
    // Put before the frameDelay check in order to detect changes in currentImages
    selectDirection();
    selectCurrentImages();
    // Update images or animation frames
    frame++;
    if (frame % frameDelay == 0 || previousImages != currentImages) {
      advanceToNextImage();
      frame = 0;
    }
    previousImages = currentImages;
  }
  //  Changes the facing direction based on velocity
  public void selectDirection() {
    isNeutral = false;
    if (super.changeX > movingError) {
      direction = Direction.RIGHT_FACING;
    } else if (super.changeX < -movingError) {
      direction = Direction.LEFT_FACING;
    } else {
      isNeutral = true;
    }
  }
  //  Changes the displayed images
  public void selectCurrentImages() {
    if (direction == Direction.RIGHT_FACING) {
      if (isNeutral) currentImages = standRight;
      else currentImages = moveRight;
    } else if (direction == Direction.LEFT_FACING) {
      if (isNeutral) currentImages = standLeft;
      else currentImages = moveLeft;
    }
  }
  public void advanceToNextImage() {
    if (currentImages != null) {
      index++;
      if (index >= currentImages.length) {
        index = 0;
      }
      super.img = currentImages[index];
      super.sizeW = super.img.width * super.scale;
      super.sizeH = super.img.height * super.scale;
    }
  }
  
  //  Mutators
  public void setCurrentImages(PImage[] currentImages) {
    this.currentImages = currentImages;
  }
  public void setStandRight(PImage[] standRight) {
    this.standRight = standRight;
  }
  public void setStandLeft(PImage[] standLeft) {
    this.standLeft = standLeft;
  }
  public void setMoveLeft(PImage[] moveLeft) {
    this.moveLeft = moveLeft;
  }
  public void setMoveRight(PImage[] moveRight) {
    this.moveRight = moveRight;
  }
  
  //  Accessors
  public PImage[] getCurrentImages() {
    return currentImages;
  }
  public PImage[] getStandRight() {
    return standRight;
  }
  public PImage[] getStandLeft() {
    return standLeft;
  }
  public PImage[] getMoveLeft() {
    return moveLeft;
  }
  public PImage[] getMoveRight() {
    return moveRight;
  }
}
