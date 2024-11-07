import processing.serial.*;

Serial myPort;
float x, y, z;

void setup() {
  size(800, 800);
  String portName = "/dev/cu.usbmodem2101";
  println(Serial.list());
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
}

void draw() {
  background(255);
  // Trace la forme en utilisant x, y, z
  ellipse(width/2 + x * 100, height/2 + y * 100, 10, 10);
}

void serialEvent(Serial myPort) {
  String inData = myPort.readStringUntil('\n');
  println("Received data: " + inData); // pour vérifier
  if (inData != null) {
    String[] values = split(inData, ',');
    if (values.length == 3) {
      x = float(values[0]);
      y = float(values[1]);
      z = float(values[2]);
    }
  }
}
