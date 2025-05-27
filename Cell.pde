class Cell {
  private Position pos;
  private boolean isMine;
  private int neighborMines;
  private boolean isEdge;
  
  private boolean isRevealed = false;
  private boolean isClicked = false;
  private boolean isFlagged = false;
  private boolean isDeathMine = false;
  
  public Cell() {
    pos = new Position();
    isMine = false;
    neighborMines = 0;
    isEdge = true;
  }
  
  public Cell(Position pos) {
    this.pos = pos;
    isMine = false;
    neighborMines = 0;
    isEdge = true;
  }
  
  public Cell(Position pos, boolean isMine) {
    this.pos = pos;
    this.isMine = isMine;
    neighborMines = 0;
    isEdge = false;
  }
  
  public Cell(Position pos, boolean isMine, int neighborMines) {
    this.pos = pos;
    this.isMine = isMine;
    this.neighborMines = neighborMines;
    isEdge = false;
  }
  
  public Cell(Position pos, boolean isMine, int neighborMines, boolean isEdge) {
    this.pos = pos;
    this.isMine = isMine;
    this.neighborMines = neighborMines;
    this.isEdge = isEdge;
  }
  
  public Position getPosition() { return pos; }
  public boolean isMine() { return isMine; }
  public int getNeighborMines() { return neighborMines; }
  public boolean isEdge() { return isEdge; }
  public boolean isRevealed() { return isRevealed; }
  public boolean isClicked() { return isClicked; }
  public boolean isFlagged() { return isFlagged; }
  
  public void setPosition(Position pos) { this.pos = pos; }
  public void setMine(boolean isMine) { this.isMine = isMine; }
  public void setNeighborMines(int neighborMines) { this.neighborMines = neighborMines; }
  public void setEdge(boolean isEdge) { this.isEdge = isEdge; }
  public void setRevealed(boolean isRevealed) { this.isRevealed = isRevealed; }
  public void setClicked(boolean isClicked) { this.isClicked = isClicked; }
  public void setDeathMine(boolean isDeathMine) { this.isDeathMine = isDeathMine; }
  
  public void display() {
    float x = pos.getX();
    float y = pos.getY();
    float mid = CELL_SIZE / 2;
    float margin = (float)CELL_SIZE * 0.1;
    noStroke();
    if (!isEdge) {
      if (!isRevealed) {
        // lighter and darker '3D' edges
        fill(isClicked ? 80 : 220);
        triangle(x, y, x + CELL_SIZE, y, x, y + CELL_SIZE);
        fill(isClicked ? 220 : 80);
        triangle(x + CELL_SIZE, y + CELL_SIZE, x, y + CELL_SIZE, x + CELL_SIZE, y);
        // 'raised' center
        fill(isClicked ? PRESSED_GRAY.getValue() : BASE_GRAY.getValue());
        rect(x + margin, y + margin, CELL_SIZE - margin * 2, CELL_SIZE - margin * 2);
        // flag
        if (isFlagged) {
          float unitSize = CELL_SIZE * 0.1;
          float cellX = pos.getX();
          float cellY = pos.getY();
          fill(0);
          rect(cellX + unitSize * 2, cellY + CELL_SIZE - unitSize * 3, CELL_SIZE - unitSize * 4, unitSize);
          rect(cellX + unitSize * 3, cellY + CELL_SIZE - unitSize * 4, CELL_SIZE - unitSize * 6, unitSize * 1.5);
          rect(cellX + CELL_SIZE / 2 - unitSize / 2, cellY + CELL_SIZE / 2 - unitSize, unitSize, unitSize * 4);
          fill(255, 0, 0);
          rect(cellX + CELL_SIZE / 2 - unitSize * 0.5, cellY + unitSize * 2, unitSize, unitSize * 3);
          rect(cellX + CELL_SIZE / 2 - unitSize * 1.5, cellY + unitSize * 2.5, unitSize * 2, unitSize * 2);
          rect(cellX + CELL_SIZE / 2 - unitSize * 2.5, cellY + unitSize * 3, unitSize * 2, unitSize);
        }
      }
      else {
        // blank background
        if (!isDeathMine) BASE_GRAY.setFill();
        else fill(255, 0, 0);
        rect(x, y, CELL_SIZE, CELL_SIZE);
        // lines on top and left
        float lineSize = CELL_SIZE / 30;
        stroke(BASE_GRAY.getValue() - 30);
        noFill();
        strokeWeight(lineSize);
        strokeCap(SQUARE);
        line(x, y + lineSize / 2, x + CELL_SIZE, y + lineSize / 2);
        line(x + lineSize / 2, y, x + lineSize / 2, y + CELL_SIZE);
        if (isFlagged) {
          // just a red 'X'
          noFill();
          stroke(255, 0, 0);
          strokeWeight(CELL_SIZE / 10);
          line(x + margin, y + margin, x + CELL_SIZE - margin, y + CELL_SIZE - margin);
          line(x + margin, y + CELL_SIZE - margin, x + CELL_SIZE - margin, y + margin);
        }
        else if (isMine) {
          // black circle
          noStroke();
          fill(0);
          ellipse(x + mid, y + mid, CELL_SIZE * 0.6, CELL_SIZE * 0.6);
          // 4 black lines for spikes
          noFill();
          strokeWeight(CELL_SIZE / 15);
          strokeCap(ROUND);
          stroke(0);
          line(x + mid, y + CELL_SIZE * 0.1, x + mid, y + CELL_SIZE * 0.9);
          line(x + CELL_SIZE * 0.1, y + mid, x + CELL_SIZE * 0.9, y + mid);
          line(x + CELL_SIZE * 0.23, y + CELL_SIZE * 0.23, x + CELL_SIZE * 0.77, y + CELL_SIZE * 0.77);
          line(x + CELL_SIZE * 0.23, y + CELL_SIZE * 0.77, x + CELL_SIZE * 0.77, y + CELL_SIZE * 0.23);
        }
        else if (neighborMines > 0) {
          numberColors.get(neighborMines).setFill();
          textAlign(CENTER);
          textSize((float)CELL_SIZE * 0.9);
          text(neighborMines, pos.getX() + CELL_SIZE / 2, pos.getY() + CELL_SIZE * 0.8);
        }
      }
    }
    // DEBUG
    //else { // show edges
    //  fill(255, 0, 0);
    //  rect(x, y, CELL_SIZE, CELL_SIZE);
    //}
  }
  
  public boolean isMouseIn() {
    return mouseX >= pos.getX() && mouseX < pos.getX() + CELL_SIZE && 
           mouseY >= pos.getY() && mouseY < pos.getY() + CELL_SIZE;
  }
  
  public boolean interact(boolean rightClick) {
    if (!isEdge) { // outer wrapper: if edge, don't do anything
      if (rightClick) { // rc wrapper : 'right click' interactions
        if (!isRevealed) {
          isFlagged = !isFlagged;
        }
      } // rc wrapper
      else { // non-rc wrapper : 'left click' interactions
        if (!isRevealed && !isFlagged) {
          isRevealed = true;
          if (isMine) {
            isDeathMine = true;
            return true;
          }
        }
      } // non-rc wrapper
    } // outer wrapper
    return false;
  }
}
