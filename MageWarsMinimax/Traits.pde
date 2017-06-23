class Traits
{
  String name;
  int [] enchants = new int[7];
  int cost, reach, level, armor, health, damage, index, maxHealth, heal, defense, defNum, row, col;
  int originalHealth;
  boolean alive = true, canHeal = false, flying = false;
  
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
  
  public void checkHealthActual()
  {
    int tmp = 0;
    if(enchants[2] == 2)
    {
      println("%%%%%%%%%%%%%%");
      tmp = -4;
    }
    else
      if(health <= tmp)
      {
        println(name + " has died");
        alive = false;
      }
      else
        alive = true;
  }
 
}