// Powerup Classes

public class PowerUp extends AnimatedSprite {
  private boolean activated = false;
  
  // Constructors
  public PowerUp(PImage img, float x, float y, float scale) {
    super(img, x, y, scale);
    PImage[] p = new PImage[] {img};
    setStandRight(p);
    setCurrentImages(p);
  }
  public PowerUp(PImage img, float x, float y) {
    this(img, x, y, 1);
  }
  public PowerUp(PImage img, float scale) {
    this(img, 0, 0, scale);
  }
  public PowerUp(String filename, float x, float y, float scale) {
    this(loadImage(filename), x, y, scale);
  }
  public PowerUp(String filename, float scale) {
    this(filename, 0, 0, scale);
  }
  // Methods
  @Override
  public void setVisibility(boolean visible) {
    super.setVisibility(visible);
    if (!visible) activatePower();
  }
  public void activatePower() {
    activated = true;
  }
  public void removePower() {
    activated = false;
  }
  public boolean getActivated() {
    return activated;
  }
}

public class JumpBoost extends PowerUp {
  // Constructors
  public JumpBoost(PImage img, float x, float y, float scale) {
    super(img, x, y, scale);
  }
  public JumpBoost(String filename, float scale) {
    super(filename, scale);
  }
  
  // Methods
  @Override
  public void activatePower() {
    super.activatePower();
    player.jumpPower += moveScale;
    println("new jumpPower: " + player.jumpPower);
  }
  @Override
  public void removePower() {
    if (getActivated() == true) {
      super.removePower();
      player.jumpPower -= moveScale;
      println("new jumpPower: " + player.jumpPower);
    }
  }
}

// Speed boost powerup
public class SpeedBoost extends PowerUp {
  // Constructors
  public SpeedBoost(PImage img, float x, float y, float scale) {
    super(img, x, y, scale);
  }
  public SpeedBoost(String filename, float scale) {
    super(filename, scale);
  }
  
  // Methods
  @Override
  public void activatePower() {
    super.activatePower();
    player.moveSpeed += moveScale / 5;
    println("new moveSpeed: " + player.moveSpeed);
  }
  @Override
  public void removePower() {
    if (getActivated() == true) {
      super.removePower();
      player.moveSpeed -= moveScale / 5;
      println("new moveSpeed: " + player.moveSpeed);
    }
  }
}
