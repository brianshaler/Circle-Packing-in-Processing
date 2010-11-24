int circle_count = 70;
Circle[] circles;
int min_radius = 4;
int max_radius = 40;

int w = 800;
int h = 600;
int cx;
int cy;

void setup () {
  size(w, h);
  background(255);
  smooth();
  cx = w/2;
  cy = h/2;
  
  int i;
  
  int[] c = new int[circle_count];
  
  circles = new Circle[circle_count];
  for (i=0; i<circle_count; i++)
  {
    c[i] = int(random(min_radius, max_radius));
  }
  c = sort(c);
  for (i=0; i<circle_count; i++)
  {
    circles[i] = new Circle(c[circle_count-1-i]);
  }
  circles[0].x = cx;
  circles[0].y = cy;
  circles[0].computed = true;
  
  for (i=1; i<circle_count; i++)
  {
    circles[i].computePosition(circles);
  }
}

void draw () {
  /**/
  background(255);
  
  int i;
  
  for (i=0; i<circle_count; i++)
  {
    circles[i].display();
  }
  /**/
}

class Circle {
  int x, y;
  int radius;
  boolean computed = false;
  
  Circle (int r) {
    radius = r;
  }
  
  void computePosition (Circle[] c) {
    int i, j;
    boolean collision;
    Point[] openPoints = new Point[0];
    int ang;
    Point pnt;
    
    if (computed) { return; }
    
    for (i=0; i<c.length; i++)
    {
      if (c[i].computed)
      {
        ang = 0;
        for (ang=0; ang<360; ang+=1)
        {
          collision = false;
          pnt = new Point();
          pnt.x = c[i].x + int(cos(ang*PI/180) * (radius+c[i].radius+1));
          pnt.y = c[i].y + int(sin(ang*PI/180) * (radius+c[i].radius+1));
          
          for (j=0; j<c.length; j++)
          {
            if (c[j].computed && !collision)
            {
              if (dist(pnt.x, pnt.y, c[j].x, c[j].y) < radius + c[j].radius)
              {
                collision = true;
              }
            }
          }
          
          if (!collision)
          {
            openPoints =  (Point[]) expand(openPoints, openPoints.length+1);
            openPoints[openPoints.length-1] = pnt;
          }
        }
      }
    }
    
    float min_dist = -1;
    int best_point = 0;
    for (i=0; i<openPoints.length; i++)
    {
      if (min_dist == -1 || dist(cx, cy, openPoints[i].x, openPoints[i].y) < min_dist)
      {
        best_point = i;
        min_dist = dist(cx, cy, openPoints[i].x, openPoints[i].y);
      }
    }
    if (openPoints.length == 0)
    {
      println("no points?");
    } else
    {
      println(openPoints.length + " points");
      x = openPoints[best_point].x;
      y = openPoints[best_point].y;
    }
    
    computed = true;
  }
  
  void display () {
    int i;
    
    for (i=0; i<circles.length; i++)
    {
      ellipseMode(CENTER);
      ellipse(circles[i].x, circles[i].y, circles[i].radius*2, circles[i].radius*2);
    }
  }
}

class Point {
  int x, y;
  
  Point () {
    
  }
}
