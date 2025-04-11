class BezierCurve{  
  ArrayList<PVector> controlPoints;
  ArrayList<PVector> handles;
  PVector pointAt;
  float handleRadius = 5;
  
  float length = 0;
  
  BezierCurve() {
    controlPoints = new ArrayList<PVector>();
    handles = new ArrayList();
  }
  
  void plot(float x_offset, float y_offset) {
    noFill();
    if(controlPoints.size()==1){
      ellipse(controlPoints.get(0).x+x_offset, controlPoints.get(0).y+y_offset, 10, 10 );
    }
    for (int i=1; i<controlPoints.size(); i++) {
      PVector a = controlPoints.get(i-1);
      PVector b = controlPoints.get(i);
      PVector h = handles.get(i-1);
      stroke(0);
      ellipse(a.x+x_offset, a.y+y_offset, 10, 10 );
      ellipse(b.x+x_offset, b.y+y_offset, 10, 10 );
      stroke(0);
      bezier(a.x+x_offset,a.y+y_offset, h.x+x_offset,h.y+y_offset,h.x+x_offset,h.y+y_offset, b.x+x_offset,b.y+y_offset);
      
    }
    fill(0);
    for (PVector h : handles) {
      circle(h.x+x_offset,h.y+y_offset,2*handleRadius);
    }
    fill(255, 0, 0);
    
  }
  
  void setControlPoint (PVector ctrl) { // ctrl lokaler koordinaten space
    controlPoints.add(ctrl);
    if (controlPoints.size()>1) {
      PVector a = controlPoints.get(controlPoints.size()-2);
      PVector b = controlPoints.get(controlPoints.size()-1);
      PVector handle = PVector.add(a,b).div(2);
      handles.add(handle);
    }
    calculateLength();
  }
  
  void updateHandle (PVector handle, float x, float y) {
    handle.x = x;
    handle.y = y;
    calculateLength();
  }
  
  PVector hoverHandle (PVector mouse) {
    PVector handle = null;
    for (PVector h : handles) {
      if (h.dist(mouse)<= handleRadius) return h;
    }
    return handle;
  }
  
  void calculateLength () {
    length = 0;
    for (int i=1; i<controlPoints.size(); i++) {
      length += segmentLength(controlPoints.get(i-1),handles.get(i-1),controlPoints.get(i));
    }
  }
  
  PVector pointAt (float t) {
    PVector p = new PVector (0,0);
    float segment_length = 0;
    
    for (int i=1; i<controlPoints.size(); i++) {
      PVector v0 = controlPoints.get(i-1);
      PVector h = handles.get(i-1);
      PVector v1 = controlPoints.get(i);
      float seg = segmentLength(v0,h,v1) / length;
      float pre_length = segment_length;
      segment_length += seg;
      if (t<segment_length) {
        float percentage = (t-pre_length)/seg;
        p.x = bezierPoint(v0.x,h.x,h.x,v1.x,percentage);
        p.y = bezierPoint(v0.y,h.y,h.y,v1.y,percentage);
        return p;
      }
    }
    
    return p;
  }
  
  float segmentLength (PVector ctrl_0, PVector handle, PVector ctrl_1) {
    // FUTURE WORK: SEGMENTATION
    return PVector.dist(ctrl_0,ctrl_1);
  }
  
  // Find a point on the curve at a specific percentage (0 <= percent <= 100)
  PVector pointAtPercent(float percent) {
    //float t = percent / 100.0;
    float t = percent;
    return pointAt(t);
  }
  
  PVector hoverControlPoint(PVector mouse){
    PVector selectedPoint = null;
    for (PVector p : controlPoints) {
      if (p.dist(mouse)<= handleRadius) return p;
    }
    return selectedPoint;
  }
  void updateControlPoint (PVector point, float x, float y) {
    point.x = x;
    point.y = y;
    calculateLength();
  }

}
