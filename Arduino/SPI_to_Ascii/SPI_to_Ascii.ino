//ESSA Seral

#include <SPI.h> 

// MOSI = 11
// MISO = 1222
//SCK = 13
// SS = A5

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  while ( !Serial ) delay(10);   // for nrf52840 with native usb
  Serial.println("Echo Test");
  pinMode(A5, OUTPUT);
  digitalWrite(A5, HIGH);
  SPI.begin();
}

void loop() {
  // put your main code here, to run repeatedly:
  int serialInput = 5;
//  SPIWrite(serialInput);
//  delay(500);
  
  if(Serial.available())
  {
    serialInput = Serial.read();
    Serial.print("Writing - 0x");
//    Serial.println(serialInput);
//    Serial.write(serialInput);
    Serial.println(serialInput,HEX);
    SPIWrite(serialInput);
  }
}

void SPIWrite(byte value)
{
  digitalWrite(A5, LOW);
  SPI.beginTransaction(SPISettings(2000000, MSBFIRST, SPI_MODE0));
  SPI.transfer(value);
  digitalWrite(A5, HIGH);
  SPI.endTransaction();
}
