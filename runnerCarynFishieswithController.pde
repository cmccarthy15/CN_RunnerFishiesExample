//potentiometer to make the fishies bigger and smaller
//photoresistor to make the scuba diver go up and down
//button to make them stop max of two times 

import cc.arduino.*;
import org.firmata.*;

import processing.serial.*;

Arduino myPort;

/****** GLOBAL VARIABLE INIT *******/
final int GAME_STATE_START = 0;
final int GAME_STATE_RUNNING = 1;
final int GAME_STATE_END = 2;

int gameScreen = GAME_STATE_START;
float speed = 10;
float fishSpeed = speed;
float grow; 
int pauses;

int cloudX;
int grassX;
int skyRed = 135;

int runnerX;
float runnerY;
float runnerSize;


float gravity;
float jumpVel;
int jumpCount;

int offset;

int sensorPin = 0;
float sensorSignal;
int potPin = 1;
int potSignal;
int buttonPin = 3;
int buttonSignal;

//Obstacle test = new Obstacle(800,450,5);
//Obstacle [] obstacles = new Obstacle[5];
Fish [] fishies = new Fish[10];

int groundLevel;

PImage img;
//PImage sand;

void setup() { 
  //printArray(Arduino.list());
  myPort = new Arduino(this, Arduino.list()[3], 57600);
  myPort.pinMode(sensorPin, Arduino.INPUT);
  myPort.pinMode(potPin, Arduino.INPUT);
  myPort.pinMode(buttonPin, Arduino.INPUT);

  size(900, 600);

  img = loadImage("deepUnderwater.jpg");
  //sand = loadImage("sand.png");

  cloudX = width;
  grassX = width - 200; 

  //Set player position
  runnerX = 100;
  groundLevel = height - 50;
  runnerY = height - 50; 
  runnerSize = 50;
  gravity = 1;
  offset = 100;
  grow = 1;
  pauses = 0;

  for (int i = 0; i < fishies.length; i++) {
    fishies[i] = new Fish(random(1000+offset, offset+1100), random(10, height), fishSpeed, grow);
    offset += 300;
  }
  //for (int i = 0; i < obstacles.length; i++) {
  //  obstacles[i] = new Obstacle(900+offset, 450, speed);
  //  offset += 400;
  //}
}

void resetComponents() {
  cloudX = width;
  grassX = width - 200;  
  //Set player position
  runnerX = 100;
  groundLevel = height - 50;
  runnerY = height - 50; 
  gravity = 1;
  offset = 100;

  for (int i = 0; i < fishies.length; i++) {
    fishies[i].resetPos(random(1000+offset, offset+1100), random(10, height), speed, grow);
    offset += 300;
  }
}
void draw() {
  //try to keep this is simple as possible
  //conditional that consist of the three game states. Game state determines which
  //screen gets draw

  drawGameBackground();
  if (gameScreen == GAME_STATE_START) {
    drawGameStartScreen();
  } else if (gameScreen == GAME_STATE_RUNNING) {
    drawMainGameScreen();
  } else if (gameScreen == 2) {
    drawGameEndScreen();
    resetComponents();
  }

  buttonSignal = myPort.digitalRead(buttonPin);
  //println(buttonSignal + "   " + gameScreen + "    " + pauses);
  if (buttonSignal == Arduino.HIGH) {
    if (gameScreen == 0) {
      gameScreen = 1;
    } else if (gameScreen == 2) {
      gameScreen = 0;
    }
    //if (gameScreen == 1 && pauses < 2) {
    //  pauses += 1;
    //  resetComponents();
    //}
  }

  sensorSignal = myPort.analogRead(sensorPin);
  grow = 1 + (sensorSignal/15);
}

void drawGameBackground() {
  noStroke();
  //background(0,0,255);

  image(img, 0, 0, width, height);
  //image(sand, 0, height-100, width, 100);

  //sand
  //fill(232,232,194);
  //rect(0, height - 100, width, 100);

  ////ground
  //fill(23,111,44);
  //rect(0, height - 100, width, 100);

  ////sky
  //fill(144, 228, 250);
  //rect(0, 0, width, height - 100);
  //fill(19,81,142,15);
  //rect(0, 0, width, height - 100);

  ////draw moving pieces
  //drawCloud();
  //drawGrass();
}

void drawGrass() {
  stroke(255);
  noFill();
  line(grassX, height - 100, grassX - 20, height - 125);
  line(grassX, height - 100, grassX, height - 125);
  line(grassX, height - 100, grassX + 20, height - 125);

  //update
  grassX-=speed; 
  if (grassX < 0) {
    grassX = width;
  }
}

void drawCloud() {
  fill(255);
  ellipse(cloudX, 50, 100, 45);

  //update
  cloudX-=speed;
  if (cloudX < 0) {
    cloudX = width;
  }
}


void drawGameStartScreen() {
  textAlign(CENTER);
  fill(255);
  textSize(26);
  text("Underwater Adventure", width/2, height/2);
  textSize(18);
  text("Press to Start", width/2, height/2 + 25);
  fill(0);
}

void drawMainGameScreen() {
  drawRunner();

  for (int i = 0; i < fishies.length; i++) {
    fishies[i].display();
    if (fishies[i].getXpos() < 0) {
      fishSpeed+=.5;
      fishies[i].resetPos(random(1000+(300*i), 1100+(300*i)), random(10, height), fishSpeed, grow);
    }
    boolean hasCollided = didCollisionOccur(fishies[i]);
    if (hasCollided) {
      gameScreen = 2;
      pauses = 0;
    }
  }
}
boolean didCollisionOccur(Fish o) {
  float fishX = o.getXpos();
  float fishY = o.getYpos();
  float fishSize = o.getSize();

  float distan = dist(fishX, fishY, runnerX, runnerY);
  if (distan < runnerSize + fishSize) {
    return true;
  }
  return false;
}


void drawRunner() {

  //outer helmet
  fill(206, 160, 104);
  noStroke();
  ellipse(runnerX, runnerY, runnerSize, runnerSize);

  //mask hole outer edge
  strokeWeight(2);
  stroke(0);
  fill(188, 145, 93);
  ellipse(runnerX, runnerY, 32, 32);

  //mask hole blue face
  fill(0);
  ellipse(runnerX, runnerY, 22, 22);

  //reflection
  //fill(225);
  //ellipse(runnerX - 4, runnerY - 4, 8, 7);

  //lattice
  stroke(188, 145, 93);
  line(runnerX - 4, runnerY - 12, runnerX + 12, runnerY + 4);
  line(runnerX - 12, runnerY - 4, runnerX + 4, runnerY + 12);
  line(runnerX + 4, runnerY - 12, runnerX - 12, runnerY + 4);
  line(runnerX + 12, runnerY - 4, runnerX - 4, runnerY + 12);

  potSignal = myPort.analogRead(potPin);
  //println(potSignal);
  runnerY = map(potSignal, 0.0, 1023.0, 0.0, 590.0);
  //skyRed = sensorSignal * 8;

  //jumpin time!
  //if (jumpVel > 0) {
  //  jumpVel -= gravity;
  //  runnerY -= jumpVel;
  //} else if (jumpVel <= 0 && runnerY < groundLevel) {
  //  jumpVel -= gravity;
  //  runnerY -= jumpVel;
  //}
  //if (runnerY >= groundLevel) {
  //  jumpCount = 0;
  //  runnerY = groundLevel;
  //}
}




void drawGameEndScreen() {
  //draw the end game screen
  fill(255);
  textAlign(CENTER);
  textSize(26);
  //text("Score: " + score + "/" + obstacles.length, width/2, height/2);
  textSize(18);
  text("Press Space to Play Again", width/2, height/2 + 25);
  fill(0);
}




/******** INPUT FUNCTIONS ********/
void keyPressed() {
  //use space bar to move from start screen to 
  if (key == ' ') {  
    if (gameScreen == 0) {
      gameScreen = 1;
    } else if (gameScreen == 1 && jumpCount < 2) {
      //jumpVel = 20;
      //jumpCount+=1;
    } else if (gameScreen == 2) {
      gameScreen = 0;
    }
  }
  if (key == 'q') {
    if (gameScreen == 1) {
      gameScreen = 2;
      pauses = 0;
    }
  }
  if (key == 'g') {
    if (gameScreen == 1) {
      grow += 1;
    }
  }
}