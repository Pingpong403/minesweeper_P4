class ConfettiBurst {
  private int count;
  private Position pos;
  private Confetti[] confetti;
  
  public ConfettiBurst() {
    count = 2;
    pos = new Position();
    confetti = new Confetti[count];
    for (int i = 0; i < count; i++) {
      confetti[i] = new Confetti(pos);
    }
  }
  
  public ConfettiBurst(int count) {
    this.count = count;
    pos = new Position();
    confetti = new Confetti[count];
    for (int i = 0; i < count; i++) {
      confetti[i] = new Confetti(pos);
    }
  }
  
  public ConfettiBurst(Position pos) {
    count = 2;
    this.pos = new Position(pos);
    confetti = new Confetti[count];
    for (int i = 0; i < count; i++) {
      confetti[i] = new Confetti(this.pos);
    }
  }
  
  public ConfettiBurst(Position pos, int count) {
    this.count = count;
    this.pos = new Position(pos);
    confetti = new Confetti[count];
    for (int i = 0; i < count; i++) {
      confetti[i] = new Confetti(this.pos);
    }
  }
  
  public void update() {
    for (int i = 0; i < count; i++) {
      confetti[i].update();
    }
  }
  
  public void display() {
    for (int i = 0; i < count; i++) {
      confetti[i].display();
    }
  }
}
