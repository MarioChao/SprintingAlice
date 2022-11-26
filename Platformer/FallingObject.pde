// Falling Object

static float gravityAcceleration = 9.8 / 60 * moveScale;

// Check if moving object will touch a wall
public static boolean checkMovingTouch(Sprite obj, ArrayList<Sprite> walls) {
  boolean val = false;
  
  // Check wall
  float speedX = obj.getSpeedX();
  obj.addX(speedX);
  ArrayList<Sprite> col_list = obj.getCollided(walls);
  if (col_list.size() > 0) {
    val = true;
  }
  // Revert changes
  obj.addX(-speedX);
  
  // Return
  return val;
}

// Check if moving object will cause it to partiallty stand on a big-enough gap
public static boolean checkMovingHovering(Sprite obj, ArrayList<Sprite> walls) {
  boolean val = false;
  
  // Move object
  float speedX = obj.getSpeedX();
  obj.addX(speedX);
  //  Keep moving right
  obj.setLeft(obj.getRight());
  obj.addY(5);
  ArrayList<Sprite> col_list = obj.getCollided(walls);
  //  Keep moving left
  obj.setRight(obj.getLeft());
  obj.setRight(obj.getLeft());
  ArrayList<Sprite> col_list2 = obj.getCollided(walls);
  //  Check collided
  if (col_list.size() == 0 || col_list2.size() == 0) {
    val = true;
  }
  // Revert changes
  obj.addX(-speedX);
  obj.setLeft(obj.getRight());
  obj.addY(-5);
  
  // Return
  return val;
}

// Check if moving object will touch a wall or partially stand on air
public static boolean checkMovingBoundary(Sprite obj, ArrayList<Sprite> walls) {
  return checkMovingTouch(obj, walls) || checkMovingHovering(obj, walls);
}

// Check if object is on ground
public static boolean checkTouchGround(Sprite obj, ArrayList<Sprite> walls) {
  boolean val = false;
  
  // Move object
  obj.addY(5);
  ArrayList<Sprite> col_list = obj.getCollided(walls);
  //  Check collided
  if (col_list.size() > 0) {
    val = true;
  }
  
  // Revert changes
  obj.addY(-5);
  
  // Return
  return val;
}

// Make object fall
public static void fallCollide(Sprite obj, ArrayList<Sprite> walls) {
  resolveCollision(obj, walls);
  if (!checkTouchGround(obj, walls)) {
    obj.addSpeedY(gravityAcceleration);
  }
}

// Move and check collisions
public static void resolveCollision(Sprite obj, ArrayList<Sprite> walls) {
  // Move in the y-direction
  obj.updateY();
  // Resolve vertical collision
  ArrayList<Sprite> col_list = obj.getCollided(walls);
  if (col_list.size() > 0) {
    float mostTop, mostBottom;
    mostTop = col_list.get(0).getTop();
    mostBottom = col_list.get(0).getBottom();
    for (Sprite collided : col_list) {
      mostTop = min(mostTop, collided.getTop());
      mostBottom = max(mostBottom, collided.getBottom());
    }
    // Touching ground
    if (obj.getSpeedY() > 0) {
      obj.setBottom(mostTop);
    }
    // Touching roof
    else if (obj.getSpeedY() < 0) {
      obj.setTop(mostBottom);
    }
    obj.setSpeedY(0);
  }
  
  // Move in the x-direction
  obj.updateX();
  // Resolve horizontal collision
  col_list = obj.getCollided(walls);
  if (col_list.size() > 0) {
    float mostRight, mostLeft;
    mostRight = col_list.get(0).getRight();
    mostLeft = col_list.get(0).getLeft();
    for (Sprite collided : col_list) {
      mostRight = max(mostRight, collided.getRight());
      mostLeft = min(mostLeft, collided.getLeft());
    }
    // Touching right wall
    if (obj.getSpeedX() > 0) {
      obj.setRight(mostLeft);
    }
    // Touching left wall
    else if (obj.getSpeedX() < 0) {
      obj.setLeft(mostRight);
    }
    obj.setSpeedX(0);
  }
}
