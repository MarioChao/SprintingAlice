// Goal Class

public class Goal extends AnimatedSprite {
  // Constructors
  public Goal(PImage img, float x, float y, float scale) {
    super(img, x, y, scale);
    PImage[] standRight = new PImage[] {
      loadImage("data/flags/flagGreen1.png"),
      loadImage("data/flags/flagGreen2.png")
    };
    setStandRight(standRight);
    setCurrentImages(standRight);
    setStandLeft(standRight);
    
    super.frameDelay = 3;
  }
  public Goal(String filename, float x, float y, float scale) {
    this(loadImage(filename), x, y, scale);
  }
  public Goal(String filename, float scale) {
    this(filename, 0, 0, scale);
  }
  public Goal(String filename) {
    this(filename, 0, 0, 1);
  }
  
  // Methods
  public void onTouch() {
    nextLevel();
  }
  public void nextLevel() {
    levelId++;
    if (levelId > totalLevel) {
      levelId = 1;
      isGameEnd = true;
      return;
    }
    setLevel(levelId);
    player.initPlayer();
  } 
}
