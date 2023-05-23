

////////////////////////////////////////////////////////////////////
//master

#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>

//#include <AFMotor.h>
// #define x 17
// #define y 18
#define left 15
#define right 16

int var = 1;

#define enA_left 7
#define enB_right 2
#define in1_left 6
#define in2_left 5
#define in3_right 4
#define in4_right 3

RF24 radio(10,9); // CE, CSN

const byte address[6] = "00001";
//const byte addresss[6] = "00011";

void setup() {
  pinMode(left, INPUT);
  pinMode(right, INPUT);

  Serial.begin(9600);
  radio.begin();
  radio.openWritingPipe(address);
  //radio.openWritingPipe(addresss);
  radio.setAutoAck(false);
  radio.setPALevel(RF24_PA_MAX);
  radio.stopListening();

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
  // int X = analogRead(x);
  // int Y = analogRead(y);
  int laneleft = digitalRead(left);
  int laneright = digitalRead(right);
  Serial.println("////////////////////////////////");
  //  Serial.println(X);
  //   Serial.println(Y);
    
  if(laneleft == 0 &&  laneright == 0 ){
    // X >= 800
 const char text[] = "go foraward";
  Serial.println("forward");
 if(radio.write(&text, sizeof(text))){
   Serial.println(text);
 }
 else{
   Serial.println("not sent");
 }
   digitalWrite(in1_left, LOW);
  digitalWrite(in2_left, HIGH);
  analogWrite(enA_left,155);
  digitalWrite(in3_right, LOW);
  digitalWrite(in4_right, HIGH);
  analogWrite(enB_right,155);


  
  
  }
  // else if(//X <= 200){

  // const char text[] = "go back";
  // Serial.println("back");
  // radio.write(&text, sizeof(text));
  // digitalWrite(in1_left, HIGH);
  // digitalWrite(in2_left, LOW);
  // analogWrite(enA_left,155);
  // digitalWrite(in3_right, HIGH);
  // digitalWrite(in4_right, LOW);
  // analogWrite(enB_right,155);
  
  // }
  else if(laneleft == 0 &&  laneright == 1){
//Y >= 800
  const char text[] = "go right";
  Serial.println("right");
  radio.write(&text, sizeof(text));

  digitalWrite(in1_left, LOW);
  digitalWrite(in2_left, LOW);
  analogWrite(enA_left,155);
  digitalWrite(in3_right, LOW);
  digitalWrite(in4_right, HIGH);
  analogWrite(enB_right,155);
  }
  else if(laneleft == 1 &&  laneright == 0){
//Y <= 200
  const char text[] = "go left";
  Serial.println("left");
  radio.write(&text, sizeof(text));
digitalWrite(in1_left, LOW);
  digitalWrite(in2_left, HIGH);
  analogWrite(enA_left,155);
  digitalWrite(in3_right, LOW);
  digitalWrite(in4_right, LOW);
  analogWrite(enB_right,155);
  
  } else if(laneleft == 1 &&  laneright == 1) {

   const char text[] = "stop";
  Serial.println("stop");
  if(radio.write(&text, sizeof(text))){
    Serial.println(text);
  }
     
  digitalWrite(in1_left, LOW);
  digitalWrite(in2_left, LOW);
  analogWrite(enA_left,0);
  digitalWrite(in3_right, LOW);
  digitalWrite(in4_right, LOW);
  analogWrite(enA_left,0);
  }
}





