public class Poligono {
  int Ymax = 1000;
  int Ymin = -1000;
  int Xmax = 1000;
  int Xmin = -1000;
  int Zmax = 1000;
  int Zmin = -1000;

  float [][] pontos;
  int [][] lados;
  int [] faces_qts_pts;
  int [][] faces_pts;
  Cor[] faces_cores;
  
  Vector3 rotacao;
  Vector3 escala;
  Vector3 posicao;
  float fator_transformacao;
  int m;
  int n;
  int f;
  
  Poligono (float[][] pontos, int[][] lados, int[] faces_qts_pontos, int[][] faces_pontos, Cor[] faces_cores, Vector3 posini, Vector3 rotini, Vector3 scalini, float fator_trans, int[] dimensoes_universo) {
    this.pontos = pontos;
    this.lados = lados;
    this.faces_qts_pts = faces_qts_pontos;
    this.faces_pts = faces_pontos;
    this.faces_cores = faces_cores;
    this.m = pontos.length;
    this.n = lados.length;
    this.f = faces_qts_pontos.length;
    this.rotacao = rotini;
    this.escala = scalini;
    this.posicao = posini;
    this.fator_transformacao = fator_trans;
    Ymax = dimensoes_universo[0];
    Ymin = dimensoes_universo[1];
    Xmax = dimensoes_universo[2];
    Xmin = dimensoes_universo[3];
    Zmax = int((Xmax+Ymax)/2);
    Zmin = int((Xmin+Ymin)/2);
  }
  
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
  
  
  float [][] transformacoes(boolean cord_homo) {
    float[][] pontos_ret;
    if (cord_homo) {
      pontos_ret = new float[m][4];
    } else {
      pontos_ret = new float[m][3];
    }
    
    
    
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
      
      pontos_ret[i][0] = x;
      pontos_ret[i][1] = y;
      pontos_ret[i][2] = z;
      
      if(cord_homo)
        pontos_ret[i][3] = 1;
    }
    
    return pontos_ret;
  }
  
  float [][] ajusta_para_dispositivo(float [][] pontos, boolean cord_homo) {
    float [][] pontos_ret;
    
    if (cord_homo) {
      pontos_ret = new float[m][4];
    } else {
      pontos_ret = new float[m][3];
    }
    
    float H = Ymax-Ymin;
    float W = Xmax-Xmin;
    
    float m_ = min(width/W, height/H);
    //print(m_);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    float dxd2 = (width- (W*m_))/2;
    float dyd2 = (height- (H*m_))/2;
    
    for(int i=0; i<m; i++) {
      float y_ = Ymax-pontos[i][1];
      float x_ = pontos[i][0]-Xmin;
      float z_ = Zmax-pontos[i][2];
      
      float x__ = x_*m_ +dxd2;
      float y__ = y_*m_ +dyd2;
      float z__ = z_*m_;
      
      pontos_ret[i][0] = x__;
      pontos_ret[i][1] = y__;
      pontos_ret[i][2] = z__;
      
      if(cord_homo)
        pontos_ret[i][3] = 1;
    }
    
    return pontos_ret;
  }
  
  
  int[][] Cabinet(float l) {
    int[][] pontos_ret = new int[m][2];
    float angulo = 45;
    
    float [][] pontos_transformados = transformacoes(false);
    
    //CABINET
    for (int i= 0; i<m; i++) {
      pontos_transformados[i][0] = (pontos_transformados[i][0] + pontos_transformados[i][2]*(l*cos(radians(angulo))));
      pontos_transformados[i][1] = (pontos_transformados[i][1] + pontos_transformados[i][2]*(l*sin(radians(angulo))));
      //print(pontos_ret[i][0] , pontos_ret[i][1]);
      //print("\n");
    }
    
    pontos_transformados=ajusta_para_dispositivo(pontos_transformados, false);
    
    for (int i= 0; i<m; i++) {
      pontos_ret[i][0] = (int)(pontos_transformados[i][0]);
      pontos_ret[i][1] = (int)(pontos_transformados[i][1]);
      //print(pontos_ret[i][0] , pontos_ret[i][1]);
      //print("\n");
    }
    
    return pontos_ret;
  }
  
  
  
  int[][] Cavaleira() {
    int[][] pontos_ret = new int[m][2];
    float angulo = 45;
    
    float [][] pontos_transformados = transformacoes(false);
    
    //CAVALEIRA
    for (int i= 0; i<m; i++) {
      pontos_transformados[i][0] = (pontos_transformados[i][0] + pontos_transformados[i][2]*(cos(radians(angulo))));
      pontos_transformados[i][1] = (pontos_transformados[i][1] + pontos_transformados[i][2]*(sin(radians(angulo))));
      //print(pontos_ret[i][0] , pontos_ret[i][1]);
      //print("\n");
    }
    
    pontos_transformados=ajusta_para_dispositivo(pontos_transformados, false);
    
    for (int i= 0; i<m; i++) {
      pontos_ret[i][0] = (int)(pontos_transformados[i][0]);
      pontos_ret[i][1] = (int)(pontos_transformados[i][1]);
      //print(pontos_ret[i][0] , pontos_ret[i][1]);
      //print("\n");
    }
    
    return pontos_ret;
  }
  
  int [][] Isometrica() {
    int [][] pontos_ret = new int[m][2];
    float thetay = radians(45);
    float thetax = radians(35.26);
    float[][] M = {{cos(thetay),sin(thetay)*sin(thetax),0,0},
                   {0,cos(thetax),0,0},
                   {sin(thetay),-cos(thetay)*sin(thetax),1,0},
                   {0,0,0,1}};

    float [][] pontos_transformados = transformacoes(true);
    
    //aplica matriz de projeção isometrica
    pontos_transformados = MultiMat(pontos_transformados, M, m, 4);
    for(int i=0; i<m; i++) {
      pontos_transformados[i][0] = (pontos_transformados[i][0]/pontos_transformados[i][3]);
      pontos_transformados[i][1] = (pontos_transformados[i][1]/pontos_transformados[i][3]);
    }
    
    pontos_transformados = ajusta_para_dispositivo(pontos_transformados, false);
    
    for (int i= 0; i<m; i++) {
      pontos_ret[i][0] = (int)(pontos_transformados[i][0]);
      pontos_ret[i][1] = (int)(pontos_transformados[i][1]);
      //print(pontos_ret[i][0] , pontos_ret[i][1]);
      //print("\n");
    }
    
    return pontos_ret;
  }
  
  int [][] PontodeFuga(Vector3 ref) {
    int [][] pontos_ret = new int[m][2];
    float r = 0.001;
    float[][] M = {{1,0,0,ref.x*r},
                   {0,1,0,ref.y*r},
                   {0,0,1,ref.z*r},
                   {0,0,0,1}};

    float [][] pontos_transformados = transformacoes(true);
    
    //aplica matriz de ponto de fuga nos eixos informados pelo vetor ref
    pontos_transformados = MultiMat(pontos_transformados, M, m, 4);
    
    for(int i=0; i<m; i++) {
      pontos_transformados[i][0] = (pontos_transformados[i][0]/pontos_transformados[i][3]);
      pontos_transformados[i][1] = (pontos_transformados[i][1]/pontos_transformados[i][3]);
    }
    
    
    pontos_transformados = ajusta_para_dispositivo(pontos_transformados, false);
    
    for (int i= 0; i<m; i++) {
      pontos_ret[i][0] = (int)(pontos_transformados[i][0]);
      pontos_ret[i][1] = (int)(pontos_transformados[i][1]);
      //print(pontos_ret[i][0] , pontos_ret[i][1]);
      //print("\n");
    }
    
    return pontos_ret;
  }
}
