#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>

#define enA_left 7
#define enB_right 2
#define in1_left 6
#define in2_left 5
#define in3_right 4
#define in4_right 3

RF24 radio(10,9);  // CE, CSN
const byte address[6] = "00001";

void setup() {
  Serial.begin(9600);
  radio.begin(); 
  radio.openReadingPipe(0, address);
  radio.setAutoAck(false);
  radio.setPALevel(RF24_PA_MAX);
  radio.startListening();
  Serial.println("[[[[[[[[[[[[[[[[[[[[[[[[[[[");

  pinMode(enA_left, OUTPUT);
  pinMode(enB_right, OUTPUT);
  pinMode(in1_left, OUTPUT);
  pinMode(in2_left, OUTPUT);
  pinMode(in3_right, OUTPUT);
  pinMode(in4_right, OUTPUT);

  // Set initial rotation direction
  digitalWrite(in1_left, LOW);
  digitalWrite(in2_left, LOW);
  digitalWrite(in3_right, LOW);
  digitalWrite(in4_right, LOW);
}

void loop() {
  
 if (radio.available()) {
    char text[32] ="";
    Serial.println("starttttt");
    radio.read(&text, sizeof(text));
    Serial.println("textreceived : ");
    Serial.println(text);
    //delay(1000);
    if(strcmp(text, "go back") == 0){
      Serial.println(text);
       analogWrite(enB_right,155);
       digitalWrite(in1_left, LOW);
      digitalWrite(in2_left, HIGH);
      analogWrite(enA_left,255);
      digitalWrite(in3_right, LOW);
      digitalWrite(in4_right, HIGH);
      analogWrite(enB_right,255); 
   }
     if(strcmp(text, "go foraward") == 0){
       Serial.println(text);
       digitalWrite(in1_left, HIGH);
      digitalWrite(in2_left, LOW);
      analogWrite(enA_left,155);
      digitalWrite(in3_right, HIGH);
      digitalWrite(in4_right, LOW);
      
      
      
    }
 
     if(strcmp(text, "go right") == 0){
       Serial.println(text);
       digitalWrite(in1_left, HIGH);
      digitalWrite(in2_left, LOW);
      analogWrite(enA_left,155);
      digitalWrite(in3_right, LOW);
      digitalWrite(in4_right, LOW);
      analogWrite(enB_right,155);
    }
     if(strcmp(text, "go left") == 0){
     

      Serial.println(text);
      digitalWrite(in1_left, LOW);
      digitalWrite(in2_left, LOW);
      analogWrite(enA_left,155);
      digitalWrite(in3_right, HIGH);
      digitalWrite(in4_right, LOW);
      
    }
     if (strcmp(text, "stop") == 0) {
      digitalWrite(in1_left, LOW);
  digitalWrite(in2_left, LOW);
  analogWrite(enA_left,155);
  digitalWrite(in3_right, LOW);
  digitalWrite(in4_right, LOW);
  analogWrite(enB_right,155);
    }
   

   
  }
else{
  Serial.println("jyfyl");
}
}
