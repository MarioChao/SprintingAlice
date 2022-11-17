// Animated Player Class

public class Player extends AnimatedSprite {
  // Attributes
  protected PImage[] jumpLeft;
  protected PImage[] jumpRight;
  
  // Constructors
  public Player(PImage img, float x, float y, float scale) {
    super(img, x, y, scale);
    standRight = new PImage[] {
      loadImage("data/player/player_stand.png")
    };
    standLeft = new PImage[] {
      loadImage("data/player/reversed/player_stand.png")
    };
    moveRight = new PImage[] {
      loadImage("data/player/player_walk1.png"),
      loadImage("data/player/player_walk2.png")
    };
    moveLeft = new PImage[] {
      loadImage("data/player/reversed/player_walk1.png"),
      loadImage("data/player/reversed/player_walk2.png")
    };
    jumpLeft = new PImage[] {
      
    };
    jumpRight = new PImage[] {
      
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
}
