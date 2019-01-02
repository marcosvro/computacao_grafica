int wid = 1280, hei = 720;
int x = wid/2;
int y = hei/2;
int velocidade = 5;

int reset = 0;

void setup () {
  size(1280,720);
  background(255);
}

void draw() {
  if (reset == 0){
    fill(0);
    rect(x,y,8,8);
  } else {
    fill(255);
    rect(0,0,wid,hei);
    reset = 0;
  }
}


void keyPressed() {
 switch(key) {
   case 'x':
     y += velocidade;
     break;
   case 'w':
     y -= velocidade;
     break;
   case 'd':
     x += velocidade;
     break;
   case 'a':
     x -= velocidade;
     break;
   case 'X':
     y += velocidade;
     break;
   case 'W':
     y -= velocidade;
     break;
   case 'D':
     x += velocidade;
     break;
   case 'A':
     x -= velocidade;
     break;
   case '2':
     y += velocidade;
     break;
   case '8':
     y -= velocidade;
     break;
   case '6':
     x += velocidade;
     break;
   case '4':
     x -= velocidade;
     break;
   case 's':
     reset = 1;
     break;
   case 'S':
     reset = 1;
     break;
   case '5':
     reset = 1;
     break;
   case ESC:
     exit();
     break;
 }
}
