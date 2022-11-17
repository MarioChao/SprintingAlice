// Animated Coins Class

static int coins = 0;

public class Coin extends AnimatedSprite {
  // Constructors
  public Coin(PImage img, float x, float y, float scale) {
    super(img, x, y, scale);
    standRight = standLeft = new PImage[30];
    for (int i = 0; i < 30; i++) {
      standRight[i] = loadImage(String.format("data/coins/normalCoinUnscaled/data/%03d.png", i));
    }
    currentImages = standRight;
    
    super.frameDelay = 4;
  }
  public Coin(PImage img, float x, float y) {
    this(img, x, y, 1);
  }
  public Coin(PImage img, float scale) {
    this(img, 0, 0, scale);
  }
  public Coin(PImage img) {
    this(img, 0, 0, 1);
  }
  public Coin(String filename, float x, float y, float scale) {
    this(loadImage(filename), x, y, scale);
  }
  public Coin(String filename, float x, float y) {
    this(filename, x, y, 1);
  }
  public Coin(String filename, float scale) {
    this(filename, 0, 0, scale);
  }
  public Coin(String filename) {
    this(filename, 0, 0, 1);
  }
  
  // Methods
  public void setVisibility(boolean visible) {
    if (getVisibility()) {
      coins++;
    }
    super.setVisibility(visible);
  }
}
