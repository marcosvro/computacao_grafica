int Ymax = 1000;
int Ymin = -1000;
int Xmax = 1000;
int Xmin = -1000;
int Zmax = 1000;
int Zmin = -1000;

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

public class Vector3 {
  float x, y, z;
  
  Vector3 (float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  Vector3 () {
    this.x = this.y = this.z= 0;
  }

}

public class Poligono {
  float [][] pontos;
  int [][] lados;
  Vector3 rotacao;
  Vector3 escala;
  Vector3 posicao;
  float fator_transformacao;
  int m;
  int n;
  
  Poligono (float[][] pontos, int[][] lados, Vector3 posini, Vector3 rotini, Vector3 scalini, float fator_trans) {
    this.pontos = pontos;
    this.lados = lados;
    this.m = pontos.length;
    this.n = lados.length;
    this.rotacao = rotini;
    this.escala = scalini;
    this.posicao = posini;
    this.fator_transformacao = fator_trans;
  }
  
  Poligono (float[][] pontos, int[][] lados) {
    this.pontos = pontos;
    this.lados = lados;
    this.m = pontos.length;
    this.n = lados.length;
    this.rotacao = new Vector3(1,1,1);
    this.escala = new Vector3(1,1,1);
    this.posicao = new Vector3(1,1,1);
    this.fator_transformacao = 5; 
  }
  
  void Rotate(Vector3 rotate) {
    this.rotacao.x += rotate.x;
    this.rotacao.y += rotate.y;
    this.rotacao.z += rotate.z;
  }
  
  void Scale(Vector3 scale) {
    this.escala.x += scale.x;
    this.escala.y += scale.y;
    this.escala.z += scale.z;
  }
  
  void Translate(Vector3 position) {
    this.posicao.x += position.x;
    this.posicao.y += position.y;
    this.posicao.z += position.z;
  }
  
  int[][] PegaPoligono() {
    int[][] pontos_ret = new int[m][2];
    
    float H = Ymax-Ymin;
    float W = Xmax-Xmin;
    
    float m_ = min(width/W, height/H);
    print(m_);
    
    float dxd2 = (width- (W*m_))/2;
    float dyd2 = (height- (H*m_))/2;
    
    for (int i= 0; i<m; i++) {
      float x = pontos[i][0];
      float y = pontos[i][1];
      float z = pontos[i][2];
      
      float x1 = pontos[i][0];
      float y1 = pontos[i][1];
      float z1 = pontos[i][2];
      
      // rotação em X
      y = (y1 * cos(radians(rotacao.x))) - (z1 * sin(radians(rotacao.x)));
      z = (y1 * sin(radians(rotacao.x))) + (z1 * cos(radians(rotacao.x)));
      y1 = y;
      z1 = z;
      
      // rotação em Y
      x = (x1 * cos(radians(rotacao.y))) + (z1 * sin(radians(rotacao.y)));
      z = (z1 * cos(radians(rotacao.y))) - (x1 * sin(radians(rotacao.y)));
      x1 = x;
      z1 = z;
      
      // rotação em Z
      x = (x1 * cos(radians(rotacao.z))) - (y1 * sin(radians(rotacao.z)));
      y = (x1 * sin(radians(rotacao.z))) + (y1 * cos(radians(rotacao.z)));
      
      // escala
      x = x*escala.x;
      y = y*escala.y;
      z = z*escala.z;
      
      // translação
      x = x + posicao.x;
      y = y + posicao.y;
      z = z + posicao.z;
      
      print(x , y, z);
      print("\n");
      
      float y_ = Ymax-y;
      float x_ = x-Xmin;
      float z_ = Zmax-z;
      
      float x__ = x_*m_ +dxd2;
      float y__ = y_*m_ +dyd2;
      float z__ = z_*m_;
      
      pontos_ret[i][0] = (int)(x__ + z__*(sqrt(2)/2.0));
      pontos_ret[i][1] = (int)(y__ - z__*(sqrt(2)/2.0));
      
      print(pontos_ret[i][0] , pontos_ret[i][1]);
      print("\n");
    }
    
    return pontos_ret;
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
          tabela [i][3] = (float) (P[indice1][0] - P[indice2][0]) / (float)(P[indice1][1] - P[indice2][1]);
        else
          tabela [i][3] = (float) 0;
      }
      if(tabela[i][0] < min_y)
        min_y = (int) tabela[i][0];
      if (tabela[i][1] > max_y)
        max_y = (int) tabela[i][1];
      //println(tabela[i][3]);
    }
    
    for (int y_var = min_y; y_var <= max_y; y_var++) {
      IntList lista = new IntList();
      lista.clear();
      for (int i= 0; i<n; i++) {
        if (y_var <= tabela[i][1] && y_var >= tabela[i][0]){
          int x = round(tabela[i][3] * (y_var - (int)tabela[i][0]) + (int)tabela[i][2]);
          if (x == tabela[i][2])
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
  int q = (int) random(3, 10);
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

// #################################################################################    EXECUÇÃO    ######################################################################################
Poligono pol;


void setup () {
  size(1250,720);
  background(255);
  
  
  float[][] vertices = {
    {-100, -100, -100},
    {-100, -100, 100},
    {-100, 100, -100},
    {-100, 100, 100},
    {100, -100, -100},
    {100, -100, 100},
    {100, 100, -100},
    {100, 100, 100}
  };
  int[][] arestas = {
    {0, 1},
    {0, 2},
    {0, 4},
    {1, 3},
    {1, 5},
    {2, 3},
    {2, 6},
    {3, 7},
    {4, 5},
    {4, 6},
    {5, 7},
    {6, 7}
  };
  
  //float[][] p = new float[][] { {-250, 250, 250}, {250, 250, 250}, {-250, -250, 250}, {250, -250, 250}, {-250, 250, -250}, {250, 250, -250}, {-250, -250, -250}, {250, -250, -250} };
  //int[][] l = new int[][] { {0,1}, {0,2}, {0,4}, {1,3}, {1,5}, {2,3}, {2,6}, {3,7}, {4,5}, {4,6}, {5,7}, {6,7} };
  
  pol = new Poligono(vertices, arestas, new Vector3(0,0, 1000), new Vector3(0,0,0), new Vector3(1,1,1), 1);
  
  
  
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
  if(keyPressed){
    if(key == '1') {
      pol.Translate(new Vector3(-pol.fator_transformacao, 0, 0));
    } else if (key == '3') {
      pol.Translate(new Vector3(pol.fator_transformacao, 0, 0));
    } else if (key == '4') {
      pol.Translate(new Vector3(0,-pol.fator_transformacao,0));
    } else if (key == '6') {
      pol.Translate(new Vector3(0,pol.fator_transformacao,0));
    } else if (key == '7') {
      pol.Translate(new Vector3(0, 0,-pol.fator_transformacao));
    } else if (key == '9') {
      pol.Translate(new Vector3(0, 0,pol.fator_transformacao));
    } else if (key == 'q') {
      pol.Rotate(new Vector3(-pol.fator_transformacao, 0, 0));
    } else if (key == 'e') {
      pol.Rotate(new Vector3(pol.fator_transformacao, 0, 0));
    } else if (key == 'a') {
      pol.Rotate(new Vector3(0,-pol.fator_transformacao,0));
    } else if (key == 'd') {
      pol.Rotate(new Vector3(0,pol.fator_transformacao,0));
    } else if (key == 'z') {
      pol.Rotate(new Vector3(0, 0,-pol.fator_transformacao));
    } else if (key == 'c') {
      pol.Rotate(new Vector3(0, 0,pol.fator_transformacao));
    } else if (key == 'r') {
      pol.Scale(new Vector3(-pol.fator_transformacao, 0, 0));
    } else if (key == 'y') {
      pol.Scale(new Vector3(pol.fator_transformacao, 0, 0));
    } else if (key == 'f') {
      pol.Scale(new Vector3(0,-pol.fator_transformacao,0));
    } else if (key == 'h') {
      pol.Scale(new Vector3(0,pol.fator_transformacao,0));
    } else if (key == 'v') {
      pol.Scale(new Vector3(0,0,-pol.fator_transformacao));
    } else if (key == 'n') {
      pol.Scale(new Vector3(0,0,pol.fator_transformacao));
    }
  }
  int offset = 0;
  
  
  
  int [][] pontos_tranformados = pol.PegaPoligono();
  //print(pontos_tranformados.length);
  
  background(255);
  textSize(15);
  fill(0);
  text("Teclas para transladar: (1,3) (4,6) (7,9)", 10, 10+20*(offset++));
  fill(0);
  text("Teclas para rotacionar: (q,e) (a,d) (z,c)", 10, 10+20*(offset++));
  fill(0);
  text("Teclas para transladar: (r,y) (f,h) (v,n)", 10, 10+20*(offset++));
  desenha_poligono(pontos_tranformados, pol.lados, new Cor(0), false, new Cor(0));
  
}
