public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_BOMBS = 1;
int tileCount = 0;

import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

public void setup ()
{
  size(400, 500);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }
  for (int i = 0; i < NUM_BOMBS; i++) {
    setBombs();
  }
}
public void setBombs()
{
  while(bombs.size() < NUM_BOMBS) {  
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if (!bombs.contains(buttons[r][c])) {
      bombs.add(buttons[r][c]);
      System.out.println(c + ", " + r);
    }
  }
}

public void draw ()
{
  background( 0 );
  fill(0);
  stroke(180,140,20);
  strokeWeight(5);
  rect(0,401,400,99);
  stroke(0);
  strokeWeight(1);
  if (isWon())
    displayWinningMessage();
  // for (int i = 0; i < NUM_ROWS; i++) {
  //   for (int j = 0; j < NUM_COLS; j++) {
  //     buttons[i][j].draw();
  // }
}
public boolean isWon()
{
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      if (buttons[i][j].isClicked() == true || buttons[i][j].isMarked() == true)
        return true;
    }
  }
  return false;
}
public void displayLosingMessage()
{
    for(int i = 0; i < bombs.size(); i++) {
      if (bombs.get(i).isClicked() == false)
        bombs.get(i).mousePressed();
    }
    buttons[NUM_ROWS/2][(NUM_COLS/2)-5].setLabel("G");
    buttons[NUM_ROWS/2][(NUM_COLS/2)-4].setLabel("A");
    buttons[NUM_ROWS/2][(NUM_COLS/2-3)].setLabel("M");
    buttons[NUM_ROWS/2][(NUM_COLS/2-2)].setLabel("E");
    buttons[NUM_ROWS/2][(NUM_COLS/2-1)].setLabel("");
    buttons[NUM_ROWS/2][(NUM_COLS/2)].setLabel("O");
    buttons[NUM_ROWS/2][(NUM_COLS/2+1)].setLabel("V");
    buttons[NUM_ROWS/2][(NUM_COLS/2+2)].setLabel("E");
    buttons[NUM_ROWS/2][(NUM_COLS/2+3)].setLabel("R");
    buttons[NUM_ROWS/2][(NUM_COLS/2+4)].setLabel("!");

}
public void displayWinningMessage()
{
    buttons[NUM_ROWS/2][(NUM_COLS/2)-4].setLabel("V");
    buttons[NUM_ROWS/2][(NUM_COLS/2)-3].setLabel("I");
    buttons[NUM_ROWS/2][(NUM_COLS/2-2)].setLabel("C");
    buttons[NUM_ROWS/2][(NUM_COLS/2-1)].setLabel("T");
    buttons[NUM_ROWS/2][(NUM_COLS/2)].setLabel("O");
    buttons[NUM_ROWS/2][(NUM_COLS/2+1)].setLabel("R");
    buttons[NUM_ROWS/2][(NUM_COLS/2+2)].setLabel("Y");
    buttons[NUM_ROWS/2][(NUM_COLS/2+3)].setLabel("!");

}

public class MSButton
{
  private int r, c;
  private float x, y, width, height;
  private boolean clicked, marked;
  private String label;

  public MSButton ( int rr, int cc )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    r = rr;
    c = cc; 
    x = c*width;
    y = r*height;
    label = "";
    marked = clicked = false;
    Interactive.add( this ); // register it with the manager
  }
  public boolean isMarked()
  {
    return marked;
  }
  public boolean isClicked()
  {
    return clicked;
  }
  // called by manager

  public void mousePressed () 
  {
      clicked = true;
      if (mouseButton == RIGHT) {
        marked = !marked;
      }
      else if (bombs.contains(this)) {
        clicked = true;
        displayLosingMessage();
      }
      else if (countBombs(r,c) > 0) {
        label = "" + countBombs(r,c);
        if (!clicked)
          tileCount++;
        clicked = true;
      }
    else {
      if (isValid(r-1,c) == true && buttons[r-1][c].isClicked() == false) 
        buttons[r-1][c].mousePressed();
      if (isValid(r+1,c-1) == true && buttons[r+1][c-1].isClicked() == false)
        buttons[r+1][c-1].mousePressed();
      if (isValid(r-1,c+1) == true && buttons[r-1][c+1].isClicked() == false)
        buttons[r-1][c+1].mousePressed();
      if (isValid(r+1,c) == true && buttons[r+1][c].isClicked() == false)
        buttons[r+1][c].mousePressed();
      if (isValid(r,c-1) == true && buttons[r][c-1].isClicked() == false)
        buttons[r][c-1].mousePressed();
      if (isValid(r,c+1) == true && buttons[r][c+1].isClicked() == false)
        buttons[r][c+1].mousePressed();
      if (isValid(r+1,c+1) == true && buttons[r+1][c+1].isClicked() == false)
        buttons[r+1][c+1].mousePressed();
      if (isValid(r-1,c-1) == true && buttons[r-1][c-1].isClicked() == false)
        buttons[r-1][c-1].mousePressed();
    }
  }

  public void draw () 
  {    
    if (marked)
      fill(0);
    else if ( clicked && bombs.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(label, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    label = newLabel;
  }
  public boolean isValid(int r, int c)
  {
    if (r < 20 && r >= 0) {
      if (c < 20 && c >=0)
        return true;
    return false;
  }
  return false;
  }
  public int countBombs(int row, int col)
  {
    int sum = 0;
     if (isValid(row-1,col) == true && bombs.contains(buttons[row-1][col]))
        sum++;
      if (isValid(row+1,col) == true && bombs.contains(buttons[row+1][col]))
        sum++;
      if (isValid(row,col-1) == true && bombs.contains(buttons[row][col-1]))
        sum++;
      if (isValid(row,col+1) == true && bombs.contains(buttons[row][col+1]))
        sum++;
      if (isValid(row-1,col+1) == true && bombs.contains(buttons[row-1][col+1]))
        sum++;
      if (isValid(row-1,col-1) == true && bombs.contains(buttons[row-1][col-1]))
        sum++;
      if (isValid(row+1,col+1) == true && bombs.contains(buttons[row+1][col+1]))
        sum++;
      if (isValid(row+1,col-1) == true && bombs.contains(buttons[row+1][col-1]))
        sum++;
    return sum;
  }
}
