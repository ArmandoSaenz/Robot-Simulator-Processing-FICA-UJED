//Angle of the joints
float q1 =0.00;
float q2 =0.00;
//Distance of the joints
float l1 = 150;
float l2 = 120;
//Cardioid
float a = 160;
float b = l1+l2;
float[] phi = new float[120];
float[] x = new float[120];
float[] y = new float[120];
float offsetx = 0;
float offsety = 0;
//step
int step;
void setup()
{
  size(600,600,P3D);
  //Computed trajectory
  for(int i = 0; i<phi.length; i++)
  {
    phi[i] = i*2*PI/phi.length;
    x[i] = a*cos(phi[i]) + offsetx;
    y[i] = b*sin(phi[i]) + offsety;
  }
}

void draw()
{
  background(120);
  //Homogeneous transformation matrix with origin in window center and traditional orientation 
  applyMatrix(1,  0,  0, width/2,
              0, -1,  0, height/2,
              0,  0, -1, 0,
              0,  0,  0, 1);
  //The trajectory is drawed
  for(int i = 1; i<=step;i++)
  {
    line(x[i-1],y[i-1],x[i],y[i]);
  }
  //Solving inverse kinematic
  q2 = -acos((pow(x[step],2) + pow(y[step],2) - pow(l1,2) - pow(l2,2))/(2*l1*l2));
  q1 = atan2(l2*sin(q2),l1+l2*cos(q2)) + atan2(y[step],x[step]);
  //First joint
  rotateZ(q1);
  fill(255,255,0);
  arc(0, 0, 80, 80, PI/2, 3*PI/2, OPEN);
  noStroke();
  beginShape();
  vertex(0,-40);
  vertex(l1,-30);
  vertex(l1,30);
  vertex(0,40);
  endShape(CLOSE);
  stroke(0);
  line(0,-40,l1,-30);
  line(0,40,l1,30);
  arc(l1,0, 60, 60, 3*PI/2, 5*PI/2, OPEN);
  //Second joint
  translate(l1,0);
  rotateZ(-q2);
  fill(255,0,0);
  arc(0, 0, 50, 50, PI/2, 3*PI/2, OPEN);
  noStroke();
  beginShape();
  vertex(0,-25);
  vertex(l2,-15);
  vertex(l2,15);
  vertex(0,25);
  endShape(CLOSE);
  stroke(0);
  line(0,-25,l2,-15);
  line(0,25,l2,15);
  arc(l2,0, 30, 30, 3*PI/2, 5*PI/2, OPEN);
  delay(100);
  step++;
  step = step%phi.length;
}
