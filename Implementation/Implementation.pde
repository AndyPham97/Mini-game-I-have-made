int numBubbles = 5;// initial bubble count
final int BROKEN = -99; // code for "broken", may have other states later
final int MAXDIAMETER = 120; // maximum size of expanding bubble
int phase = 1;
boolean start = false;
int newSize = numBubbles;
int random = 0, movement = 0; //Each type of bubble will be randomly added to the field
int interval = 5;


ArrayList pieces; // all the playing pieces
Player prophet; //Secondary player


void setup() 
{
  pieces = new ArrayList(numBubbles);
  fullScreen();
  noStroke();
  smooth();
  prophet = new Player(width/2, 800, 40, #951818);
  for (int i = 0; i < numBubbles; i++)
  {
    random = int(random(4));
    pieces.add(new Bubble(random(width), random(300), 30, i, pieces, random));
  }
}

void keyPressed() {
  //Prophet movement

   if (key == 'd')
     prophet.playerX += prophet.vx;
   else if (key == 'a')
     prophet.playerX -= prophet.vx;
   else if (key == 'w')
     prophet.playerY -= prophet.vy;
   else if (key == 's')
     prophet.playerY += prophet.vy;
}

void mousePressed()
{
  if (start == true) { //Prevents making accidental attacks before the game actually starts
      // on click, create a new burst bubble at the mouse location and add it to the field
      Bubble b = new Bubble(mouseX,mouseY,2,numBubbles,pieces, 5);
      b.burst();
      pieces.add(b);
      numBubbles++;
  }
    
}
void draw() 
{
  background(#7C0622);
  textSize(28);
  fill(255,255,255);
  textAlign(CENTER);
  text("The plagues have been terroizing the earth bit by bit, humanity gripping on the brink of extinction", width/2, 200);
  text("But one remains and that is you, the prophet, who is the only survivor left", width/2, 230);
  text("A god from this universe has stepped out to protect the earth but most importantly to protect his prophet", width/2, 260);
  text("Press ENTER to save the earth", width/2, 340);
  prophet.drawPlayer();  
 
 if (keyCode == ENTER) {
   start = true;
 }
  
 if (start == true) {
    background(0);
    String text = "PHASE " + phase;
    textAlign(LEFT);
    textSize(32);
    fill(255,255,255);
    text(text, 0, 30);    
    
    prophet.drawPlayer();  
    for (int i = 0; i < numBubbles; i++) {
      Bubble b = (Bubble)pieces.get(i); // get the current piece
      if (b.diameter < 1) // if too small, remove
        {
    pieces.remove(i);
    numBubbles--;
    i--;
        }
      else
        {
    // check collisions, update state, and draw this piece
          if (b.broken == BROKEN)
          // only bother to check collisions with broken bubbles
         b.collide();
    b.update();
    b.display(); 
    prophet.playerDeath();
        }
    }
    
    
      if (numBubbles == 0 && phase <= 15) { //Once you destroy all the bubbles and you stop attacking afterwards
      phase++; //Advancing through next phase
      newSize = newSize + 3; //Increase next batch by 1
      pieces = new ArrayList(newSize);
      numBubbles = newSize;
      
      for (int i = 0; i < numBubbles; i++)
          {
            random = int(random(4));
            pieces.add(new Bubble(random(width), random(300), 30, i, pieces, random));
          }
      }
    
    else if (prophet.death) {
        background(0);
        textSize(40);
        textAlign(CENTER);
        fill(255,255,255);
        text("THE PROPHET HAS DIED! GAME OVER, NOW THE WORLD SHALL BE EXTINCT", width/2, height/2);
      }
     
     else if (phase == 16)
     {
   background(255,255,255);
   textSize(28);
   fill(0);
   textAlign(CENTER);
   text("You saved the world! Human race is saved and you, the prophet will be the next", width/2, 200);
   text("god for this world. A new history and beginning, humanity can be restored finally.", width/2, 230);
   text("Farewell, be the new god in this infinetely expanding universe and time. I wish you good luck.", width/2, 290);
 }
 }
}
/*-------------------------------------------------------------*/
// "Bubble" class: all playing pieces
class Bubble {
  float x, y; // coordinates
  float diameter; 
  float vx = 0; // x velocity
  float vy = 0; // y velocity
  int id;
  int broken = 0; // is it broken or not
  float growrate = 0;
  ArrayList others; // all the other bubbles
  // note, bubbles need to know where the others are to process collisions
  
  int states; 
  
 
  Bubble(float xin, float yin, float din, int idin, ArrayList oin,  int s) {
    x = xin;
    y = yin;
    diameter = din;
    growrate = 0;
    id = idin;
    vx = random(0,100)/50. - 1.;
    vy = random(0,100)/50. - 1.;
    states = s;
    
    others = oin;
  } 
  void burst()
  {
    if (this.broken != BROKEN) // only burst once
      {
  this.broken = BROKEN;
  this.growrate = 2; // start it expanding
      }
  }
  
  void collide() {
    Bubble b;
    
    // check collisions with all bubbles
    for (int i = 0; i < numBubbles; i++) {
     
      b = (Bubble)others.get(i);
      
      float dx = b.x - x;
      float dy = b.y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = b.diameter/2 + diameter/2;
      if (distance < minDist) { // collision has happened
  if ((this.broken == BROKEN) || (b.broken == BROKEN))
    {
      // broken bubbles cause others to break also
      
      b.burst();
    }
      }
    }   
  }
  
  void update() {
    if (this.broken == BROKEN)
      {
  this.diameter += this.growrate;
  if (this.diameter > MAXDIAMETER) // reached max size
    this.growrate = -0.75; // start shrinking
      }
    else
      {
        
      int timer = interval - int(millis()/1000);
  if (states == 0) {
      x += 2*vx;
      y += 2*vy;
    }
    
    else if (states == 1) {
      x += vx;
      y -= 8*vy;
    }
    
    else if (states == 2) {
       x += 10*vx;
       y -= 2*vy;
    }
    
   else if (states == 3) {
       if (timer < 0) {
         movement = int(random(3));
         interval += 5;
       }
       
           
         if (movement == 0) {
            x -= 4*vx;
            y -= 4*vy;
          }
          
          else if (movement == 1) {
            x += 3*vx;
            y += 3*vy;
          }
          
          else if (movement == 2) 
             x += 8*vx;
      }

  
  // the rest: reflect off the sides and top and bottom of the screen
  if (x + diameter/2 > width) {
    x = width - diameter/2;
    vx *= -1; 
  }
  else if (x - diameter/2 < 0) {
    x = diameter/2;
    vx *= -1;
  }
  if (y + diameter/2 > height) {
    y = height - diameter/2;
    vy *= -1; 
  } 
  else if (y - diameter/2 < 0) {
    y = diameter/2;
    vy *= -1;
  }
      }
  }
  
  void display() {
    // how to draw a bubble: set to white with some transparency, draw a circle
    if (states == 0) {
      fill(#B4238B); 
      ellipse(x, y, diameter, diameter);
    }
    
    else if (states == 1) {
      fill(#5C10C9); 
      ellipse(x, y, diameter, diameter);
    }
    
    else if (states == 2) {
      fill(#861498); 
      ellipse(x, y, diameter, diameter);
    }
    
    else if (states == 3) {
      fill(#0CB4C9);
      ellipse(x, y, diameter, diameter);
    }
    
    else {
      fill(255, 204); 
      ellipse(x, y, diameter, diameter);
    }
  }
}

class Player {
  float playerX, playerY;
  float diameter;
  color body;
  boolean death;
  float vx;
  float vy;
  
  public Player(float x, float y, float d, color s) {
    playerX = x;
    playerY = y;
    diameter = d;
    body = s; 
    death = false;
    vx = 5;
    vy = 5;
  }
  
  void drawPlayer() {
    fill(body);
    ellipse(playerX, playerY, diameter, diameter);
  }
  
  void playerDeath() {
      Bubble b;
      for (int i = 0; i < numBubbles; i++) {
      
        b = (Bubble)pieces.get(i);
        float dx = b.x - this.playerX;
        float dy = b.y - this.playerY;
        float distance = sqrt(dx*dx + dy*dy);
        float minDist = b.diameter/2 + this.diameter/2;
        
        if (distance < minDist) 
          death = true;
      }
  }
}