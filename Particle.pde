class Particle 
{
  PVector location;
  PVector velocity;
  PVector acceleration;
  float theta;
  float lifespan;
  float r, g, b;
  char note;

  Particle(PVector l, char nt) 
  {
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-2, 2), random(-4, 2));
    location = l.get();
    note = nt;
    theta = 0.0;
    lifespan = getLifeSpan();

    r = random(0, 255);
    g = random(0, 255);
    b = random(0, 255);
  }

  void run() 
  {
    update();
    display();
  }

  void display() 
  {
    stroke(r, g, b, lifespan);
    fill(r, g, b, lifespan);
    drawParticleShape();
  }

  void update() 
  {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 2.0;

    float theta_vel = (velocity.x * velocity.mag()) / 10.0f;
    theta += theta_vel;
  }

  boolean isDead() 
  {
    return (lifespan < 0.0);
  }


  //random bezier ellipse stuff
  float[] px, py, cx, cy, cx2, cy2;
  float rad1 = 4; 
  float cRad1 = 11;
  float rad2 = 11; 
  float cRad2 = 7;
  //random line thickness
  float lWeight = random(1, 2);
  void drawParticleShape()
  {

    switch(note)
    {
      case 'C':
      {
        float x1 = location.x + random(-10, 10);
        float y1 = location.y + random(-10, 10);
        float x2 = location.x + random(-5, 20);
        float y2 = location.y + random(-5, 20);
        float x3 = location.x + random(-5, 20);
        float y3 = location.y + random(-5, 20);
        float x4 = location.x + random(-5, 20);
        float y4 = location.y + random(-5, 20);
        rectMode(CENTER);
        quad(x1, y1, x2, y2, x3, y3, x4, y4);
        rectMode(CORNER);
        break;
      }
      case 'D':
      {
        noFill();
        ellipse(location.x, location.y, random(5, 20), random(5, 20));
        break;
      }
      case 'E':
      {
        pushMatrix();
        translate(location.x, location.y);
        rotate(theta);
        rect(0, 0, 8, 8);
        popMatrix();
        break;
      }
      case 'F':
      {
        pushMatrix();
        translate(location.x, location.y);
        rotate(theta);
        stroke(r, g, b, lifespan);
        strokeWeight(lWeight);
        line(0, 0, 25, 0);
        popMatrix();
        strokeWeight(1);
        break;
      }
      case 'G':
      {
        int circs = (int)random(3, 5);
        float spacing = 2 * PI / circs;
        noFill();

        pushMatrix();
        translate(location.x, location.y);
        rotate(theta);
        triangle(0, 10, 10, 0, -10, 0);
        popMatrix();
        break;
      }
      case 'A':
      {
        pushMatrix();
        translate(location.x, location.y);
        rotate(theta);
        setEllipse(pts, rad1, cRad1);
        drawEllipse();
        popMatrix();
        break;
      }
      case 'B':
      {
        pushMatrix();
        translate(location.x, location.y);
        rotate(theta);
        setEllipse(pts, rad2, cRad2);
        drawEllipse();
        popMatrix();
        break;
      }      
      default:
        ellipse(location.x, location.y, 8, 8);
    }
  }

  float getLifeSpan()
  {
    float lf_time = 0;
    switch(note)
    {
      case 'C':
        lf_time = random(150, 255);
        break;
      case 'D':
        lf_time = random(125, 225);
        break;
      case 'E':
        lf_time = random(100, 200);
        break;
      case 'F':
        lf_time = random(75, 200);
        break;
      case 'G':
        lf_time = random(125, 150);
        break;
      case 'A':
        lf_time = random(50, 125);
        break;
      case 'B':
        lf_time = random(75, 100);
        break;        
      default:
        lf_time = 100;
    }

    return lf_time;
  }

  int pts = (int)random(5, 10);
  void drawEllipse() 
  {
    strokeWeight(1);
    stroke(r, g, b, lifespan);
    noFill();

    for (int i=0; i<pts; i++) 
    {
      if (i==pts-1) 
        bezier(px[i], py[i], cx[i], cy[i], cx2[i], cy2[i], px[0], py[0]);
      else 
        bezier(px[i], py[i], cx[i], cy[i], cx2[i], cy2[i], px[i + 1], py[i + 1]);
    }
  }

  void setEllipse(int points, float radius, float controlRadius) 
  {
    pts = points;
    px = new float[points];
    py = new float[points];
    cx = new float[points];
    cy = new float[points];
    cx2 = new float[points];
    cy2 = new float[points];

    float angle = 360.0 / points;
    float controlAngle1 = angle / 3.0;
    float controlAngle2 = controlAngle1 * 2.0;

    for ( int i=0; i < points; i++) 
    {
      px[i] = cos(radians(angle)) * radius;
      py[i] = sin(radians(angle)) * radius;
      cx[i] =  cos(radians(angle+controlAngle1)) * 
        controlRadius /cos(radians(controlAngle1));
      cy[i] = sin(radians(angle+controlAngle1)) * 
        controlRadius / cos(radians(controlAngle1));
      cx2[i] = cos(radians(angle+controlAngle2)) * 
        controlRadius / cos(radians(controlAngle1));
      cy2[i] = sin(radians(angle+controlAngle2))* 
        controlRadius / cos(radians(controlAngle1));

      angle += 360.0 / points;
    }
  }
}

