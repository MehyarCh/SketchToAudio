class Quantize extends NodeUI {
  
  public Quantize(int x, int y, int nheight, int nwidth){
    super(x,y,1,1,"Quantize", nheight, nwidth);
    type = NodeTypes.QUANTIZE;
  }
  
  @Override
  public void calculate(){
    println("value in quant= "+ inlets.get(0).getValue());
    outlets.get(0).setValue(quantize((int)inlets.get(0).getValue()));
    println("calculated value from quant= "+ outlets.get(0).getValue());
  }
    
  private int quantize (int m) {
    int [] lookup = new int [] {0,0,2,2,4,5,5,7,7,9,9,11}; // <= pentatonic
    //int [] lookup = new int [] {0,1,2,2,4,5,6,7,8,9,10,11};
    int q = (m/12)*12+lookup[m%12];
    return q;
  }
}
