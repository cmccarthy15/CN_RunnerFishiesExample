class Obstacle {
  private int xPosition;
  private int yPosition;
  private int rate; //speed

  
  //Constructor
  public Obstacle(int xPos, int yPos, int r) {
    xPosition = xPos;
    yPosition = yPos;
    rate = r;
  }
  
  public void setRate(int x){
    rate = x;
  }
  
  public void setXpos(int x){
    xPosition = x;
  }
  
  public int getXpos(){
    return xPosition; 
  }
  
  public int getRightSide(){
    return xPosition + 50; 
  }
  
  public int getTopSide(){
    return yPosition; 
  }
  
  //Draw the obstacle
  public void display() {
    //Draw each obstacle as a rectangle using the variables in the class
    stroke(0);
    fill(0);
    xPosition -= rate;
    rect(xPosition,yPosition,50,50);
  }
  
}  









/*Personalization Up challenge
  Add variables for color, width, height 
*/