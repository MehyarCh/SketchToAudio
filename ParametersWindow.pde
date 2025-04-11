class ParametersWindow {
  private PApplet parent;
  private NodeUI selected;
  private float x, y, width, height;
  ArrayList<Numberbox> gui_objects;
  
  ParametersWindow(PApplet parent, float x, float y, float width, float height) {
    this.parent = parent;
    
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    
    selected = null;
    gui_objects = new ArrayList<Numberbox>();
  }
  
  void draw() {
      fill(50); // Dark gray background
      rect(x, y, width, height);
  }
  
  void select (NodeUI s) {
      for (Numberbox b : gui_objects) {
        gui.remove(b.getAddress());
      }
      gui_objects.clear();
      selected = s;
      int i=0;
      
      for (NodeParameter p : s.parameters) {
        Numberbox b = gui.addNumberbox(p.name);
        if(s.type == NodeTypes.FREQUENCY){
          b.setRange(0,100.0);
        }
        b.setValue(p.value).setSize(200,50);
        b.setPosition(x + 50, y + 54 + i * 80);
        gui_objects.add(b);
        int id = i;
        b.plugTo(new ParamCallback () {
          void controlEvent(ControlEvent theEvent) {
            float value = gui_objects.get(id).getValue();
            s.parameters.get(id).value = value;
            println(id,value);
          }
        });
        i++;
      }  
  }
}


class ParamCallback {
  void controlEvent(ControlEvent theEvent) {}
}
