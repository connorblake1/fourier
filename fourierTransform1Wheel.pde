ArrayList<wheel> wheels;
float[][] dots = new float[2000][2];
int index = 0;
int index1 = 4000;
boolean displayGraphs = false;
boolean mode = true;
float[][] waveform = new float[index1][2];
int detail = 4000;
int index2 = 0;
int t = 0;
int[] xa = new int[detail];
int[] ya = new int[detail];
//write to xa/ya here then press g as soon as programlaunches

//twoDim d = drawLine(xa,ya,0,-100,-100,-100,200);
//twoDim d1 = drawLine(xa,ya,0,-100,200,-100,-100);



int el;
void setup() {
  //for (int i =0; i < detail; i++) {
  //  xa[i]=0;
  //  ya[i]=0;
  //}
  wheels = new ArrayList<wheel>();

  size(1200, 700);
  background(0);
}

void draw() {
  if (mode == false) {
    background(0);
    for (int i = 0; i < wheels.size(); i++) {
      wheels.get(i).changeAngle();
      if (!wheels.get(i).fixed() && i!=0) {
        wheels.get(i).changeX(wheels.get(i-1).getVX()+wheels.get(i-1).getX());
        wheels.get(i).changeY(wheels.get(i-1).getVY()+wheels.get(i-1).getY());
      }
      wheels.get(i).display();

      //makes dot[][] for last end of wheel
      if (i == wheels.size()-1) {
        if (index == 2000) {
          for (int h = 0; h < 2000; h++) {
            dots[h][0] = 0;
            dots[h][1] = 0;
          }
          index = 0;
        }
        dots[index][0] = wheels.get(i).getVX()+wheels.get(i).getX();
        dots[index][1] = wheels.get(i).getVY()+wheels.get(i).getY();
        for (int w = index1-1; w >0; w--) {
          waveform[w][0] = waveform[w-1][0];
          waveform[w][1] = waveform[w-1][1];
        }
        waveform[0][0] = dots[index][0];
        waveform[0][1] = dots[index][1];
      }
    }
    // graphs the shape
    strokeWeight(4);
    stroke(255, 0, 0);
    int pel = waveform.length;
    for (int j = 0; j < index1; j++) {
      if (waveform[j][0] == 0 && waveform[j][1] == 0) {
        if (isAllZero(j, index1, split2DArray(waveform, 0)) && isAllZero(j, index1, split2DArray(waveform, 1))) {
          pel = j;
          break;
        }
      }
    }
    beginShape();
    for (int wf = 0; wf < pel; wf++) {
      vertex(waveform[wf][0], waveform[wf][1]);
    }
    endShape();
    index++;
  } else {
    if (displayGraphs) {
      //draw dots and graph of x/y
      strokeWeight(2);
      stroke(0);
      rect(.5*width, .5*height, .5*width, .5*height);
      line(.5*width, .75*height, width, .75*height);
      stroke(0);
      while (t < detail-1) {
        float x = t*(float(width/2)/float(detail));
        float y = t*(float(width/2)/float(detail));
        point((width/2)+ x, (.75*height)-(xa[t]/8));
        point((width/2)+ y, (height)-(ya[t]/4));
        t++;
      }
      t = 0;
    }
  }
}

void mouseDragged() {
  if (mode == true) {
    stroke(255);
    strokeWeight(3);
    point(mouseX, mouseY);
    xa[index2] = mouseX-(width/2);
    ya[index2] = mouseY-(height/2);
    index2++;
    if (index2 >= detail-1) {
      background(0);
      index2 = 0;
      for (int i =0; i < detail; i++) {
        xa[i] = 0;
        ya[i] = 0;
      }
    }
  }
}

void keyPressed() {
  if (key == 'g') {
    mode = false;
    for (int i = 0; i < detail; i++) {
      if (ya[i] == 0) {
        if (isAllZero(i, detail, ya)) {
          el = i;
          break;
        }
      }
    }
    int yel = el;
    int xel = el;
    if (isOdd(xa)) {
      el--;
    }
    int[] nnXA = stripZero(makeOdd(xa, true), xel);
    int[] nnYA = stripZero(makeOdd(ya, false), yel);
    float[][] A = dft2D(nnXA, nnYA);
    //wheels
    for (int k = 0; k < el; k++) {
      int f = k;
      if (k > (el-1)/2) {
        f = k-el;
      }
      float cx;
      float cy;
      if (k == 0) {
        cx = width/2;
        cy = height/2;
      } else {
        cx = wheels.get(k-1).getVX() + wheels.get(k-1).getX();
        cy = wheels.get(k-1).getVY() + wheels.get(k-1).getY();
      }
      float amp = sqrt(sq(A[k][0]) + sq(A[k][1]));
      float freq = f;
      float angle = atan2(A[k][1], A[k][0]);
      //println(YA[k][0]);
      wheels.add(new wheel(freq, amp, cx, cy, angle, false, false));
    }
    wheels = reverseArrayList(quickSortArrayList(wheels));
  } else if (key == 'r') {
    for (int i = 0; i < wheels.size(); i++) {
      wheels.remove(i);
    }
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < index1; j++) {
        waveform[j][i] = 0;
      }
    }
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2000; j++) {
        dots[j][i] = 0;
      }
    }
    for (int j =0; j < detail; j++) {
      xa[j] = 0;
      ya[j] = 0;
    }
    background(0);
    mode = true;
    index2 = 0;
    index = 0;
    el = 0;
    t = 0;
  }
}

boolean isAllZero(int currentI, int thisDetail, int[] tArray) {
  for (int d = currentI; d < thisDetail; d++) {
    if (tArray[d] != 0) {
      return false;
    }
  }
  return true;
}

int[] stripZero(int[] tArray, int EL) {
  int[] R = new int[EL];
  for (int i = 0; i < EL; i++) {
    R[i] = tArray[i];
  }
  return R;
} 

float[][] dft2D(int[] xa2, int[] ya2) {
  int N = xa2.length;
  float[][] TA = new float[N][2];
  for (int k = 0; k < N; k++) {
    float re = 0;
    float im = 0;
    for (int n = 0; n < N; n++) {
      float theta = (TWO_PI * k * n)/N;
      re+= xa2[n]*cos(theta);
      im-= xa2[n]*sin(theta);
      im+= ya2[n]*cos(theta);
      re+= ya2[n]*sin(theta);
    }
    re /= N;
    im /= N;
    TA[k][0] = re;
    TA[k][1] = im;
  }
  return TA;
}

int[] makeOdd(int[] ta, boolean decr) {
  int a = ta.length;
  if (ta.length %2 ==0) {
    a--;
  }
  int [] TA = new int[a];
  for (int i = 0; i< a; i++) {
    TA[i] = ta[i];
  }
  return TA;
}


boolean isOdd(int[] ta) {
  if (ta.length%2 == 1) {
    return true;
  }
  return false;
}

int[] compress(int[] ta, int num) {
  ArrayList<Integer> TA;
  TA = new ArrayList<Integer>();
  for (int i = 0; i < ta.length; i++) {
    if (i%num == 0) {
      TA.add(ta[i]);
    }
  }
  int[] nTA = new int[TA.size()];
  for (int i =0; i < TA.size(); i++) {
    nTA[i] = TA.get(i);
  }
  el = TA.size();
  return nTA;
}

float[] split2DArray(float[][] ta, int column) {
  int l = ta.length;
  float[] TA = new float[l];
  for (int i = 0; i < l; i++) {
    TA[i] = ta[i][column];
  }
  return TA;
}

boolean isAllZero(int currentI, int thisDetail, float[] tArray) {
  for (int d = currentI; d < thisDetail; d++) {
    if (tArray[d] != 0.0) {
      return false;
    }
  }
  return true;
}

ArrayList<wheel>  quickSortArrayList(ArrayList<wheel> a) {
  //wheel(float sR, float s, float x, float y, float a, boolean iF, boolean iE)
  ArrayList<wheel> A = copyArrayList(a);
  int lm = 0;
  int rm = a.size()-1;
  int p = int(a.size()/2);

  while (lm <= rm) {
    while (A.get(lm).getAmp() < A.get(p).getAmp()) {
      lm++;
    }
    while (A.get(rm).getAmp() > A.get(p).getAmp()) {
      rm--;
    }
    if (lm <= rm) {
      wheel hold = A.get(lm);
      A.set(lm, A.get(rm));
      A.set(rm, hold);
      lm++;
      rm--;
    }
    //for (int i = 0; i< A.size(); i++ ) {
    //  println(A.get(i).getAmp());}
    //println();
  }
  ArrayList<wheel> p1 = new ArrayList<wheel>();
  ArrayList<wheel> p2 = new ArrayList<wheel>();
  for (int i =0; i < A.size(); i++) {
    if (i <= p) {
      p1.add(A.get(i));
    } else {
      p2.add(A.get(i));
    }
  }
  if (!isInOrderArrayList(p1)) {
    while (!isInOrderArrayList(p1)) {
      p1 = quickSortArrayList(p1);
    }
  }
  if (!isInOrderArrayList(p2)) {
    while (!isInOrderArrayList(p2)) {
      p2 = quickSortArrayList(p2);
    }
  }
  for (int i = 0; i< A.size(); i++) {
    if (i <= p) {
      A.set(i, p1.get(i));
    } else {
      A.set(i, p2.get(i-p-1));
    }
  }
  return A;
}

ArrayList<wheel> copyArrayList(ArrayList<wheel> tal) {
  ArrayList<wheel> TAL = new ArrayList<wheel>();
  for (int i = 0; i< tal.size(); i++) {
    TAL.add(tal.get(i));
  }
  return TAL;
}
boolean equalsArrayList(ArrayList<wheel> a, ArrayList<wheel> b) {
  if (a.size() == b.size()) {
    for ( int i = 0; i < a.size(); i++) {
      if (a.get(i).getAmp() != b.get(i).getAmp()) {
        return false;
      }
    }
    return true;
  } else {
    return false;
  }
}

boolean isInOrderArrayList(ArrayList<wheel> ta) {
  for (int i = 1; i < ta.size(); i++) {
    if (ta.get(i).getAmp() < ta.get(i-1).getAmp()) {
      return false;
    }
  }
  return true;
}

ArrayList<wheel> reverseArrayList(ArrayList<wheel> ta) {
  ArrayList<wheel> TA = new ArrayList<wheel>(ta.size());
  for (int i = ta.size()-1; i >= 0; i--) {
    TA.add(ta.get(i));
  }
  return TA;
}

twoDim drawLine(int[] ta1, int[] ta2, int in, int x1, int y1, int x2, int y2) {
  float m;
  //if (y2-y1 != 0) {
  //  m = (y2-y1)/(x2-x1);}
  //else {
  //  m = 1000;}
  int dist = int(sqrt(sq(x2-x1)+sq(y2-y1)));
  for (int i = 0; i <= dist; i++) {
    ta1[in+i] = x1+int((i*(x2-x1))/dist);
    ta2[in+i] = y1+int((i*(y2-y1))/dist);}
  in += dist;
  twoDim d = new twoDim(ta1,ta2,in);
  return d;
  }
  
twoDim drawCircle(int[] ta1, int[] ta2, int in, int x1, int y1, int x2, int y2) {
  float m;
  //if (y2-y1 != 0) {
  //  m = (y2-y1)/(x2-x1);}
  //else {
  //  m = 1000;}
  int dist = int(sqrt(sq(x2-x1)+sq(y2-y1)));
  for (int i = 0; i <= dist; i++) {
    ta1[in+i] = x1+int((i*(x2-x1))/dist);
    ta2[in+i] = y1+int((i*(y2-y1))/dist);}
  in += dist;
  twoDim d = new twoDim(ta1,ta2,in);
  return d;
  }
