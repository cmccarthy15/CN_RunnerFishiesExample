class Fish {
  private int red;
  private int green;
  private int blue;
  private float size;
  private float speed;
  private float xPos;
  private float yPos;

  public Fish(float x, float y, float fast, float s) {
    xPos = x;
    yPos = y;
    size = s;
    speed = fast;
    red = 252;
    green = 140;
    blue = 102;
  }

  public void display() {
    noStroke();
    fill(255, 0, 0);
    ellipse(xPos, yPos, 50*size, 40*size);
    triangle(xPos, yPos, xPos + (40*size), yPos - (10*size), xPos + (40*size), yPos + (10*size));
    fill(0);
    ellipse(xPos - (15*size), yPos - (5*size), 5*size, 5*size);
    xPos-=speed;
  }
  
  public void resetPos(float x, float y, float rate, float s){
    xPos = x;
    yPos = y;
    speed = rate;
    size = s;
  }
  
  public float getXpos(){
    return xPos;
  }
  
  public float getYpos(){
    return yPos;
  }
  
  public float getSize(){
    return (45*size)/2;
  }
}