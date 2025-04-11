
enum MouseEventType {
  PRESS,RELEASE,DOUBLE,DRAG,HOVER
}

class MouseEvent {
  MouseEventType type;
  PVector pos;
  double time;
  
  public MouseEvent (MouseEventType t, PVector p, double ti) {
    type = t;
    pos = p;
    time = ti;
  }
}

interface MouseEventListener {
  void mouseEvent (MouseEvent e);
}


class MouseEventHandler {
  MouseEvent event;
  
  ArrayList<MouseEventListener> listeners;
  
  public MouseEventHandler () {
    listeners = new ArrayList<MouseEventListener>();
  }
  
  void addListener (MouseEventListener l) {
    listeners.add(l);
  }
  
  void mousePressed () {
    if (event==null) event = new MouseEvent(MouseEventType.PRESS, new PVector(mouseX,mouseY), millis());
    else {
      double last_event_time = event.time;
      event = new MouseEvent(MouseEventType.PRESS, new PVector(mouseX,mouseY), millis());
      if (event.time-last_event_time<500) {
        event.type = MouseEventType.DOUBLE;
      }
    }
    for (MouseEventListener l : listeners) l.mouseEvent(event);
  }
  
  void mouseReleased () {
    event = new MouseEvent(MouseEventType.RELEASE, new PVector(mouseX,mouseY), millis());
    for (MouseEventListener l : listeners) l.mouseEvent(event);
  }
  
  void mouseDragged () {
    event = new MouseEvent(MouseEventType.DRAG, new PVector(mouseX,mouseY), millis());
    for (MouseEventListener l : listeners) l.mouseEvent(event);
  }
}

class MouseListener implements MouseEventListener {
  void mouseEvent (MouseEvent e) {}
}
