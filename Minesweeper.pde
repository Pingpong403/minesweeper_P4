// MINESWEEPER
import java.util.Vector;
import java.util.Queue;
import java.util.LinkedList;
import java.util.HashSet;
import java.util.Random;

// CUSTOM MOUSE CLICKING TOOL
boolean mouseChoose = false;
void mouseReleased() {
  mouseChoose = true;
  // set to false at the end of drawing phase
}

// CONSTANTS
int CELL_SIZE = 20;
Color BASE_GRAY = new Color(170);
Color PRESSED_GRAY = new Color(150);

// Variables
boolean firstClick = false;
boolean gameOver = false;
boolean gameWin = false;

int gridW = 50; // 50
int gridH = 35; // 35
int mineCount = gridW * gridH / 5;
int revealToWin = gridW * gridH - mineCount;
int revealCount = 0;

// Objects
Grid gameGrid;
GridPosition[] mines;
Vector<Color> numberColors;

void setup() {
  size(1000, 700);
  
  Position gridPos = new Position(500 - CELL_SIZE * ((float)gridW / 2), 350 - CELL_SIZE * ((float)gridH / 2));
  gameGrid = new Grid(gridPos);
  mines = gameGrid.getMines(gridW, gridH, mineCount);
  
  numberColors = new Vector<Color>();
  numberColors.add(BASE_GRAY);
  numberColors.add(new Color(7, 1, 247));
  numberColors.add(new Color(6, 126, 0));
  numberColors.add(new Color(254, 1, 1));
  numberColors.add(new Color(2, 0, 127));
  numberColors.add(new Color(127, 1, 2));
  numberColors.add(new Color(7, 127, 127));
  numberColors.add(new Color(0));
  numberColors.add(new Color(128));
}

void draw() {
  background(255);
  
  if (!gameOver && !gameWin) {
    // Initial events
    
    // visually de-select all mines
    for (Vector<Cell> row : gameGrid.getCells()) {
      for (Cell cell : row) {
        cell.setClicked(false);
      }
    }
    
    // Mouse events
    
    // select cell if mouse is depressed only
    if (mousePressed && mouseButton != RIGHT) {
      gameGrid.getSelectedCell().setClicked(true);
    }
    
    // events that happen when mouse is released
    if (mouseChoose) {
      // find cardinal mouse grid position
      GridPosition clickPos = gameGrid.getSelectedGridPosition();
      Cell clickedCell = gameGrid.getSelectedCell();
      
      boolean clickedFlag = clickedCell.isFlagged();
      boolean rightClick = mouseButton == RIGHT;
      // when a spot is first clicked
      if (!rightClick && !firstClick && gameGrid.isMouseIn() && !clickedFlag) {
        gameGrid.generateGrid(mines, clickPos);
        clickPos = gameGrid.getSelectedGridPosition();
        firstClick = true;
      }
      
      // single cell interactions
      gameOver = clickedCell.interact(rightClick);
      if (clickedCell.isRevealed() && !rightClick) {
        gameOver = gameGrid.autoReveal(clickPos) || gameOver;
      }
      
      if (gameOver) {
        // reveal mines & show incorrect flags
        gameGrid.doMinesSummary();
      }
      
      // Every time the mouse is clicked, reveal spaces around cells with 0 neighboring mines
      gameGrid.revealZeroNeighbors();
    }
  }
  else if (gameOver) {
    // Initial events
    
    // Mouse events
    
  }
  else if (gameWin) {
    // Initial events
    
    // Mouse events
    
  }
  else {
    
  }
  
  // Display
  gameGrid.display();
  
  // Misc.
  mouseChoose = false;
}
