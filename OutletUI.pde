class OutletUI extends Port {
  private float value;
  
  OutletUI(float x, float y){
    super(x,y);
  }  
  
  public void setValue(float f) {
    value = f;
  }
  
  public float getValue() {
    return value;
  }
   @Override
  String toString(){
    return "outlet";
  }
}
