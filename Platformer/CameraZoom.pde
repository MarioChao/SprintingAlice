// Camera Zoom functions

static float mapScale = 1;
static float prevMapScale = 1;

// Function
int Signum(float num) {
  if (num > 0) return 1;
  else if (num < 0) return -1;
  return 0;
}

// Update zoom
void cameraZoom() {
  if (abs(player.getSpeedX()) > 0.1) {
    mapScale = 1 / pow((abs(player.getSpeedX()) + 6) / 6, 1.0 / 20);
  } else {
    mapScale = 1;
  }
  mapScale = prevMapScale * (1 + 0.001 * Signum(mapScale - prevMapScale));
  if (mapScale > prevMapScale && (dbRight || dbLeft || dbUp || dbDown || dbSpace)) {
    mapScale = prevMapScale;
  }
  scale(mapScale);
  prevMapScale = mapScale;
}

// Scroll screen
void scroll() {
  float rightBoundary = viewX + width * (1 / mapScale) - RIGHT_MARGIN;
  if (player.getRight() > rightBoundary) {
    viewX += player.getRight() - rightBoundary;
  }
  float leftBoundary = viewX + LEFT_MARGIN;
  if (player.getLeft() < leftBoundary) {
    viewX -= leftBoundary - player.getLeft();
  }
  float topBoundary = viewY + VERTICAL_MARGIN;
  if (player.getTop() < topBoundary) {
    viewY -= topBoundary - player.getTop();
  }
  float bottomBoundary = viewY + height * (1 / mapScale) - VERTICAL_MARGIN;
  if (player.getBottom() > bottomBoundary) {
    viewY += player.getBottom() - bottomBoundary;
  }
  translate(-viewX - (1 / mapScale - 1), -viewY - (1 / mapScale - 1));
  //translate(-viewX, -viewY);
}
