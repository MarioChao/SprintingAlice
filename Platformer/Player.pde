// Animated Player Class

public class Player extends AnimatedSprite {
  // Constructors
  public Player(PImage img, float x, float y, float scale) {
    super(img, x, y, scale);
    super.standNeutral = new PImage[] {loadImage("data/player/player_stand.png")};
    super.moveRight = new PImage[] {
      loadImage("data/player/player_walk1.png"),
      loadImage("data/player/player_walk2.png")
    };
    super.moveLeft = new PImage[] {
      loadImage("data/player/player_walk1.png"),
      loadImage("data/player/player_walk2.png")
    };
    
    super.frameDelay = 6;
    super.movingError = 0.2;
  }
  public Player(PImage img, float x, float y) {
    this(img, x, y, 1);
  }
  public Player(PImage img, float scale) {
    this(img, 0, 0, scale);
  }
  public Player(PImage img) {
    this(img, 0, 0, 1);
  }
  public Player(String filename, float x, float y, float scale) {
    this(loadImage(filename), x, y, scale);
  }
  public Player(String filename, float x, float y) {
    this(filename, x, y, 1);
  }
  public Player(String filename, float scale) {
    this(filename, 0, 0, scale);
  }
  public Player(String filename) {
    this(filename, 0, 0, 1);
  }
}
