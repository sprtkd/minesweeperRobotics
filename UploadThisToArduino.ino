//Mohit's and vivek's and Suprotik's bot has 5,6 & 10,11 motor input l293d ic h-bridge
int leftmotfwd = 5;
int leftmotrvs = 6;
int rightmotfwd = 11;
int rightmotrvs = 10;
char state;
int low = 0;
int high = 255;
int del = 100;
int del_low = 50;
int flag=0;
//sound output declarations
/*to define the notes for speaker sound*/
#define NOTE_B0  31
#define NOTE_C1  33
#define NOTE_CS1 35
#define NOTE_D1  37
#define NOTE_DS1 39
#define NOTE_E1  41
#define NOTE_F1  44
#define NOTE_FS1 46
#define NOTE_G1  49
#define NOTE_GS1 52
#define NOTE_A1  55
#define NOTE_AS1 58
#define NOTE_B1  62
#define NOTE_C2  65
#define NOTE_CS2 69
#define NOTE_D2  73
#define NOTE_DS2 78
#define NOTE_E2  82
#define NOTE_F2  87
#define NOTE_FS2 93
#define NOTE_G2  98
#define NOTE_GS2 104
#define NOTE_A2  110
#define NOTE_AS2 117
#define NOTE_B2  123
#define NOTE_C3  131
#define NOTE_CS3 139
#define NOTE_D3  147
#define NOTE_DS3 156
#define NOTE_E3  165
#define NOTE_F3  175
#define NOTE_FS3 185
#define NOTE_G3  196
#define NOTE_GS3 208
#define NOTE_A3  220
#define NOTE_AS3 233
#define NOTE_B3  247
#define NOTE_C4  262
#define NOTE_CS4 277
#define NOTE_D4  294
#define NOTE_DS4 311
#define NOTE_E4  330
#define NOTE_F4  349
#define NOTE_FS4 370
#define NOTE_G4  392
#define NOTE_GS4 415
#define NOTE_A4  440
#define NOTE_AS4 466
#define NOTE_B4  494
#define NOTE_C5  523
#define NOTE_CS5 554
#define NOTE_D5  587
#define NOTE_DS5 622
#define NOTE_E5  659
#define NOTE_F5  698
#define NOTE_FS5 740
#define NOTE_G5  784
#define NOTE_GS5 831
#define NOTE_A5  880
#define NOTE_AS5 932
#define NOTE_B5  988
#define NOTE_C6  1047
#define NOTE_CS6 1109
#define NOTE_D6  1175
#define NOTE_DS6 1245
#define NOTE_E6  1319
#define NOTE_F6  1397
#define NOTE_FS6 1480
#define NOTE_G6  1568
#define NOTE_GS6 1661
#define NOTE_A6  1760
#define NOTE_AS6 1865
#define NOTE_B6  1976
#define NOTE_C7  2093
#define NOTE_CS7 2217
#define NOTE_D7  2349
#define NOTE_DS7 2489
#define NOTE_E7  2637
#define NOTE_F7  2794
#define NOTE_FS7 2960
#define NOTE_G7  3136
#define NOTE_GS7 3322
#define NOTE_A7  3520
#define NOTE_AS7 3729
#define NOTE_B7  3951
#define NOTE_C8  4186
#define NOTE_CS8 4435
#define NOTE_D8  4699
#define NOTE_DS8 4978
/*to define the notes for speaker sound*/


// notes in the melody:
int melody[] = {
  NOTE_C4, NOTE_G3, NOTE_G3, NOTE_A3, NOTE_G3, 0, NOTE_B3, NOTE_C4
};

// note durations: 4 = quarter note, 8 = eighth note, etc.:
int noteDurations[] = {
  4, 8, 8, 4, 4, 4, 4, 4
};
//sound output declarations
int thresh = 150;

void setup() {
  Serial.begin(9600);
 pinMode(leftmotfwd,OUTPUT); 
  pinMode(leftmotrvs,OUTPUT);
   pinMode(rightmotfwd,OUTPUT); 
    pinMode(rightmotrvs,OUTPUT); 
    pinMode(13,OUTPUT);
}

void loop() {
  digitalWrite(13,LOW);
 analogWrite(leftmotfwd,low);
 analogWrite(rightmotfwd,low);
 analogWrite(leftmotrvs,low);
 analogWrite(rightmotrvs,low); 
  while(Serial.available() == 0);
 state = Serial.read();
  digitalWrite(13,HIGH);
  flag=0;
 
 if((state == 'f')||(state == 'F'))//forward
 {analogWrite(leftmotfwd,high);
 analogWrite(rightmotfwd,high);
 delay(del);
 analogWrite(leftmotfwd,low);
 analogWrite(rightmotfwd,low);
 }
 else if((state == 'b')||(state == 'B'))//reverse
 {analogWrite(leftmotrvs,high);
 analogWrite(rightmotrvs,high);
 delay(del);
 analogWrite(leftmotrvs,low);
 analogWrite(rightmotrvs,low);
 }
else if((state == 'l')||(state == 'L'))//turn left
 {analogWrite(leftmotrvs,high);
 analogWrite(rightmotfwd,high);
 delay(del_low);
 analogWrite(leftmotrvs,low);
 analogWrite(rightmotfwd,low);
 }
else if((state == 'r')||(state == 'R'))//turn right
 {analogWrite(leftmotfwd,high);
 analogWrite(rightmotrvs,high);
 delay(del_low);
 analogWrite(leftmotfwd,low);
 analogWrite(rightmotrvs,low);
 }
 else if((state == 'm')||(state == 'M'))//checking connection
 {delay(0.5);
 Serial.print('y');
 }
  else if((state == 's')||(state == 'S'))//checking connection
 {
   for (int thisNote = 0; thisNote < 8; thisNote++) 
                          {

                          // to calculate the note duration, take one second
                          // divided by the note type.
                          //e.g. quarter note = 1000 / 4, eighth note = 1000/8, etc.
                           int noteDuration = 1000 / noteDurations[thisNote];
                            tone(8, melody[thisNote], noteDuration);

                           // to distinguish the notes, set a minimum time between them.
                          // the note's duration + 30% seems to work well:
                         int pauseBetweenNotes = noteDuration * 1.30;
                          delay(pauseBetweenNotes);
                          // stop the tone playing:
                          noTone(8);
                          }
                           for (int thisNote = 0; thisNote < 8; thisNote++) 
                          {

                          // to calculate the note duration, take one second
                          // divided by the note type.
                          //e.g. quarter note = 1000 / 4, eighth note = 1000/8, etc.
                           int noteDuration = 1000 / noteDurations[thisNote];
                            tone(8, melody[thisNote], noteDuration);

                           // to distinguish the notes, set a minimum time between them.
                          // the note's duration + 30% seems to work well:
                         int pauseBetweenNotes = noteDuration * 1.30;
                          delay(pauseBetweenNotes);
                          // stop the tone playing:
                          noTone(8);
                          }
 }
 else if((state == 'c')||(state == 'C'))//check for ir transmitters
          {int presentflag;
          presentflag=1;
        for(int i;i<=1000;i++)
        
            {
              if(flag==1)
                break;
            
              // read the input on analog pin 0:
                int sensorValue1 = analogRead(A0);
             // read the input on analog pin 1:
                int sensorValue2 = analogRead(A1);
             // read the input on analog pin 2:
                int sensorValue3 = analogRead(A2);
            //checking
                    if((sensorValue1>=thresh)||(sensorValue2>=thresh)||(sensorValue3>=thresh))
                     {
                          flag=1;
                          Serial.print('y'); 
  
                          for (int thisNote = 0; thisNote < 8; thisNote++) 
                          {

                          // to calculate the note duration, take one second
                          // divided by the note type.
                          //e.g. quarter note = 1000 / 4, eighth note = 1000/8, etc.
                           int noteDuration = 1000 / noteDurations[thisNote];
                            tone(8, melody[thisNote], noteDuration);

                           // to distinguish the notes, set a minimum time between them.
                          // the note's duration + 30% seems to work well:
                         int pauseBetweenNotes = noteDuration * 1.30;
                          delay(pauseBetweenNotes);
                          // stop the tone playing:
                          noTone(8);
                          }
                  
                  }
                  else
                  {

 presentflag=0;
                  
                }
               
              }
if(presentflag==0)
      Serial.print('n');
 }
}
  


