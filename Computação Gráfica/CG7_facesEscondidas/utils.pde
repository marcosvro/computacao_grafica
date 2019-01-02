

float[][] MultiMat(float[][] m1, float[][] m2, int l, int c) {
  float[][] mat_ret = new float[l][c];
  int meio = m2.length;
  
  for (int i=0; i<l; i++) {
    for (int j=0; j<c; j++) {
      float soma = 0;
      for (int k=0; k<meio; k++) {
        soma += m1[i][k]*m2[k][j];
      }
      mat_ret[i][j] = soma;
    }
  }
  return mat_ret;
}

float ProdutoEscalar(float[] p1, float[] p2) {
  float soma =0;
  if (p1.length != p2.length) {
    print("Não é possivel calcular o produto escalar destes vetores, dimensões não equivalentes!!");
    exit();
  }
  for (int i =0; i< p1.length; i++) {
    soma += p1[i]*p2[i];
  }
  
  return soma;
}

float [] Normal(float[] p0, float[] p1, float[] p2) {
  float[] u = new float[3];
  float[] v = new float[3];
  float[] n = new float[3];
  
  u[0] = p1[0] - p0[0];
  u[1] = p1[1] - p0[1];
  u[2] = p1[2] - p0[2];
  
  v[0] = p2[0] - p0[0];
  v[1] = p2[1] - p0[1];
  v[2] = p2[2] - p0[2];
  
  n[0] = u[1]*v[2] - u[2]*v[1];
  n[1] = u[0]*v[2] - u[2]*v[0];
  n[2] = u[0]*v[1] - u[1]*v[0];
  
  return n;
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
  
void desenha_faces_poligono(int [][] P, int[][]F, Cor[] cor_faces, Cor cor_linha) {
  int f = F.length;
  
  for (int i = 0; i<f; i++) {
    int[][] pontos_face = new int[F[i].length][2];
    int[][] arestas_face = new int[F[i].length][2];
    for(int j =0; j<F[i].length; j++) {
      pontos_face[j][0] = P[F[i][j]][0];
      pontos_face[j][1] = P[F[i][j]][1];
    }
    int j;
    for(j =0; j<F[i].length-1; j++) {
      arestas_face[j][0] = F[i][j];
      arestas_face[j][1] = F[i][j+1];
    }
    arestas_face[j][0] = F[i][j];
    arestas_face[j][1] = F[i][0];
    desenha_poligono(P, arestas_face, cor_linha, true, cor_faces[i]);
  }
}

void desenha_faces_poligonos(int [][][] P, int[][][]F, int[][]faces_visiveis, float[][] dist_faces, Cor[][] cor_faces, Cor cor_linha_selecionado, Cor cor_linha_padrao, int id_pol_selecionado, int tipo_pinbtura) {
  int num_pols = P.length;
  int[] ids_pol_faces = new int[num_pols];
  int id_pol_face_longe = 0;
  float maior_dist = dist_faces[0][dist_faces[0].length-1];
  int total_faces = 0;
  
  for (int i=0; i< num_pols; i++) {
    ids_pol_faces[i] = faces_visiveis[i].length-1;
    total_faces += faces_visiveis[i].length;
  }
  
  for (int l = 0; l<total_faces; l++) {
    //escolhe poligono que tem a face mais longe ainda não desenhada
    
    for (int i=0; i<num_pols; i++) {
      if ((ids_pol_faces[i] >= 0 && dist_faces[i][ids_pol_faces[i]] > maior_dist) || (ids_pol_faces[id_pol_face_longe] < 0 && i != id_pol_face_longe)) {
        id_pol_face_longe = i;
        maior_dist = dist_faces[i][ids_pol_faces[i]];
      }
    }
    
    //desenha a face
    int p = faces_visiveis[id_pol_face_longe][ids_pol_faces[id_pol_face_longe]];
    int f = F[id_pol_face_longe][p].length;
    int[][] face = new int[1][f];
    face[0] = F[id_pol_face_longe][faces_visiveis[id_pol_face_longe][ids_pol_faces[id_pol_face_longe]]];
    Cor[]  cor_face = new Cor[1];
    cor_face[0] = cor_faces[id_pol_face_longe][faces_visiveis[id_pol_face_longe][ids_pol_faces[id_pol_face_longe]]];
    if (tipo_pintura == 0) {
      fill(0);
      text("Pintando com algoritmo do processing", (int)(width-285), (int)(40));
      if (id_pol_selecionado == id_pol_face_longe)
        desenha_poligono_processing(P[id_pol_face_longe], face, cor_face,cor_linha_selecionado);
        //desenha_faces_poligono(P[id_pol_face_longe], face, cor_face,cor_linha_selecionado);
      else
        desenha_poligono_processing(P[id_pol_face_longe], face, cor_face,cor_linha_padrao);
        //desenha_faces_poligono(P[id_pol_face_longe], face, cor_face,cor_linha_padrao);
    } else {
      fill(0);
      text("Pintando com algoritmo de varredura", (int)(width-285), (int)(40));
      if (id_pol_selecionado == id_pol_face_longe)
        //desenha_poligono_processing(P[id_pol_face_longe], face, cor_face,cor_linha_selecionado);
        desenha_faces_poligono(P[id_pol_face_longe], face, cor_face,cor_linha_selecionado);
      else
        //desenha_poligono_processing(P[id_pol_face_longe], face, cor_face,cor_linha_padrao);
        desenha_faces_poligono(P[id_pol_face_longe], face, cor_face,cor_linha_padrao);
    }
    
    
    
    ids_pol_faces[id_pol_face_longe]--;
  }
}

void desenha_poligono_processing(int [][] P, int[][]F, Cor[] cor_faces, Cor cor_linha) {
  int f = F.length;
  
  for (int i = 0; i<f; i++) {
    int[][] pontos_face = new int[F[i].length][2];
    int[][] arestas_face = new int[F[i].length][2];
    for(int j =0; j<F[i].length; j++) {
      pontos_face[j][0] = P[F[i][j]][0];
      pontos_face[j][1] = P[F[i][j]][1];
    }
    int j;
    for(j =0; j<F[i].length-1; j++) {
      arestas_face[j][0] = F[i][j];
      arestas_face[j][1] = F[i][j+1];
    }
    arestas_face[j][0] = F[i][j];
    arestas_face[j][1] = F[i][0];
    //desenha_poligono(P, arestas_face, cor_linha, true, cor_faces[i]);
    
    fill(cor_faces[i].r, cor_faces[i].g, cor_faces[i].b);
    stroke(cor_linha.r, cor_linha.g, cor_linha.b);
    strokeWeight(2);
    beginShape();
    for (int l =0; l<pontos_face.length; l++) {
      vertex(pontos_face[l][0], pontos_face[l][1]);
    }
    endShape(CLOSE);
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

Poligono[] ler_poligonos_do_arquivo(String file) {
  String[] lines = loadStrings(file);
  int i = 0;
  
  //Pula Comentarios iniciais
  for (; i < lines.length; i++) {
    String[] splited = split(lines[i], ' ');
    if (splited[0].equals("#") == true) {
      continue;
    } else
      break;
  }
  
  //Pega dimensões do espaço
  String dim = lines[i];
  int[] dim_universo = int(split(dim, ' '));
  i++;
  
  //pega objetos
  int num_objs = int(lines[i]);
  i++;
  if (num_objs <= 0) {
    print("Nenhum poligono no arquivo!!");
    exit();
  }
  Poligono[] rets = new Poligono[num_objs];
  for (int j = 0; j<num_objs; j++) {
    
    //skiping comments
    String[] splited= split(lines[i], ' ');;
    while(true) {
      if (splited[0].equals("#") == true)
        i++;
      else
        break;
      splited = split(lines[i], ' ');
    }
    //reading points ammount, lines ammount and faces ammount
    int[] PLF_lens = int(split(lines[i], ' '));
    i++;
    //geting pontos
    float[][] pontos = new float[PLF_lens[0]][3];
    for(int k = 0; k< PLF_lens[0]; k++) {
      pontos[k] = float(split(lines[i],' '));
      i++;
    }
    //getting lados
    int[][] lados = new int[PLF_lens[1]][2];
    for(int k = 0; k< PLF_lens[1]; k++) {
      lados[k] = int(split(lines[i],' '));
      lados[k][0] -= 1;
      lados[k][1] -= 1;
      i++;
    }
    //geting faces
    int[] faces_qts_pontos = new int[PLF_lens[2]];
    int[][] faces_pontos = new int[PLF_lens[2]][];
    Cor[] faces_cores = new Cor[PLF_lens[2]];
    for(int k = 0; k< PLF_lens[2]; k++) {
      String[] face_ = split(lines[i],' ');
      int num_pontos = int(face_[0]);
      faces_qts_pontos[k] = num_pontos;
      faces_pontos[k] = new int[num_pontos];
      int l;
      for (l = 1; l<=num_pontos; l++) {
        faces_pontos[k][l-1] = int(face_[l])-1;
      }
      faces_cores[k] = new Cor(int(255*float(face_[l])), int(255*float(face_[l+1])), int(255*float(face_[l+2])));
      i++;
    }
    //geting transforms
    float[] rotation = float(split(lines[i],' '));
    i++;
    float[] scale = float(split(lines[i],' '));
    i++;
    float[] position = float(split(lines[i],' '));
    i++;
    rets[j] = new Poligono(pontos, lados, faces_qts_pontos, faces_pontos, faces_cores, new Vector3(position), new Vector3(rotation), new Vector3(scale), 1, dim_universo);
  }
  return rets;
}
