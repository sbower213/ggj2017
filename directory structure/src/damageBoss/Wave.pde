class Wave {

  ArrayList<Integer> p1EventTimes;
  ArrayList<String> p1EventNotes;
  
  ArrayList<Integer> p2EventTimes;
  ArrayList<String> p2EventNotes;
  
  float amplitude;
  float period;
  
  int xspacing;   // How far apart should each horizontal location be spaced
  int w;              // Width of entire wave
  int travelTime;  //millis
  
  public Wave(float a, float p, int xs, int _w, int tt) {
    p1EventTimes = new ArrayList<Integer>();
    p2EventTimes = new ArrayList<Integer>();
    
    p1EventNotes = new ArrayList<String>();
    p2EventNotes = new ArrayList<String>();
    
    amplitude = a;
    period = p;
    xspacing = xs;
    w = _w;
    travelTime = tt;
  }
  
  void drawWave() {
    noFill();
    stroke(255);
    colorMode(HSB);
    
    int time = millis();
    
    float prev = -131313;
    for (int x = 0; x < w; x += xspacing) {
      float t = getTime(x, time);
      
      float yvalue = p1Height(t);
      if (x > w * .75) {
        if (matched(t)) {
          yvalue = 0;
        } else {
          yvalue -= p2Height(t + travelTime);
        }
      }
      
      boolean[] p1NotesPlaying = new boolean[squares.length];
      for (int i = 0; i < p1EventTimes.size(); i++) {
        if (p1EventTimes.get(i) > t)
          break;
        if (noteToNumMap.containsKey(p1EventNotes.get(i))) {
          int indx = noteToNumMap.get(p1EventNotes.get(i));
          p1NotesPlaying[indx] = !p1NotesPlaying[indx];
        }
      }
      
      if (prev != -1313131) {
        int notes = 0;
        for (int i = 0; i < 6; i++) {
          notes += (p1NotesPlaying[i] ? 1 : 0);
        }
        
        int hue = 0;
        for (int i = 0; i < 6; i++) {
          hue += (p1NotesPlaying[i] ? 1  : 0) * 42 * i;
        }
        if (notes > 0) hue /= notes;
        
        int sat = notes == 0 ? 0 : 255;
                  
        stroke(hue, sat, 255);
        
        line(x - xspacing, prev, x, height / 2 + yvalue);
      }
      prev = height / 2 + yvalue;
    }
  }

  float getTime(float x) {
    return getTime(x, millis());
  }
  
  float getTime(float x, float time) {
    return time - (x * 4.0 / 3 / w * travelTime);
  }
  
  boolean matched(float t) {
    boolean[] p1NotesPlaying = new boolean[squares.length];
    for (int i = 0; i < p1EventTimes.size(); i++) {
      if (p1EventTimes.get(i) > t)
        break;
      if (noteToNumMap.containsKey(p1EventNotes.get(i))) {
        int indx = noteToNumMap.get(p1EventNotes.get(i));
        p1NotesPlaying[indx] = !p1NotesPlaying[indx];
      }
    }
    
    boolean[] p2NotesPlaying = new boolean[squares.length];
    for (int i = 0; i < p2EventTimes.size(); i++) {
      if (p2EventTimes.get(i) > t + travelTime)
        break;
      if (noteToNumMap.containsKey(p2EventNotes.get(i))) {
        int indx = noteToNumMap.get(p2EventNotes.get(i));
        p2NotesPlaying[indx] = !p2NotesPlaying[indx];
      }
    }
    
    boolean equal = true;
    for (int i = 0;  i < squares.length; i++) {
      equal = (p1NotesPlaying[i] == p2NotesPlaying[i]);
      if (!equal)
        break;
    }
    return equal;
  }

  float p1Height(float t) {
    boolean[] notesPlaying = new boolean[squares.length];
    int[] timesPlaying = new int[squares.length];
    for (int i = 0; i < p1EventTimes.size(); i++) {
      if (p1EventTimes.get(i) > t)
        break;
      if (noteToNumMap.containsKey(p1EventNotes.get(i))) {
        int indx = noteToNumMap.get(p1EventNotes.get(i));
        notesPlaying[indx] = !notesPlaying[indx];
        timesPlaying[indx] = p1EventTimes.get(i);
      }
    }
    
    return amplitude *
       ((notesPlaying[0] ? sin(1/period*(t - timesPlaying[0])) : 0)+
         (notesPlaying[1] ? sin(2/period*(t - timesPlaying[1])) : 0)+
          (notesPlaying[2] ? sin(4/period*(t - timesPlaying[2])) : 0)+
           (notesPlaying[3] ? sin(8/period*(t - timesPlaying[3])) : 0)+
            (notesPlaying[4] ? sin(16/period*(t - timesPlaying[4])) : 0)+
             (notesPlaying[5] ? sin(32/period*(t - timesPlaying[5])) : 0));
  }
  
  float p2Height(float t) {
    boolean[] notesPlaying = new boolean[squares.length];
    int[] timesPlaying = new int[squares.length];
    for (int i = 0; i < p2EventTimes.size(); i++) {
      if (p2EventTimes.get(i) > t)
        break;
      if (noteToNumMap.containsKey(p2EventNotes.get(i))) {
        int indx = noteToNumMap.get(p2EventNotes.get(i));
        notesPlaying[indx] = !notesPlaying[indx];
        timesPlaying[indx] = p2EventTimes.get(i);
      }
    }
  
    return amplitude *
       ((notesPlaying[0] ? sin(1/period*(t - timesPlaying[0])) : 0)+
         (notesPlaying[1] ? sin(2/period*(t - timesPlaying[1])) : 0)+
          (notesPlaying[2] ? sin(4/period*(t - timesPlaying[2])) : 0)+
           (notesPlaying[3] ? sin(8/period*(t - timesPlaying[3])) : 0)+
            (notesPlaying[4] ? sin(16/period*(t - timesPlaying[4])) : 0)+
             (notesPlaying[5] ? sin(32/period*(t - timesPlaying[5])) : 0));
  }

  void drawOpponent() {
    float x = w * .75;
    float t = millis();
    float oppHeight = p2Height(t);
    float p1Height = p1Height(t - travelTime);
    
    colorMode(RGB);
    stroke(255, 0, 0);
    line(x, height/2 - oppHeight, x, height/2 + p1Height);
    stroke(255);
    ellipse(x, height / 2  - oppHeight, 16, 16);
  }
  
  void p1PlayNote(String note) {
      p1EventTimes.add((int)(((int)(millis() / millisPerBeat) + 1) * millisPerBeat));
      p1EventNotes.add(note);
  }
  
  void p2PlayNote(String note) {
      p2EventTimes.add((int)(((int)(millis() / millisPerBeat) + 1) * millisPerBeat));
      p2EventNotes.add(note);
  }
}