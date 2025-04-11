class BezierNode extends NodeUI {

  private PVector point;
  private float curr = 0;
  
  BezierNode(int x, int y, int nheight, int nwidth) {
    
    super(x,y,1, 2, "Bezier", nheight, nwidth);
    type= NodeTypes.BEZIER;
    parameters.add(new NodeParameter("in min", 0));
    parameters.add(new NodeParameter("in max", 100));
    parameters.add(new NodeParameter("x min", 60));
    parameters.add(new NodeParameter("x max", 84));
    parameters.add(new NodeParameter("y min", 0));
    parameters.add(new NodeParameter("y max", 1));
    bezierCurve = new BezierCurve();
  }
  
  @Override
  void drawNode(){
    stroke(0);
    fill(0, 150, 255);
    if(isBlankSpaceHovered) {
      fill(180);
    }
    fill(200, 200, 200);
    rect(x, y + titleHeight, nodeWidth, nodeHeight);
    fill(10, 45, 90);
    rect(x,y, nodeWidth, titleHeight); 
    fill(255);       
    textAlign(CENTER, CENTER);
    textSize(12);
    // Display the text at the center of the rectangle
    text(text, x + nodeWidth / 2, y + titleHeight / 2);
    
    if(selected){
      stroke(255, 255, 0);  // Yellow color
      noFill();
      rect(x, y, nodeWidth, titleHeight);
      rect(x, y+titleHeight, nodeWidth, nodeHeight);
    }
    
    
    
    stroke(0);
    fill(0);
    updateConnectingPoints();
    // Draw inlets
    for(InletUI in : inlets){
      in.drawPort(dotRadius);
    }
    
    //Draw outlets
    for(OutletUI out : outlets){
      out.drawPort(dotRadius);
    }
    
    //super.drawNode();
    bezierCurve.plot(x,y);
    
    // READ POSITION
    if(point != null){
      stroke(255,0,0);
      ellipse(point.x+x, point.y+y, dotRadius * 2, dotRadius * 2);
    }
    stroke(0);
  }
  
  void checkHover(float mouseX, float mouseY) {
    isBlankSpaceHovered = mouseX > x && mouseX < x + nodeWidth && mouseY > y + titleHeight && mouseY < y + nodeHeight - titleHeight * 2;
  }
  
   @Override
  void calculate(){
    if(bezierCurve.controlPoints.size()<2){
      //gui.addControlWindow("Draw a Bezier curve");
    } else {
      curr = inlets.get(0).getValue();
      float c = constrain(curr,parameters.get(0).value,parameters.get(1).value);
      c = map(c,parameters.get(0).value,parameters.get(1).value,0,1);
      point = bezierCurve.pointAtPercent(c);
      
      /*float x = map(sin(point.x), -1, 1, parameters.get(2).value, parameters.get(3).value);
      float y = map(sin(point.y), -1, 1, parameters.get(4).value, parameters.get(5).value);*/
      float x = map(point.x, 0, nodeWidth, parameters.get(2).value, parameters.get(3).value);
      float y = map(point.y, 0 , nodeHeight, parameters.get(4).value, parameters.get(5).value);
      
      println("bezier:",point.y,y);
      float d = constrain(y,parameters.get(4).value, parameters.get(5).value- 0.01);
      outlets.get(0).setValue(x);
      outlets.get(1).setValue(d);
    }
  }
  
  @Override
  void updateControlPoint(PVector selectedCtrl, float x, float y){
    if(x>0 && x<this.nodeWidth && y> titleHeight && y<titleHeight+this.nodeHeight){
      bezierCurve.updateControlPoint(selectedCtrl,x,y);
    }  
  }
  @Override
  void updateHandle (PVector handle, float x, float y) {
    if(x>-10 && x<this.nodeWidth && y> titleHeight && y<titleHeight+this.nodeHeight){    
      bezierCurve.updateHandle(handle,x,y);
    }
  }
  @Override
  void reset(){
    bezierCurve.controlPoints.clear();
    bezierCurve.handles.clear();
    point = null;
    bezierCurve.length = 0;
  }
  
}
