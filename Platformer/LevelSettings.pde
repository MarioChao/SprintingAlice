// Level settings

// Level
int totalLevel = 3;
int levelId = 1; // Start level id

// Spawn location
float[][] spawnLocation;

// Set spawn location
void initSpawnLocation() {
  spawnLocation = new float[5][2]; // 5 levels, {x, y}
  // Level 1
  spawnLocation[0][0] = tileSize * 29.5;
  spawnLocation[0][1] = tileSize * 56.5;
  // Level 2
  spawnLocation[1][0] = tileSize * 3.5;
  spawnLocation[1][1] = tileSize * 55.5;
  // Level 3
  spawnLocation[2][0] = tileSize * 1.5;
  spawnLocation[2][1] = tileSize * 17.5;
}
