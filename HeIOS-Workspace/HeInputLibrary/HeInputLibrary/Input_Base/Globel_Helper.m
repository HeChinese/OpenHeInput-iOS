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

#import "Globel_Helper.h"
#import "MacOS_VirtualKeyCode.h"
#import <UIKit/UIKit.h>
#import "Input_Constants.h"

@implementation Globel_Helper

+(NSUInteger)indexToShuMa:(NSUInteger)index;
{
    return (index/5+1)*10 + (index)%5+1;
}

+(NSUInteger)shuMaToIndex:(NSUInteger)sm;
{
    return (sm/10-1)*5 + (sm%10-1);
}

+(NSString*)indexToCharacterSet:(NSUInteger)index;
{
    //NSUInteger sm = (index/5+1)*10 + (index)%5+1;
    NSString  *characterSetString = @"一乛彐又王丨冂口日月十土卄木米丿亻人女犭丶冫氵火心";
    
    return [characterSetString substringWithRange:NSMakeRange(index, 1)];
}

+(NSString*)shuMaToCharacterSet:(NSUInteger)sm;
{
    NSUInteger index = (sm/10-1)*5 + (sm%10-1);
    return [self indexToCharacterSet:index];
}

+(NSString*)indexToHeEnglishChar:(NSUInteger)index;
{
    NSUInteger sm = 0;
    
    if (index == 25) {
        sm = 36;  //"M"
    }
    else
    {
        sm = (index/5+1)*10 + (index)%5+1;
    }
    
    return [self shuMaToHeEnglishChar:sm];
}

+(NSString*)shuMaToHeEnglishChar:(NSUInteger)sm;
{
    switch (sm)
    {
        case 11: return @"F"; break;
        case 12: return @"E"; break;
        case 13: return @"T"; break;
        case 14: return @"J"; break;
        case 15: return @"Z"; break;
        case 21: return @"B"; break;
        case 22: return @"A"; break;
        case 23: return @"D"; break;
        case 24: return @"P"; break;
        case 25: return @"R"; break;
        case 31: return @"L"; break;
        case 32: return @"I"; break;
        case 33: return @"N"; break;
        case 34: return @"H"; break;
        case 35: return @"K"; break;
        case 36: return @"M"; break;  //"M"
        case 41: return @"C"; break;
        case 42: return @"O"; break;
        case 43: return @"S"; break;
        case 44: return @"G"; break;
        case 45: return @"Q"; break;
        case 51: return @"V"; break;
        case 52: return @"U"; break;
        case 53: return @"W"; break;
        case 54: return @"Y"; break;
        case 55: return @"X"; break;
        default:
            break;
    }
    
    return nil;
}

+ (NSUInteger)charToShuMa:(unichar)c
{
    short ma;
    switch (c) {
        case 't': case 'T': ma=11; 	break;
        case 'r': case 'R': ma=12; 	break;
        case 'e': case 'E': ma=13; 	break;
        case 'w': case 'W': ma=14; 	break;
        case 'q': case 'Q': ma=15; 	break;
        case 'y': case 'Y': ma=21; 	break;
        case 'u': case 'U': ma=22; 	break;
        case 'i': case 'I': ma=23; 	break;
        case 'o': case 'O': ma=24; 	break;
        case 'p': case 'P': ma=25; 	break;
        case 'g': case 'G': ma=31; 	break;
        case 'f': case 'F': ma=32; 	break;
        case 'd': case 'D': ma=33; 	break;
        case 's': case 'S': ma=34; 	break;
        case 'a': case 'A': ma=35; 	break;
        case 'h': case 'H': ma=41; 	break;
        case 'j': case 'J': ma=42; 	break;
        case 'k': case 'K': ma=43; 	break;
        case 'l': case 'L': ma=44; 	break;
        case 'n': case 'N': ma=45; 	break;
        case 'b': case 'B': ma=51; 	break;
        case 'v': case 'V': ma=52; 	break;
        case 'c': case 'C': ma=53; 	break;
        case 'x': case 'X': ma=54; 	break;
        case 'z': case 'Z': ma=55; 	break;
        case 'm': case 'M': ma=0; 	break;
        default :
            ma=0;
            break;
    }
    
    return ma;
}

+ (int) screenDimensionLarge;
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return  MAX(screenRect.size.height,screenRect.size.width);
}

+ (int) screenDimensionSmall;
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return  MIN(screenRect.size.height,screenRect.size.width);
}

+ (int) detectScreenHeightPoints;
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        return IPadHeightPoints;
    }
    else
    {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        //CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = MAX(screenRect.size.height,screenRect.size.width);
        
        if (screenHeight >= IPhone6HeightPoints) {
            return IPhone6HeightPoints;
        }
        else if (screenHeight >= IPhone6PlusHeightPoints) {
            return IPhone6PlusHeightPoints;
        }
        else if (screenHeight >= IPhone5HeightPoints) {
            return IPhone5HeightPoints;
        }
        else
            return IPhone4HeightPoints;
    }
}

/*
+(NSUInteger)keyCodeToShuMa:(NSInteger)keyCode {
    
    NSUInteger ma;
    
    switch (keyCode) {
        case kVK_ANSI_T: ma=11; 	break;
        case kVK_ANSI_R: ma=12; 	break;
        case kVK_ANSI_E: ma=13; 	break;
        case kVK_ANSI_W: ma=14; 	break;
        case kVK_ANSI_Q: ma=15; 	break;
        case kVK_ANSI_Y: ma=21; 	break;
        case kVK_ANSI_U: ma=22; 	break;
        case kVK_ANSI_I: ma=23; 	break;
        case kVK_ANSI_O: ma=24; 	break;
        case kVK_ANSI_P: ma=25; 	break;
        case kVK_ANSI_G: ma=31; 	break;
        case kVK_ANSI_F: ma=32; 	break;
        case kVK_ANSI_D: ma=33; 	break;
        case kVK_ANSI_S: ma=34; 	break;
        case kVK_ANSI_A: ma=35; 	break;
        case kVK_ANSI_H: ma=41; 	break;
        case kVK_ANSI_J: ma=42; 	break;
        case kVK_ANSI_K: ma=43; 	break;
        case kVK_ANSI_L: ma=44; 	break;
        case kVK_ANSI_N: ma=45; 	break;
        case kVK_ANSI_B: ma=51; 	break;
        case kVK_ANSI_V: ma=52; 	break;
        case kVK_ANSI_C: ma=53; 	break;
        case kVK_ANSI_X: ma=54; 	break;
        case kVK_ANSI_Z: ma=55; 	break;
        case kVK_ANSI_M: ma=0;      break;
            
        case kVK_ANSI_Keypad0: ma=0; 	break;
        case kVK_ANSI_Keypad1: ma=1; 	break;
        case kVK_ANSI_Keypad2: ma=2; 	break;
        case kVK_ANSI_Keypad3: ma=3; 	break;
        case kVK_ANSI_Keypad4: ma=4; 	break;
        case kVK_ANSI_Keypad5: ma=5; 	break;
        case kVK_ANSI_Keypad6: ma=6; 	break;
        case kVK_ANSI_Keypad7: ma=7; 	break;
        case kVK_ANSI_Keypad8: ma=8; 	break;
        case kVK_ANSI_Keypad9: ma=9; 	break;
            
        default :
            ma=0;
            break;
    }
    return ma;
}

+(BOOL)is26EnglishCharKey:(NSInteger)keyCode{
 
    bool bRet = false;
    
    switch (keyCode) {
        case kVK_ANSI_A:
        case kVK_ANSI_B:
        case kVK_ANSI_C:
        case kVK_ANSI_D:
        case kVK_ANSI_E:
        case kVK_ANSI_F:
        case kVK_ANSI_G:
        case kVK_ANSI_H:
        case kVK_ANSI_I:
        case kVK_ANSI_J:
        case kVK_ANSI_K:
        case kVK_ANSI_L:
        case kVK_ANSI_M:
        case kVK_ANSI_N:
        case kVK_ANSI_O:
        case kVK_ANSI_P:
        case kVK_ANSI_Q:
        case kVK_ANSI_R:
        case kVK_ANSI_S:
        case kVK_ANSI_T:
        case kVK_ANSI_U:
        case kVK_ANSI_V:
        case kVK_ANSI_W:
        case kVK_ANSI_X:
        case kVK_ANSI_Y:
        case kVK_ANSI_Z:
            bRet = true;
            break;
            
        default:
            break;
    }
    return bRet;
}

+(BOOL)isMainKeyboardNumberKey:(NSInteger)keyCode {
    bool bRet = false;
    
    switch (keyCode) {
        case kVK_ANSI_0:
        case kVK_ANSI_1:
        case kVK_ANSI_2:
        case kVK_ANSI_3:
        case kVK_ANSI_4:
        case kVK_ANSI_5:
        case kVK_ANSI_6:
        case kVK_ANSI_7:
        case kVK_ANSI_8:
        case kVK_ANSI_9:
            bRet = true;
            break;
            
        default:
            break;
    }

    return bRet;
}

+(BOOL)isNumberPadNumberKey:(NSInteger)keyCode {
    bool bRet = false;
    
    switch (keyCode) {
            
        case kVK_ANSI_Keypad0:
        case kVK_ANSI_Keypad1:
        case kVK_ANSI_Keypad2:
        case kVK_ANSI_Keypad3:
        case kVK_ANSI_Keypad4:
        case kVK_ANSI_Keypad5:
        case kVK_ANSI_Keypad6:
        case kVK_ANSI_Keypad7:
        case kVK_ANSI_Keypad8:
        case kVK_ANSI_Keypad9:
            
            bRet = true;
            break;
            
        default:
            break;
    }
    
    return bRet;
}

+(BOOL)isPunctuationKey:(NSInteger)keyCode {
    bool bRet = false;
    
    switch (keyCode) {
        case kVK_ANSI_Equal:
        case kVK_ANSI_Minus:
        case kVK_ANSI_RightBracket:
        case kVK_ANSI_LeftBracket:
        case kVK_ANSI_Quote:
        case kVK_ANSI_Semicolon:
        case kVK_ANSI_Backslash:
        case kVK_ANSI_Comma:
        case kVK_ANSI_Slash:
        case kVK_ANSI_Period:
        //case kVK_ANSI_Grave:
            
            bRet = true;
            break;
        default:
            break;
    }    
    return bRet;
}

// control keys need to process
+(BOOL)isMainKeyboardControlKey:(NSInteger)keyCode {
    bool bRet = false;
    
    switch (keyCode) {
            
        case kVK_Space:
        //case kVK_Tab:
        case kVK_Delete:
        //case kVK_Command:
        //case kVK_Shift:
        //case kVK_CapsLock:
        //case kVK_Option:
        //case kVK_Control:
        //case kVK_RightShift:
        //case kVK_RightOption:
        //case kVK_RightControl:
        //case kVK_Function:
        case kVK_VolumeUp:
        case kVK_VolumeDown:
        //case kVK_Mute:
        //case kVK_Help:
        //case kVK_Home:
        //case kVK_PageUp:
        //case kVK_ForwardDelete:
        //case kVK_End:
            // IMK don't need to process following keys
            // IMKCandidates class has good defaults function for these keys
            
        case kVK_Return:
        case kVK_Escape:
        case kVK_PageUp:
        case kVK_PageDown:
        case kVK_LeftArrow:
        case kVK_RightArrow:
        case kVK_DownArrow:
        case kVK_UpArrow:
            
            bRet = true;
            break;
            
        default:
            break;
    }
 
    return bRet;
}

+(BOOL)isNumPadControlKey:(NSInteger)keyCode {
    bool bRet = false;
    
    switch (keyCode) {
        case kVK_ANSI_KeypadClear:
        case kVK_ANSI_KeypadDecimal:
        case kVK_ANSI_KeypadMultiply:
        case kVK_ANSI_KeypadPlus:
        case kVK_ANSI_KeypadDivide:
        case kVK_ANSI_KeypadEnter:
        case kVK_ANSI_KeypadMinus:
        case kVK_ANSI_KeypadEquals:
            
            bRet = true;
        default:
            break;
    }
    
    return bRet;
}
*/
@end
