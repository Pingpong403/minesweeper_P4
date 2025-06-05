class Grid {
  private Vector<Vector<Cell>> cells;
  private Position pos;
  
  public Grid() {
    cells = new Vector<Vector<Cell>>();
    pos = new Position();
  }
  
  public Grid(Position pos) {
    cells = new Vector<Vector<Cell>>();
    this.pos = pos;
  }
  
  public Vector<Vector<Cell>> getCells() { return cells; }
  public Position getPosition() { return pos; }
  
  public Cell getCell(GridPosition gPos) { return cells.get(gPos.y).get(gPos.x); }
  public Cell getSelectedCell() {
    boolean edgesInserted = cells.get(0).get(0).isEdge();
    float tlC_X = pos.getX();
    float tlC_Y = pos.getY();
    int gridX = (int)(mouseX - tlC_X) / CELL_SIZE + (edgesInserted ? 1 : 0);
    int gridY = (int)(mouseY - tlC_Y) / CELL_SIZE + (edgesInserted ? 1 : 0);
    return cells.get(gridY).get(gridX);
  }
  public GridPosition getSelectedGridPosition() {
    boolean edgesInserted = cells.get(0).get(0).isEdge();
    float tlC_X = pos.getX();
    float tlC_Y = pos.getY();
    int gridX = (int)(mouseX - tlC_X) / CELL_SIZE + (edgesInserted ? 1 : 0);
    int gridY = (int)(mouseY - tlC_Y) / CELL_SIZE + (edgesInserted ? 1 : 0);
    return new GridPosition(gridX, gridY);
  }
  
  public GridPosition[] getMines(int w, int h, int count) {
    // fill grid with empty, non-edge cells
    initializeGrid(w, h);
    
    // use to keep track of which grid spaces have been filled or not
    int arrayLen = w * h - 9;
    GridPosition[] unusedSpaces = new GridPosition[arrayLen];
    HashSet<Integer> usedIndices = new HashSet<Integer>();
    
    // to be returned
    GridPosition[] mineSpaces = new GridPosition[count];
    
    int i = 0;
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        // avoid the 3x3 square in the top left
        if (!(x < 3 && y < 3)) {
          unusedSpaces[i] = new GridPosition(x, y);
          i++;
        }
      }
    }
    
    Random r = new Random();
    int randSpace;
    for (int m = 0; m < count; m++) {
      do {
        randSpace = r.nextInt(0, arrayLen);
      } while (usedIndices.contains(randSpace));
      mineSpaces[m] = unusedSpaces[randSpace];
      usedIndices.add(randSpace);
    }
    
    return mineSpaces;
  }
  
  private void initializeGrid(int w, int h) {
    for (int j = 0; j < h; j++) {
      Vector<Cell> row = new Vector<Cell>();
      for (int i = 0; i < w; i++) {
        Position newPos = new Position(pos.getX() + CELL_SIZE * i, pos.getY() + CELL_SIZE * j);
        row.add(new Cell(newPos, false)); // add a new Cell object to the row
      }
      cells.add(row); // add the row to the outer Vector
    }
  }
  
  public void generateGrid(GridPosition[] mines, GridPosition click) {
    GridPosition wh = new GridPosition(cells.get(0).size(), cells.size());
    // the 3x3 grid is completely in the top left, so (1, 1)
    int xOffset = click.x - 1;
    int yOffset = click.y - 1;
    
    // place mines according to the offset
    for (GridPosition mine : mines) {
      // wrap around based on width and height
      int mineX = (mine.x + xOffset) % wh.x;
      while (mineX < 0) mineX += wh.x;
      int mineY = (mine.y + yOffset) % wh.y;
      while (mineY < 0) mineY += wh.y;
      cells.get(mineY).get(mineX).setMine(true);
    }
    
    // insert edge cells
    insertEdges(wh);
    
    // count mines around each non-mine
    for (int j = 0; j < cells.size(); j++) {
      for (int i = 0; i < cells.get(0).size(); i++) {
        Cell cell = cells.get(j).get(i);
        if (!cell.isEdge() && !cell.isMine()) { // only target empty cells on the field
          cell.setNeighbors(checkNeighbors(new GridPosition(i, j)));
        }
      }
    }
  }
  
  private void insertEdges(GridPosition dimensions) {
    // top row
    cells.add(0, new Vector<Cell>());
    for (int i = 0; i < cells.get(1).size() + 2; i++) {
      cells.get(0).add(new Cell(
        new Position(pos.getX() + CELL_SIZE * (i - 1), pos.getY() - CELL_SIZE)
      ));
    }
    // sides
    for (int i = 1; i < cells.size(); i++) {
      cells.get(i).add(cells.get(i).size(), new Cell(
        new Position(pos.getX() - CELL_SIZE, pos.getY() + CELL_SIZE * (i - 1))
      ));
      cells.get(i).add(0, new Cell(
        new Position(pos.getX() + CELL_SIZE * dimensions.x, pos.getY() + CELL_SIZE * (i - 1))
      ));
    }
    // bottom row
    cells.add(cells.size(), new Vector<Cell>());
    for (int i = 0; i < cells.get(1).size(); i++) {
      cells.get(cells.size() - 1).add(new Cell(
        new Position(pos.getX() + CELL_SIZE * (i - 1), pos.getY() + CELL_SIZE * dimensions.y)
      ));
    }
  }
  
  private int checkNeighbors(GridPosition cell) {
    int count = 0;
    for (int j = cell.y - 1; j < cell.y + 2; j++) {
      for (int i = cell.x - 1; i < cell.x + 2; i++) {
        if (cells.get(j).get(i).isMine()) count++; // we can count this one because it is not a mine
      }
    }
    return count;
  }
  
  public void revealZeroNeighbors() {
    Queue<GridPosition> queue = new LinkedList<>();
    HashSet<GridPosition> visited = new HashSet<>();
    for (int j = 0; j < cells.size(); j++) {
      for (int i = 0; i < cells.get(0).size(); i++) {
        Cell cell = cells.get(j).get(i);
        if (cell.isRevealed() && !cell.isMine() && !cell.isEdge() && cell.getNeighbors() == 0) {
          GridPosition position = new GridPosition(i, j);
          queue.add(position);
          visited.add(position);
        }
      }
    }
    
    // process queue
    while (!queue.isEmpty()) {
      GridPosition current = queue.poll();
      for (int j = current.y - 1; j < current.y + 2; j++) {
        for (int i = current.x - 1; i < current.x + 2; i++) {
          Cell neighbor = cells.get(j).get(i);
          GridPosition neighborPosition = new GridPosition(i, j);
          if (!neighbor.isRevealed() && !neighbor.isEdge() && !visited.contains(neighborPosition)) {
            neighbor.setRevealed();
            // add neighbor back into queue if it's also a zero
            if (neighbor.getNeighbors() == 0) {
              queue.add(neighborPosition);
              visited.add(neighborPosition);
            }
          }
        }
      }
    }
  }
  
  public boolean autoReveal(GridPosition click) {
    // Mines are excluded
    if (cells.get(click.y).get(click.x).isMine()) {
      return false;
    }
    // first check if surrounding flags equals cell's number
    int flagCount = 0;
    for (int j = click.y - 1; j < click.y + 2; j++) {
      for (int i = click.x - 1; i < click.x + 2; i++) {
        if (cells.get(j).get(i).isFlagged()) {
          flagCount++;
        }
      }
    }
    boolean mineTripped = false;
    // then reveal all non-flag spaces around
    if (flagCount == cells.get(click.y).get(click.x).getNeighbors()) {
      for (int j = click.y - 1; j < click.y + 2; j++) {
        for (int i = click.x - 1; i < click.x + 2; i++) {
          if (!cells.get(j).get(i).isFlagged()) {
            cells.get(j).get(i).interact(false);
            if (cells.get(j).get(i).isMine()) {
              mineTripped = true;
            }
          }
        }
      }
    }
    return mineTripped;
  }
  
  public void doMinesSummary() {
    for (int j = 0; j < cells.size(); j++) {
      for (int i = 0; i < cells.get(0).size(); i++) {
        Cell cell = getCell(new GridPosition(i, j));
        // reveal untouched mines
        if (cell.isMine() && !cell.isFlagged() && !cell.isRevealed() && !cell.isExploded()) {
          cell.setRevealed();
        }
        // set wrong flags
        else if (cell.isFlagged() && !cell.isMine()) cell.setMisflagged();
      }
    }
  }
  
  public void display() {
    for (Vector<Cell> row : cells) {
      for (Cell cell : row) {
        cell.display();
      }
    }
  }
  
  public boolean isMouseIn() {
    GridPosition wh = new GridPosition(cells.get(0).size(), cells.size());
    return mouseX > pos.getX() && mouseX < pos.getX() + wh.x * CELL_SIZE && 
           mouseY > pos.getY() && mouseY < pos.getY() + wh.y * CELL_SIZE;
  }
  
  public void reset() {
    cells = new Vector<Vector<Cell>>();
  }
}
