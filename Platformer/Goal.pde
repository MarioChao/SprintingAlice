// Goal Class

public class Goal extends AnimatedSprite {
  private String flagType;
  
  // Constructors
  public Goal(PImage img, String type, float x, float y, float scale) {
    super(img, x, y, scale);
    flagType = type;
    
    PImage[] standRight;
    if (type.equals("Pole")) {
      standRight = new PImage[] {img};
    } else {
      standRight = new PImage[] {
        loadImage(String.format("data/flags/flag%s1.png", type)),
        loadImage(String.format("data/flags/flag%s2.png", type))
      };
    }
    setStandRight(standRight);
    setCurrentImages(standRight);
    setStandLeft(standRight);
    
    super.frameDelay = 8;
  }
  public Goal(String filename, String type, float x, float y, float scale) {
    this(loadImage(filename), type, x, y, scale);
  }
  public Goal(String filename, float x, float y, float scale) {
    this(loadImage(filename), "Pole", x, y, scale);
  }
  public Goal(String filename, String type, float scale) {
    this(filename, type, 0, 0, scale);
  }
  public Goal(String filename) {
    this(filename, "Pole", 0, 0, 1);
  }
  
  // Methods
  public String getType() {
    return flagType;
  }
  public void onTouch() {
    nextLevel();
  }
  public void nextLevel() {
    player.initPlayerPowerup();
    if (levelId > 0) {
      levelId++;
      if (levelId == totalLevel + 1) {
        isGameEnd = true;
        return;
      }
    } else {
      levelId--;
      if (levelId == -1) {
        isGameEnd = true;
        return;
      }
    }
    setLevel(levelId);
    player.initPlayerPos();
  } 
}
