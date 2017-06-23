class Creature extends Traits
{
    int regDam;
    int armPecDam;
    int totalDam =0;
    int damageTaken = 0;
    int belongsTo;
    // will need to be changed for actual game
    boolean canAttack = true, bS;

    Creature(String n, int c, int r, int l, int a, int h, int d, int bT, int heals, int def, int defNum, boolean flying)
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
        this.flying = flying;
        
        for(int i = 0; i < 7; i++)
          enchants[i] = 0;
    }
    void setLocation(int r, int c)
    {
      row = r;
      col = c;
    }
    
    void heal(Creature c2)
    {
      int tmpHealth = c2.health + heal;
      c2.health = min(tmpHealth, c2.maxHealth);
    }
    
    void healActual(Creature c2)
    {
      int tmpHealth = c2.health + heal;
      c2.health = min(tmpHealth, c2.maxHealth);
      println("********Card "+name+" healed "+c2.name);
      canAttack = false;
    }

  public void addEnchant(int i, boolean revealed)
  {
    if(revealed)
      enchants[i] = 2;
    else
      enchants[i] = 1;
  }
  
  public boolean validToAttack(Creature c2, int curPlayer)
  {
    boolean temp = belongsTo == curPlayer && c2.belongsTo == 3-curPlayer && canAttack 
                      && alive && c2.alive;
    if(c2.flying && !flying)
      temp = false;
    if(abs(row-c2.row) + abs(col-c2.col) > 1)
    {
      println(name + " is too far away from " + c2.name);
      temp = false;
    }
    return temp;
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
        //println(name+" did "+totalDam+" damage to the "+c2.name);
//        println(Names[cost]+" did "+totalDam+" damage to the "+Names[c2.cost]);

        c2.checkHealth();
    }

  public void battleActual(Creature c2, int curPlayer)
    {
      if(validToAttack(c2,curPlayer))
      //if(alive && canAttack && c2.alive && c2.belongsTo != belongsTo)
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
        println("AB " + name+" did "+totalDam+" damage to the "+c2.name);
//        println(Names[cost]+" did "+totalDam+" damage to the "+Names[c2.cost]);

        printHP();
        c2.checkHealthActual();
        canAttack = false;
      }
      
      else if(!c2.alive)
        println(c2.name + " is not alive");
      
      else if(c2.flying)
        println(c2.name + " has flying and " + name + " does not.");
      else
       println(name + " you attacked belongs to you. " + c2.name);
    }
    
}