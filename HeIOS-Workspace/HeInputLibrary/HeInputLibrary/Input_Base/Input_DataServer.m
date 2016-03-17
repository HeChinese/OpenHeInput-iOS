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

#import "Input_DataServer.h"

//HanZi Table
static NSString * const COLUMN_NAME_HanZi = @"HanZi";
static NSString * const COLUMN_NAME_Ma1 = @"M1";
static NSString * const COLUMN_NAME_Ma2 = @"M2";
static NSString * const COLUMN_NAME_Ma3 = @"M3";
static NSString * const COLUMN_NAME_Ma4 = @"M4";
static NSString * const COLUMN_NAME_GBOrder = @"GBOrder";
static NSString * const COLUMN_NAME_B5Order = @"B5Order";

//CiZu Table
static NSString * const COLUMN_NAME_CiZu = @"CiZu";
static NSString * const COLUMN_NAME_HeMaOrder = @"HeMaOrder";
static NSString * const COLUMN_NAME_JianFan = @"JianFan";


static NSString * const COLUMN_NAME_BookNum = @"BookNumber";
static NSString * const COLUMN_NAME_LessonNum = @"LessonNumber";
static NSString * const COLUMN_NAME_NumOfImage = @"NumberOfImage";
static NSString * const COLUMN_NAME_PinYinAndShengDiao = @"PinYinAndShengDiao";
static NSString * const COLUMN_NAME_English = @"English";
static NSString * const COLUMN_NAME_ErZiCi = @"ErZiCi";
static NSString * const COLUMN_NAME_DuoZiCi = @"DuoZiCi";
static NSString * const COLUMN_NAME_PinYinString = @"PinYinString";


@implementation Input_DataServer

// Get the shared instance and create it if necessary.
// Standard practice
+ (id)sharedInstance
{
    static Input_DataServer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init
{
    if (self = [super init])
    {
        //_deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        //_heWebService = [[HeWebService alloc] init];
        
        [self setupUserDatabase];
        
        //lessonRecordDB = [[HeBook_UserData alloc]init];
        //self.lrAtRuntime = [[LessonRecord alloc] init];
    }
    return self;
}

- (BOOL)setupUserDatabase;
{
    self.databaseName = @"hema_db";
    
    self.databasePath = [[NSBundle mainBundle] pathForResource:self.databaseName ofType:@"sqlite"];
    hema_database = [FMDatabase databaseWithPath:self.databasePath];
    
    BOOL success = false;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //Set default to Simplified Chinese
    if(nil == [defaults objectForKey:@"IsSimplifiedChinese"])
	{
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"IsSimplifiedChinese"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
	
	if ([hema_database open])
    {
        success = true;
        engineCollection = [[EngineCollection alloc] initWithDatabase:hema_database];
        typingState = [[Input_TypingState alloc] init];
        _setting = [[Input_Setting alloc] init];
        self.setting.mainKeyboardMode = HeMaMode;
        self.setting.numPadMode = HeMaMode;
        self.setting.currentKeyMode = HeMaMode;
        self.setting.bSimplified_Chinese = [defaults boolForKey:@"IsSimplifiedChinese"];
        self.setting.bNormalZiKu = true;
        self.setting.bPinYinPrompt = true;

        engineCollection.menuArray = [self generateMenuArray];
    }
    
    [hema_database close];
    return success;
}

- (void)setMenuArray;
{
    engineCollection.menuArray = [self generateMenuArray];
}

// return value give caller information to change candidates or
// input inset text to client application.
- (DataServer_Return)typingCharOrNumber:(unichar)uniChar TypedShuMa:(NSInteger)shuMa;
{
    //self.setting.currentKeyMode reseetted here according typingState
    // such as if is menu, or ma1 >=6 && ma1<=9
    if(shuMa == -2 || (typingState.ma1 == 0 && typingState.maShu == 2)) // menu mode
    {
        self.setting.currentKeyMode = HeMaMode;
        [typingState typeShuMa:shuMa];
    }
    else if (typingState.ma1 >=6 && typingState.ma1<=9)
    {
        self.setting.currentKeyMode = HeMaMode;
        [typingState typeShuMa:shuMa];
    }
    else if ([self isStateClean] &&  ((shuMa == 0 && self.keySource == NumPadKey) || (shuMa>=6 && shuMa<=9)))
    {
        self.setting.currentKeyMode = HeMaMode;
        [typingState typeShuMa:shuMa];
    }
    else
    {
        if(![self changeTypingState4Modes:uniChar TypedShuMa:shuMa])
        {
            return InvalidShuMa;
        }
    }
    
    //Function menu, such as 0 
    if((typingState.ma1 == 0 || typingState.ma1 == -2) && typingState.maShu == 4)
    {
        DataServer_Return retValue = [self menuSelected];
        
        switch (retValue) {
            case MenuSelected_ContinueTyping:
            case MenuSelected_Repeat:
            case MenuSelected_InputMode_Changed:
            case MenuSelected_MenuArray_NeedUpdate:
            case MenuSelected_PleaseSaveSetting:
                return retValue;
                break;
            case MenuSelected_Error:
                [self changeTypingState4Modes:0xffff TypedShuMa:100];  //typeBack
                return MenuSelected_ContinueTyping;
                break;
            default:
                break;
        }
    }
    
    if([engineCollection generateCandidates:self.setting TypingState:typingState])
    {
        self.candidateArray = engineCollection.candidateArray;
        _numOfCand = [self.candidateArray count];
        
        return CandidateArrayChanged;
    }
    else if(typingState.maShu > 0 || typingState.typedEngStrLen >0 || typingState.engShuMa>0)
    {
        //means did not get cursor for typingState, need do typeBack.
        //however this typeback is inside dataServer, do not need to update Cursor and UI
        if(self.setting.currentKeyMode == HeMaMode)
        {
            if(typingState.maShu <=5)
            {
                //41 15 does not have danzi, but should not typeback, since we need to type CiZu
                //updateTypedMaView();
                return ShuMaChanged;
            }
            else if(typingState.previousShuMa == 0) //when 7 43 0, should change selection
            {
                [self changeTypingState4Modes:0xffff TypedShuMa:100];
                return ChangeSelection;
            }
        }
        
        [self changeTypingState4Modes:0xffff TypedShuMa:100]; //typeback
        
        return TypeAndTypeBack;
    }
    else
    {
        return CandidateArrayEmpty;
    }
}

- (BOOL)changeTypingState4Modes:(unichar)uniChar TypedShuMa:(NSInteger)shuMa
{
    BOOL bRet = false;
    
    if([self isMenuShow])
    {
        bRet =[typingState typeShuMa:shuMa];
    }
    else
    {
        switch(self.setting.currentKeyMode)
        {
            case HeMaMode:
                bRet =[typingState typeShuMa:shuMa];
                break;
            case PinYinMode:
            case HeEnglishMode:
                bRet =[typingState typeEnglishCharOrShuMa: uniChar TypedShuMa:shuMa];
                break;
            default:
                break;
        }
    }
    return bRet;
}

- (BOOL)isMenuShow
{
    return (typingState.maShu>=2 && (typingState.ma1==0 || typingState.ma1 == -2));
}

- (NSString*)provideTypedString;
{
    NSString *str=@"";
    
    if([self isMenuShow])
    {
        str = [typingState provideMenuTypedMaStr];
    }
    else if (typingState.ma1>=6 && typingState.ma1<=9)
    {
        str = [typingState provideTypedMaStr];
    }
    else
    {
        switch(self.setting.currentKeyMode)
        {
            case HeMaMode:
                str = [typingState provideTypedMaStr];
                break;
            case PinYinMode:
                str = [typingState getTypedEngStr];
                break;
            case HeEnglishMode:
                str = [typingState getTypedEngStr];
                break;
            default:
                break;
        }
    }
    return str;
}

- (NSString*)getPinYinPromptString:(NSString*)danZi
{
    if(self.setting.bPinYinPrompt)
    {
        if(typingState.typedEngStrLen >=1 && self.setting.currentKeyMode == PinYinMode)
        {
            return [engineCollection getPinYinPromptStr:danZi];
        }
        else if(typingState.maShu <= 3  &&  (typingState.ma1 == 0 || typingState.ma1 == -2))
        {
            return @"";
        }
        else
            return [engineCollection getPinYinPromptStr:danZi];
    }
    else
        return @"";
}

- (ZiCiObject*)provideZiCiObject:(NSString*)ziCiStr WithCertainty:(BOOL)moreCertain
{
    return [engineCollection provideZiCiObject:ziCiStr WithCertainty:moreCertain];
}

- (NSString*)provideDanZiCodeString:(NSString*)danZi;
{
    ZiCiObject *ziCiObj = [engineCollection provideZiCiObject:danZi WithCertainty:YES];
    
    if (![self isInputable]) {
        return @"";
    }
    else if ( typingState.typedEngStr.length >= 1) {
        return [NSString stringWithFormat:@"[%2ld %2ld %2ld]",
            (long)ziCiObj.ma1,
            (long)ziCiObj.ma2,
            (long)ziCiObj.ma3];
    }
    else {
       return @"";
    }
}

- (void)clearState;
{
    self.candidateArray = nil;
    _numOfCand = 0;
    [typingState clearState];
}

- (void)heBackspace;
{
    [self changeTypingState4Modes:0xffff TypedShuMa:100];
}

- (BOOL)isStateClean;
{
    return (typingState.maShu ==0 && typingState.engShuMa == 0 && typingState.typedEngStrLen == 0);
}

- (BOOL)needShowEnglishCodeList;
{
    return typingState.maShu == 0 && typingState.engShuMa >= 1 && typingState.engShuMa <= 5; //&& typingState.typedEngStrLen == 0
}

- (NSUInteger)provideEnglishShuMa;
{
    return typingState.engShuMa;
}

- (BOOL)isInputable; //when candidate list is manu or EnglishCharPrompt, then it is not inputable
{
    if([self needShowEnglishCodeList])
    {
        return false;
    }
    else if((typingState.ma1 == 0 || typingState.ma1 == -2) && typingState.maShu>=2)
    {
        return false;
    }
    else if(self.numOfCand == 0)
    {
        return false;
    }
    return true;
}

- (BOOL)isChineseCandidate; //when candidate list is manu or EnglishCharPrompt, then it is not inputable
{
    if (self.numOfCand > 0 && typingState.ma1 >=11 && typingState.ma1 <=55) {
        return true;
    }
    
    if(typingState.typedEngStrLen > 0 && self.setting.currentKeyMode==PinYinMode)
    {
        return true;
    }
    
    if(typingState.typedEngStrLen > 0 && self.setting.currentKeyMode==HeEnglishMode)
    {
        return false;
    }
    
    return false;
}

- (BOOL)judgeContinueTyping:(NSInteger)ma;
{
    if (typingState.ma1>10 && typingState.maShu==8 && self.numOfCand>0) {
        return true;
    }
    //else if (ma>5 && ma<10 && self.numOfCand>0 && (typingState.ma1>10 || typingState.typedEngStrLen>0))
    
    return false;
}

//This function need to use resource to get localized string
//So must stay in DataServer class.
- (NSArray*)generateMenuArray
{
    NSMutableArray *menuArray = [[NSMutableArray alloc] init];
    ZiCiObject *ziCiObj = nil;

    ziCiObj = [[ZiCiObject alloc] init];
    ziCiObj.ziCi = NSLocalizedString(@"menu_repeat", @"Repeat");
    ziCiObj.ma1 = 0;
    ziCiObj.ma2 = 0;
    [menuArray addObject:ziCiObj];
    
    ziCiObj = [[ZiCiObject alloc] init];
    ziCiObj.ziCi = NSLocalizedString(@"menu_punctuation", @"punctuation");
    ziCiObj.ma1 = 0;
    ziCiObj.ma2 = 11;
    [menuArray addObject:ziCiObj];

    ziCiObj = [[ZiCiObject alloc] init];
    ziCiObj.ziCi = NSLocalizedString(@"menu_math_symbol", @"Math Symbol");
    ziCiObj.ma1 = 0;
    ziCiObj.ma2 = 12;
    [menuArray addObject:ziCiObj];
    
    ziCiObj = [[ZiCiObject alloc] init];
    ziCiObj.ziCi = NSLocalizedString(@"menu_number", @"number");
    ziCiObj.ma1 = 0;
    ziCiObj.ma2 = 13;
    [menuArray addObject:ziCiObj];
    
    ziCiObj = [[ZiCiObject alloc] init];
    ziCiObj.ziCi = NSLocalizedString(@"menu_english_char", @"English Char");
    ziCiObj.ma1 = 0;
    ziCiObj.ma2 = 14;
    [menuArray addObject:ziCiObj];
    
    if (self.setting.mainKeyboardMode != HeMaMode || self.setting.numPadMode != HeMaMode)
    {
        ziCiObj = [[ZiCiObject alloc] init];
        ziCiObj.ziCi = NSLocalizedString(@"menu_he_chinese_input", @"HeMa Input");
        ziCiObj.ma1 = -2;
        ziCiObj.ma2 = 21;
        [menuArray addObject:ziCiObj];
    }
    
    if (self.setting.mainKeyboardMode != PinYinMode || self.setting.numPadMode != PinYinMode)
    {
        ziCiObj = [[ZiCiObject alloc] init];
        ziCiObj.ziCi = NSLocalizedString(@"menu_pinyin_input", @"PinYin Input");
        ziCiObj.ma1 = -2;
        ziCiObj.ma2 = 22;
        [menuArray addObject:ziCiObj];
    }
    
//    if(self.setting.currentKeyMode != NumberMode)
//    {
//        ziCiObj = [[ZiCiObject alloc] init];
//        ziCiObj.ziCi = NSLocalizedString(@"menu_numpad", @"Number");
//        ziCiObj.ma1 = -2;
//        ziCiObj.ma2 = 23;
//        [menuArray addObject:ziCiObj];
//    }

    //cursor.addRow(new Object[] { context.getResources().getString(R.string.menu_symbol_input), -2, 23});
    /*
     if(setting.currentKeyMode != InputMode.NumberMode)
     {
     cursor.addRow(new Object[] { context.getResources().getString(R.string.menu_number_input), -2, 24});
     }
     //*/
    
//    if(self.setting.currentKeyMode != HeEnglishMode)
//    {
//        ziCiObj = [[ZiCiObject alloc] init];
//        ziCiObj.ziCi = NSLocalizedString(@"menu_he_english_input", @"HeEnglish Input");
//        ziCiObj.ma1 = -2;
//        ziCiObj.ma2 = 25;
//        [menuArray addObject:ziCiObj];
//    }
    
//    if(self.setting.currentKeyMode != EnglishMode)
//    {
//        ziCiObj = [[ZiCiObject alloc] init];
//        ziCiObj.ziCi = NSLocalizedString(@"menu_english_input", @"English Input");
//        ziCiObj.ma1 = -2;
//        ziCiObj.ma2 = 31;
//        [menuArray addObject:ziCiObj];
//    }
    
    if (self.setting.mainKeyboardMode == HeMaMode || self.setting.numPadMode == HeMaMode)
    {
        if(self.setting.bSimplified_Chinese)
        {
            ziCiObj = [[ZiCiObject alloc] init];
            ziCiObj.ziCi = NSLocalizedString(@"menu_use_traditional", @"Traditional Chinese");
            ziCiObj.ma1 = -2;
            ziCiObj.ma2 = 41;
            [menuArray addObject:ziCiObj];
        }
        else
        {
            ziCiObj = [[ZiCiObject alloc] init];
            ziCiObj.ziCi = NSLocalizedString(@"menu_use_simplified", @"Simplified Chinese");
            ziCiObj.ma1 = -2;
            ziCiObj.ma2 = 41;
            [menuArray addObject:ziCiObj];
        }        
    }
    
    if (self.setting.mainKeyboardMode == HeMaMode || self.setting.numPadMode == HeMaMode)
    {
        if(self.setting.bNormalZiKu)
        {
            ziCiObj = [[ZiCiObject alloc] init];
            ziCiObj.ziCi = NSLocalizedString(@"menu_use_big_collection", @"Big ZiKu");
            ziCiObj.ma1 = -2;
            ziCiObj.ma2 = 42;
            [menuArray addObject:ziCiObj];
        }
        else
        {
            ziCiObj = [[ZiCiObject alloc] init];
            ziCiObj.ziCi = NSLocalizedString(@"menu_use_small_collection", @"Small ZiKu");
            ziCiObj.ma1 = -2;
            ziCiObj.ma2 = 42;
            [menuArray addObject:ziCiObj];
        }
    }
    
//    if(self.setting.currentKeyMode == HeMaMode || self.setting.currentKeyMode == PinYinMode)
//    {
//        if(self.setting.bPinYinPrompt)
//        {
//            ziCiObj = [[ZiCiObject alloc] init];
//            ziCiObj.ziCi = NSLocalizedString(@"menu_turn_off_pinyin_prompt", @"PinYin Prompt OFF");
//            ziCiObj.ma1 = -2;
//            ziCiObj.ma2 = 43;
//            [menuArray addObject:ziCiObj];
//        }
//        else
//        {
//            ziCiObj = [[ZiCiObject alloc] init];
//            ziCiObj.ziCi = NSLocalizedString(@"menu_turn_on_pinyin_prompt", @"PinYin Prompt On");
//            ziCiObj.ma1 = -2;
//            ziCiObj.ma2 = 43;
//            [menuArray addObject:ziCiObj];
//        }
//    }
    /*
     if(setting.bSystemLianXiangOn)
     {
     }
     else
     {
     
     }
     //*/
    
    /*
    if(self.setting.currentKeyMode == HeMaMode)
    {
        if(self.setting.bHeMaModeNumpad)
        {
            ziCiObj = [[ZiCiObject alloc] init];
            ziCiObj.ziCi = NSLocalizedString(@"menu_big_number_keyboard", @"Big Number Pad");
            ziCiObj.ma1 = -2;
            ziCiObj.ma2 = 44;
            [menuArray addObject:ziCiObj];
        }
        else
        {
            ziCiObj = [[ZiCiObject alloc] init];
            ziCiObj.ziCi = NSLocalizedString(@"menu_numpad", @"NumPad ");
            ziCiObj.ma1 = -2;
            ziCiObj.ma2 = 43;
            [menuArray addObject:ziCiObj];
        }
    }
    else if(self.setting.currentKeyMode == PinYinMode)
    {
        if(self.setting.bPinYinModeNumpad)
        {
            ziCiObj = [[ZiCiObject alloc] init];
            ziCiObj.ziCi = NSLocalizedString(@"menu_big_char_keyboard", @"Big Char Keyboard");
            ziCiObj.ma1 = -2;
            ziCiObj.ma2 = 44;
            [menuArray addObject:ziCiObj];
        }
        else
        {
            ziCiObj = [[ZiCiObject alloc] init];
            ziCiObj.ziCi = NSLocalizedString(@"menu_numpad", @"Num Pad");
            ziCiObj.ma1 = -2;
            ziCiObj.ma2 = 44;
            [menuArray addObject:ziCiObj];
        }
    }
    else if(self.setting.currentKeyMode == HeEnglishMode)
    {
        if(self.setting.bHeEnglishModeNumpad)
        {
            ziCiObj = [[ZiCiObject alloc] init];
            ziCiObj.ziCi = NSLocalizedString(@"menu_big_char_keyboard", @"Big Char Keyboard On");
            ziCiObj.ma1 = -2;
            ziCiObj.ma2 = 44;
            [menuArray addObject:ziCiObj];
        }
        else
        {
            ziCiObj = [[ZiCiObject alloc] init];
            ziCiObj.ziCi = NSLocalizedString(@"menu_numpad", @"NumPad");
            ziCiObj.ma1 = -2;
            ziCiObj.ma2 = 44;
            [menuArray addObject:ziCiObj];
        }
    }
    //*/
    
    /*
    ziCiObj = [[ZiCiObject alloc] init];
    ziCiObj.ziCi = NSLocalizedString(@"menu_save_setting", @"Save Setting");
    ziCiObj.ma1 = -2;
    ziCiObj.ma2 = 55;
    [menuArray addObject:ziCiObj];
    //*/
    
    return menuArray;
}

- (DataServer_Return)menuSelected;
{
    //BOOL bRet = false; //get the selection
    DataServer_Return retValue = MenuSelected_Error;
    //ma1 == 0 or ma1 == -2
    switch(typingState.ma2)
    {
        case 0:
            //repeat typedString
            retValue = MenuSelected_Repeat;
            break;
        case 11:
            typingState.ma1 = 6;
            typingState.maShu = 2;
            retValue = MenuSelected_ContinueTyping;
            break;
        case 12:
            typingState.ma1 = 7;
            typingState.maShu = 2;
            retValue = MenuSelected_ContinueTyping;
            break;
        case 13:
            typingState.ma1 = 8;
            typingState.maShu = 2;
            retValue = MenuSelected_ContinueTyping;
            break;
        case 14:
            typingState.ma1 = 9;
            typingState.maShu = 2;
            retValue = MenuSelected_ContinueTyping;
            break;
			//-------------------
        case 21:
        {
            if (self.keySource == MainKeyboardKey) {
                self.setting.mainKeyboardMode = HeMaMode;
            }
            else {
                self.setting.numPadMode = HeMaMode;
            }
            self.setting.currentKeyMode = HeMaMode;
            
            retValue = MenuSelected_InputMode_Changed;
        }
            break;
        case 22:
        {
            if (self.keySource == MainKeyboardKey) {
                self.setting.mainKeyboardMode = PinYinMode;
            }
            else {
                self.setting.numPadMode = PinYinMode;
            }
            self.setting.currentKeyMode = PinYinMode;
            retValue = MenuSelected_InputMode_Changed;
        }
            break;
        case 23:
        {
            if (self.keySource == NumPadKey) {
                self.setting.numPadMode = NumberMode;
            }
            self.setting.currentKeyMode = NumberMode;
            retValue = MenuSelected_InputMode_Changed;
        }
            break;
        case 24:
            break;
	    case 25:
        {
            if (self.keySource == MainKeyboardKey) {
                self.setting.mainKeyboardMode = HeEnglishMode;
            }
            else {
                self.setting.numPadMode = HeEnglishMode;
            }

            self.setting.currentKeyMode = HeEnglishMode;
            retValue = MenuSelected_InputMode_Changed;
        }
            break;
        case 31: //English Mode
        {
            if (self.keySource == MainKeyboardKey) {
                self.setting.mainKeyboardMode = EnglishMode;
            }
            else {
                self.setting.numPadMode = EnglishMode;
            }
            self.setting.currentKeyMode = EnglishMode;
            //dataServerListener.keyboardChange(setting.currentKeyMode);
            //engineCollection.setMenuCursor(generateMenuCursor());
            retValue = MenuSelected_InputMode_Changed;
        }
            break;
        case 41:
        {
            self.setting.bSimplified_Chinese = !self.setting.bSimplified_Chinese;
            
            [[NSUserDefaults standardUserDefaults] setBool:self.setting.bSimplified_Chinese forKey:@"IsSimplifiedChinese"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            retValue = MenuSelected_MenuArray_NeedUpdate;
        }
            break;
        case 42:
            self.setting.bNormalZiKu = !self.setting.bNormalZiKu;
            retValue = MenuSelected_MenuArray_NeedUpdate;
            break;
        case 43:
            self.setting.bPinYinPrompt = !self.setting.bPinYinPrompt;
            retValue = MenuSelected_MenuArray_NeedUpdate;
            break;
        case 44:
            if(self.setting.currentKeyMode == HeMaMode)
            {
                self.setting.bHeMaModeNumpad = !self.setting.bHeMaModeNumpad;
                retValue = MenuSelected_InputMode_Changed;
            }
            else if(self.setting.currentKeyMode == PinYinMode)
            {
                self.setting.bPinYinModeNumpad = !self.setting.bPinYinModeNumpad;
                retValue = MenuSelected_InputMode_Changed;
            }				
            else if(self.setting.currentKeyMode == HeEnglishMode)
            {
                self.setting.bHeEnglishModeNumpad = !self.setting.bHeEnglishModeNumpad;
                retValue = MenuSelected_InputMode_Changed;
            }				
            break;
        case 55:
            //dataServerListener.saveSharedPreferences();
            retValue = MenuSelected_PleaseSaveSetting;
            break;
        default:
            break;				
    }
    
    return retValue;
}

@end
