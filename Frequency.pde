class Frequency extends NodeUI {
  float value;
  
  public Frequency(int x, int y, int nheight, int nwidth){
    super(x,y, 0, 1, "Tempo", nheight, nwidth);
    parameters.add(new NodeParameter("Tempo", 50));   
    type= NodeTypes.FREQUENCY;
  }
  
  @Override
  void calculate(){
    value = (value+parameters.get(0).value/10.)%100;
    outlets.get(0).setValue(value);
  }
  
  protected void updateDragging(float mouseX, float mouseY) {
    if (isDragging) {
      x = mouseX + offsetX;
      y = mouseY + offsetY;
    }
  }
}
