// #################################################################################    EXECUÇÃO    ######################################################################################
Poligono[] pols;
int projecao = 0;
int pol_selecionado = 0;
int tipo_pintura = 0;

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

  //pol = new Poligono(vertices, arestas, new Vector3(0,0, 0), new Vector3(0,0,0), new Vector3(1,1,1), 5);
  pols = ler_poligonos_do_arquivo("figure.dat");
  
  pol_selecionado = 0;
}


void draw() {
  if(keyPressed){
    if(key == '1') {
      pols[pol_selecionado].Translate(new Vector3(-pols[pol_selecionado].fator_transformacao, 0, 0));
    } else if (key == '3') {
      pols[pol_selecionado].Translate(new Vector3(pols[pol_selecionado].fator_transformacao, 0, 0));
    } else if (key == '4') {
      pols[pol_selecionado].Translate(new Vector3(0,-pols[pol_selecionado].fator_transformacao,0));
    } else if (key == '6') {
      pols[pol_selecionado].Translate(new Vector3(0,pols[pol_selecionado].fator_transformacao,0));
    } else if (key == '7') {
      pols[pol_selecionado].Translate(new Vector3(0, 0,-pols[pol_selecionado].fator_transformacao));
    } else if (key == '9') {
      pols[pol_selecionado].Translate(new Vector3(0, 0,pols[pol_selecionado].fator_transformacao));
    } else if (key == 'q') {
      pols[pol_selecionado].Rotate(new Vector3(-pols[pol_selecionado].fator_transformacao, 0, 0));
    } else if (key == 'e') {
      pols[pol_selecionado].Rotate(new Vector3(pols[pol_selecionado].fator_transformacao, 0, 0));
    } else if (key == 'a') {
      pols[pol_selecionado].Rotate(new Vector3(0,-pols[pol_selecionado].fator_transformacao,0));
    } else if (key == 'd') {
      pols[pol_selecionado].Rotate(new Vector3(0,pols[pol_selecionado].fator_transformacao,0));
    } else if (key == 'z') {
      pols[pol_selecionado].Rotate(new Vector3(0, 0,-pols[pol_selecionado].fator_transformacao));
    } else if (key == 'c') {
      pols[pol_selecionado].Rotate(new Vector3(0, 0,pols[pol_selecionado].fator_transformacao));
    } else if (key == 'r') {
      pols[pol_selecionado].Scale(new Vector3(-pols[pol_selecionado].fator_transformacao, 0, 0));
    } else if (key == 'y') {
      pols[pol_selecionado].Scale(new Vector3(pols[pol_selecionado].fator_transformacao, 0, 0));
    } else if (key == 'f') {
      pols[pol_selecionado].Scale(new Vector3(0,-pols[pol_selecionado].fator_transformacao,0));
    } else if (key == 'h') {
      pols[pol_selecionado].Scale(new Vector3(0,pols[pol_selecionado].fator_transformacao,0));
    } else if (key == 'v') {
      pols[pol_selecionado].Scale(new Vector3(0,0,-pols[pol_selecionado].fator_transformacao));
    } else if (key == 'n') {
      pols[pol_selecionado].Scale(new Vector3(0,0,pols[pol_selecionado].fator_transformacao));
    } else if (key == '/') {
       projecao = 0;
    } else if (key == '*') {
      projecao = 1;
    } else if (key == '-') {
      projecao = 2;
    } else if (key == '+') {
      projecao = 3;
    } else if (key == '.') {
      projecao = 4;
    } else if (key == 'o') {
      tipo_pintura = 0;
    } else if (key == 'p') {
      tipo_pintura = 1;
    } else if (keyCode == TAB) {
      pol_selecionado = (pol_selecionado+1)%pols.length;
    } else if (keyCode == SHIFT) {
      pol_selecionado = pol_selecionado-1;
      if (pol_selecionado < 0)
        pol_selecionado += pols.length;
    }
  }
  
  int offset = 0;
  int [][][] pontos_tranformados = new int[pols.length][][];
  for(int i = 0; i<pols.length; i++) {
    pontos_tranformados[i] = new int[pols[i].m][2];
  }
  
  background(255);
  textSize(15);
  fill(0);
  if (projecao == 0) {
    for (int i =0; i<pols.length; i++) {
      pontos_tranformados[i] = pols[i].Cavaleira();
    }
    text("Projeção atual = Cavaleira", (int)(width-200), (int)(20));
  }else if (projecao == 1){
    for (int i =0; i<pols.length; i++) {
      pontos_tranformados[i] = pols[i].Cabinet(0.5);
    }
    text("Projeção atual = Cabinet", (int)(width-195), (int)(20));
  }else if (projecao == 2){
    for (int i =0; i<pols.length; i++) {
      pontos_tranformados[i] = pols[i].Isometrica();
    }
    text("Projeção atual = Isometrica", (int)(width-210), (int)(20));
  }else if (projecao == 3){
    for (int i =0; i<pols.length; i++) {
      pontos_tranformados[i] = pols[i].PontodeFuga(new Vector3(0, 0, 1));
    }
    text("Projeção atual = Pronto de Fuga (z)", (int)(width-265), (int)(20));
  }else if (projecao == 4){
    for (int i =0; i<pols.length; i++) {
      pontos_tranformados[i] = pols[i].PontodeFuga(new Vector3(1, 0, 1));
    }
    text("Projeção atual = Pronto de Fuga (x, z)", (int)(width-285), (int)(20));
  }else{
    for (int i =0; i<pols.length; i++) {
      pontos_tranformados[i] = pols[i].Cavaleira();
    }
  }
  
  //print(pontos_tranformados.length);
  
  
  
  fill(0);
  text("Teclas para transladar: (1,3) (4,6) (7,9)", 10, 15+20*(offset++));
  fill(0);
  text("Teclas para rotacionar: (q,e) (a,d) (z,c)", 10, 15+20*(offset++));
  fill(0);
  text("Teclas para transladar: (r,y) (f,h) (v,n)", 10, 15+20*(offset++));
  fill(0);
  text("Teclas: Cavaleira('/') Cabinet('*') Isometrica('-') Ponto_de_fuga_z('+') Ponto_de_fuga_xz('.') - padrão = Cavaleira", 10, 15+20*(offset++));
  fill(0);
  text("Teclas para mudar poligono selecionado: (SHIFT, TAB)", 10, 15+20*(offset++));
  fill(0);
  text("Para escolher pintar com o processing ou com o algoritmo de preencher poligonos(Sala de aula): (o, p)", 10, 15+20*(offset++));
  /*for (int i =0; i<pols.length; i++) {
    Cor contorno = new Cor(0);
    if (pol_selecionado == i)
      contorno.SetColor(255, 0, 0);
    desenha_faces_poligono(pontos_tranformados[i], pols[i].faces_pts, pols[i].faces_cores, contorno);
  } */
  
  int [][][] faces = new int[pols.length][][];
  int [][] faces_visiveis = new int[pols.length][];
  float [][] dist_faces = new float[pols.length][];
  Cor[][] cores_faces = new Cor[pols.length][];
  
  for (int i=0; i<pols.length; i++) {
    faces [i] = pols[i].faces_pts;
    faces_visiveis[i] = pols[i].faces_visiveis;
    dist_faces[i] = pols[i].dist_faces_visiveis;
    cores_faces[i] = pols[i].faces_cores;
  }
  
  desenha_faces_poligonos(pontos_tranformados, faces, faces_visiveis, dist_faces, cores_faces, new Cor(255, 0, 0), new Cor(0), pol_selecionado, tipo_pintura);
}
