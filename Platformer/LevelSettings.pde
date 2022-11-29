// Level settings

// Level
int totalLevel = 3;
int initialLevel = 1; // Start level id
int levelId;

// Spawn location
HashMap<Integer, Float[]> spawnLocation;

// Set spawn location
void initSpawnLocation() {
  // 5 levels, {x, y}
  spawnLocation = new HashMap<Integer, Float[]>();
  // Level 1
  spawnLocation.put(1, new Float[] {tileSize * 29.5, tileSize * 56.5});
  // Level 2
  spawnLocation.put(2, new Float[] {tileSize * 3.5, tileSize * 55.5});
  // Level 3
  spawnLocation.put(3, new Float[] {tileSize * 1.5, tileSize * 17.5});
  
  // Negative levels
  // Level 0
  spawnLocation.put(1, new Float[] {tileSize * 29.5, tileSize * 56.5});
}
