import java.awt.Color;

// Level settings

// Level
int totalLevel = 3;
int initialLevel = 1; // Start level id
int levelId;

// Spawn location
HashMap<Integer, Float[]> spawnLocation;

// Background colors
HashMap<Integer, Color> backgroundColor;

// Set spawn location and level settings
void initLevelSettings() {
  backgroundColor = new HashMap<Integer, Color> ();
  
  backgroundColor.put(1, new Color(230, 230, 230));
  backgroundColor.put(2, new Color(210, 210, 210));
  backgroundColor.put(3, new Color(190, 190, 190));
  
  backgroundColor.put(0, new Color(150, 150, 150));
}
void initSpawnLocation() {
  // 5 levels, {x, y}
  spawnLocation = new HashMap<Integer, Float[]> ();
  // Level 1
  spawnLocation.put(1, new Float[] {tileSize * 29.5, tileSize * 56.5});
  // Level 2
  spawnLocation.put(2, new Float[] {tileSize * 3.5, tileSize * 55.5});
  // Level 3
  spawnLocation.put(3, new Float[] {tileSize * 1.5, tileSize * 17.5});
  
  // Negative levels
  // Level 0
  spawnLocation.put(0, new Float[] {tileSize * 152.5, tileSize * 12.5});
}

// Set level and load map
void setLevel(int lvl){
  isGameLoaded = false;
  println("Level " + lvl);
  createPlatforms("data/maps/map" + lvl + ".csv");
  isGameLoaded = true;
}
