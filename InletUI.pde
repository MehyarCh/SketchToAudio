class InletUI extends Port{
  NodeUI parent;
  private OutletUI out;
  private float temp,value;
  
  InletUI(float x, float y){
    super(x,y);
    out = null;
    parent = null;
  }
  void update() {
    value = getOutlet();
  }
  public float getValue(){
    return value;
  }
  public float getOutlet(){
    if (out!=null) {
      return out.getValue();
    }
    println("out is null");
    return 0;
  }
  
  @Override
  public String toString(){
    return "inlet";
  }
  
}
