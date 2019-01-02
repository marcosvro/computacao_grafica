public class Cor {
  int r, g, b;
  
  Cor (int r, int g, int b) {
    SetColor(r,g,b);
  }
  
  Cor (int gray) {
    r = g = b = gray;
  }
  
  Cor() {
    r = g = b = 0;
  }
  
  public void SetColor(int r, int g, int b) {
    if (r > 255)
      r = 255;
    else if (r < 0)
      r = 0;
    if (g > 255)
      g = 255;
    else if (g < 0)
      g = 0;
    if (b > 255)
      b = 255;
    else if (b < 0)
      b = 0;
    this.r = r;
    this.g = g;
    this.b = b;
  }
}

public class Vector2{
  int x, y;
  
  Vector2 (int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  Vector2 () {
    this.x = this.y = 0;
  }
}


void reta(Vector2 A, Vector2 B, Cor cor) {
  int dx = B.x - A.x, dy = B.y - A.y, steps;
  float iX, iY, x = A.x, y = A.y;
  
  if (abs(dx) > abs(dy))
    steps = abs(dx);
  else
    steps = abs(dy);
    
  iX = (float) dx / (float) steps;
  iY = (float) dy / (float) steps;
  
  stroke(cor.r, cor.g, cor.b);
  point((int)x, (int)y);
  
  for (int i = 0; i<steps; i++) {
   x += iX;
   y += iY;
   point((int)x, (int)y);
  }
}


/*
  – uma matriz P de dimensão n x 2 contendo as coordenadas (X, Y) de cada um dos npontos;

  – uma matriz L de dimensão mx 2 indicando, para cada linha, o índice dos seus pontos extremos;

  – a cor da linha do polígono;

  – se o polígono será preenchido ou não;

  – a cor de preenchimento do interior do polígono.
*/
void desenha_poligono(int [][] P, int [][]L, Cor cor_linha,  boolean preeche, Cor cor_preenchimento) {
  int m = P.length;
  int n = L.length;
  int min_y = height, max_y = 0;
  float [][] tabela = new float[n][4];
  
  if (preeche) {
    for(int i = 0; i< n; i++) {
      int indice1 = L[i][0], indice2 = L[i][1];
      if (P[indice1][1] < P[indice2][1]) { // p1.Y < p2.Y
        tabela [i][0] = P[indice1][1];
        tabela [i][1] = P[indice2][1];
        tabela [i][2] = P[indice1][0];
        if(P[indice1][1] != P[indice2][1])
          tabela [i][3] = (float) (P[indice1][0] - P[indice2][0]) / (float)(P[indice1][1] - P[indice2][1]);
        else
          tabela [i][3] = (float) 0;
      } else { //p2.Y >= P1.Y
        tabela [i][0] = P[indice2][1];
        tabela [i][1] = P[indice1][1];
        tabela [i][2] = P[indice2][0];
        if(P[indice1][1] != P[indice2][1])
          tabela [i][3] = ((float) (P[indice1][0] - P[indice2][0])) / ((float)(P[indice1][1] - P[indice2][1]));
        else
          tabela [i][3] = (float) 0;
      }
      if(tabela[i][0] < min_y)
        min_y = (int) tabela[i][0];
      if (tabela[i][1] > max_y)
        max_y = (int) tabela[i][1];
      //println(tabela[i][3]);
    }
    
    for (int y_var = min_y; y_var < max_y; y_var++) {
      IntList lista = new IntList();
      lista.clear();
      for (int i= 0; i<n; i++) {
        if (y_var <= tabela[i][1] && y_var >= tabela[i][0]){
          int x = round(tabela[i][3] * (y_var - (int)tabela[i][0]) + (int)tabela[i][2]);
          if (x == round(tabela[i][2]) &&  (y_var == tabela[i][0] || y_var == tabela[i][1]))
            x *= -1;
          lista.append(x);
          //println(lista.size());
        }
      }
      //println(lista.length);
      lista.sort();
      int [] aux = lista.array();
      //println(lista.size());
      for (int i = 1; i< aux.length;) {
        if(aux[i] == aux[i-1]) {
          i += 2;
        } else if (aux[i-1] < 0 && lista.hasValue(abs(aux[i-1]))) {
          i++;
        } else {
          reta(new Vector2(abs(aux[i]), y_var), new Vector2(abs(aux[i-1]), y_var), cor_preenchimento);
          i+=2;
        }
          
      }
    }
  }
  
  
  for (int i = 0; i< n; i++) {
    reta(new Vector2(P[L[i][0]][0], P[L[i][0]][1]), new Vector2(P[L[i][1]][0], P[L[i][1]][1]), cor_linha);
  }
  
}

void poligonos_aleatorios() {
  int q = (int) random(3, 6);
  int [][] P = new int[q][2];
  for(int i = 0; i < q; i++) {
    P[i][0] = (int) random(width);
    P[i][1] = (int) random(height);
  }
  
  int [][] L = new int[q][2];
  for(int i = 0; i < q; i++) {
    L[i][0] = i;
    L[i][1] = (i + 1) % q;
  }
  
  desenha_poligono(P, L, new Cor((int) random(0, 255), (int) random(0, 255), (int) random(0, 255)), true, new Cor((int) random(0, 255), (int) random(0, 255), (int) random(0, 255)));
}

void setup () {
  size(1250,720);
  background(255);
  /*Cor linha = new Cor();
  Cor fundo = new Cor(255, 0, 255);
  
  int[][] pontos ={{1,1},
                 {1,400},
                 {400,400},
                 {400,1}};
  int[][] lados = {{0,1},
                   {1,2},
                   {2,3},
                   {3,0}};
  
  desenha_poligono(pontos, lados, linha, true, fundo);
  reta(new Vector2(0, 300), new Vector2((int)(width), 300), linha);
  
  poligonos_aleatorios();
  */
}


void draw() {
  poligonos_aleatorios();
}
