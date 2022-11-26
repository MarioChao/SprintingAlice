// Stopwatch Class

public class Stopwatch {
  // Variables
  private float currentTime;
  
  // Constructors
  public Stopwatch() {
    currentTime = millis();
  }
  
  // Methods
  public void reset() {
    currentTime = millis();
  }
  public float getTime() {
    return millis() - currentTime;
  }
  public float getTimeSeconds() {
    return (millis() - currentTime) / 1000;
  }
}
