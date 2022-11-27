// Animated Coins Class

static int coins = 0;

public class Coin extends AnimatedSprite {
  // Constructors
  public Coin(PImage img, float x, float y, float scale) {
    super(img, x, y, scale);
    PImage[] standRight = new PImage[30];
    for (int i = 0; i < 30; i++) {
      standRight[i] = loadImage(String.format("data/coins/normalCoinUnscaled/data/%03d.png", i));
    }
    setStandRight(standRight);
    setCurrentImages(standRight);
    setStandLeft(standRight);
    
    super.frameDelay = 4;
  }
  public Coin(String filename, float x, float y, float scale) {
    this(loadImage(filename), x, y, scale);
  }
  public Coin(String filename, float scale) {
    this(filename, 0, 0, scale);
  }
  public Coin(String filename) {
    this(filename, 0, 0, 1);
  }
  
  // Methods
  @Override
  public void setVisibility(boolean visible) {
    if (getVisibility()) {
      coins++;
      if (coins % 100 == 0) {
        player.lives++;
      }
    }
    super.setVisibility(visible);
  }
}
