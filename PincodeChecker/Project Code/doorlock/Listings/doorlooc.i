
#line 1 "doorlooc.c" /0
 
 #pragma src
  
#line 1 "C:\Keil_v5\C51\Inc\reg51.h" /0






 
 
 
 
 
 
 sfr P0   = 0x80;
 sfr P1   = 0x90;
 sfr P2   = 0xA0;
 sfr P3   = 0xB0;
 sfr PSW  = 0xD0;
 sfr ACC  = 0xE0;
 sfr B    = 0xF0;
 sfr SP   = 0x81;
 sfr DPL  = 0x82;
 sfr DPH  = 0x83;
 sfr PCON = 0x87;
 sfr TCON = 0x88;
 sfr TMOD = 0x89;
 sfr TL0  = 0x8A;
 sfr TL1  = 0x8B;
 sfr TH0  = 0x8C;
 sfr TH1  = 0x8D;
 sfr IE   = 0xA8;
 sfr IP   = 0xB8;
 sfr SCON = 0x98;
 sfr SBUF = 0x99;
 
 
 
 
 sbit CY   = 0xD7;
 sbit AC   = 0xD6;
 sbit F0   = 0xD5;
 sbit RS1  = 0xD4;
 sbit RS0  = 0xD3;
 sbit OV   = 0xD2;
 sbit P    = 0xD0;
 
 
 sbit TF1  = 0x8F;
 sbit TR1  = 0x8E;
 sbit TF0  = 0x8D;
 sbit TR0  = 0x8C;
 sbit IE1  = 0x8B;
 sbit IT1  = 0x8A;
 sbit IE0  = 0x89;
 sbit IT0  = 0x88;
 
 
 sbit EA   = 0xAF;
 sbit ES   = 0xAC;
 sbit ET1  = 0xAB;
 sbit EX1  = 0xAA;
 sbit ET0  = 0xA9;
 sbit EX0  = 0xA8;
 
 
 sbit PS   = 0xBC;
 sbit PT1  = 0xBB;
 sbit PX1  = 0xBA;
 sbit PT0  = 0xB9;
 sbit PX0  = 0xB8;
 
 
 sbit RD   = 0xB7;
 sbit WR   = 0xB6;
 sbit T1   = 0xB5;
 sbit T0   = 0xB4;
 sbit INT1 = 0xB3;
 sbit INT0 = 0xB2;
 sbit TXD  = 0xB1;
 sbit RXD  = 0xB0;
 
 
 sbit SM0  = 0x9F;
 sbit SM1  = 0x9E;
 sbit SM2  = 0x9D;
 sbit REN  = 0x9C;
 sbit TB8  = 0x9B;
 sbit RB8  = 0x9A;
 sbit TI   = 0x99;
 sbit RI   = 0x98;
 
 
#line 3 "doorlooc.c" /0
 
 
 
 
 sbit keyrow1 = P2 ^ 0;
 sbit keyrow2 = P2 ^ 1;
 sbit keyrow3 = P2 ^ 2;
 sbit keyrow4 = P2 ^ 3;
 
 sbit keycolumn1 = P3 ^ 0;
 sbit keycolumn2 = P3 ^ 1;
 sbit keycolumn3 = P3 ^ 2;
 
 
 sbit motorpin1 = P3 ^ 3;
 sbit motorpin2 = P3 ^ 4;
 
 
 sbit rs = P3 ^ 5;
 sbit rw = P3 ^ 6;
 sbit en = P3 ^ 7;
 
 
 void lcdcmd(unsigned char);
 void lcddat(unsigned char);
 void lcddisplay(unsigned char *q);
 char keypad();
 void check();
 void delay(unsigned int);
 unsigned char pin[] = {"12345"};
 unsigned char Epin[5];
 
 
 void main()
 {
 lcdcmd(0x0F);  
 lcdcmd(0x38);  
 lcdcmd(0x01);  
 
 while (1)
 {
 unsigned int i = 0;
 lcdcmd(0x80);  
 lcddisplay("ENTER PIN NUMBER");
 delay(1000);
 lcdcmd(0xc0);  
 while (pin[i] != '\0')
 {
 Epin[i] = keypad();
 delay(1000);
 i++;
 }
 check();
 }
 }
 
 
 void delay(unsigned int j)
 {
 int a, b;
 for (a = 0; a < j; a++)
 {
 for (b = 0; b < 10; b++)
 ;
 }
 }
 
 
 void lcdcmd(unsigned char A)
 {
 P1 = A;
 rs = 0;
 rw = 0;
 en = 1;
 delay(1000);
 en = 0;
 }
 
 
 
 void lcddat(unsigned char i)
 {
 P1 = i;
 rs = 1;
 rw = 0;
 en = 1;
 delay(1000);
 en = 0;
 }
 
 
 
 void lcddisplay(unsigned char *q)
 {
 int k;
 for (k = 0; q[k] != '\0'; k++)
 {
 lcddat(q[k]);
 }
 delay(10000);
 }
 
 
 
 char keypad()
 {
 int x = 0;
 while (x == 0)
 {
 
 keyrow1 = 0;
 keyrow2 = 1;
 keyrow3 = 1;
 keyrow4 = 1;
 if (keycolumn1 == 0)
 {
 lcddat('*');
 delay(1000);
 x = 1;
 return '1';
 }
 if (keycolumn2 == 0)
 {
 lcddat('*');
 delay(1000);
 x = 1;
 return '2';
 }
 if (keycolumn3 == 0)
 {
 lcddat('*');
 delay(1000);
 x = 1;
 return '3';
 }
 
 keyrow1 = 1;
 keyrow2 = 0;
 keyrow3 = 1;
 keyrow4 = 1;
 
 if (keycolumn1 == 0)
 {
 lcddat('*');
 delay(1000);
 x = 1;
 return '4';
 }
 if (keycolumn2 == 0)
 {
 lcddat('*');
 delay(1000);
 x = 1;
 return '5';
 }
 if (keycolumn3 == 0)
 {
 lcddat('*');
 delay(1000);
 x = 1;
 return '6';
 }
 
 
 keyrow1 = 1;
 keyrow2 = 1;
 keyrow3 = 0;
 keyrow4 = 1;
 if (keycolumn1 == 0)
 {
 lcddat('*');
 delay(1000);
 x = 1;
 return '7';
 }
 if (keycolumn2 == 0)
 {
 lcddat('*');
 delay(1000);
 x = 1;
 return '8';
 }
 if (keycolumn3 == 0)
 {
 lcddat('*');
 delay(1000);
 x = 1;
 return '9';
 }
 
 
 keyrow1 = 1;
 keyrow2 = 1;
 keyrow3 = 1;
 keyrow4 = 0;
 
 if (keycolumn1 == 0)
 {
 lcddat('*');
 delay(1000);
 x = 1;
 return '*';
 }
 if (keycolumn2 == 0)
 {
 lcddat('*');
 delay(1000);
 x = 1;
 return '0';
 }
 if (keycolumn3 == 0)
 {
 lcddat('*');
 delay(1000);
 x = 1;
 return '#';
 }
 }
 return '#';
 }
 
 
 
 void check()
 {
 
 if (pin[0] == Epin[0] && pin[1] == Epin[1] && pin[2] == Epin[2] && pin[3] == Epin[3] && pin[4] == Epin[4])
 {
 delay(1000);
 lcdcmd(0x01);  
 lcdcmd(0x81);  
 
 lcddisplay("PIN CORRECT");
 delay(1000);
 
 motorpin1 = 1;
 motorpin2 = 0;
 lcdcmd(0xc1);  
 
 lcddisplay("DOOR OPENED");
 delay(10000);
 motorpin1 = 1;
 motorpin2 = 0;
 lcdcmd(0x01);  
 }
 else
 {
 lcdcmd(0x01);  
 lcdcmd(0x80);  
 lcddisplay("WRONG PIN");
 delay(1000);
 lcdcmd(0x01);  
 }
 }
 
 
