clc;
clear;
close all;

a = arduino('Com3','UNO','Libraries',{'ExampleLCD/LCDAddon','Servo'}); %arduino argument and involve libraries
Spots = 13; % available parking spaces 
Entry_pin = 'A0'; % push button for entry
Exit_pin = 'A1'; % push button for exit
LED_Green = 'D13'; % Green signal for enter or exit
LED_Red = 'D12'; % Red signal for restriction
servo_pin = 'D9'; % servo motor control logic pin
Servo_close = 0; % servo motor position at rest
Servo_open = 0.50; %  servo motor position at open gate condition
Servo_Position = servo(a, servo_pin); 
writePosition(Servo_Position, Servo_close); %default close position
lcd=addon(a,'ExampleLCD/LCDAddon','RegisterSelectPin','D7','EnablePin','D6','DataPins',{'D5','D4','D3','D2'}); %lcd declaration 
initializeLCD(lcd); %start LCD Display 
writeDigitalPin (a, LED_Red,1); %default red light on for restrict the vehicle

 printLCD(lcd,'Welcome!!!'); %Greetings

 pause(1); %pause the dispay message for given amount of time
 clearLCD(lcd); %Clear the lcd screen
 
 printLCD(lcd,'Bonjour!!!'); 

 pause(1);
 clearLCD(lcd); 
 
 %Group members Information & IDs
 printLCD(lcd,'1) Gururaja S R');
 
 pause(1); 
 clearLCD(lcd);
 
 
% set up the pin position and assign the modes

configurePin (a, Entry_pin, 'Pullup'); 
configurePin (a, Exit_pin, 'Pullup');
configurePin (a, LED_Green, 'DigitalOutput');
configurePin (a, LED_Red, 'DigitalOutput');

 while 1 % creating a loop (1 means the true condition)

     Enter = readDigitalPin (a, Entry_pin); %read the enter digital pin and position
     Exit = readDigitalPin (a, Exit_pin); %read the exit digital pin and position

     if (Spots > 0) % IF block for run message on lcd with variable spots
        
        clearLCD(lcd);

        printLCD(lcd,['Available : ',num2str(Spots)]); % will show the available parking slots
        printLCD(lcd,'Welcome!!!'); 


     elseif (Spots == 0)

        clearLCD(lcd);

        printLCD(lcd,'NoSlot available') % no space between no and slot because for 16 digit limit
        printLCD(lcd,'Plz Come Later'); 

     end

     % (output 0 means wire is connected and 1 means its not connected)
     % when press the push button it complete the circuit the Enters value
     % change from 1 to 0 and While loop is executed with AND logic
     if (Enter == 0 && Spots > 0) %Logic for entry 

         writeDigitalPin (a, LED_Red, 0);  % Red LED turn off  (0 = off and 1=on)

         writeDigitalPin (a, LED_Green, 1);  % Green LED turn On

         writePosition (Servo_Position, Servo_open); %Gate is open

         pause(1);

         writePosition (Servo_Position, Servo_close); % Gate is close 

         writeDigitalPin (a, LED_Green, 0);

         writeDigitalPin (a, LED_Red, 1);  

         Spots = Spots - 1; % number of parking space decreases by one


     elseif ((Exit == 0) && (Spots < 13)) %Logic for exit point

         writeDigitalPin(a, LED_Red,0);

         writeDigitalPin(a, LED_Green,1); 

         writePosition(Servo_Position, Servo_open);% Gate is open

         pause(1); 

         writePosition(Servo_Position, Servo_close); 

         writeDigitalPin(a, LED_Green,0);
         
         writeDigitalPin(a, LED_Red,1);

         Spots = Spots + 1; % number of parking space increases by one

     end

 end
