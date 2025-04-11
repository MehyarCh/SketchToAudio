
class NodeParameter {
  float value;
  String name;
  
  public NodeParameter (String n, float def) {
    value = def;
    name = n;
  }
}

class NodeUI{
  protected ArrayList<InletUI> inlets;
  protected ArrayList<OutletUI> outlets;
  protected ArrayList<Port> connectingDots;
  protected int nbrOfParams, inletsNbr, outletsNbr;
  protected int nodeWidth;
  protected int nodeHeight = 0;
  protected int titleHeight = 50;
  protected final int dotRadius = 5;
  protected String text;
  protected boolean isDragging, selected;
  protected float x,y;
  protected float offsetX, offsetY;
  protected boolean isBlankSpaceHovered;
  protected NodeTypes type;
  
  protected ArrayList<NodeParameter> parameters;
  
  
  protected BezierCurve bezierCurve;
  
  void clearConnections () {
    for (InletUI i : inlets) {
      
    }
  }
  
  NodeUI(int x, int y, int inletsNbr, int outletsNbr, String text, int nodeHeight, int nodeWidth) {
    parameters = new ArrayList<NodeParameter>();
    
    isBlankSpaceHovered = false;
    this.x = x;
    this.y = y;
    this.inletsNbr = inletsNbr;
    this.outletsNbr = outletsNbr;
    this.text = text;
    this.nodeWidth = nodeWidth;
    this.nodeHeight = nodeHeight;
    
    isDragging = false;
    selected = false;
    
    inlets = new ArrayList<InletUI>(inletsNbr);
    outlets = new ArrayList<OutletUI>(outletsNbr);
    initializePorts();
    connectingDots = new ArrayList<Port>(inletsNbr + outletsNbr);
    if(inlets.size()>0){
      connectingDots.addAll(inlets);
    }
    if(outlets.size()>0){
      connectingDots.addAll(outlets);
    }
    
    updateConnectingPoints();
  }

  void connect(int inNbr, OutletUI out){
    println("connecting inlet number " + inNbr + " from " + this.toString());
    inlets.get(inNbr).out = out;
  }
  
  void update(){
    for( InletUI in : inlets){
      in.update();
    }
  }
  
  void calculate(){   
  }
  
  void reset(){
  }
  
  void play(){
  }
  
  void updateControlPoint(PVector selectedCtrl, float x, float y){
  }
  
  OutletUI getOutlet(int outletnbr){
    return outlets.get(outletnbr);
  }
  
  void drawConnections () {
    for (InletUI i : inlets) {
      if (i.out!=null) line(i.x,i.y,i.out.x,i.out.y);
    }
  }
  
  void drawNode(){
    stroke(0);
    fill(0, 150, 255);
    if(isBlankSpaceHovered) {
      fill(180);
    }
     
    fill(10, 45, 90);
    rect(x, y, nodeWidth, titleHeight);
    /*fill(0, 150, 255);
    rect(x, y + titleHeight, nodeWidth, nodeHeight);*/
    fill(255);         // Text color (white)
    textAlign(CENTER, CENTER);
    textSize(12);
    // Display the text at the center of the rectangle
    text(text, x + nodeWidth / 2, y + titleHeight / 2);
    
    if(selected){
      stroke(255, 255, 0);  // Yellow color
      noFill();
      rect(x, y, nodeWidth, titleHeight);
      //rect(x, y+titleHeight, nodeWidth, nodeHeight);
    }
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
    stroke(0);
  }
  
  void updateConnectingPoints() {
    if(inlets.size()>0){
      updateInlets();
    }
    if(outlets.size()>0){
      updateOutlets();
    }
  }
  
  private void updateInlets(){
    if( inletsNbr == 2){
      inlets.get(0).updatePort(x, y + titleHeight / 4); // Dot 1
      inlets.get(1).updatePort(x, y + titleHeight * 3 / 4 ); // Dot 2
    } else if ( inletsNbr == 1) {
      inlets.get(0).updatePort(x, y + titleHeight / 2);
    }
  }
  
  private void updateOutlets(){
    if( outletsNbr == 2){
      outlets.get(0).updatePort(x + nodeWidth, y + titleHeight / 4 ); // Dot 1
      outlets.get(1).updatePort(x + nodeWidth, y + titleHeight * 3 / 4); // Dot 2
    } else if ( outletsNbr == 1 ){
      outlets.get(0).updatePort(x + nodeWidth, y + titleHeight / 2 );
    }
  }
  
  Port containsDot(int px, int py) {
    for ( Port dot : connectingDots) {
      if (dist(px, py, dot.x, dot.y) < dotRadius) {
        return dot;
      }
    }
    return null;
  }

  boolean contains(int px, int py) {
    return px > x && px < x + nodeWidth && py > y && py < y + nodeHeight + titleHeight;
  }
  
  protected void initializePorts(){
    if( inletsNbr == 2){
      
      inlets.add(new InletUI(x, y / 4)); // Dot 1
      inlets.get(0).setParent(this, 0);
      inlets.add(new InletUI(x, y * 3 / 4 )); // Dot 2
      inlets.get(1).setParent(this, 1);
      
    } else if ( inletsNbr == 1) {
      //inlets.add(new InletUI(x, y + nodeHeight / 2 + titleHeight));
      inlets.add(new InletUI(x, y / 2 ));
      inlets.get(0).setParent(this, 0);
    }
    if(  outletsNbr == 2){
      
      outlets.add(new OutletUI(x + nodeWidth, y / 4)); // Dot 1
      outlets.get(0).setParent(this, 0);
      outlets.add(new OutletUI(x + nodeWidth, y * 3 / 4 )); // Dot 2
      outlets.get(1).setParent(this, 1);
    } else if ( outletsNbr == 1 ){
      outlets.add(new OutletUI(x + nodeWidth, y / 2));
      outlets.get(0).setParent(this, 0);
    }
  }
  
  protected boolean isTitleHovered(float mouseX, float mouseY) {
    return mouseX > x && mouseX < x + nodeWidth && mouseY > y && mouseY < y + titleHeight;
  }
  protected void startDragging(float mouseX, float mouseY) {
    isDragging = true;
    offsetX = x - mouseX;
    offsetY = y - mouseY;
  }
  protected void select(){
    println("node selected");
    selected = true;
  }
  protected void unselect(){
    println("node unselected");
    selected = false;
  }

  protected boolean isPointInBlankSpace(float px, float py) {
    return px > x && px < x + nodeWidth && py > y + titleHeight && py < y + nodeHeight + titleHeight;
  }
  protected void stopDragging(){
    isDragging = false;
    //bezierCurve.stopDragging();
  }
  protected void updateDragging(float mouseX, float mouseY) {
    if (isDragging) {
      x = mouseX + offsetX;
      y = mouseY + offsetY;
    }
  }
  
  void updateHandle (PVector handle, float x, float y) {
    
  }
  
  boolean withinBody (float x, float y) {  
    return (type==NodeTypes.BEZIER) && (x>this.x && x<this.x+nodeWidth && y>this.y+titleHeight && y<this.y+titleHeight+nodeHeight); 
  }
}
