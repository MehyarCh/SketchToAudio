import processing.sound.*;
import controlP5.*;

ControlP5 gui;
ControlFont myFont;

final int rectWidth = 200;
final int rectHeight = 250;
final int bezierHeight = 300;
final int bezierWidth = 300;
final int buttonHeight = 40;
final int buttonWidth = 100;
int dotRadius = 5;
int mapNodeCount = 0;

NodeUI selectedNode = null;
Port selectedDot = null;
PVector selectedHandle, selectedControlPoint;

int offsetX, offsetY;
boolean playing = false;

ArrayList<NodeUI> nodes;

ParametersWindow params;


MouseEventHandler mouseHandler;

void setup(){
  background(255);
  size(1720, 920);
  PFont font = createFont("Arial", 8);
  myFont = new ControlFont(font, 8);
  
  gui = new ControlP5(this);
  
  params = new ParametersWindow(this, 1400, 10, 300, 900);
  nodes = new ArrayList<NodeUI>();
  //connections = new ArrayList<Line>();
  createGUI();
  
  mouseHandler = new MouseEventHandler();
  
  mouseHandler.addListener(
    new MouseListener () {
      void mouseEvent (MouseEvent e) {
        if (e.type==MouseEventType.PRESS || e.type==MouseEventType.DOUBLE) {
            PVector mouse = new PVector(mouseX, mouseY);
            /*
             if not pressing a text field
             selectedNode = null; */
            //selectedNode = null;
            /*
            *case1: pressed on title to move node
            *case2: pressed on connection port
            *case3: pressed on node body to add bezier point
            *case4: pressed on bezier handle point
            */
            
            // ***
            
            // IS CLICK WITHIN NODE?
            
            
            
            for(NodeUI node : nodes) {
              Port port = node.containsDot(mouseX, mouseY);
              if (node.contains(mouseX,mouseY) || port!=null) {
                if (port!=null) selectedDot = port;
                if (selectedNode!=null) selectedNode.unselect();
                selectedNode = node;
                selectedNode.select();
                // PRAMETERSWINDOW SET SELECTED NODE ?
                
                params.select(selectedNode);
                break;
              }
            }
            
            if (selectedNode!=null) {
              // PORT
              /*Port port = selectedNode.containsDot(mouseX, mouseY);
              if (port!=null) {
                selectedDot = port;
              }
              // TITLEBAR
              else*/ if (selectedNode.isTitleHovered(mouseX,mouseY)) {
                selectedNode.startDragging(mouseX,mouseY);
              }
              // BODY
              else {
                println("BODY");
                if (selectedNode.type==NodeTypes.BEZIER && selectedNode.withinBody(mouseX, mouseY)) {
                  // HANDLE
                  selectedHandle = selectedNode.bezierCurve.hoverHandle(new PVector(mouseX-selectedNode.x, mouseY-selectedNode.y));
                  
                  // CTRLPOINT
                  if (selectedHandle==null) {
                    selectedControlPoint = selectedNode.bezierCurve.hoverControlPoint(new PVector(mouseX-selectedNode.x, mouseY-selectedNode.y));
                    if( selectedControlPoint!= null){
                      println("move control point");                      
                    }else{
                      println("add ctrl");
                      selectedNode.bezierCurve.setControlPoint(new PVector(mouseX-selectedNode.x, mouseY-selectedNode.y)); // lokaler ursprung
                    }
                  }
                } 
              }
            }
            
            // ***
            
            
          }
          else if (e.type==MouseEventType.RELEASE) {       
            
            selectedHandle = null;
            selectedControlPoint = null;
            
            // ***
            
            if (selectedNode!=null) {
              selectedNode.stopDragging();
            }
            
            // ***
            
            //handle possibility of changing and deleting lines or nodes
            if (selectedDot != null) {
              for (NodeUI node : nodes) {
                Port dot = node.containsDot(mouseX, mouseY);
                if (dot != null && dot != selectedDot &&
                  !dot.toString().equals(selectedDot.toString())) {
                  // Check if there's an existing line with the same endpoints
                  boolean lineExists = false;
                  if (!lineExists) {
                    // Add a new line between the dots
                    NodeUI left, right;
                    if(selectedDot.toString().equals("outlet")){
                      left = selectedDot.getParent();
                      right = dot.getParent();
                      println("left is: "+ selectedDot.toString()+ " with number: " + selectedDot.getNbr() + " and parent: " + selectedDot.getParent().toString());
                      println("right is: "+ dot.toString()+ " with number: " + dot.getNbr() +" and parent: "+ dot.getParent().toString());
                      connectNodes(left,selectedDot.getNbr(),right, dot.getNbr());
                    }else{
                      assert selectedDot.toString().equals("inlet");           
                      left = dot.getParent();
                      right = selectedDot.getParent();
                      println("left is: "+ dot.toString()+ " with number: " + dot.getNbr()+" and parent: "+ dot.getParent().toString());
                      println("right is: "+ selectedDot.toString() + " with number: " + selectedDot.getNbr() + " and parent: " + selectedDot.getParent().toString());
                      connectNodes(left,dot.getNbr(),right,selectedDot.getNbr());
                    }
                    
                  }
                }
              }
              selectedDot = null;
            }
            
          }
          else if (e.type==MouseEventType.DRAG) {
            //case1: moving node, and updating bezier curve
            if (selectedNode != null) {
              // Move the selected rectangle and its connecting dots
              selectedNode.updateDragging(mouseX, mouseY);
          
              // Move the connecting dots and update the lines
              assert selectedNode != null;
              selectedNode.updateConnectingPoints();
            }
            
            //case2: moving handle on bezier
            if (selectedHandle!=null) {
              selectedNode.updateHandle(selectedHandle,mouseX-selectedNode.x,mouseY-selectedNode.y);
              
              // recalculate length of bezier curve !!!
            }
            
            if(selectedControlPoint != null){
              selectedNode.updateControlPoint(selectedControlPoint,mouseX-selectedNode.x,mouseY-selectedNode.y);
            }
          }
          else if (e.type==MouseEventType.HOVER) {
            
          }    
        }
      }
    
  );
}

void draw(){
  background(220);
  if(selectedNode != null ){
    //selectedNode.parameters = params.getNodeParameters();
    //println("param 1 is " + selectedNode.parameters.get(0).value); 
    params.draw();
  }
  //println(framerate);
  for(NodeUI node : nodes){
    node.drawNode();
    node.drawConnections();
  }

  if (selectedDot != null) {
    stroke(0);
    line(selectedDot.x, selectedDot.y, mouseX, mouseY);
  }
  
  stroke(0);
  if(playing){
    for (NodeUI n : nodes) {
      n.update();
    }
  
    for(NodeUI node : nodes){
      node.calculate();
    }
  }
}


void createGUI() {
  gui.addButton("add_tempo").setSize(buttonWidth, buttonHeight).setFont(myFont);
  gui.addButton("add_bezier").setSize(buttonWidth, buttonHeight).setFont(myFont);
  gui.addButton("add_quant").setSize(buttonWidth, buttonHeight).setFont(myFont);
  gui.addButton("add_mtof").setSize(buttonWidth, buttonHeight).setFont(myFont);
  gui.addButton("add_synth").setSize(buttonWidth, buttonHeight).setFont(myFont);
  gui.addButton("example").setSize(buttonWidth, buttonHeight).setFont(myFont)
                .setPosition(width/2+150, 30);
  gui.addToggle("play_button")
                .setPosition(width/2, 30)
                .setSize(100, 40)
                .setLabel("Play")
                .setValue(false)
                .setColorActive(color (0, 128, 64))
                .align(ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER,ControlP5.CENTER);
                
  
}

//connect right node´s inlet with left node´s outlet
void connectNodes(NodeUI left, int outletnbr, NodeUI right, int inletnbr){ //<>//
  right.connect(inletnbr, left.getOutlet(outletnbr));
}

void mousePressed() {
  mouseHandler.mousePressed();  
}

void mouseReleased() {
  mouseHandler.mouseReleased(); //<>//
}

void mouseDragged() {
  mouseHandler.mouseDragged();
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    if(selectedNode!=null && selectedNode.type == NodeTypes.BEZIER){
      selectedNode.reset();
    }
    for(int i=0; i<nodes.size();i++){
      if(nodes.get(i).type == NodeTypes.SYNTH){
       if(playing == true){
         playing = !playing;
       }
      }
      if(!playing){
        gui.getController("play_button").setValue(0);
      }
    }
    play_button(playing);
    
  } else if (key == BACKSPACE) {
    if(selectedNode!=null){
      for(int i=0; i<nodes.size();i++){
        if(selectedNode == nodes.get(i)){
          // delete connections
          deleteConnections(nodes.get(i));
          nodes.remove(i);
        }
      }
    }
  } else if (key == 32) {
    playing = !playing; 
    if(playing){
      gui.getController("play_button").setValue(1);
    }else{
      gui.getController("play_button").setValue(0);
    }
    
    play_button(playing);  
  }
}

void deleteConnections(NodeUI n){
  for(NodeUI node : nodes){
    for(InletUI inlet : node.inlets){
      for(OutletUI outlet : n.outlets){
        if(inlet.out == outlet){
          inlet.out = null;
        }
      }
    }
  }
  for(InletUI inlet : n.inlets){
    inlet.out = null;
  }
}

void play_button(boolean state){
  playing = state;
  println("playing: "+playing);
  
  for(NodeUI n : nodes){
    if(n.type == NodeTypes.SYNTH){
      if(!playing){
        n.reset();
      }else {
        n.play();
      }
    }
  }
}
void add_bezier () {
  int x = width / 2 - rectWidth / 2;
  int y = height / 2 - rectHeight / 2;
  nodes.add(new BezierNode(x, y, bezierHeight, bezierWidth));
}
void add_tempo() {
  int x = width/2 - rectWidth /2 ;
  int y = height / 2 - rectHeight / 2 + 100;
  nodes.add(new Frequency(x,y, 0, rectWidth));
}

void add_synth() {
  nodes.add(new SinusFunc(width/2 - rectWidth /2, height / 2 - rectHeight / 2 + 50, this, 0, rectWidth));
}

void add_mtof(){
  nodes.add(new MidiToFreq(width/2 - rectWidth /2, height / 2 - rectHeight / 2 + 100, 0, rectWidth));
}

void add_quant(){
  nodes.add(new Quantize(width/2 - rectWidth /2, height / 2 - rectHeight / 2 + 150, 0, rectWidth));
}

void example(){
  int x = 100;
  int y = 300;
  NodeUI freq = new Frequency(x,y, 0, rectWidth);
  x+=300;
  NodeUI bez = new BezierNode(x, y, bezierHeight, bezierWidth);
  x+=350;
  NodeUI quant = new Quantize(x, y, 0, rectWidth);
  x+=250;
  NodeUI mtf = new MidiToFreq(x , y, 0, rectWidth);
  y+=150;
  NodeUI syn = new SinusFunc(x, y, this, 0, rectWidth);
  
  nodes.add(freq);
  nodes.add(bez);
  nodes.add(quant);
  nodes.add(mtf);
  nodes.add(syn); 
  
  connectNodes(freq,0,bez, 0);
  connectNodes(bez,0,quant, 0);
  connectNodes(quant,0,mtf, 0);
  connectNodes(mtf,0,syn,0);
  connectNodes(bez,1,syn,1);
    
}
