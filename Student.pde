// Alan Jiang
// PLEASE PLACE YOUR CODE IN THIS TAB

void student_displayDancer(pt H, pt K, pt A, pt E, pt B, pt T, float hipAngle) // displays dancer using dimensions
{
  caplet(H,_rH,K,_rK);
  caplet(K,_rK,A,_rA);
  caplet(A,_rA,E,_rE);
  caplet(E,_rE,B,_rB);
  caplet(B,_rB,T,_rT);
  caplet(A,_rA,B,_rB);
  if (animate) {
    fill(blue);
    pt torso = P(H); torso.y -= 120;
    caplet(torso, _rH * 1.6, H, _rH);
    pt neck = P(torso); neck.y -= 70;
    pt head = P(neck); head.y -= 60;
    caplet(head, 40, neck, 20);
  } else {
  noFill(); pen(magenta,2); edge(H,P(H,R(V(0,100),hipAngle)));
  }
}

//MODULE TWO
// Recompute global dancer points (_H,..._T) from Hip center, Ball center, leg dimensions, and angle a btweeen HB and HK
void student_computeDancerPoints
    (
    pt H,     // hip center
    pt B,     // ball center 
    float a,   // angle between HB and HK
    pt OB,    // other ball center
    float oa  //angle between HOB and HOK
    )
  {
   _H.setTo(H);
   _B.setTo(B); _OB.setTo(OB);
   _B.y = height - ground - _rB; _OB.y = height - ground - _rB;
   _T = P(sqrt(sq(_bt) - sq(_B.y - (height - ground))) + _B.x, height - ground);
   _OT = P(sqrt(sq(_bt) - sq(_OB.y - (height - ground))) + _OB.x, height - ground);
   //_T = P.G[5];
   vec HB = V(H, B); vec OHB = V(H, OB);
   float _hb = d(H, B), _ohb = d(H, OB);
   _K = P(H, _hk / _hb, R(HB, a)); _OK = P(H, _hk / _ohb, R(OHB, oa));
   //_K=P.G[1]; 
   float angle = acos((sq(_ka) + sq(d(_K, B)) - sq(_ab)) / (2 * _ka * d(_K, B)));
   _A = P(_K, _ka / d(_K, B), R(V(_K, B), angle));
   angle = acos((sq(_ka) + sq(d(_OK, OB)) - sq(_ab)) / (2 * _ka * d(_OK, OB)));
   _OA = P(_OK, _ka / d(_OK, OB), R(V(_OK, OB), angle));
   //_A=P.G[2]; 
   angle = acos((sq(_ae) + sq(d(_A, B)) - sq(_eb)) / (2 * _ae * d(_A, B)));
   _E = P(_A, _ae / d(_A, B), R(V(_A, B), angle));
   angle = acos((sq(_ae) + sq(d(_OA, OB)) - sq(_eb)) / (2 * _ae * d(_OA, OB)));
   _OE = P(_OA, _ae / d(_OA, OB), R(V(_OA, OB), angle));
   //_E=P.G[3]; 
   }
   
void caplet(pt A, float rA, pt B, float rB) // displays Isosceles Trapezoid of axis(A,B) and half lengths rA and rB
  {
  show(A,rA);
  show(B,rB);
  // replace the line blow by your code to draw the proper caplet (cone) that the function displays th ecnvex hull of the two disks
  capletcone(A,rA,B,rB);
  }
//MODULE ONE
void capletcone(pt A, float rA, pt B, float rB) // displays Isosceles Trapezoid of axis(A,B) and half lengths rA and rB 
{
  float d = d(A, B); //d is the distance between A and B
  float x = (sq(rA) - (rB * rA)) / d;
  float y = sqrt(sq(rA) - sq(x));
  pt H = P(A, x / d, V(A, B)); //midpoint of line segment formed by edge intersections on A
  pt C = P(H, y / d, R(V(A, B))); //edge intersection on A
  pt D = P(B, rB / rA, V(A, C)); //edge intersection on B.  Vector from B to D is parallel to AC so I use that vector.
  pt CP = P(H, y / d * -1, R(V(A, B))); //opposite intersections
  pt DP = P(B, rB / rA, V(A, CP));
  //vec T = U(A,B);
  //vec N = R(T);
  //pt LA = P(A,-rA,N);
  //pt LB = P(B,-rB,N);
  //pt RA = P(A,rA,N);
  //pt RB = P(B,rB,N);
  beginShape(); v(C); v(D); v(DP); v(CP); endShape(CLOSE);
}

float floatLerp(float a, float b, float t) {
  if (t < 0) t = 0;
  if (t > 1) t = 1;
  return a + (t * (b - a));
}

    //(
    //pt H,     // hip center
    //float hk, // distance from to 
    //pt K,     // knee center 
    //float ka, // distance from to 
    //pt A,     // ankle center 
    //float ae, // distance from to 
    //pt E,     // heel center
    //float eb, // distance from to 
    //float ab, // distance from to 
    //pt B,     // ball center 
    //float bt, // distance from to 
    //pt T,     // toe center
    //float a   // angle between HB and HK
    //)