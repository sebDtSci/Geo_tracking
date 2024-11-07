import processing.serial.*;
import peasy.*; // Pour faciliter la rotation 3D

Serial myPort; // Communication série
PeasyCam cam; // Caméra interactive pour visualisation 3D
float[] position = {0, 0, 0}; // Position actuelle dans l'espace
ArrayList<float[]> trajectory = new ArrayList<float[]>(); // Stocker les points 3D

void setup() {
  size(800, 800, P3D); // Fenêtre 3D
  cam = new PeasyCam(this, 500); // Initialiser la caméra
  //String portName = Serial.list()[0]; // Modifier l'index si nécessaire
  String portName = "/dev/cu.usbmodem1101";
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n'); // Attendre une ligne complète
}

void draw() {
  background(0);
  lights();

  synchronized (trajectory) {
    stroke(255);
    noFill();

    beginShape();
    for (float[] p : trajectory) {
      vertex(p[0], p[1], p[2]);
    }
    endShape();
  }

  fill(255, 0, 0);
  noStroke();
  pushMatrix();
  translate(position[0], position[1], position[2]);
  sphere(5);
  popMatrix();
}

// void draw() {
//   background(0);
//   lights();

//   ArrayList<float[]> trajectoryCopy = new ArrayList<float[]>(trajectory); // Créer une copie de la liste

//   stroke(255);
//   noFill();

//   // Dessiner les trajectoires en utilisant la copie
//   beginShape();
//   for (float[] p : trajectoryCopy) {
//     vertex(p[0], p[1], p[2]);
//   }
//   endShape();

//   // Dessiner la position actuelle
//   fill(255, 0, 0);
//   noStroke();
//   pushMatrix();
//   translate(position[0], position[1], position[2]);
//   sphere(5);
//   popMatrix();
// }

void serialEvent(Serial myPort) {
  String data = myPort.readStringUntil('\n');
  if (data != null) {
    data = trim(data);
    String[] values = split(data, ',');
    if (values.length == 3) {
      try {
        float x = Float.parseFloat(values[0]) * 100;
        float y = Float.parseFloat(values[1]) * 100;
        float z = Float.parseFloat(values[2]) * 100;

        position[0] += x * 0.01;
        position[1] += y * 0.01;
        position[2] += z * 0.01;

        synchronized (trajectory) {
          trajectory.add(new float[] {position[0], position[1], position[2]});
          if (trajectory.size() > 1000) {
            trajectory.remove(0);
          }
        }
      } catch (NumberFormatException e) {
        println("Erreur de conversion : " + data);
      }
    }
  }
}
// void draw() {
//   background(0);
//   lights(); // Activer l'éclairage

//   stroke(255);
//   noFill();

//   // Dessiner les trajectoires 3D
//   beginShape();
//   for (float[] p : trajectory) {
//     vertex(p[0], p[1], p[2]);
//   }
//   endShape();

//   // Dessiner la position actuelle
//   fill(255, 0, 0);
//   noStroke();
//   pushMatrix();
//   translate(position[0], position[1], position[2]);
//   sphere(5); // Dessiner une sphère pour représenter la position actuelle
//   popMatrix();
// }

// void serialEvent(Serial myPort) {
//   String data = myPort.readStringUntil('\n');
//   if (data != null) {
//     data = trim(data); // Nettoyer les données reçues
//     String[] values = split(data, ',');
//     if (values.length == 3) {
//       try {
//         // Lire les données reçues et convertir en coordonnées
//         float x = Float.parseFloat(values[0]) * 100; // Ajuster l'échelle
//         float y = Float.parseFloat(values[1]) * 100;
//         float z = Float.parseFloat(values[2]) * 100;

//         // Calculer la position actuelle
//         position[0] += x * 0.01; // Ajuster selon le temps
//         position[1] += y * 0.01;
//         position[2] += z * 0.01;

//         // Ajouter à la trajectoire
//         trajectory.add(new float[] {position[0], position[1], position[2]});

//         // Limiter la taille de la trajectoire pour éviter les ralentissements
//         if (trajectory.size() > 1000) {
//           trajectory.remove(0);
//         }
//       } catch (NumberFormatException e) {
//         println("Erreur de conversion : " + data);
//       }
//     }
//   }
// }
