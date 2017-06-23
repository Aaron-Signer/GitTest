//Test

import java.util.Map;
import static javax.swing.JOptionPane.*;
boolean hasFlying = true, noFlying = false;

Creature sG = new Creature("Steelclaw Grizly", 17, 0, 4, 3, 15, 7, 1, 0, 0, 0, noFlying);
Creature tF = new Creature("Thunderift Falcon", 6, 0, 1, 0, 5, 3, 1, 0, 0, 0, hasFlying);
Creature aC = new Creature("Asyran Cleric", 5, 0, 1, 1, 6, 2, 2, 1, 0, 0, noFlying);
Creature kW = new Creature("Knight of Westlock", 13, 0, 3, 3, 10, 5, 2, 0, 8, 1, noFlying);
Creature dB = new Creature("Darkfenne Bat", 5, 0, 1, 0, 4, 2, 2, 0, 0, 0, hasFlying);



Creature [] cards= {sG, tF, aC, kW, dB};
//String[] Names = {" ", " ", " ", " ", " ", "Asyran Cleric", "Thunderift Falcon", " ", " ", " ", " ", " ", " ", "Knight of Westlock", " ", " ", " ", "Steelclaw Grizzly"};

int depth = cards.length;

//int[] bestMove=new int[2];
int[][] path = new int [cards.length][3];
int numHeals = 0;

int bestScore = 0;

int numberOfCards = cards.length;
//int maxPlyLevel = numberOfCards;
//int midDef = numberOfCards/2;

String input, first, second;
int num1, num2;

HashMap<String, Integer> hm = new HashMap<String, Integer>();
IntDict inventory = new IntDict();


/*public void printRoute()
 {
 for (int i = 0; i < 4; i++)
 route[i].printPair();
 }*/

/*public Pair[] transfer(Pair [] p1)
 {
 Pair [] p2 = new Pair[p1.length];
 for (int i = 0; i < 2; i++)
 p2[i] = p1[i];
 return p2;
 }*/

public void resetAllCreatures()
{
  for (int i = 0; i < cards.length; i++)
    if (cards[i].alive)
      cards[i].canAttack = true;
}

public void checkEndRound()
{
  int temp = creaturesLeft();
  if (temp == 0)
    resetAllCreatures();
}
public void printHP()
{
  for (int i = 0; i < cards.length; i ++)
    print(cards[i].health + " ");
  println();
}

public int[] transferEnchants(int[] e1)
{
  int [] tmp = new int[e1.length];
  for (int i = 0; i < e1.length; i ++)
    tmp[i] = e1[i];
  return tmp;
}

void updatePath(int ply, int i, int r, int bestScore)
{
  path[ply][0] = i;
  path[ply][1] = r;
  path[ply][2] = bestScore;
}

int leading()
{
  int score = 0;
  //int p1TotalHealth = 0;
  //int p2TotalHealth = 0;
  for (int i = 0; i < numberOfCards; i++)
    if (cards[i].health > 0)
      if (cards[i].belongsTo == 1)
        score += 20 + cards[i].health;
      else
        score -= 20 + cards[i].health;

  return score;
}

public int creaturesLeft()
{
  int temp = 0;
  for (int i = 0; i < cards.length; i ++)
    if (cards[i].canAttack)
      temp++;

  return temp;
}

public boolean validToHeal(int i, int r, int curPlayer)
{
  return cards[r].belongsTo==curPlayer && cards[i].belongsTo == curPlayer && cards[i].canAttack 
    && cards[i].alive && cards[r].alive && cards[i].canHeal && cards[r].health < cards[r].maxHealth;
}

public boolean validToPass(int curPlayer)
{
  boolean pass=false;
  int numCreaturesForPlayerOne=0;
  int numCreaturesForPlayerTwo=0;
  for (int i=0; i<cards.length; ++i)
  {
    if (cards[i].canAttack)
    {
      if (cards[i].belongsTo==1)
        numCreaturesForPlayerOne++;
      else
        numCreaturesForPlayerTwo++;
    }
  }
  if(curPlayer==1&&numCreaturesForPlayerOne<numCreaturesForPlayerTwo) pass = true;
  if(curPlayer==2&&numCreaturesForPlayerOne>numCreaturesForPlayerTwo) pass = true;
  return pass;
}

int miniMax(int ply, int curPlayer)
{

  //print(ply);
  int bestScore = 0, score;
  int gameState = leading();
  //optimalPath TMP = new optimalPath();
  if (ply == depth)
  {
    score=gameState;
    return score;
  }

  if (curPlayer == 1)
    bestScore = -10000;
  else
    bestScore = 10000;
    
    if (validToPass(curPlayer))
  {
    score=miniMax(ply+1, 3-curPlayer);
    println("Player "+curPlayer+" Passes.lk aklsdhj'fla sjdflkjaslkdjf lasj dflkjasdl fjalskdjf");
    if (score > bestScore && curPlayer == 1)
    {
      println("*** Ply: "+ply+" Player: "+curPlayer+" score: "+ score+" bestScore: "+bestScore);
      bestScore = score;
      updatePath(ply, -1, -1, bestScore);
    }
    if (score < bestScore && curPlayer == 2)
    {
      println("*** Ply: "+ply+" Player: "+curPlayer+" score: "+ score+" bestScore: "+bestScore);
      bestScore = score;
      updatePath(ply, -1, -1, bestScore);
    }
  }

  for (int i = 0; i < numberOfCards; i++)
  {
    for (int r = 0; r < numberOfCards; r++)
    {              
      if (validToHeal(i, r, curPlayer))
      {
        numHeals ++;
        cards[i].canAttack =false;
        println("********Card "+cards[i].name+" healed "+cards[r].name);
        int tempHealth = cards[r].health;
        cards[i].heal(cards[r]);
        score = miniMax(ply+1, 3-curPlayer);
        print(score + " ");
        if (score > bestScore && curPlayer == 1)
        {
          println("*** Ply: "+ply+" Player: "+curPlayer+" score: "+ score+" bestScore: "+bestScore);
          bestScore = score;
          updatePath(ply, i, r, bestScore);
        }
        if (score < bestScore && curPlayer == 2)
        {
          println("*** Ply: "+ply+" Player: "+curPlayer+" score: "+ score+" bestScore: "+bestScore);
          bestScore = score;
          updatePath(ply, i, r, bestScore);
        }
        cards[i].canAttack = true;
        cards[r].health = tempHealth;
      }

      if (cards[i].validToAttack(cards[r], curPlayer))
      {
        int [] tmp = transferEnchants(cards[i].enchants);
        int [] tmp2 = transferEnchants(cards[r].enchants);
        int tempHealth = cards[r].health;
        cards[i].canAttack = false;
        ;
        cards[i].battle(cards[r]);
        score = miniMax(ply + 1, 3-curPlayer);
        print(score + " ");
        if (score > bestScore && curPlayer == 1)
        {
          println("*** Ply: "+ply+" Player: "+curPlayer+" score: "+score+" bestScore: "+bestScore);
          bestScore = score;
          updatePath(ply, i, r, bestScore);
        }
        if (score < bestScore && curPlayer == 2)
        {
          println("*** Ply: "+ply+" Player: "+curPlayer+" score: "+score+" bestScore: "+bestScore);
          bestScore = score;
          updatePath(ply, i, r, bestScore);
        }
        cards[i].canAttack = true;
        cards[r].health = tempHealth;
        cards[r].checkHealth();
        cards[i].enchants = transferEnchants(tmp);
        cards[r].enchants = transferEnchants(tmp2);
      }
    }
  }
    
  
    
  return bestScore;
}

void input()
{
  input = showInputDialog("Enter LOW value for range selection.");
  input = input.trim();
  //println(input);
  first = input.substring(0, 1);
  //println(first);
  second = input.substring(1);
  second = second.trim();
  //println(second);
  num1 = Integer.parseInt(first);
  num2 = Integer.parseInt(second);
}

void turn()
{
}

void setup()
{
  for(int i = 0; i < cards.length; i++)
    cards[i].setLocation(0,0);
  kW.setLocation(1,1);
  
  String temp = showInputDialog("Enter LOW value for range selection.");
  //temp = input.trim();
  inventory.set("Bear Strength", 0);
  inventory.set("Endurance",1);
  println(inventory.get(temp));
  //println(hm.getValue());
  //input();
  //low = parseFloat(input == null? "" : input, low);
  //cards[2].addEnchant(2,true);
  depth = 4;
  miniMax(0, 1);
  println();
  for (int i=0; i<numberOfCards; ++i)
  {
    print(path[i][0]+" ");
    print(path[i][1]+"    ");
  }
  println(numHeals);
  
  
  
}

void draw()
{
}

void mousePressed()
{
  if (mousePressed)
  {

    printHP();
    input();
    if (cards[num1].canAttack && cards[num1].belongsTo != cards[num2].belongsTo)
    {
      cards[num1].battleActual(cards[num2], 1);
      println("--------------");
      println("++++++ " + depth);
      depth  = creaturesLeft();
      println("++++++ " + depth);
      miniMax(0, 2);
      if (cards[path[0][0]].belongsTo == cards[path[0][1]].belongsTo)
        cards[path[0][0]].healActual(cards[path[0][1]]);
      else
        cards[path[0][0]].battleActual(cards[path[0][1]], 2);
    } else
      println(cards[num1].name + " has no action available");
  }
  printHP();
  checkEndRound();
}