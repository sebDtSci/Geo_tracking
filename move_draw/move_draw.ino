#include <Arduino_LSM9DS1.h>

void setup() {
  Serial.begin(9600);
  if (!IMU.begin()){
    Serial.println("Failed to initialize IMU");
    while(1);
  }
}

void loop() {
  float x, y, z;
  if (IMU.accelerationAvailable()){
    IMU.readAcceleration(x,y,z);
    Serial.print(x); Serial.print(",");
    Serial.print(y); Serial.print(",");
    Serial.println(z);
  }
  delay(10);
}