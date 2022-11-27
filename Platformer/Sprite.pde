// Creates an OOP Sprite

public class Sprite {
  // Attributes
  //  Image
  private PImage img;
  //  Image dimensions
  private float imgx, imgy;
  private float sizeW, sizeH;
  private float scale;
  //  Movements
  private float changeX, changeY;
  //  State
  private boolean visible;
  
  // Constructors
  public Sprite(PImage img, float x, float y, float scale) {
    this.img = img.copy();
    imgx = x;
    imgy = y;
    sizeW = img.width * scale;
    sizeH = img.height * scale;
    this.scale = scale;
    visible = true;
    changeX = 0;
    changeY = 0;
  }
  public Sprite(PImage img, float x, float y) {
    this(img, x, y, 1);
  }
  public Sprite(PImage img, float scale) {
    this(img, 0, 0, scale);
  }
  public Sprite(PImage img) {
    this(img, 0, 0, 1);
  }
  public Sprite(String filename, float x, float y, float scale) {
    this(loadImage(filename), x, y, scale);
    /*img = loadImage(filename);
    imgx = x;
    imgy = y;
    sizeW = img.width * scale;
    sizeH = img.height * scale;
    this.scale = scale;
    visible = true;
    changeX = 0;
    changeY = 0;*/
  }
  public Sprite(String filename, float x, float y) {
    this(filename, x, y, 1);
  }
  public Sprite(String filename, float scale) {
    this(filename, 0, 0, scale);
  }
  public Sprite(String filename) {
    this(filename, 0, 0, 1);
  }
  
  
  // Methods
  //  Accessors
  public PImage getImg() {
    return img;
  }
  
  public float getX() {
    return imgx;
  }
  public float getY() {
    return imgy;
  }
  
  public float getSpeedX() {
    return changeX;
  }
  public float getSpeedY() {
    return changeY;
  }
  
  public float getW() {
    return sizeW;
  }
  public float getH() {
    return sizeH;
  }
  public float getScale() {
    return scale;
  }
  
  public float getLeft() {
    return imgx - sizeW / 2;
  }
  public float getRight() {
    return imgx + sizeW / 2;
  }
  public float getTop() {
    return imgy - sizeH / 2;
  }
  public float getBottom() {
    return imgy + sizeH / 2;
  }
  
  //  Change coordinates
  public void setX(float x) {
    imgx = x;
  }
  public void setY(float y) {
    imgy = y;
  }
  public void setCord(float x, float y) {
    setX(x);
    setY(y);
  }
  
  public void addX(float dx) {
    imgx += dx;
  }
  public void addY(float dy) {
    imgy += dy;
  }
  
  public void setLeft(float x) {
    imgx = x + sizeW / 2;
  }
  public void setRight(float x) {
    imgx = x - sizeW / 2;
  }
  public void setTop(float y) {
    imgy = y + sizeH / 2;
  }
  public void setBottom(float y) {
    imgy = y - sizeH / 2;
  }
  
  //  Change speeds
  public void setSpeedX(float dx) {
    changeX = dx;
  }
  public void setSpeedY(float dy) {
    changeY = dy;
  }
  
  public void addSpeedX(float dx) {
    changeX += dx;
  }
  public void addSpeedY(float dy) {
    changeY += dy;
  }
  
  //  State update
  public void updateX() {
    imgx += changeX;
  }
  public void updateY() {
    imgy += changeY;
  }
  public void updateXY() {
    updateX();
    updateY();
  }
  
  public void setVisibility(boolean visible) {
    this.visible = visible;
  }
  public boolean getVisibility() {
    return visible;
  }
  
  //  Show image
  public void display() {
    if (visible) {
      image(img, imgx, imgy, sizeW, sizeH);
    }
  }
  
  //  Functions
  public boolean isColliding(Sprite other) {
    if (other.visible == false) return false;
    boolean isNotCollidingX = getRight() <= other.getLeft() || getLeft() >= other.getRight();
    boolean isNotCollidingY = getBottom() <= other.getTop() || getTop() >= other.getBottom();
    return !(isNotCollidingX || isNotCollidingY);
  } 
  public ArrayList<Sprite> getCollided(ArrayList<Sprite> objects) {
    ArrayList<Sprite> collided = new ArrayList<Sprite> ();
    for (Sprite obj : objects) {
      if (this != obj && isColliding(obj)) {
        collided.add(obj);
      }
    }
    return collided;
  }
}
