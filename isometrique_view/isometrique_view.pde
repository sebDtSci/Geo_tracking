import processing.serial.*;
float[] position = {0, 0, 0}; // Position actuelle dans l'espace
ArrayList<float[]> trajectory = new ArrayList<float[]>(); // Stocker les points 3D
Serial myPort;

void setup() {
  size(800, 800, P3D); // Fenêtre 3D

  // Configuration de la communication série
  String portName = "/dev/cu.usbmodem1101";
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
}

void draw() {
  background(0);
  lights(); // Activer l'éclairage pour la 3D

  // Configurer la vue isométrique
  translate(width / 2.0, height / 2.0, 0); // Centrer la scène
  rotateX(PI / 6); // Inclinaison de 30° sur X
  rotateY(-PI / 4); // Inclinaison de 45° sur Y

  // Dessiner une grille pour référence
  stroke(50);
  for (int i = -400; i <= 400; i += 50) {
    line(i, -400, 0, i, 400, 0); // Lignes verticales
    line(-400, i, 0, 400, i, 0); // Lignes horizontales
  }

  // Synchroniser l'accès à la liste pour éviter des conflits
  synchronized (trajectory) {
    stroke(255);
    noFill();
    beginShape();
    for (float[] p : trajectory) {
      vertex(p[0], p[1], p[2]); // Points de la trajectoire
    }
    endShape();
  }

  // Dessiner la position actuelle
  fill(255, 0, 0);
  noStroke();
  pushMatrix();
  translate(position[0], position[1], position[2]);
  sphere(5); // Dessiner une sphère pour représenter la position actuelle
  popMatrix();
}

void serialEvent(Serial myPort) {
  String data = myPort.readStringUntil('\n');
  if (data != null) {
    data = trim(data); // Nettoyer les données reçues
    String[] values = split(data, ',');
    if (values.length == 3) {
      try {
        // Lire les données reçues
        float x = Float.parseFloat(values[0]) * 100; // Ajuster l'échelle
        float y = Float.parseFloat(values[1]) * 100;
        float z = Float.parseFloat(values[2]) * 100;

        // Mettre à jour la position actuelle
        position[0] += x * 0.01; // Ajuster selon le temps
        position[1] += y * 0.01;
        position[2] += z * 0.01;

        // Synchroniser l'accès à la liste lors de l'ajout
        synchronized (trajectory) {
          trajectory.add(new float[] {position[0], position[1], position[2]});
          if (trajectory.size() > 1000) {
            trajectory.remove(0); // Limiter la taille pour éviter les ralentissements
          }
        }
      } catch (NumberFormatException e) {
        println("Erreur de conversion : " + data);
      }
    }
  }
}
