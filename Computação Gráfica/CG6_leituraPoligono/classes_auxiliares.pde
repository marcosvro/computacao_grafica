
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
  
  Vector3 (float[] vec) {
    this.x = vec[0];
    this.y = vec[1];
    this.z = vec[2];
  }
  
  Vector3 () {
    this.x = this.y = this.z= 0;
  }

}
