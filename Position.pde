class Position {
  private float x;
  private float y;
  
  public Position() {
    x = 0.0;
    y = 0.0;
  }
  
  public Position(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  public Position(double x, double y) {
    this.x = (float)x;
    this.y = (float)y;
  }
  
  public Position(int x, int y) {
    this.x = (float)x;
    this.y = (float)y;
  }
  
  public Position(Position tlCorner, GridPosition gPos) {
    this.x = tlCorner.getX() + CELL_SIZE * gPos.x;
    this.y = tlCorner.getY() + CELL_SIZE * gPos.y;
  }
  
  public Position(Position other) {
    this.x = other.getX();
    this.y = other.getY();
  }
  
  public float getX() { return x; }
  public float getY() { return y; }
}
