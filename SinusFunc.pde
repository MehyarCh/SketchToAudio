class SinusFunc extends NodeUI {
  
  private float x,y;
  
  SinOsc func;
  
  public SinusFunc (int x, int y, PApplet applet, int nheight, int nwidth) {
    super(x,y,2,0, "Synth", nheight, nwidth);
    type = NodeTypes.SYNTH;
    println("for sin node");
    func = new SinOsc(applet);
    func.amp(0);
    func.play();
  }
  
  @Override
  void calculate(){
    println("inlet 0 value= " + inlets.get(0).getValue());
    println("inlet 1 value= " + inlets.get(1).getValue());
    float frq = inlets.get(0).getValue();
    float amp = inlets.get(1).getValue(); 
    func.freq(frq);
    func.amp(amp);
  }
  
  @Override
  String toString(){
    return "synth";
  }
  @Override
  void reset(){
    func.amp(0);
    func.stop();
  }
  @Override
  void play(){
    func.play();
  }
}
