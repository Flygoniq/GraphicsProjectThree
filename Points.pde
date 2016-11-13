// Template for 2D projects
// Author: Jarek ROSSIGNAC Edited: Alan Jiang
import processing.pdf.*;    // to save screen shots as PDFs, does not always work: accuracy problems, stops drawing or messes up some curves !!!

//**************************** global variables ****************************
pts P = new pts(); // class containing array of points, used to standardize GUI
float t=0, f=0;
float ground = 50; //set ground level here
boolean animate=false, fill=false, timing=false;
boolean showLetters=true; // toggles to display vector interpoations
int ms=0, me=0; // milli seconds start and end for timing
int npts=100; // number of points
float _hipAngle=-PI/20;
float _ohipAngle=_hipAngle;//0;
pt _H=P(), _K=P(), _A=P(), _E=P(), _B=P(), _T=P(); // centers of Hip, Knee, Ankle, hEel, Ball, Toe
pt _OK=P(), _OA=P(), _OE=P(), _OB=P(), _OT=P(); //O stands for other
float _rH=100, _rK=50, _rA=20, _rE=25, _rB=15, _rT=5; // radii of Hip, Knee, Ankle, hEel, Ball, Toe
//float _rH=200, _rK=20, _rA=20, _rE=25, _rB=15, _rT=5; // radii of Hip, Knee, Ankle, hEel, Ball, Toe
// leg measures (to update press '/' and copy print here):
float _hk=319.979, _ka=266.46463, _ae=28.718777, _eb=117.23831, _ab=113.9619, _bt=44.75581; //distances: hip-knee, knee-ankle, ankle-heel, heel-ball, ball-toe
float _h = (950 - ground) / 2; // height of _H 
pt support, free;
float memory = 0;

int sillyCounter = 0;
//**************************** initialization ****************************
void setup()               // executed once at the begining 
  {
  size(800, 800);            // window size
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  P.declare(); // declares all points in P. MUST BE DONE BEFORE ADDING POINTS 
  //P.resetOnCircle(6); // sets P to have 4 points and places them in a circle on the canvas
  P.loadPts("data/pts");  // loads points form file saved with this program
  support = P.G[6]; free = P.G[4];
  memory = free.x;
  } // end of setup

//**************************** display current frame ****************************
void draw()      // executed at each frame
  {
  if(recordingPDF) startRecordingPDF(); // starts recording graphics to make a PDF
  
    background(white); // clear screen and paints white background
    pen(grey,3); line(0,height-ground,width,height-ground);  // show ground line
    
    pt H=P.G[0], K=P.G[1], A=P.G[2], E=P.G[3], B=P.G[4], T=P.G[5]; // local copy of dancer points from points of Polyloop P
    // Hip       Knee      Ankle    hEel       Ball      Toe
    pt OB = P.G[6];
 
    noFill(); pen(black,4); 
    //P.drawCurve(); 
    //edge(_A,_B);  // add (foot top) edge from Ankle to Ball
    if(showLetters) {pen(black,2); showId(_H,"H"); showId(_K,"K"); showId(_A,"A"); showId(_E,"E"); showId(_B,"B");showId(_T,"T");}
    
    noStroke(); fill(green);  student_displayDancer(_H,_K,_A,_E,_B,_T, _hipAngle);
    if (animate) {fill(red); student_displayDancer(_H,_OK,_OA,_OE,_OB,_OT, _ohipAngle);}
    student_computeDancerPoints(H,B,_hipAngle, OB, _ohipAngle); // computes _H,_K,_A,_E,_B,_T  from measures and _hipAngle
    if (!animate) {noFill(); pen(red,2); student_displayDancer(_H,_K,_A,_E,_B,_T, _hipAngle);}
    //if (animate) {noFill(); pen(red,2); student_displayDancer(_H,_OK,_OA,_OE,_OB,_OT, _ohipAngle);}
    
    //noFill(); pen(red,4); 
    //P.drawCurve(); 
    //edge(_A,_B);   
    if(showLetters) 
      { 
      pen(red,2); 
      showId(_H,"H"); showId(_K,"K"); showId(_A,"A"); showId(_E,"E"); showId(_B,"B");showId(_T,"T");
      }
      
  //MODULE THREE, amonng other parts
  if(animate) {
    if (t < 40) {//transfer
      P.G[0].x = floatLerp(support.x + ((free.x - support.x) / 4), free.x - ((free.x - support.x) / 4), t / 40);
    } else if (t < 80) {//collect
      free.x = floatLerp(memory, support.x, t / 40 - 1);
      P.G[0].x = floatLerp(support.x - ((support.x - memory) / 4), support.x + ((support.x - memory) / 4), t / 40 - 1);
    } else if (t < 120) {//aim
      free.x = floatLerp(support.x, support.x + 200, (t - 80) / 40);
      P.G[0].x = floatLerp(support.x + ((support.x - memory) / 4), support.x + ((support.x - memory) * 3 / 4), t / 40 - 2);
    }
    
    t++;
    if (t == 40) {
      pt temp = free;
      free = support;
      support = temp;
      memory = free.x;
    }
    if (t == 150) {
      t = 0;
      P.G[0].y = _h;
      P.G[0].x = 240;
      P.G[4].x = 360;
      P.G[6].x = 200;
      support = P.G[6]; free = P.G[4];
    }
  }
    

  if(recordingPDF) endRecordingPDF();  // end saving a .pdf file with the image of the canvas

  fill(black); displayHeader(); // displays header
  if(scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 

  if(filming && (animating || change)) snapFrameToTIF(); // saves image on canvas as movie frame 
  if(snapTIF) snapPictureToTIF();   
  if(snapJPG) snapPictureToJPG();   
  change=false; // to avoid capturing movie frames when nothing happens
  }  // end of draw
  