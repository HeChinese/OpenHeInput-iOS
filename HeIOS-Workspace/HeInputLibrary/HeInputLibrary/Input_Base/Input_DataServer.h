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
//#import "FMDatabase.h"
#import "Input_Setting.h"
#import "EngineCollection.h"

typedef enum {
    MainKeyboardKey,
    NumPadKey
} KeySource;

typedef enum {
    CandidateArrayChanged,    //shuMa changed and candidateArray changed
    ShuMaChanged,        //Only ShuMa changed, candidateArray keep same
    ChangeSelection,     //Nothing change, but need change selection
    TypeAndTypeBack,    //Type invalid, typed back
    CandidateArrayEmpty,     //Candidate changed to empty
    TypeBackspaceFailed,    //typingstate is empty
    InvalidShuMa,        //Invalid shuMa
    MenuSelected_Repeat,     //need to repeat previous typing
    MenuSelected_InputMode_Changed,  //InputMode changed, need to change keyboard and MenuArray
    MenuSelected_MenuArray_NeedUpdate, //Only need to update MenuArray
    MenuSelected_PleaseSaveSetting,   //please save setting
    MenuSelected_ContinueTyping,     //Continue typing
    MenuSelected_Error          //Error typing
} DataServer_Return;

@interface Input_DataServer : NSObject
{
    EngineCollection *engineCollection;
    FMDatabase *hema_database;
    
    Input_TypingState *typingState;
}

@property KeySource keySource;

@property NSString *SQL_CREATE_LessonRecord;
@property NSString *SQL_DELETE_LessonRecord;
@property NSString *databasePath, *databaseName;

@property (strong, nonatomic) Input_Setting *setting;
@property (strong, nonatomic) NSArray *candidateArray;

@property (readonly) NSUInteger numOfCand;

//@property (strong,nonatomic) NSString * deviceID;
//@property (strong,nonatomic) HeWebService *heWebService;

+ (id)sharedInstance;
- (BOOL)setupUserDatabase;

- (DataServer_Return)typingCharOrNumber:(unichar)uniChar TypedShuMa:(NSInteger)shuMa;
- (BOOL)changeTypingState4Modes:(unichar)uniChar TypedShuMa:(NSInteger)shuMa;

- (NSString*)provideTypedString;
- (NSString*)getPinYinPromptString:(NSString*)danZi;

- (NSString*)provideDanZiCodeString:(NSString*)danZi;

// WithCertainty means
- (ZiCiObject*)provideZiCiObject:(NSString*)ziCiStr WithCertainty:(BOOL)moreCertain;

- (void)clearState;
- (void)heBackspace;
- (BOOL)isStateClean;

//display English Char Code to user, such as: @"1- F1E2T3J4Z5", @"2- B1A2D3P4R5";
- (BOOL)needShowEnglishCodeList;
- (NSUInteger)provideEnglishShuMa;

- (BOOL)isInputable; //when candidate list is manu or EnglishCharPrompt, then it is not inputable
- (BOOL)isChineseCandidate;

- (void)setMenuArray;
- (BOOL)judgeContinueTyping:(NSInteger)ma;

@end
