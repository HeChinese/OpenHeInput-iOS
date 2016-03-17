/*
 * Copyright (c) 2016 Guilin Ouyang. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef HeInput_Globel_h
#define HeInput_Globel_h

//#define ISIPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? TRUE:FALSE
//#define ISIPHONE5 (([[UIScreen mainScreen] bounds].size.height-568) < 0 ? NO : YES)
//#define ISIPHONE6 (([[UIScreen mainScreen] bounds].size.height-640) < 0 ? NO : YES)
//#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width
//#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height

#define IPadHeightPoints 1024       //x 768
#define IPhone6HeightPoints 667     //x 375  (1334x750)
#define IPhone6PlusHeightPoints 640 //x 360  (1920x1080)
#define IPhone5HeightPoints 568     //x 320
#define IPhone4HeightPoints 480     //x 320

#define HEMAORDER_1MAZISPECIAL 0
#define HEMAORDER_1MAZI 1
#define HEMAORDER_2MAZI 2
#define HEMAORDER_3SHUMAZI 3
#define HEMAORDER_3MAZI 4
#define HEMAORDER_4MAZI 5
#define HEMAORDER_CIZU 5
#define HEMAORDER_AFTERCIZU 6
#define HEMAORDER_RONGCUOMA 7
#define HEMAORDER_GBK 8	//more than 7600 hanzi
#define HEMAORDER_ENGCHAR 9

#define HeKeyCode_Escape 16
#define HeKeyCode_UpArrow 112
#define HeKeyCode_DownArrow 113
#define HeKeyCode_LeftArrow 62
#define HeKeyCode_RightArrow 63
#define HeKeyCode_Mode 26
#define HeKeyCode_Space 46
#define HeKeyCode_Return 56
#define HeKeyCode_NumberKeyboard 66
#define HeKeyCode_Backspace 61
#define HeKeyCode_NextInputMode 67
#define HeKeyCode_Zero 0
#define HeKeyCode_One 1
#define HeKeyCode_Two 2
#define HeKeyCode_Three 3
#define HeKeyCode_Four 4
#define HeKeyCode_Five 5
#define HeKeyCode_Six 6
#define HeKeyCode_Seven 7
#define HeKeyCode_Eight 8
#define HeKeyCode_Nine 9

#define HeKeyCode_Underscore 71
#define HeKeyCode_Period 72
#define HeKeyCode_Comma 73

#endif
