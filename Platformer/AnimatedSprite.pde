// Animated Sprite

public class AnimatedSprite extends Sprite {
  // Attributes
  protected PImage[] currentImages;
  protected PImage[] standRight;
  protected PImage[] standLeft;
  protected PImage[] moveLeft;
  protected PImage[] moveRight;
  private String direction;
  private int index;
  private int frame;
  private int frameDelay;
  private float movingError;
  
  // Constructors
  public AnimatedSprite(PImage img, float x, float y, float scale) {
    super(img, x, y, scale);
    direction = "STAND_RIGHT";
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
    frame++;
    if (frame % frameDelay == 0) {
      selectDirection();
      selectCurrentImages();
      advanceToNextImage();
      frame = 0;
    }
  }
  //  Changes the facing direction based on velocity
  public void selectDirection() {
    if (super.changeX > movingError) {
      direction = "RIGHT";
    } else if (super.changeX < -movingError) {
      direction = "LEFT";
    } else if (super.changeX > 0) {
      direction = "STAND_RIGHT";
    } else if (super.changeX < 0) {
      direction = "STAND_LEFT";
    } else {
      if (direction.charAt(0) == 'R') {
        direction = "STAND_RIGHT";
      } else if (direction.charAt(0) == 'L') {
        direction = "STAND_LEFT";
      }
    }
  }
  //  Changes the displayed images
  public void selectCurrentImages() {
    if (direction.charAt(0) == 'R') {
      currentImages = moveRight;
    } else if (direction.charAt(0) == 'L') {
      currentImages = moveLeft;
    } else if (direction.equals("STAND_RIGHT")) {
      currentImages = standRight;
    } else if (direction.equals("STAND_LEFT")) {
      currentImages = standLeft;
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
}
