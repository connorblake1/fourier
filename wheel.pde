class wheel {
  private float spinRate;
  private float radius;
  private float x;
  private float y;
  private float vx;
  private float vy;
  private float angle;
  boolean isFixed;
  private boolean isEnd;
  wheel(float sR, float s, float x, float y, float a, boolean iF, boolean iE) {
    spinRate = sR;
    radius = s;
    this.x = x;
    this.y = y;
    angle = a;
    vx = cos(angle)*radius;
    vy = sin(angle)*radius;
    isFixed = iF;
    isEnd = iE;}
    
  void display() {
    pushMatrix();
      translate(x,y);
      strokeWeight(1);
      stroke(255);
      noFill();
      vx = cos(angle)*radius;
      vy = sin(angle)*radius;
      ellipse(0,0,2*radius,2*radius);
      strokeWeight(2);
      line(0,0,vx,vy);
    popMatrix();}
  void changeAngle() {
    angle += spinRate/100;} 
  float getVX() {
    return vx;}
  float getVY() {
    return vy;}
  float getX() {
    return x;}
  float getY() {
    return y;}  
  boolean fixed() {
    return isFixed;} 
  void changeX(float x) {
    this.x = x;} 
  void changeY(float y) {
    this.y = y;} 
  float getAmp() {
    return this.radius;}
}
