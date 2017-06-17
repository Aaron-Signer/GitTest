class Traits
{
  int [] enchants = new int[7];
  int cost, reach, level, armor, health, damage, index, maxHealth, heal, defense, defNum;
  int originalHealth;
  boolean alive = true, canHeal = false;
  
  public void checkHealth()
  {
    int tmp = 0;
    if(enchants[2] == 2)
      tmp = -4;
    else
      if(health <= tmp)
          alive = false;
      else
        alive = true;
  }
 
}