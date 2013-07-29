Maxim maxim; 
float margin;
float kW;
float kH;
int keys;
boolean artMode;
boolean barMode;
ArrayList<ParticleSystem> particleSystems;
String[] notes = { 
  "C", "D", "E", "F", "G", "A", "B"
};
AudioPlayer[] notePlayers;
void setup()
{
  size(768, 480);
  frame.setResizable(true);
  background(0);

  maxim = new Maxim(this);
  particleSystems = new ArrayList<ParticleSystem>();
  artMode = false;
  barMode = true;
  keys = 7;
  kW = width / 15;
  kH = height / 4;
  margin = (width - kW * keys) / 2;

  load_notePlayers();
}

void draw()
{
  /*===========Keyboard Drawing==========*/
  kW = width / 15;
  kH = height / 4;
  margin = (width - kW * keys) / 2;
  if (!artMode)
    background(0);

  draw_keyboard(keys, kW, kH);
  /*=====================================*/

  /*================================Hovering Over Keys================================*/
  for (int i = 0; i < keys; i++)
  {
    if (overKey(i, kW, kH))
    {
      stroke(100);
      fill(255, 255, 0);
      rect(i * kW + margin, height - kH, kW, kH);
      fill(0);
      textAlign(CENTER);
      text(notes[i], i *kW + margin + (kW/2), height - kH + (kH/2));
    }
  }
  /*===================================================================================*/

  if (!artMode)
    visualizeSound();

  /*======================Draw Particles======================*/
  for (int i = particleSystems.size() - 1; i >= 0; i--)
  {
    if (particleSystems.get(i).dead())
      particleSystems.remove(i);
    else
      particleSystems.get(i).run();
  }
  /*==========================================================*/
}

//Either draw line graph or bar graph of spectrum
void visualizeSound()
{
  colorMode(HSB);
  float viewCenterY = (height - kH) / 2;
  float amp = 200;
  for (int i = 0; i < keys; i++)
  {
    if (notePlayers[i].isPlaying())
    {
      float[] spec = notePlayers[i].getPowerSpectrum();
      int bars = 128;
      float barWidth = width / bars;
      if (barMode)
      {
        for (int j = 0; j < bars; j++)
        {
          noStroke();
          fill(map(j, 0, bars, 0, 255), 255, 255);
          float barHeight = spec[j];
          rect(j*barWidth, viewCenterY - (barHeight * amp), barWidth, barHeight * amp);
          rect(j*barWidth, viewCenterY, barWidth, barHeight * amp);
        }
      }
      else
      {
        strokeWeight(2);
        pushMatrix();
        translate(0, viewCenterY);
        for (int j = 0; j < bars - 1; j++)
        {
          stroke(map(j, 0, bars, 0, 255), 255, 255);
          line(j * barWidth, spec[j] * amp, (j+1) * barWidth, spec[j+1] * amp);
        }
        popMatrix();
        strokeWeight(1);
      }
    }
  }
  colorMode(RGB);
}

void keyPressed()
{
  switch(key)
  {
    case 'c':
    {
      background(0);
      particleSystems.clear();
      draw_keyboard(keys, kW, kH);
      break;
    }
    case 'm':
    {
      background(0);
      particleSystems.clear();
      draw_keyboard(keys, kW, kH);
      artMode = !artMode;
      break;
    }
    case 'b':
    {
      background(0);
      particleSystems.clear();
      draw_keyboard(keys, kW, kH);
      barMode = !barMode;
    }
  }
}

void mouseClicked()
{
  for (int i = 0; i < keys; i++)
  {
    if (overKey(i, kW, kH))
    {
      if (notePlayers[i].isPlaying())
      {
        notePlayers[i].cue(0);
      }
      notePlayers[i].play();
      ParticleSystem ps = new ParticleSystem(ceil(map(i, 0, keys, 10, 30)), new PVector(random(0, width), random(0, height-kH)), notes[i]);
      particleSystems.add(ps);
      ps.run();
    }
  }
}

void load_notePlayers()
{
  notePlayers = new AudioPlayer[notes.length];
  notePlayers[0] = maxim.loadFile("notes/note_c.wav");
  notePlayers[1] = maxim.loadFile("notes/note_d.wav");
  notePlayers[2] = maxim.loadFile("notes/note_e.wav");
  notePlayers[3] = maxim.loadFile("notes/note_f.wav");
  notePlayers[4] = maxim.loadFile("notes/note_g.wav");
  notePlayers[5] = maxim.loadFile("notes/note_a_alt.wav");
  notePlayers[6] = maxim.loadFile("notes/note_b.wav");

  for (int i = 0; i < keys; i++)
  {
    notePlayers[i].setLooping(false);
    notePlayers[i].volume(1.5);
    notePlayers[i].setAnalysing(true);
  }
}

void draw_keyboard(float numKeys, float key_w, float key_h)
{
  noStroke();
  fill(200);
  rect(0, height - key_h, width, key_h);

  stroke(100);
  fill(255);
  for (int i = 0; i < numKeys; i++)
    rect(i * key_w + margin, height - key_h, key_w, key_h);
}

boolean overKey(int keyNum, float key_w, float key_h)  
{
  if (mouseX >= keyNum * key_w + margin && 
    mouseX <= keyNum * key_w + margin + key_w && 
    mouseY >= height - key_h && 
    mouseY <= height) 
  {
    return true;
  } 
  return false;
}

