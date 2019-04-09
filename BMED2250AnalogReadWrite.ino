#include <SD.h>

const int SAMPLE_RATE = 1000;
const int RECORD_TIME = 5;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  while (!Serial) {}
  
  Serial.println("Initializing SD card...");
  
  SD.begin(10);
  File myFile = SD.open("data.txt", FILE_WRITE);
  
  if (!myFile) {
    Serial.println("Error opening data.txt");
    return;
  }

  Serial.println("Writing to data.txt");

  unsigned long next_sample_time = micros() + 1000000 / SAMPLE_RATE;

  for (int i = 0; i < RECORD_TIME * SAMPLE_RATE; i = i + 1) {
    unsigned long curr_time = micros();
    while (curr_time < next_sample_time) {
      curr_time = micros();
    }
//    Serial.println(analogRead(A0));
    myFile.println(analogRead(A0));
//    myFile.println(curr_time);
    next_sample_time += 1000000 / SAMPLE_RATE;
  }
  
  myFile.close();

  Serial.println("Done!");
}

void loop() {}
