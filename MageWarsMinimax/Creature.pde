class Creature extends Traits
{
    String name;
    int regDam;
    int armPecDam;
    int totalDam =0;
    int damageTaken = 0;
    int belongsTo;
    // will need to be changed for actual game
    boolean canAttack = true;

    Creature(String n, int c, int r, int l, int a, int h, int d, int bT, int heals, int def, int defNum)
    {
        name=n;
        cost = c;
        reach = r;
        level = l;
        armor = a;
        health = h;
        maxHealth = h;
        damage = d;
        belongsTo = bT;
        originalHealth = h;
        heal = heals;
        if(heal > 0)
          canHeal = true;
        defense = def;
        this.defNum = defNum;
        
        for(int i = 0; i < 7; i++)
          enchants[i] = 0;
    }
    
    void heal(Creature c2)
    {
      int tmpHealth = c2.health + heal;
      c2.health = min(tmpHealth, c2.maxHealth);
    }

  public void addEnchant(int i, boolean revealed)
  {
    if(revealed)
      enchants[i] = 2;
    else
      enchants[i] = 1;
  }

    public void battle(Creature c2)
    {
        regDam = 0;
        armPecDam = 0;
        int dieRoll;
        int dice = damage;
        int c2Armor = c2.armor;

        /*for (int i = 0; i < damage; i++)
        {
            dieRoll = (int)random(0, 6);
            if (dieRoll == 2)
                regDam += 1;
            else if (dieRoll == 3)
                regDam += 2;
            else if (dieRoll == 4)
                armPecDam += 1;
            else if (dieRoll == 5)
                armPecDam += 2;
        }*/
        
        if(enchants[0] == 2)
          dice += 2;
        if(c2.enchants[1] == 1)
        {
          dice = 0;
          c2.enchants[1] = 0;
        }
        if(c2.enchants[3] == 2)
          dice = 0;
        
        if(c2.enchants[5] == 2)
          c2Armor = max(c2Armor - 2, 0);
          

        regDam = (int)(.5*dice);
        armPecDam = (int)(.5*dice);

        totalDam = max(regDam-c2Armor, 0);
        totalDam += armPecDam;
        c2.health -= totalDam;   
        c2.damageTaken = totalDam;
        println(name+" did "+totalDam+" damage to the "+c2.name);
//        println(Names[cost]+" did "+totalDam+" damage to the "+Names[c2.cost]);

        c2.checkHealth();
    }

  public void battle(Creature c1,Creature c2)
    {
      if(c1.canAttack)
      {
        regDam = 0;
        armPecDam = 0;
        int dieRoll;
        int dice = damage;
        int c2Armor = c2.armor;

        /*for (int i = 0; i < damage; i++)
        {
            dieRoll = (int)random(0, 6);
            if (dieRoll == 2)
                regDam += 1;
            else if (dieRoll == 3)
                regDam += 2;
            else if (dieRoll == 4)
                armPecDam += 1;
            else if (dieRoll == 5)
                armPecDam += 2;
        }*/
        
        if(enchants[0] == 2)
          dice += 2;
        if(c2.enchants[1] == 1)
        {
          dice = 0;
          c2.enchants[1] = 0;
        }
        if(c2.enchants[3] == 2)
          dice = 0;
        
        if(c2.enchants[5] == 2)
          c2Armor = max(c2Armor - 2, 0);
          

        regDam = (int)(.5*dice);
        armPecDam = (int)(.5*dice);

        totalDam = max(regDam-c2Armor, 0);
        totalDam += armPecDam;
        c2.health -= totalDam;   
        c2.damageTaken = totalDam;
        println(name+" did "+totalDam+" damage to the "+c2.name);
//        println(Names[cost]+" did "+totalDam+" damage to the "+Names[c2.cost]);

        c2.checkHealth();
        c1.canAttack = false;
      }
      else
        println(c1.name + "has no action available");
    }
    
}