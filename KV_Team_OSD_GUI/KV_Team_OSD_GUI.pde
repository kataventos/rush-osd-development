
//   KV Team OSD GUI
//   http://code.google.com/p/rush-osd-development/
//   July  2013  V_r370
//   This program is free software: you can redistribute it and/or modify
//   it under the terms of the GNU General Public License as published by
//   the Free Software Foundation, either version 3 of the License, or
//   any later version. see http://www.gnu.org/licenses/

              /***********************************************************************************************************************************************/
              /*                                                            KV_OSD_Team_GUI                                                                  */
              /*                                                                                                                                             */
              /*                                                                                                                                             */
              /*                                             This software is the result of a team work                                                      */
              /*                                                                                                                                             */
              /*                           POWER67             KATAVENTOS               ITAIN                    CARLONB                                     */
              /*                                                                                                                                             */
              /*                                                                                                                                             */
              /*                                                                                                                                             */
              /*                                                                                                                                             */
              /*                                                                                                                                             */
              /***********************************************************************************************************************************************/


 



import processing.serial.Serial; // serial library
import controlP5.*; // controlP5 library
import java.io.File;
import java.lang.*; // for efficient String concatemation
import javax.swing.SwingUtilities; // required for swing and EDT
import javax.swing.JFileChooser;// Saving dialogue
import javax.swing.filechooser.FileFilter; // for our configuration file filter "*.mwi"
import javax.swing.JOptionPane; // for message dialogue
//import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream; 
import java.io.FileOutputStream;
import java.io.FileInputStream;
import java.util.*;
import java.io.FileNotFoundException;
import java.text.DecimalFormat;


//added new imports to support proccessing 2.0b7



String KV_OSD_GUI_Version = "2.2";


PImage img_Clear,OSDBackground,RadioPot;

// ScreenType---------- NTSC = 0, PAL = 1 ---------------------------------
int ScreenType = 0;

int TIMEBASE_X1 =  50;
int TIMEBASE = TIMEBASE_X1;
int LINE  =    30;
int LINE01 =   0;
int LINE02  =  30;
int LINE03  =  60;
int LINE04  =  90;
int LINE05  =  120;
int LINE06  =  150;
int LINE07  =  180;
int LINE08  =  210;
int LINE09  =  240;
int LINE10  =  270;
int LINE11  =  300;
int LINE12  =  330;
int LINE13  =  360;
int LINE14  =  390;
int LINE15  =  420;
int LINE16  =  450;
int TestLine = 300;

// TOP OF THE SCREEN
int[] GPS_numSatPosition = {
 LINE02+2,LINE02+2};
int[] GPS_directionToHomePosition=    {
  LINE03+13 ,LINE03+13};

int[] GPS_distanceToHomePosition=  {
  LINE02+22  ,LINE02+24 };
int[] speedPosition = {     
  LINE03+22 ,LINE03+24};  // [0] En Km/h   [1] En Mph
int[] GPS_angleToHomePosition=  {
  LINE04+14 ,LINE04+14};
int[] MwGPSAltPosition =        {
  LINE04+22,LINE04+24};
int[] sensorPosition=           {
  LINE03+2 ,LINE03+2};
int[] MwHeadingPosition =       {
  LINE02+19 ,LINE02+19};
int[] MwHeadingGraphPosition =  {
  LINE02+10 ,LINE02+10};

// MIDDLE OF THE SCREEN
int[] MwAltitudePosition=  {
  LINE07+2,LINE07+2 };
int[] MwClimbRatePosition=  {
  LINE07+27 ,LINE07+28 };
int[] CurrentThrottlePosition = {
  LINE12+23,LINE12+24+60};
int[] flyTimePosition=                {
  LINE13+23,LINE13+24+60};
//int[] onTimePosition=                 {
 // LINE13+23,LINE13+24+60};
int[] motorArmedPosition=            {
  LINE12+11,LINE11+11+60};
int[] MwGPSLatPosition =              {
  LINE10+2,LINE10+2+60};
int[] MwGPSLonPosition =              {
  LINE10+13+2,LINE10+2+13+60};
int[]  rssiPosition = {
  LINE12+2 ,LINE12+2+60};
int[] temperaturePosition= {
  LINE11+2   ,LINE11+2};
int[] voltagePosition =                {
  LINE13+2  ,LINE13+2+60 };
int[] vidvoltagePosition =   {
  LINE11+3  ,LINE11+3+60};
int[] amperagePosition =     {
  LINE13+17,LINE13+19+60};
int[] pMeterSumPosition =       {
  LINE15+30,LINE15+30+60};
  
int DisplayWindowX = 598; //500;
int DisplayWindowY = 40; //5;
int WindowAdjX = -84; //15
int WindowAdjY = -31;
int WindowShrinkX = 8;
int WindowShrinkY = 48;

int currentCol = 0;
int currentRow = 0;  
//Boolean SimulateMW = true;


ControlP5 controlP5;
ControlP5 SmallcontrolP5;
ControlP5 ScontrolP5;
ControlP5 FontGroupcontrolP5;
ControlP5 GroupcontrolP5;
Textlabel txtlblWhichcom; 
ListBox commListbox;

//char serialBuffer[] = new char[128]; // this hold the imcoming string from serial O string
//String TestString = "";
///String SendCommand = "";




boolean PortRead = false;
boolean PortWrite = false;


ControlGroup messageBox;
Textlabel MessageText;




// Int variables
String OSname = System.getProperty("os.name");
String LoadPercent = "";
//String CallSign = "";

int init_com = 0;
int commListMax = 0;
int whichKey = -1;  // Variable to hold keystoke values
int inByte = -1;    // Incoming serial data
int[] serialInArray = new int[3];    // Where we'll put what we receive


int serialCount = 0;                 // A count of how many bytes we receive
int ConfigEEPROM = -1;
int ConfigVALUE = -1;

int windowsX    = 855;       int windowsY    =440;        //995; //573;
int xGraph      = 10;         int yGraph      = 325;
int xObj        = 520;        int yObj        = 293; //900,450
int xCompass    = 920;        int yCompass    = 341; //760,336
int xLevelObj   = 920;        int yLevelObj   = 80; //760,80
int xParam      = 120;        int yParam      = 5;
int xRC         = 690;        int yRC         = 10; //850,10
int xMot        = 690;        int yMot        = 155; //850,155
int xButton     = 845;        int yButton     = 231; //685,222
int xBox        = 415;        int yBox        = 10;
//int xGPS        = 853;        int yGPS        = 438; //693,438
int XSim        = DisplayWindowX+WindowAdjX;        int YSim        = 288-WindowShrinkY + 85;

//DisplayWindowX+WindowAdjX, DisplayWindowY+WindowAdjY, 360-WindowShrinkX, 288-WindowShrinkY);
// Box locations -------------------------------------------------------------------------
int Col1Width = 180;        int Col2Width = 200;  int Col3Width = 360;

int XEEPROM    = 120;        int YEEPROM    = 5;  //hidden do not remove
int XBoard     = 120;        int YBoard   = 5;
int XRSSI      = 120;        int YRSSI    = 45;
int XVolts      = 120;       int YVolts    = 152;
//int XAmps       = 120;       int YAmps    = 281;
int XVVolts    = 305;        int YVVolts  = 152;
int XTemp      = 305;        int YTemp    = 5;
int XGPS       = 305;        int YGPS    = 45;
int XCS      = 120;          int YCS    = 472;

//int XUV = 490;        int XUV   = 5; //48;
int XOther     = 490;        int YOther   = 5; //48;
int XPortStat  = 5;            int YPortStat = 272;
int XControlBox     = 5;        int YControlBox   = 310;  //389
int XRCSim    =   XSim;      int YRCSim = 430;


String FontFileName = "data/MW_OSD_Team.mcm";

//File FontFile;
int activeTab = 1;
int xx=0;
int YLocation = 0;
int Roll = 0;
int Pitch = 0;

int OnTimer = 0;
int FlyTimer = 0;
float SimItem0= 0;
int Armed = 0;
int Showback = 1;
int del = 0;
// int variables

// For Heading
char[] headGraph={
  0x1a,0x1d,0x1c,0x1d,0x19,0x1d,0x1c,0x1d,0x1b,0x1d,0x1c,0x1d,0x18,0x1d,0x1c,0x1d,0x1a,0x1d,0x1c,0x1d,0x19,0x1d,0x1c,0x1d,0x1b};

static int MwHeading=0;
char MwHeadingUnitAdd=0xbd;


String[] ConfigNames = {
  "EEPROM Loaded",
  
  "RSSI Min",
  "RSSI Max",
  "RSSI Alarm",
  "Input Type", //MW ADC
  "PWM",
  
  //"Display Voltage",
  "Voltage Min",
  "Battery Cells",
  "Voltage Devider",
  "Input Type", //MW ADC
  
  //"Display Amperage",
  //"Diplay Amperage Used",
  
  //"Display Video Voltage",
  "Voltage Devider",
  "Input Type", //Mw ADC
  
  //"Display Temperature",
  "Temperature Max",
  
  "", // for Board type do not remove
  
  "GPS",
  "Coords",
  //"Display Coords on Top",
  //"Display GPS Altitude",
  //"Display Angle to Home",
  //"Display Heading",
  "Heading",
  
  "Unit", //unit
  "Video",// signal
  //"Display Throttle Position",
  //"Display Horizon Bar",
  //"Display Horizon Side Bars",
  //"Display Battery Evo",
  "Stats",
  "OSD ADC",
  " ",
  //"Display Flight Mode Icons",
  "Blink Frequency",
  
  //"Horizon_",
  //"Decoration",
  //"RSSI",
  //"VOLTAGE",
  
  "Display CallSign",
  "S_CS0",
  "S_CS1",
  "S_CS2",
  "S_CS3",
  "S_CS4",
  "S_CS5",
  "S_CS6",
  "S_CS7",
  "S_CS8",
  "S_CS9",
};

String[] ConfigHelp = {
  "EEPROM Loaded",
  
  "RSSI Min",
  "RSSI Max",
  "RSSI Alarm",
  "RSSI",
  "PWM RSSI",
  
  "Voltage Min",
  "Battery Cells",
  "Main Voltage Devider",
  "Main Voltage MW",
  
  "Video Voltage Devider",
  "Video Voltage MW",
  
  "Temperature Max",
  
  "", // for Board type do not remove
  
  "GPS",
  "Coords",
  "Display Heading 360",
  
  "Units",
  "Video Signal",
  
  "Reset Stats After Arm",
  "ADC",
  " ",
  "Blink Frequency",
  
  //"Horizon_",
  //"Decoration",
  //"RSSI",
  //"VOLTAGE",
  
  "Display CallSign",
  "S_CS0",
  "S_CS1",
  "S_CS2",
  "S_CS3",
  "S_CS4",
  "S_CS5",
  "S_CS6",
  "S_CS7",
  "S_CS8",
  "S_CS9",
  
  };




static int CHECKBOXITEMS=0;
int CONFIGITEMS=ConfigNames.length;
static int SIMITEMS=6;
  
int[] ConfigRanges = {
1,   // used for check             0

255,   // S_RSSIMIN                   1
255, // S_RSSIMAX                   2
60,  //S_RSSI_ALARM                 3
1,   // S_MWRSSI                    4
1,   // S_PWMRSSI                   5
105, // S_VOLTAGEMIN                6
4,   // S_BATCELLS                  7
100, // S_DIVIDERRATIO              8
1,   // S_MAINVOLTAGE_VBAT          9
100, // S_VIDDIVIDERRATIO           10
1,   // S_VIDVOLTAGE_VBAT           11 
255, // S_TEMPERATUREMAX            12
1,   // S_BOARDTYPE                 13
1,   // S_DISPLAYGPS                14
1,   // S_COORDINATES               15
1,   // S_HEADING360                16
1,   // S_UNITSYSTEM                17
1,   // S_VIDEOSIGNALTYPE           18
1,   // S_RESETSTATISTICS           19
1,   // S_ENABLEADC                 20
1,   // S_USE_BOXNAMES              21
10,   // S_BLINKINGHZ,               22

//1,   //S_DISPLAY_HORIZON_BR
//1,   //S_WITHDECORATION
//1,   //S_DISPLAYRSSI
//1,   //S_DISPLAYVOLTAGE

1,     // call sign                37
255,
255,
 255,
 255,
 255,
 255,
 255,
 255,
 255,
 255,

};

int[] ItemLocationPAL = {
  // ROW= Row position on screen (255= no action)
// COL= Column position on screen (255= no action)
// DSPL= Display item on screen
2,   // L_GPS_NUMSATPOSITIONROW LINE02+2
2,   // L_GPS_NUMSATPOSITIONCOL
1,   // L_GPS_NUMSATPOSITIONDSPL
3,   // L_GPS_DIRECTIONTOHOMEPOSROW LINE03+14
14,  // L_GPS_DIRECTIONTOHOMEPOSCOL
1,   // L_GPS_DIRECTIONTOHOMEPOSDSPL
2,   // L_GPS_DISTANCETOHOMEPOSROW LINE02+24
24,  // L_GPS_DISTANCETOHOMEPOSCOL
1,   // L_GPS_DISTANCETOHOMEPOSDSPL
3,   // L_SPEEDPOSITIONROW LINE03+24
24,  // L_SPEEDPOSITIONCOL
1,   // L_SPEEDPOSITIONDSPL
4,   // L_GPS_ANGLETOHOMEPOSROW LINE04+12
12,  // L_GPS_ANGLETOHOMEPOSCOL
1,   // L_GPS_ANGLETOHOMEPOSDSPL
4,   // L_MW_GPS_ALTPOSITIONROW LINE04+24
24,  // L_MW_GPS_ALTPOSITIONCOL
1,   // L_MW_GPS_ALTPOSITIONDSPL
3,   // L_SENSORPOSITIONROW LINE03+2
2,   // L_SENSORPOSITIONCOL
1,   // L_SENSORPOSITIONDSPL
2,   // L_MW_HEADINGPOSITIONROW LINE02+19
19,  // L_MW_HEADINGPOSITIONCOL
1,   // L_MW_HEADINGPOSITIONDSPL
2,   // L_MW_HEADINGGRAPHPOSROW LINE02+10
10,  // L_MW_HEADINGGRAPHPOSCOL
1,   // L_MW_HEADINGGRAPHPOSDSPL
11,  // L_TEMPERATUREPOSROW LINE11+2
2,   // L_TEMPERATUREPOSCOL
0,   // L_TEMPERATUREPOSDSPL

8,   // L_MW_ALTITUDEPOSITIONROW LINE08+2
2,   // L_MW_ALTITUDEPOSITIONCOL
1,   // L_MW_ALTITUDEPOSITIONDSPL
8,   // L_CLIMBRATEPOSITIONROW LINE08+24
24,  // L_CLIMBRATEPOSITIONCOL
1,   // L_CLIMBRATEPOSITIONDSPL
6,   // L_HORIZONPOSITIONROW LINE06+8
8,   // L_HORIZONPOSITIONCOL
1,   // L_HORIZONPOSITIONDSPL
255, // L_HORIZONSIDEREFROW,
255, // L_HORIZONSIDEREFCOL,
1,   // L_HORIZONSIDEREFDSPL,
255, // L_HORIZONCENTERREFROW,
255, // L_HORIZONCENTERREFCOL,
1,   // L_HORIZONCENTERREFDSPL,  
  
14,   // L_CURRENTTHROTTLEPOSITIONROW LINE14+22
22,   // L_CURRENTTHROTTLEPOSITIONCOL
1,    // L_CURRENTTHROTTLEPOSITIONDSPL
15,   // L_FLYTIMEPOSITIONROW LINE15+22
22,   // L_FLYTIMEPOSITIONCOL
1,    // L_FLYTIMEPOSITIONDSPL
15,   // L_ONTIMEPOSITIONROW LINE15+22
22,   // L_ONTIMEPOSITIONCOL
1,    // L_ONTIMEPOSITIONDSPL
14,   // L_MOTORARMEDPOSITIONROW LINE14+11
11,   // L_MOTORARMEDPOSITIONCOL
1,    // L_MOTORARMEDPOSITIONDSPL
12,   // L_MW_GPS_LATPOSITIONROW  LINE12+2
2,    // L_MW_GPS_LATPOSITIONCOL
1,    // L_MW_GPS_LATPOSITIONDSPL
12,   // L_MW_GPS_LONPOSITIONROW  LINE12+15
15,   // L_MW_GPS_LONPOSITIONCOL
1,    // L_MW_GPS_LONPOSITIONDSPL
14,   // L_RSSIPOSITIONROW LINE14+2
2,    // L_RSSIPOSITIONCOL
1,    // L_RSSIPOSITIONDSPL
15,   // L_VOLTAGEPOSITIONROW LINE15+3
3,    // L_VOLTAGEPOSITIONCOL
1,    // L_VOLTAGEPOSITIONDSPL
255,  // L_MAINBATLEVEVOLUTIONROW,
255,  // L_MAINBATLEVEVOLUTIONCOL,
1,    // L_MAINBATLEVEVOLUTIONDSPL,  
13,   // L_VIDVOLTAGEPOSITIONROW LINE13+3
3,    // L_VIDVOLTAGEPOSITIONCOL
0,    // L_VIDVOLTAGEPOSITIONDSPL
15,   // L_AMPERAGEPOSITIONROW LINE15+10
10,   // L_AMPERAGEPOSITIONCOL
0,    // L_AMPERAGEPOSITIONDSPL
15,   // L_PMETERSUMPOSITIONROW LINE15+16
16,   // L_PMETERSUMPOSITIONCOL
0,    // L_PMETERSUMPOSITIONDSPL
14,   // L_CALLSIGNPOSITIONROW LINE14+10
10,   // L_CALLSIGNPOSITIONCOL
0,    // L_CALLSIGNPOSITIONDSPL
};

int[] ItemLocationNTSC = {
2,   // L_GPS_NUMSATPOSITIONROW LINE02+2
2,   // L_GPS_NUMSATPOSITIONCOL
1,   // L_GPS_NUMSATPOSITIONDSPL
3,   // L_GPS_DIRECTIONTOHOMEPOSROW LINE03+14
14,  // L_GPS_DIRECTIONTOHOMEPOSCOL
1,   // L_GPS_DIRECTIONTOHOMEPOSDSPL
2,   // L_GPS_DISTANCETOHOMEPOSROW LINE02+24
24,  // L_GPS_DISTANCETOHOMEPOSCOL
1,   // L_GPS_DISTANCETOHOMEPOSDSPL
3,   // L_SPEEDPOSITIONROW LINE03+24
24,  // L_SPEEDPOSITIONCOL
1,   // L_SPEEDPOSITIONDSPL
4,   // L_GPS_ANGLETOHOMEPOSROW LINE04+12
12,  // L_GPS_ANGLETOHOMEPOSCOL
1,   // L_GPS_ANGLETOHOMEPOSDSPL
4,   // L_MW_GPS_ALTPOSITIONROW LINE04+24
24,  // L_MW_GPS_ALTPOSITIONCOL
1,   // L_MW_GPS_ALTPOSITIONDSPL
3,   // L_SENSORPOSITIONROW LINE03+2
2,   // L_SENSORPOSITIONCOL
1,   // L_SENSORPOSITIONDSPL
2,   // L_MW_HEADINGPOSITIONROW LINE02+19
19,  // L_MW_HEADINGPOSITIONCOL
1,   // L_MW_HEADINGPOSITIONDSPL
2,   // L_MW_HEADINGGRAPHPOSROW LINE02+10
10,  // L_MW_HEADINGGRAPHPOSCOL
1,   // L_MW_HEADINGGRAPHPOSDSPL
9,   // L_TEMPERATUREPOSROW LINE11+2
2,   // L_TEMPERATUREPOSCOL
0,   // L_TEMPERATUREPOSDSPL

7,   // L_MW_ALTITUDEPOSITIONROW LINE08+2
2,   // L_MW_ALTITUDEPOSITIONCOL
1,   // L_MW_ALTITUDEPOSITIONDSPL
7,   // L_CLIMBRATEPOSITIONROW LINE08+24
24,  // L_CLIMBRATEPOSITIONCOL
1,   // L_CLIMBRATEPOSITIONDSPL
5,   // L_HORIZONPOSITIONROW LINE06+8
8,   // L_HORIZONPOSITIONCOL
1,   // L_HORIZONPOSITIONDSPL
255, // L_HORIZONSIDEREFROW,
255, // L_HORIZONSIDEREFCOL,
1,   // L_HORIZONSIDEREFDSPL,
255, // L_HORIZONCENTERREFROW,
255, // L_HORIZONCENTERREFCOL,
1,   // L_HORIZONCENTERREFDSPL,  
  
12,   // L_CURRENTTHROTTLEPOSITIONROW LINE14+22
22,   // L_CURRENTTHROTTLEPOSITIONCOL
1,    // L_CURRENTTHROTTLEPOSITIONDSPL
13,   // L_FLYTIMEPOSITIONROW LINE15+22
22,   // L_FLYTIMEPOSITIONCOL
1,    // L_FLYTIMEPOSITIONDSPL
13,   // L_ONTIMEPOSITIONROW LINE15+22
22,   // L_ONTIMEPOSITIONCOL
1,    // L_ONTIMEPOSITIONDSPL
12,   // L_MOTORARMEDPOSITIONROW LINE14+11
11,   // L_MOTORARMEDPOSITIONCOL
1,    // L_MOTORARMEDPOSITIONDSPL
10,   // L_MW_GPS_LATPOSITIONROW  LINE12+2
2,    // L_MW_GPS_LATPOSITIONCOL
1,    // L_MW_GPS_LATPOSITIONDSPL
10,   // L_MW_GPS_LONPOSITIONROW  LINE12+15
15,   // L_MW_GPS_LONPOSITIONCOL
1,    // L_MW_GPS_LONPOSITIONDSPL
12,   // L_RSSIPOSITIONROW LINE14+2
2,    // L_RSSIPOSITIONCOL
1,    // L_RSSIPOSITIONDSPL
13,   // L_VOLTAGEPOSITIONROW LINE15+3
3,    // L_VOLTAGEPOSITIONCOL
1,    // L_VOLTAGEPOSITIONDSPL
255,  // L_MAINBATLEVEVOLUTIONROW,
255,  // L_MAINBATLEVEVOLUTIONCOL,
1,    // L_MAINBATLEVEVOLUTIONDSPL,  
11,   // L_VIDVOLTAGEPOSITIONROW LINE13+3
3,    // L_VIDVOLTAGEPOSITIONCOL
0,    // L_VIDVOLTAGEPOSITIONDSPL
13,   // L_AMPERAGEPOSITIONROW LINE15+10
10,   // L_AMPERAGEPOSITIONCOL
0,    // L_AMPERAGEPOSITIONDSPL
13,   // L_PMETERSUMPOSITIONROW LINE15+16
16,   // L_PMETERSUMPOSITIONCOL
0,    // L_PMETERSUMPOSITIONDSPL
12,   // L_CALLSIGNPOSITIONROW LINE14+10
10,   // L_CALLSIGNPOSITIONCOL

};
  
String[] SimNames= {
  "Armed:",
  "Acro/Stable:",
  "Bar Mode:",
  "Mag Mode:",
  "GPS Home:",
  "GPS Hold:",
  "Sim 6:",
  "Sim 7:",
  "Sim 8:",
  "Sim 9:",
  "Sim 10:"
};
  
  
  int[] SimRanges = {
  1,
  1,
  1,
  1,
  1,
  1,
  1,
  255,
  1,
  1,
  1};


PFont font8,font9,font10,font11,font12,font15;

//Colors--------------------------------------------------------------------------------------------------------------------
color yellow_ = color(200, 200, 20), green_ = color(30, 120, 30), red_ = color(120, 30, 30), blue_ = color(50, 50, 100),
grey_ = color(30, 30, 30);
//Colors--------------------------------------------------------------------------------------------------------------------

// textlabels -------------------------------------------------------------------------------------------------------------
Textlabel txtlblconfItem[] = new Textlabel[CONFIGITEMS] ;
Textlabel txtlblSimItem[] = new Textlabel[SIMITEMS] ;
Textlabel FileUploadText, TXText, RXText;
// textlabels -------------------------------------------------------------------------------------------------------------

// Buttons------------------------------------------------------------------------------------------------------------------
Button buttonIMPORT,buttonSAVE,buttonREAD,buttonRESET,buttonWRITE,buttonRESTART;
// Buttons------------------------------------------------------------------------------------------------------------------

// Toggles------------------------------------------------------------------------------------------------------------------
Toggle toggleConfItem[] = new Toggle[CONFIGITEMS] ;
// Toggles------------------------------------------------------------------------------------------------------------------    

// checkboxes------------------------------------------------------------------------------------------------------------------
CheckBox checkboxConfItem[] = new CheckBox[CONFIGITEMS] ;


// Toggles------------------------------------------------------------------------------------------------------------------    
RadioButton RadioButtonConfItem[] = new RadioButton[CONFIGITEMS] ;
RadioButton R_PortStat;

//  number boxes--------------------------------------------------------------------------------------------------------------

Numberbox confItem[] = new Numberbox[CONFIGITEMS] ;
//Numberbox SimItem[] = new Numberbox[SIMITEMS] ;
//  number boxes--------------------------------------------------------------------------------------------------------------

Group MGUploadF,
  G_EEPROM,
  G_RSSI,
  G_Voltage,
  G_Amperage,
  G_VVoltage,
  G_Temperature,
  G_Board,
  G_GPS,
  G_UV,
  G_Other,
  G_CallSign,
  G_PortStatus
  
  ;

// Timers --------------------------------------------------------------------------------------------------------------------
//ControlTimer OnTimer,FlyTimer;

controlP5.Controller hideLabel(controlP5.Controller c) {
  c.setLabel("");
  c.setLabelVisible(false);
  return c;
}



void setup() {
  size(windowsX,windowsY);
 
//Map<Settings, String> table = new EnumMap<Settings>(Settings.class);
OnTimer = millis();
  frameRate(30); 
OSDBackground = loadImage("Background3.jpg");
//RadioPot = loadImage("kvImage.jpg");
//PGraphics icon = createGraphics(16, 16, P3D);
//icon.beginDraw();
//icon.beginShape();
//icon.texture(RadioPot);
//icon.endShape();
//icon.endDraw();
//frame.setIconImage(icon.image);
  font8 = createFont("Arial bold",8,false);
  font9 = createFont("Arial bold",10,false);
  font10 = createFont("Arial bold",11,false);
  font11 = createFont("Arial bold",11,false);
  font12 = createFont("Arial bold",12,false);
  font15 = createFont("Arial bold",15,false);

  controlP5 = new ControlP5(this); // initialize the GUI controls
  controlP5.setControlFont(font10);
  //controlP5.setAutoDraw(false);
  

  SmallcontrolP5 = new ControlP5(this); // initialize the GUI controls
  SmallcontrolP5.setControlFont(font9); 
  //SmallcontrolP5.setAutoDraw(false); 
 
  ScontrolP5 = new ControlP5(this); // initialize the GUI controls
  ScontrolP5.setControlFont(font10);  
  //ScontrolP5.setAutoDraw(false);  
 
 
 
 //FontGroupcontrolP5.setAutoDraw(false); 
 
 
  GroupcontrolP5 = new ControlP5(this); // initialize the GUI controls
  GroupcontrolP5.setControlFont(font10);
  //GroupcontrolP5.setColorForeground(color(30,255));
  //GroupcontrolP5.setColorBackground(color(30,255));
  //GroupcontrolP5.setColorLabel(color(0, 110, 220));
  //GroupcontrolP5.setColorValue(0xffff88ff);
  //GroupcontrolP5.setColorActive(color(30,255));
  //GroupcontrolP5.setAutoDraw(false);
  FontGroupcontrolP5 = new ControlP5(this); // initialize the GUI controls
 FontGroupcontrolP5.setControlFont(font10);

  SetupGroups();




  commListbox = controlP5.addListBox("portComList",5,100,110,260); // make a listbox and populate it with the available comm ports
  commListbox.setItemHeight(15);
  commListbox.setBarHeight(15);

  commListbox.captionLabel().set("PORT COM");
  commListbox.setColorBackground(red_);
  for(int i=0;i<Serial.list().length;i++) {
    String pn = shortifyPortName(Serial.list()[i], 13);
    if (pn.length() >0 ) commListbox.addItem(pn,i); // addItem(name,value)
    commListMax = i;
  }
  commListbox.addItem("Close Comm",++commListMax); // addItem(name,value)
  // text label for which comm port selected
  txtlblWhichcom = controlP5.addTextlabel("txtlblWhichcom","No Port Selected",5,65); // textlabel(name,text,x,y)
  
  buttonSAVE = controlP5.addButton("bSAVE",1,5,45,40,19); buttonSAVE.setLabel("SAVE"); buttonSAVE.setColorBackground(red_);
  buttonIMPORT = controlP5.addButton("bIMPORT",1,50,45,40,19); buttonIMPORT.setLabel("LOAD"); buttonIMPORT.setColorBackground(red_); 
  
  buttonREAD = controlP5.addButton("READ",1,XControlBox+30,YControlBox+25,45,16);buttonREAD.setColorBackground(red_);
  buttonRESET = controlP5.addButton("RESET",1,XControlBox+30,YControlBox+50,45,16);buttonRESET.setColorBackground(red_);
  buttonWRITE = controlP5.addButton("WRITE",1,XControlBox+30,YControlBox+75,45,16);buttonWRITE.setColorBackground(red_);
  buttonRESTART = controlP5.addButton("RESTART",1,XControlBox+25,YControlBox+100,55,16);buttonRESTART.setColorBackground(red_);
    
    

// EEPROM----------------------------------------------------------------

CreateItem(GetSetting("S_CHECK_"), 5, 0, G_EEPROM);

// RSSI  ---------------------------------------------------------------------------

CreateItem(GetSetting("S_RSSIMIN"), 5, 0, G_RSSI);
CreateItem(GetSetting("S_RSSIMAX"), 5,1*17, G_RSSI);
CreateItem(GetSetting("S_RSSI_ALARM"), 5,2*17, G_RSSI);
CreateItem(GetSetting("S_MWRSSI"),  5,3*17, G_RSSI);
BuildRadioButton(GetSetting("S_MWRSSI"),  5,3*17, G_RSSI, "ADC","MWii");
CreateItem(GetSetting("S_PWMRSSI"),  5,4*17, G_RSSI);
BuildRadioButton(GetSetting("S_PWMRSSI"),  5,4*17, G_RSSI, "Off","On");

// Voltage  ------------------------------------------------------------------------

CreateItem(GetSetting("S_VOLTAGEMIN"), 5,0*17, G_Voltage);
CreateItem(GetSetting("S_BATCELLS"), 5,1*17, G_Voltage);
CreateItem(GetSetting("S_DIVIDERRATIO"), 5,2*17, G_Voltage);
CreateItem(GetSetting("S_MAINVOLTAGE_VBAT"), 5,3*17, G_Voltage);
BuildRadioButton(GetSetting("S_MAINVOLTAGE_VBAT"),  5,3*17, G_Voltage, "ADC","MWii");

// Amperage  ------------------------------------------------------------------------
//CreateItem(GetSetting("S_AMPERAGE"),  5,0, G_Amperage);
//CreateItem(GetSetting("S_AMPER_HOUR"),  5,1*17, G_Amperage);

// Video Voltage  ------------------------------------------------------------------------
CreateItem(GetSetting("S_VIDDIVIDERRATIO"),  5,1*17, G_VVoltage);
CreateItem(GetSetting("S_VIDVOLTAGE_VBAT"),  5,2*17, G_VVoltage);
BuildRadioButton(GetSetting("S_VIDVOLTAGE_VBAT"),  5,0, G_VVoltage, "ADC","MWii");

//  Temperature  --------------------------------------------------------------------
CreateItem(GetSetting("S_TEMPERATUREMAX"),  5,0*17, G_Temperature);

//  Board ---------------------------------------------------------------------------
CreateItem(GetSetting("S_BOARDTYPE"),  5,0, G_Board);
BuildRadioButton(GetSetting("S_BOARDTYPE"),  5,0, G_Board, "Rush","Minim");


//  GPS  ----------------------------------------------------------------------------
CreateItem(GetSetting("S_DISPLAYGPS"), 5,0, G_GPS);
BuildRadioButton(GetSetting("S_DISPLAYGPS"),  5,0, G_GPS, "Off","On");
CreateItem(GetSetting("S_COORDINATES"),  5,1*17, G_GPS);
BuildRadioButton(GetSetting("S_COORDINATES"),  5,1*17, G_GPS, "Off","On");
CreateItem(GetSetting("S_HEADING360"),  5,2*17, G_GPS);
BuildRadioButton(GetSetting("S_HEADING360"),  5,2*17, G_GPS, "180°","360°");



//  Unit and Video ---------------------------------------------------------------------------
CreateItem(GetSetting("S_UNITSYSTEM"),  5,0, G_Other);
BuildRadioButton(GetSetting("S_UNITSYSTEM"),  5,0, G_Other, "Metric","Imperial");
CreateItem(GetSetting("S_VIDEOSIGNALTYPE"),  5,1*17, G_Other);
BuildRadioButton(GetSetting("S_VIDEOSIGNALTYPE"),  5,1*17, G_Other, "NTSC","PAL");

CreateItem(GetSetting("S_RESETSTATISTICS"),  5,2*17, G_Other);
BuildRadioButton(GetSetting("S_RESETSTATISTICS"),  5,2*17, G_Other, "Reset","Maintain");
CreateItem(GetSetting("S_ENABLEADC"),  5,3*17, G_Other);
BuildRadioButton(GetSetting("S_ENABLEADC"),  5,3*17, G_Other, "Off","On");
CreateItem(GetSetting("S_USE_BOXNAMES"),  5,4*17, G_Other);
BuildRadioButton(GetSetting("S_USE_BOXNAMES"),  5,4*17, G_Other, "BoxIDs","BoxNames");
CreateItem(GetSetting("S_BLINKINGHZ"),  5,5*17, G_Other);


//  Call Sign ---------------------------------------------------------------------------
CreateItem(GetSetting("S_DISPLAY_CS"),  5,0, G_CallSign);

controlP5.addTextfield("CallSign")
     .setPosition(5,1*17)
     .setSize(105,15)
     .setFont(font10)
     .setAutoClear(false)
     .setGroup(G_CallSign);
     ;
 controlP5.addTextlabel("TXTCallSign","Call Sign",120,1*17)
 .setGroup(G_CallSign);
 CreateCS(GetSetting("S_CS0"),  0,0, G_CallSign);
 CreateCS(GetSetting("S_CS1"),  0,0, G_CallSign);
 CreateCS(GetSetting("S_CS2"),  0,0, G_CallSign);
 CreateCS(GetSetting("S_CS3"),  0,0, G_CallSign);
 CreateCS(GetSetting("S_CS4"),  0,0, G_CallSign);
 CreateCS(GetSetting("S_CS5"),  0,0, G_CallSign);
 CreateCS(GetSetting("S_CS6"),  0,0, G_CallSign);
 CreateCS(GetSetting("S_CS7"),  0,0, G_CallSign);
 CreateCS(GetSetting("S_CS8"),  0,0, G_CallSign);
 CreateCS(GetSetting("S_CS9"),  0,0, G_CallSign);




       
  // CheckBox "Hide Background"
  /*ShowSimBackground = controlP5.addCheckBox("ShowSimBackground",XSim,YSim+1);
  ShowSimBackground.setColorActive(color(255));
  ShowSimBackground.setColorBackground(color(120));
  ShowSimBackground.setItemsPerRow(1);
  ShowSimBackground.setSpacingColumn(10);
  ShowSimBackground.setLabel("Hide Background");
  ShowSimBackground.addItem("Hide Background",1);*/

  for(int i=0;i<CONFIGITEMS;i++) {
    if (ConfigRanges[i] == 0) {
      toggleConfItem[i].hide();
      confItem[i].hide();
    }
    if (ConfigRanges[i] > 1) {
      try{
      toggleConfItem[i].hide();
      }catch(Exception e) {
      }finally {
      }  	
    }
      
    if (ConfigRanges[i] == 1){
      confItem[i].hide();  
    }
  }
  
  //byte[] inBuf = new byte[256];
  for (int txTimes = 0; txTimes<255; txTimes++) {
    inBuf[txTimes] = 0;
  }

  
  

  BuildToolHelp();
  Font_Editor_setup();
   SimSetup();
  img_Clear = LoadFont(FontFileName);
  //toggleMSP_Data = true;
  CloseMode = 0;
  LoadConfig();
  
  
}


controlP5.Controller hideCheckbox(controlP5.Controller c) {
  c.hide();
  //c.setLabelVisible(false);
  return c;
}

controlP5.Controller CheckboxVisable(controlP5.Controller c) {
  c.isVisible(); 

  //c.setLabelVisible(false);
  return c;
}



void BuildRadioButton(int ItemIndex, int XLoction, int YLocation,Group inGroup, String Cap1, String Cap2){
    
  RadioButtonConfItem[ItemIndex] = controlP5.addRadioButton("RadioButton"+ItemIndex)
         .setPosition(XLoction,YLocation+3)
         .setSize(10,10)
         .setNoneSelectedAllowed(false) 
         //.setColorBackground(color(120))
         //.setColorActive(color(255))
        // .setColorLabel(color(255))
         .setItemsPerRow(2)
         .setSpacingColumn(int(textWidth(Cap1))+10)
         .addItem("First"+ItemIndex,0)
         .addItem("Second"+ItemIndex,1)
         .toUpperCase(false)
        //.hideLabels() 
         ;
    RadioButtonConfItem[ItemIndex].setGroup(inGroup);
    RadioButtonConfItem[ItemIndex].getItem(0).setCaptionLabel(Cap1);
    RadioButtonConfItem[ItemIndex].getItem(1).setCaptionLabel(Cap2 + "    " + ConfigNames[ItemIndex]);
    
    toggleConfItem[ItemIndex].hide();
    txtlblconfItem[ItemIndex].hide();
    
  
}

void CreateCS(int ItemIndex, int XLoction, int YLocation, Group inGroup){
  //numberbox
  confItem[ItemIndex] = (controlP5.Numberbox) hideLabel(controlP5.addNumberbox("configItem"+ItemIndex,0,XLoction,YLocation,35,14));
  confItem[ItemIndex].setMin(0);
  confItem[ItemIndex].setMax(255);
  confItem[ItemIndex].setDecimalPrecision(0);
  confItem[ItemIndex].setGroup(inGroup);
  confItem[ItemIndex].hide();
  toggleConfItem[ItemIndex] = (controlP5.Toggle) hideLabel(controlP5.addToggle("toggleValue"+ItemIndex));
  toggleConfItem[ItemIndex].hide();
  
  

}

void CreateItem(int ItemIndex, int XLoction, int YLocation, Group inGroup){
  //numberbox
  confItem[ItemIndex] = (controlP5.Numberbox) hideLabel(controlP5.addNumberbox("configItem"+ItemIndex,0,XLoction,YLocation,35,14));
  confItem[ItemIndex].setColorBackground(red_);
  confItem[ItemIndex].setMin(0);
  confItem[ItemIndex].setDirection(Controller.VERTICAL);
  confItem[ItemIndex].setMax(ConfigRanges[ItemIndex]);
  confItem[ItemIndex].setDecimalPrecision(0);
  confItem[ItemIndex].setGroup(inGroup);
  //Toggle
  toggleConfItem[ItemIndex] = (controlP5.Toggle) hideLabel(controlP5.addToggle("toggleValue"+ItemIndex));
  toggleConfItem[ItemIndex].setPosition(XLoction,YLocation+3);
  toggleConfItem[ItemIndex].setSize(35,10);
  toggleConfItem[ItemIndex].setMode(ControlP5.SWITCH);
  toggleConfItem[ItemIndex].setGroup(inGroup);
  //TextLabel
  txtlblconfItem[ItemIndex] = controlP5.addTextlabel("txtlblconfItem"+ItemIndex,ConfigNames[ItemIndex],XLoction+40,YLocation);
  txtlblconfItem[ItemIndex].setGroup(inGroup);
  //controlP5.getTooltip().register("txtlblconfItem"+ItemIndex,ConfigHelp[ItemIndex]);

} 


void BuildToolHelp(){
  controlP5.getTooltip().setDelay(100);
  //confItem[1].setMultiplier(confItem[1].value);
  //controlP5.getTooltip().register("txtlblconfItem"+0,"Changes the size of the ellipse.");
  //controlP5.getTooltip().register("s2","Changes the Background");
}





void MakePorts(){
  if (PortWrite){  
       TXText.setColorValue(color(255,10,0));
  }
  else
  {
    TXText.setColorValue(color(100,10,0));
  }
  if (PortRead){  
    RXText.setColorValue(color(0,240,0));
  }
   else
  {
    RXText.setColorValue(color(0,100,0));
  }
}

void draw() {
  time=millis();
  //hint(ENABLE_DEPTH_TEST);
  //pushMatrix();
  //PortRead = false; 
  //PortWrite = false; 
  //del++; 
  //System.out.println(del);
  if ((init_com==1)  && (toggleMSP_Data == true)) {
    //time2 = time;
    PortRead = true;
    MakePorts();
    MWData_Com();
    if (!FontMode) PortRead = false;
    
  }
  
  //PortWrite = false;
  if ((SendSim ==1) && (ClosePort == false)){
    //PortWrite = true;
      //MakePorts();
 
    if ((init_com==1)  && (time-time5 >5000) && (toggleMSP_Data == false) && (!FontMode)){
      if(ClosePort) return;
      time5 = time;
       
      if (init_com==1){
        SendCommand(MSP_BOXNAMES);
        SendCommand(MSP_BOXIDS);
      }
      //PortWrite = false;
    }
    if ((init_com==1)  && (time-time4 >200) && (!FontMode)){
      if(ClosePort) return;
      time4 = time; 
      //PortWrite = !PortWrite;
      //MakePorts();
      if (init_com==1)SendCommand(MSP_ANALOG);
      if (init_com==1)SendCommand(MSP_STATUS);
      if (init_com==1)SendCommand(MSP_RC);
      if (init_com==1)SendCommand(MSP_ALTITUDE);
      if (init_com==1)SendCommand(MSP_RAW_GPS);
      if (init_com==1)SendCommand(MSP_COMP_GPS);
      
      
    }
    if ((init_com==1)  && (time-time1 >40) && (!FontMode)){
      if(ClosePort) return;
      time1 = time; 
      PortWrite = !PortWrite;
      
      if (init_com==1)SendCommand(MSP_ATTITUDE);
      //PortWrite = false;
    }
  }
  else
  {
    if (!FontMode) PortWrite = false; 
  }


  
  
  if ((FontMode) && (time-time2 >100)){
    SendChar();
   }
    
    
  MakePorts();  
  
  background(80);
  
  // ------------------------------------------------------------------------
  // Draw background control boxes
  // ------------------------------------------------------------------------

  // Coltrol Box
  fill(80); strokeWeight(2);stroke(100); rectMode(CORNERS); rect(XControlBox,YControlBox, XControlBox+108, YControlBox+123); //108//130
  textFont(font12); fill(255, 255, 255); text("OSD Controls",XControlBox + 15,YControlBox + 15);
  if (activeTab == 1) {
  
  }
  
  fill(60, 40, 40);
  strokeWeight(3);stroke(0);
  rectMode(CORNERS);
  rect(5,5,113,40);
  textFont(font12);
  // version
  fill(255, 255, 255);
  text("KV Team OSD",10,19);
  text("  GUI    V",10,35);
  text(KV_OSD_GUI_Version, 74, 35);
  fill(0, 0, 0);
  strokeWeight(3);stroke(0);
  rectMode(CORNERS);
  //if (int(ShowSimBackground.arrayValue()[0]) < 1){
//image(OSDBackground,DisplayWindowX+WindowAdjX, DisplayWindowY+WindowAdjY, 529-WindowShrinkX, 360-WindowShrinkY); //529-WindowShrinkX, 360-WindowShrinkY);
  /*}
  else{
    fill(80, 80,80); strokeWeight(3);stroke(1); rectMode(CORNER); rect(DisplayWindowX+WindowAdjX, DisplayWindowY+WindowAdjY, 529-WindowShrinkX, 360-WindowShrinkY);  //335-WindowShrinkX, 288-WindowShrinkY);
  }
*/

 

 //displayHorizon(int(MW_Pitch_Roll.arrayValue()[0])*10,int(MW_Pitch_Roll.arrayValue()[1])*10*-1);
  //SimulateTimer();
  //ShowCurrentThrottlePosition();
  //if (int(confItem[GetSetting("S_DISPLAYRSSI")].value()) > 0)
    //ShowRSSI(); 
  //if (int(confItem[GetSetting("S_DISPLAYVOLTAGE")].value()) > 0) {
    // ShowVolts(sVBat);
 // }
    
 
  //CalcAlt_Vario(); 
  //displaySensors();
  //displayMode();
  //ShowAmperage();
  //displayHeadingGraph();
  //displayHeading();
 
  MatchConfigs();
  MakePorts();

  
  if ((ClosePort ==true)&& (PortWrite == false)){ //&& (init_com==1)
    ClosePort();
  }
}


int GetSetting(String test){
  int TheSetting = 0;
  for (int i=0; i<Settings.values().length; i++) 
  if (Settings.valueOf(test) == Settings.values()[i]){ 
      TheSetting = Settings.values()[i].ordinal();
  }
  return TheSetting;
}


void ShowSimBackground(float[] a) {
  Showback = int(a[0]);
}

//void SimulateMultiWii(float[] a) {
//}

public void BuildCallSign(){
  String CallSText = "";
  for (int i=0; i<10; i++){ 
    //confItem[GetSetting("S_CS0")+i].setValue(0);
    if (int(confItem[GetSetting("S_CS0")+i].getValue())>0){
    CallSText+=char(int(confItem[GetSetting("S_CS0")+i].getValue()));
    }
  }
  controlP5.get(Textfield.class,"CallSign").setText(CallSText);
}  

public void CheckCallSign() {
  // automatically receives results from controller input
  String CallSText = controlP5.get(Textfield.class,"CallSign").getText().toUpperCase();
  controlP5.get(Textfield.class,"CallSign").setText(CallSText);
  //if (CallSText.length()  >0){
    if (CallSText.length()  >10){
      controlP5.get(Textfield.class,"CallSign").setText(CallSText.substring(0, 10));
      CallSText = controlP5.get(Textfield.class,"CallSign").getText();
    } 
    for (int i=0; i<10; i++){ 
    confItem[GetSetting("S_CS0")+i].setValue(0);
    }
    for (int i=0; i<CallSText.length(); i++){ 
      confItem[(GetSetting("S_CS0"))+i].setValue(int(CallSText.charAt(i)));
    //println(int(CallSText.charAt(0)));
    //println(controlP5.get(Textfield.class,"CallSign").getText());
    }
  //}
}




void MatchConfigs(){
 for(int i=0;i<CONFIGITEMS;i++) {
   try{ 
       if (RadioButtonConfItem[i].isVisible()){
          confItem[i].setValue(int(RadioButtonConfItem[i].getValue()));
       }
        }catch(Exception e) {}finally {}
    
  
     if  (toggleConfItem[i].isVisible()){
       if (int(toggleConfItem[i].getValue())== 1){
       confItem[i].setValue(1);
     }
     else{ 
       confItem[i].setValue(0);
     }
   }
   
   if (ConfigRanges[i] == 0) {
      toggleConfItem[i].hide();
      //RadioButtonConfItem[i].hide();
      confItem[i].hide();
    }
    if (ConfigRanges[i] > 1) {
      toggleConfItem[i].hide();
      
    }  
    if (ConfigRanges[i] == 1){
      confItem[i].hide();  
    }
    
    
  }
  // turn on FlyTimer----
  if ((toggleModeItems[0].getValue() == 0) && (SimItem0 < 1)){
    Armed = 1;
    FlyTimer = millis();
  }
  // turn off FlyTimer----
  if ((toggleModeItems[0].getValue() == 1 ) && (SimItem0 == 1)){
    FlyTimer = 0;
  }



}

// controls comport list click
public void controlEvent(ControlEvent theEvent) {
  
  try{
  if (theEvent.isGroup())
    if (theEvent.name()=="portComList")
      InitSerial(theEvent.group().value()); // initialize the serial port selected
  }catch(Exception e){
    System.out.println("error with Port");
  }

if (theEvent.name()=="CallSign"){
  CheckCallSign();
}

      
  try{
  //for (int i=0;i<col.length;i++) {
    if ((theEvent.getController().getName().substring(0, 7).equals("CharPix")) && (theEvent.getController().isMousePressed())) {
      //println("Got a pixel " + theEvent.controller().id());
        int ColorCheck = int(theEvent.getController().value());
        curPixel = theEvent.controller().id();
    }
    if ((theEvent.getController().getName().substring(0, 7).equals("CharMap")) && (theEvent.getController().isMousePressed())) {
      curChar = theEvent.controller().id();    
      //println("Got a Char " + theEvent.controller().id());
    }
   } catch(ClassCastException e){}
     catch(StringIndexOutOfBoundsException se){}
      
}





void mapchar(int address, int screenAddress){
  int placeX = (screenAddress % 30) * 12;
  int placeY = (screenAddress / 30) * 18;

  blend(img_Clear, 0,address*18, 12, 18, placeX+DisplayWindowX, placeY+DisplayWindowY, 12, 18, BLEND);
}

void makeText(String inString, int inStartAddress ){
  for (int i = 0; i < inString.length(); i++){
    mapchar(int(inString.charAt(i)), inStartAddress +i); 
  }   
}



void displaySensors()
{
   mapchar(0xa0,sensorPosition[0]);
   mapchar(0xa2,sensorPosition[0]+1);
   mapchar(0xa1,sensorPosition[0]+2);
   mapchar(0xa3,sensorPosition[0]+3);
   /* 
  if(MwSensorPresent&ACCELEROMETER) mapchar("0xa0",sensorPosition[0]);
  else ;
  if(MwSensorPresent&BAROMETER)     screenBuffer[1]=0xa2;
  else screenBuffer[1]=' ';
  if(MwSensorPresent&MAGNETOMETER)  screenBuffer[2]=0xa1;
  else screenBuffer[2]=' ';
  if(MwSensorPresent&GPSSENSOR)     screenBuffer[3]=0xa3;
  else screenBuffer[3]=' ';
  screenBuffer[4]=0;
  MAX7456_WriteString(screenBuffer,sensorPosition[videoSignalType][screenType]);
  */
}







/////////////////////////////////////////////////////////////////////////////////////////////////////////////////// BEGIN FILE OPS//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




//save the content of the model to a file
public void bSAVE() {
  updateModel();
  SwingUtilities.invokeLater(new Runnable(){
    public void run() {
     final JFileChooser fc = new JFileChooser(dataPath("")) {

        private static final long serialVersionUID = 7919427933588163126L;

        public void approveSelection() {
            File f = getSelectedFile();
            if (f.exists() && getDialogType() == SAVE_DIALOG) {
                int result = JOptionPane.showConfirmDialog(this,
                        "The file exists, overwrite?", "Existing file",
                        JOptionPane.YES_NO_CANCEL_OPTION);
                switch (result) {
                case JOptionPane.YES_OPTION:
                    super.approveSelection();
                    return;
                case JOptionPane.CANCEL_OPTION:
                    cancelSelection();
                    return;
                default:
                    return;
                }
            }
            super.approveSelection();
        }
    };

      fc.setDialogType(JFileChooser.SAVE_DIALOG);
      fc.setFileFilter(new MwiFileFilter());
      int returnVal = fc.showSaveDialog(null);
      if (returnVal == JFileChooser.APPROVE_OPTION) {
        File file = fc.getSelectedFile();
        String filePath = file.getPath();
        if(!filePath.toLowerCase().endsWith(".osd")){
          file = new File(filePath + ".osd");
        }

        
        FileOutputStream out =null;
        String error = null;
        try{
          out = new FileOutputStream(file) ;
          MWI.conf.storeToXML(out, "RUSH_OSD Configuration File  " + new  Date().toString());
          JOptionPane.showMessageDialog(null,new StringBuffer().append("configuration saved : ").append(file.toURI()) );
        }catch(FileNotFoundException e){
         
          error = e.getCause().toString();
        }catch( IOException ioe){
                /*failed to write the file*/
                ioe.printStackTrace();
                error = ioe.getCause().toString();
        }finally{
                
          if (out!=null){
            try{
              out.close();
            }catch( IOException ioe){/*failed to close the file*/error = ioe.getCause().toString();}
          }
          if (error !=null){
                  JOptionPane.showMessageDialog(null, new StringBuffer().append("error : ").append(error) );
          }
        }
    }
    }
  }
  );
}

public void updateModel(){
  for(int j=0;j<ConfigNames.length;j++) {
         MWI.setProperty(ConfigNames[j],String.valueOf(confItem[j].value()));
  }
}

public void updateView(){
  for(int j=0; j<ConfigNames.length; j++) {
    
    //confItem[j].setValue(int(MWI.getProperty(ConfigNames[j])));
    if(j >= CONFIGITEMS)
    return;
  int value = int(MWI.getProperty(ConfigNames[j]));
  confItem[j].setValue(value);
  if (j == CONFIGITEMS-1){
    //buttonWRITE.setColorBackground(green_);
  }  
  if (value >0){
    toggleConfItem[j].setValue(1);
    }
    else {
    toggleConfItem[j].setValue(0);
  }

  try{
    switch(value) {
    case(0):
      RadioButtonConfItem[j].activate(0);
      break;
    case(1):
      RadioButtonConfItem[j].activate(1);
      break;
    }
  }
  catch(Exception e) {}finally {}
  }
  BuildCallSign();
}

public class MwiFileFilter extends FileFilter {
  public boolean accept(File f) {
    if(f != null) {
      if(f.isDirectory()) {
        return true;
      }
      String extension = getExtension(f);
      if("osd".equals(extension)) {
        return true;
      }
    }
    return false;
  }


  public String getExtension(File f) {
    if(f != null) {
      String filename = f.getName();
      int i = filename.lastIndexOf('.');
      if(i>0 && i<filename.length()-1) {
        return filename.substring(i+1).toLowerCase();
      }
    }
    return null;
  } 

  public String getDescription() {
    return "*.osd KVT_OSD configuration file";
  }   
}




// import the content of a file into the model
public void bIMPORT(){
  SwingUtilities.invokeLater(new Runnable(){
    public void run(){
      final JFileChooser fc = new JFileChooser(dataPath(""));
      fc.setDialogType(JFileChooser.SAVE_DIALOG);
      fc.setFileFilter(new MwiFileFilter());
      int returnVal = fc.showOpenDialog(null);
      if (returnVal == JFileChooser.APPROVE_OPTION) {
        File file = fc.getSelectedFile();
        FileInputStream in = null;
        boolean completed = false;
        String error = null;
        try{
          in = new FileInputStream(file) ;
          MWI.conf.loadFromXML(in); 
          JOptionPane.showMessageDialog(null,new StringBuffer().append("configuration loaded : ").append(file.toURI()) );
          completed  = true;
          
        }catch(FileNotFoundException e){
                error = e.getCause().toString();

        }catch( IOException ioe){/*failed to read the file*/
                ioe.printStackTrace();
                error = ioe.getCause().toString();
        }finally{
          if (!completed){
                 // MWI.conf.clear();
                 // or we can set the properties with view values, sort of 'nothing happens'
                 updateModel();
          }
          updateView();
          if (in!=null){
            try{
              in.close();
            }catch( IOException ioe){/*failed to close the file*/}
          }
          
          if (error !=null){
                  JOptionPane.showMessageDialog(null, new StringBuffer().append("error : ").append(error) );
          }
        }
      }
    }
  }
  );
}


//  our model 
static class MWI {
  private static Properties conf = new Properties();
  public static void setProperty(String key ,String value ){
    conf.setProperty( key,value );
  }
  public static String getProperty(String key ){
    return conf.getProperty( key,"0");
  }
  public static void clear( ){
    conf= null; // help gc
    conf = new Properties();
  }
}



public void updateConfig(){
  String error = null;
  FileOutputStream out =null;
  
  ConfigClass.setProperty("StartFontFile",FontFileName);
  
  
  File file = new File(dataPath("GUI.Config"));
  try{
    out = new FileOutputStream(file) ;
    ConfigClass.conf.storeToXML(out, "KV_Team_OSD GUI Configuration File  " + new  Date().toString());
    }catch(FileNotFoundException e){
      error = e.getCause().toString();
      }catch( IOException ioe){
        /*failed to write the file*/
        ioe.printStackTrace();
        error = ioe.getCause().toString();
      }finally{
        if (out!=null){
          try{
            out.close();
            }catch( IOException ioe){/*failed to close the file*/error = ioe.getCause().toString();}
            }
            if (error !=null){
              JOptionPane.showMessageDialog(null, new StringBuffer().append("error : ").append(error) );
            }
      }
}


public void LoadConfig(){
  String error = null;
  FileInputStream in =null;  
  try{
   
    in = new FileInputStream(dataPath("GUI.Config"));
  }catch(FileNotFoundException e){
    System.out.println("Configuration Failed- Creating Default");
    updateConfig();
    }catch( IOException ioe){
      /*failed to write the file*/
      ioe.printStackTrace();
      error = ioe.getCause().toString();
    }//finally{
      if (in!=null){
        try{
          ConfigClass.conf.loadFromXML(in); 
          FontFileName = ConfigClass.getProperty("StartFontFile");
          img_Clear = LoadFont(FontFileName);
          System.out.println("Configuration Successful");
          in.close();
          }catch( IOException ioe){/*failed to close the file*/error = ioe.getCause().toString();}
          }
          if (error !=null){
            JOptionPane.showMessageDialog(null, new StringBuffer().append("error : ").append(error) );
          }
    //}
    
}

//  our configuration 
static class ConfigClass {
  private static Properties conf = new Properties();
  public static void setProperty(String key ,String value ){
    conf.setProperty( key,value );
  }
  public static String getProperty(String key ){
    return conf.getProperty( key,"0");
  }
  public static void clear( ){
    conf= null; // help gc
    conf = new Properties();
  }
}
















        
        
        
        


void mouseReleased() {
  mouseDown = false;
  mouseUp = true;
  if (curPixel>-1)changePixel(curPixel);
  if (curChar>-1)GetChar(curChar);
  ControlLock();
  
} 

        
public void mousePressed() {
                mouseDown = true;
                mouseUp = false;
        }



        public boolean mouseDown() {
                return mouseDown;
        }

        public boolean mouseUp() {
                return mouseUp;
        }
        
        
void SketchUploader(){
  String ArduioLocal = ConfigClass.getProperty("ArduinoLocation");
  if (ArduioLocal == "0"){
   try {  
    SwingUtilities.invokeAndWait(new Runnable(){
    public void run(){
      JFileChooser fc = new JFileChooser();
      fc.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
      fc.setDialogType(JFileChooser.SAVE_DIALOG);
      fc.setDialogTitle("Select Arduino Folder");
      //fc.setFileFilter(new FontFileFilter());
      //fc.setCurrentDirectory();
      int returnVal = fc.showOpenDialog(null);
      if (returnVal == JFileChooser.APPROVE_OPTION) {
        File ArduioFile = fc.getSelectedFile();
        String ArduioLocal = ArduioFile.getPath();
        ConfigClass.setProperty("ArduinoLocation",ArduioLocal);
        updateConfig();
        
        String error = null;
        
      }
    }
  }
  );  
  } catch (Exception e) { }
  }

  toggleMSP_Data = false;
  //delay(1000);
  InitSerial(200.00);
  updateConfig(); 
  //if (init_com==1){
    //init_com=0;
  //g_serial.stop();
  //}
  
 
  
  super.exit();
}


