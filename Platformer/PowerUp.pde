public class PowerUp extends AnimatedSprite{
  // Constructors
  public PowerUp(PImage img, float x, float y, float scale) {
    super(img, x, y, scale);
    PImage[] a = new PImage[] {img};
    setStandRight(a);
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
  public void activatePower(){
  }
  // Methods
  public void setVisibility(boolean visible) {
    print("jumpPower: " + jumpPower);
    super.setVisibility(visible);
    if (!visible) activatePower();
  }
}

public class SpeedBoost extends PowerUp{
  public SpeedBoost(String filename, float scale){
    super(filename, scale);
  }
  public SpeedBoost(PImage img, float x, float y, float scale){
    super(img, x, y, scale);
  }
  @Override
  public void activatePower(){
    jumpPower += moveScale;
  }
}
