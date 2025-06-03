class Cell {
  private Position pos;
  private boolean isEdge;
  private boolean isMine;
  private int neighbors;
  
  private CellState state = CellState.hidden;
  
  private boolean isClicked = false;
  
  public Cell() {
    pos = new Position();
    isEdge = true;
    isMine = false;
    neighbors = 0;
  }
  
  public Cell(Position pos) {
    this.pos = pos;
    isEdge = true;
    isMine = false;
    neighbors = 0;
  }
  
  public Cell(Position pos, boolean isEdge) {
    this.pos = pos;
    this.isEdge = isEdge;
    isMine = false;
    neighbors = 0;
  }
  
  public Cell(Position pos, boolean isEdge, boolean isMine) {
    this.pos = pos;
    this.isEdge = isEdge;
    this.isMine = isMine;
    neighbors = 0;
  }
  
  public Cell(Position pos, boolean isEdge, boolean isMine, int neighbors) {
    this.pos = pos;
    this.isEdge = isEdge;
    this.isMine = isMine;
    this.neighbors = neighbors;
  }
  
  public Position getPosition() { return pos; }
  public boolean isMine() { return isMine; }
  public int getNeighbors() { return neighbors; }
  public boolean isEdge() { return isEdge; }
  public boolean isClicked() { return isClicked; }
  
  public boolean isRevealed() { return state == CellState.revealed; }
  public boolean isFlagged() { return state ==  CellState.flagged; }
  public boolean isMisflagged() { return state == CellState.misflagged; }
  public boolean isExploded() { return state == CellState.exploded; }
  
  public boolean test() { return state == CellState.exploded; }
  
  public void setPosition(Position pos) { this.pos = pos; }
  public void setMine(boolean isMine) { this.isMine = isMine; }
  public void setNeighbors(int neighbors) { this.neighbors = neighbors; }
  public void setEdge(boolean isEdge) { this.isEdge = isEdge; }
  public void setClicked(boolean isClicked) { this.isClicked = isClicked; }
  
  public void setRevealed() { state = CellState.revealed; }
  public void setExploded() { state = CellState.exploded; }
  public void setMisflagged() { state = CellState.misflagged; }
  
  public boolean isMouseIn() {
    return mouseX >= pos.getX() && mouseX < pos.getX() + CELL_SIZE && 
           mouseY >= pos.getY() && mouseY < pos.getY() + CELL_SIZE;
  }
  
  public boolean interact(boolean rightClick) {
    if (!isEdge) { // outer wrapper: if edge, don't do anything
      if (rightClick) { // rc wrapper : 'right click' interactions
        if (state == CellState.hidden) {
          state = CellState.flagged;
        }
        else if (state == CellState.flagged) {
          state = CellState.hidden;
        }
      } // rc wrapper
      else { // non-rc wrapper : 'left click' interactions
        if (state == CellState.hidden && state != CellState.flagged) {
          state = CellState.revealed;
          if (isMine) {
            state = CellState.exploded;
            return true;
          }
        }
      } // non-rc wrapper
    } // outer wrapper
    return false;
  }
  
  public GridPosition getGridPos(Position tlC) {
    int gridX = (int)(pos.getX() - tlC.getX()) / CELL_SIZE;
    int gridY = (int)(pos.getY() - tlC.getY()) / CELL_SIZE;
    return new GridPosition(gridX, gridY);
  }
  
  public void display() {
    float x = pos.getX();
    float y = pos.getY();
    float mid = CELL_SIZE / 2;
    float margin = (float)CELL_SIZE * 0.1;
    noStroke();
    if (!isEdge) {
      if (state == CellState.hidden || state == CellState.flagged || state == CellState.misflagged) {
        // lighter and darker '3D' edges
        fill(isClicked ? 80 : 220);
        triangle(x, y, x + CELL_SIZE, y, x, y + CELL_SIZE);
        fill(isClicked ? 220 : 80);
        triangle(x + CELL_SIZE, y + CELL_SIZE, x, y + CELL_SIZE, x + CELL_SIZE, y);
        // 'raised' center
        fill(isClicked ? PRESSED_GRAY.getValue() : BASE_GRAY.getValue());
        rect(x + margin, y + margin, CELL_SIZE - margin * 2, CELL_SIZE - margin * 2);
        if (state == CellState.flagged || state == CellState.misflagged) {
          // flag
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
          if (state == CellState.misflagged) {
            // red 'X'
            noFill();
            stroke(128, 0, 0);
            strokeWeight(CELL_SIZE / 10);
            strokeCap(SQUARE);
            line(x + margin, y + margin, x + CELL_SIZE - margin, y + CELL_SIZE - margin);
            line(x + margin, y + CELL_SIZE - margin, x + CELL_SIZE - margin, y + margin);
          }
        }
      }
      else {
        // blank background
        if (state != CellState.exploded) BASE_GRAY.setFill();
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
        if (isMine) {
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
        else if (neighbors > 0) {
          numberColors.get(neighbors).setFill();
          textAlign(CENTER);
          textSize((float)CELL_SIZE * 0.9);
          text(neighbors, pos.getX() + CELL_SIZE / 2, pos.getY() + CELL_SIZE * 0.8);
        }
      }
    }
    // DEBUG
    //else { // show edges
    //  fill(255, 0, 0);
    //  rect(x, y, CELL_SIZE, CELL_SIZE);
    //}
  }
}
