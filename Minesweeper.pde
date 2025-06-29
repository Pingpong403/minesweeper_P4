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
  mouseMoving = 40;
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
int correctFlags = 0;

// Objects
Grid gameGrid;
GridPosition[] mines;
Vector<Color> numberColors;
Button restartButton;

void settings() {
  size(CELL_SIZE * gridW, CELL_SIZE * gridH);
}

void setup() {
  frameRate(5);
  
  int centerX = width / 2;
  int centerY = height / 2;
  Position gridPos = new Position(centerX - CELL_SIZE * ((float)gridW / 2), centerY - CELL_SIZE * ((float)gridH / 2));
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
  
  int buttonW = width / 5;
  int buttonH = height / 10;
  restartButton = new Button(new Position(width / 2 - buttonW / 2, height / 2 - buttonH / 2), buttonW, buttonH, "Restart", false);
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
      if (clickedCell.isRevealed() && !rightClick) {
        gameOver = gameGrid.autoReveal(clickPos);
      }
      gameOver = clickedCell.interact(rightClick) || gameOver;
      if (rightClick && clickedCell.isMine()) {
        if (clickedCell.isFlagged()) correctFlags++;
        else correctFlags--;
      }
      
      if (correctFlags == mineCount) gameWin = true;
      
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
    if (restartDelay > 0) restartDelay--;
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
        correctFlags = 0;
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
  if (gameWin) {
    fill(100, 255, 255);
    noStroke();
    textSize(40);
    textAlign(CENTER);
    text("You Won!", width / 2, height / 2 - 60);
  }
  
  // Misc.
  mouseChoose = false;
  mouseMoving--;
  if (mouseMoving < 0) mouseMoving = 0;
  
  // debug
  //fill(0, 255, 0);
  //noStroke();
  //textSize(30);
  //textAlign(RIGHT);
  //text((int)frameRate, 1000, 40);
  //text(mouseMoving, 1000, 80);
  //text(correctFlags, 1000, 120);
}
