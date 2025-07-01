class Confetti {
  private Position pos;
  private float r;
  private float fallSpeed;
  private float tilt, tiltAngle, tiltSpeed;
  private Color c;
  
  public Confetti() {
    pos = new Position();
    r = random(4, 10);
    fallSpeed = random(1, 3);
    tilt = random(-10, 10);
    tiltAngle = random(TWO_PI);
    tiltSpeed = random(0.05, 0.12);
    Color[] colors = {
      new Color(255, 199, 100),
      new Color(255, 50, 100),
      new Color(100, 100, 255),
      new Color(65, 200, 255),
      new Color(0, 255, 0)
    };
    c = colors[int(random(colors.length))];
  }
  
  public Confetti(Position pos) {
    this.pos = new Position(pos);
    r = random(4, 10);
    fallSpeed = random(1, 3);
    tilt = random(-10, 10);
    tiltAngle = random(TWO_PI);
    tiltSpeed = random(0.05, 0.12);
    Color[] colors = {
      new Color(255, 199, 100),
      new Color(255, 50, 100),
      new Color(100, 100, 255),
      new Color(65, 200, 255),
      new Color(0, 255, 0),
      new Color(255),
      new Color(150, 0, 255),
      new Color(255, 0, 0),
      new Color(255, 255, 0)
    };
    c = colors[int(random(colors.length))];
  }
  
  public void update() {
    pos.addY(fallSpeed);
    tiltAngle += tiltSpeed;
    tilt = sin(tiltAngle) * 15;
    if (pos.getY() > height) {
      pos.setY(-10);
      tilt = random(-10, 10);
    }
  }
  
  public void display() {
    noFill();
    c.setStroke();
    strokeWeight(r);
    line(pos.getX() + tilt + r / 3, pos.getY(), pos.getX() + tilt, pos.getY() + tilt + r);
  }
}
