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

// CUSTOM MOUSE MOVING TOOL
int mouseMoving = 0;
void mouseMoved() {
  mouseMoving = 20;
  // decrement by 1 at the end of drawing phase
}

// CONSTANTS
int CELL_SIZE = 20;
Color BASE_GRAY = new Color(170);
Color PRESSED_GRAY = new Color(150);

// Variables
boolean firstClick = false;
boolean gameOver = false;
boolean gameWin = false;
int restartDelay = 100;

int gridW = 50; // 50
int gridH = 35; // 35
int mineCount = gridW * gridH / 5;
int revealToWin = gridW * gridH - mineCount;
int revealCount = 0;

// Objects
Grid gameGrid;
GridPosition[] mines;
Vector<Color> numberColors;
Button restartButton;

void setup() {
  frameRate(5);
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
  
  restartButton = new Button(new Position(400, 315), 200, 70, "Restart", false);
}

void draw() {
  if (mouseMoving > 0) frameRate(60);
  else                 frameRate(5 );
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
  else if (gameOver || gameWin) {
    frameRate(30);
    // Initial events
    restartDelay--;
    if (restartDelay < 0) restartDelay = 0;
    if (restartDelay == 0) restartButton.activate();
    
    // Mouse events
    if (mousePressed) {
      if (restartButton.isMouseWithin() && !restartButton.isPressed()){
        restartButton.toggle();
      }
    }
    if (mouseChoose) {
      if (restartButton.isMouseWithin()) {
        mines = gameGrid.getMines(gridW, gridH, mineCount);
        firstClick = false;
        gameOver = false;
        gameWin = false;
        gameGrid.reset();
        mines = gameGrid.getMines(gridW, gridH, mineCount);
        restartButton.deactivate();
        restartDelay = 100;
      }
    }
  }
  else {
    
  }
  
  // Display
  gameGrid.display();
  restartButton.display();
  
  // Misc.
  mouseChoose = false;
  mouseMoving--;
  if (mouseMoving < 0) mouseMoving = 0;
  
  fill(0, 255, 0);
  noStroke();
  textSize(30);
  textAlign(RIGHT);
  text((int)frameRate, 1000, 40);
  text(mouseMoving, 1000, 80);
  text(restartDelay, 1000, 120);
}
