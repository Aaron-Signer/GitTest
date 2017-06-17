//This is a test line
//well this is another test
//Update the screen please

Creature sG = new Creature("Steelclaw Grizly", 17, 0, 4, 3, 15, 7, 1,0,0,0);
Creature tF = new Creature("Thunderift Falcon", 6, 0, 1, 0, 5, 3, 1,0,0,0);
Creature aC = new Creature("Asyran Cleric", 5, 0, 1, 1, 6, 2, 2,1,0,0);
Creature kW = new Creature("Knight of Westlock", 13, 0, 3, 3, 10, 5, 2,0,8,1);

optimalPath A=new optimalPath();

Creature [] cards= {sG, tF, aC, kW};
//String[] Names = {" ", " ", " ", " ", " ", "Asyran Cleric", "Thunderift Falcon", " ", " ", " ", " ", " ", " ", "Knight of Westlock", " ", " ", " ", "Steelclaw Grizzly"};

Pair [] route = new Pair[4];
Pair [] routeTemp = new Pair[4];

int[] bestMove=new int[2];
int[][] path = new int [4][3];
int numHeals = 0;

int bestScore = 0;

int numberOfCards = 4;//cards.length;
int maxPlyLevel = 4;
//int midDef = numberOfCards/2;

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

public int[] transferEnchants(int[] e1)
{
  int [] tmp = new int[e1.length];
  for(int i = 0; i < e1.length; i ++)
    tmp[i] = e1[i];
  return tmp;
}

void updatePath(int ply, int i , int r, int bestScore)
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


int miniMax(int ply, int curPlayer)
{
    //print(ply);
    int bestScore = 0, score;
    int gameState = leading();
    //optimalPath TMP = new optimalPath();
    if (ply == maxPlyLevel)
    {
        score=gameState;
        return score;
    }

    if (curPlayer == 1)
      bestScore = -10000;
    else
      bestScore = 10000;
        for (int i = 0; i < numberOfCards; i++)
        {
            for (int r = 0; r < numberOfCards; r++)
            {
                if(cards[r].belongsTo==curPlayer && cards[i].belongsTo == curPlayer && cards[i].canAttack 
                   && cards[i].alive && cards[r].alive && cards[i].canHeal && cards[r].health < cards[r].maxHealth)
                {
                    numHeals ++;
                    cards[i].canAttack =false;
                    println("********Card "+cards[i].name+" healed "+cards[r].name);
                    int tempHealth = cards[r].health;
                    cards[i].heal(cards[r]);
                    score = miniMax(ply+1,3-curPlayer);
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
                
                if (cards[i].belongsTo == curPlayer && cards[r].belongsTo == 3-curPlayer && cards[i].canAttack 
                    && cards[i].alive && cards[r].alive)
                {
                    int [] tmp = transferEnchants(cards[i].enchants);
                    int [] tmp2 = transferEnchants(cards[r].enchants);
                    int tempHealth = cards[r].health;
                    cards[i].canAttack = false;;
                    cards[i].battle(cards[r]);
                    score = miniMax(ply + 1, 3-curPlayer);
                    print(score + " ");
                    if (score > bestScore && curPlayer == 1)
                    {
                        println("*** Ply: "+ply+" Player: "+curPlayer+" score: "+score+" bestScore: "+bestScore);
                        bestScore = score;
                        updatePath(ply, i,r,bestScore);
                    }
                    if (score < bestScore && curPlayer == 2)
                    {
                        println("*** Ply: "+ply+" Player: "+curPlayer+" score: "+score+" bestScore: "+bestScore);
                        bestScore = score;
                        updatePath(ply, i,r,bestScore);
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

void setup()
{
    cards[2].addEnchant(2,true);
    miniMax(0, 1);
    println();
    for (int i=0; i<numberOfCards; ++i)
    {
        print(path[i][0]+" ");
        print(path[i][1]+"    ");
    }
    print(numHeals);
}

void draw()
{
}

void keyPressed()
{
    if (key == ' ')
    {
        aC.battle(sG);
        print(sG.health + " ");
        if (sG.alive)
            print("Alive -- ");
        else
            print("Dead -- ");
    }
}

class optimalPath
{
    int score;
    int[][] path=new int[4][2];

    optimalPath()
    {
        score=0;
    }
}