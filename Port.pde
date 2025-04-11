class Port {
  protected float x, y;
  protected NodeUI parent;
  protected int nbr; //position in the array, used for connections
  
  Port(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  void drawPort(int dotRadius){
    ellipse(x, y, dotRadius * 2, dotRadius * 2);
  }
  
  void updatePort(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  public float getX(){
    return x;
  }
  public float getY(){
    return y;
  }
  public void setParent(NodeUI parent, int nbr){
    this.nbr = nbr;
    this.parent = parent;
  }
  public NodeUI getParent(){
    return parent;
  }
  public int getNbr(){
    return this.nbr;
  }
}
