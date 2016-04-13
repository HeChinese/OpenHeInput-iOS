# OpenHeInput-iOS

Open Source HeInput project for iOS (iPhone/iPad) using Objective C.

This application is based on iOS 8.0+ App Extension custom keyboard.

Now it is full functional Chinese Input application, can be deployed to iPhone/iPad.

This application is also available in the AppStore:<br/>
https://itunes.apple.com/ca/app/id417876708?mt=8

Input features include:

1. 21,000+ Chinese words;
2. 184,000+ Chinese phrases;
3. Chinese Simplified and Traditional option;
4. Search code with PinYin;
5. Convenient switch between HeInput/PinYin/English/Number input.

Setting steps: 
1. System requirement: iOS 8.0+; 
2. Settings > General > Keyboard > Keyboards > Add a New Keyboard;
3. Select \"OpenHeInput\".

输入法设置：
1. 系统要求: iOS 8.0+； 
2. 设置 > 通用 > 键盘 > 键盘 > 添加新键盘；
3. 选择 \"OpenHeInput\"。

# Application Structure

Created with XCode 7.2 and iOS 9.2.

Workspace Name: HeIOS-Workspace, include 3 modules:

1. Static Library: HeLibrary; 
2. Static Library: HeInputLibrary; 
3. iOS Application: OpenHeInput. 

The main parts of code are:

1. Hekeyboard_ViewController which is inherited from UIInputViewController;
2. Input_DataServer which provide input data;
   1. Input_DataServer includes EngineCollection;
   2. EngineCollection includes HeMaEngine, PinYinEngine, HeEnglishEngine, etc;
   3. Each Engine access SQLite database;

# Database Structure

Include a SQLite database: hema_db.sqlite, it includes tables:

create table HanZi</br>
(</br>
--_id INTEGER PRIMARY KEY,</br>
HanZi text,	</br>
M1 numeric,</br>
M2 numeric,</br>
M3 numeric,</br>
M4 numeric,</br>
GBOrder numeric,</br>
B5Order numeric</br>
);

create table CiZu</br>
(</br>
--_id INTEGER PRIMARY KEY,</br>
CiZu text,	</br>
M1 numeric,</br>
M2 numeric,</br>
M3 numeric,</br>
M4 numeric,</br>
HeMaOrder numeric,</br>
JianFan numeric</br>
);

create table English_Word</br>
(</br>
--_id INTEGER PRIMARY KEY,</br>
word text,	</br>
HeMaOrder numeric</br>
);

create table PinYin_Number</br>
(</br>
--_id INTEGER PRIMARY KEY,</br>
PinYin text,</br>
number numeric</br>
);

create table PinYin_HanZi</br>
(</br>
--_id INTEGER PRIMARY KEY,</br>
PinYin text,	</br>
HanZiString text</br>
);

create table HanZi_PinYin</br>
(</br>
--_id INTEGER PRIMARY KEY,</br>
HanZi text,	</br>
PinYin text,</br>
ShengDiao numeric</br>
);

# ToDo list in short

1. Convienent function for user adding words and phrases;
2. Function for adding users favorite phrases collection;
3. Keyboard skin;
4. Convienent way to input emoji;

# HeInput related information:

http://www.hezi.net/He/UserGuide_Concise/en-us/Set/HeChinese_Guide_Concise.htm
