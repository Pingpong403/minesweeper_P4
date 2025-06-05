class Button {
  private Position pos;
  private int w;
  private int h;
  private String text = "";
  private boolean pressed = false;
  private boolean active = true;
  private Color textColor = new Color(0);
  
  public Button() {
    pos = new Position();
    w = 90;
    h = 40;
  }
  
  public Button(Position pos, String text) {
    this.pos = pos;
    w = 90;
    h = 40;
    this.text = text;
  }
  
  public Button(Position pos, int w, int h, String text) {
    this.pos = pos;
    this.w = w;
    this.h = h;
    this.text = text;
  }
  
  public Button(Position pos, int w, int h, String text, boolean active) {
    this.pos = pos;
    this.w = w;
    this.h = h;
    this.text = text;
    this.active = active;
  }
  
  public boolean isMouseWithin() {
    return active &&
           mouseX > pos.getX() && mouseX < pos.getX() + w &&
           mouseY > pos.getY() && mouseY < pos.getY() + h &&
           text != "";
  }
  
  public boolean isPressed() { return pressed; }
  public boolean isActive() { return active; }
  
  public void setPos(Position pos) { this.pos = pos; }
  public void setText(String text) { this.text = text; }
  public void setTextColor(Color textColor) { this.textColor = textColor; }
  
  public void display() {
    strokeWeight(1);
    if (text != "" && active)
    {
      stroke(pressed ? 200 : 100);
      fill(pressed ? 100 : 200);
      rect(pos.getX(), pos.getY(), w, h);
      textColor.setFill();
      textAlign(CENTER);
      textSize((float)h * 0.75);
      text(text, pos.getX() + (float)w / 2, pos.getY() + (float)h * 0.75);
      pressed = false;
    }
  }
  
  public void toggle() { pressed = !pressed; }
  public void activate() { active = true; }
  public void deactivate() { active = false; }
}
