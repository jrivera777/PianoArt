class ParticleSystem 
{

  ArrayList<Particle> particles;    
  PVector origin;                   
  int count;
  char note;
  ParticleSystem(int num, PVector v, String nt) 
  {
    particles = new ArrayList<Particle>();
    origin = v.get();                     
    note = nt.charAt(0);
    count = (note == 'F') ? num * 2 : num;

    for (int i = 0; i < num; i++) 
    {
      particles.add(new Particle(origin, note));
    }
  }

  void run() 
  {
    for (int i = particles.size()-1; i >= 0; i--)
    {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }

  void addParticle() 
  {
    Particle p;
    p = new Particle(origin, note);
    particles.add(p);
  }

  void addParticle(Particle p) 
  {
    particles.add(p);
  }

  boolean dead() 
  {
    return particles.isEmpty();
  }
}

