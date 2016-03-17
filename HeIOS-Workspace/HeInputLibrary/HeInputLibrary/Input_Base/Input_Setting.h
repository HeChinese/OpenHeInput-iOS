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

#import <Foundation/Foundation.h>

typedef enum
{
    //Main Keyboard HeMa (ZiXin)
    HeMaMode,
    //Main Keyboard PinYin
    PinYinMode,
    
    HeEnglishMode,
    EnglishMode,
    
    //HeMa6KeyTempNum,
    NumberMode,
    //NumberModeTemp	//input number between HeMaMode input, * key can be used for change back to HeMaMode.
    //LianXiangMode				//Indicated by m1 == 99
} Input_Mode;

@interface Input_Setting : NSObject

@property BOOL bHealthy;
@property BOOL bDanZiOnly;
@property BOOL bSimplified_Chinese;
@property BOOL bNormalZiKu;

@property BOOL bLianXiangPurchased;
@property BOOL bLianXiang;		//default is ture;
@property BOOL bPinYinPrompt;
@property BOOL bHeMaModeNumpad;
@property BOOL bPinYinModeNumpad;
@property BOOL bHeEnglishModeNumpad;

@property Input_Mode mainKeyboardMode;
@property Input_Mode numPadMode;
@property Input_Mode currentKeyMode;

//Code addition for main keyboard
@property Input_Mode systemMode;      //For MacOS, HeMaMode,
@property BOOL isSystem_simplified_chinese;

@property BOOL bSystemLianXiangOn;

@end
