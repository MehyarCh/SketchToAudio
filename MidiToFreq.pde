class MidiToFreq extends NodeUI {
  
  public MidiToFreq(int x, int y, int nheight, int nwidth){
    super(x,y,1,1, "MidiToFreq", nheight, nwidth);
    println("for mtof node");
    
  }
  
  @Override
  public void calculate(){
    println("value in miditof= "+ inlets.get(0).getValue());
    outlets.get(0).setValue(pow(2, (inlets.get(0).getValue() - 69) / 12) * 440);
    println("calculated value from miditof= "+ outlets.get(0).getValue());
  }
  
}
