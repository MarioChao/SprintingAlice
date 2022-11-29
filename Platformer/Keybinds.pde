// Keyboard input functions

// Booleans
//  Debounces
boolean dbRight, dbLeft, dbUp, dbDown;
boolean dbSpace;

void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      if (dbRight) return;
      dbRight = true;
    }
    if (keyCode == LEFT) {
      if (dbLeft) return;
      dbLeft = true;
    }
    if (keyCode == UP) {
      if (dbUp) return;
      dbUp = true;
    }
    if (keyCode == DOWN) {
      if (dbDown) return;
      dbDown = true;
    }
  }
  if (key == ' ') {
    if (dbSpace) return;
    dbSpace = true;
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      if (!dbRight) return;
      dbRight = false;
    }
    if (keyCode == LEFT) {
      if (!dbLeft) return;
      dbLeft = false;
    }
    if (keyCode == UP) {
      if (!dbUp) return;
      dbUp = false;
    }
    if (keyCode == DOWN) {
      if (!dbDown) return;
      dbDown = false;
    }
  }
  if (key == ' ') {
    if (!dbSpace) return;
    if ((isGameEnd && levelId > 0)) {
      initialLevel = 0;
      isGameEnd = false;
      isGameLoading = true;
      loop();
    } else if (isGameOver || (isGameEnd && levelId > 0)) {
      isGameOver = false;
      isGameLoading = true;
      loop();
    }
    dbSpace = false;
  }
}
