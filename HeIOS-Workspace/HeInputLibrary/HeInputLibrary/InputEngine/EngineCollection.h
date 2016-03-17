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
#import "HeMaEngine.h"
#import "PinYinEngine.h"
#import "HeEnglishEngine.h"
#import "MenuEngine.h"
#import "Input_Setting.h"
#import "SymbolEngine.h"

@interface EngineCollection : NSObject
{
    HeMaEngine *heMaEngine;
    PinYinEngine *pinYinEngine;
    HeEnglishEngine *heEnglishEngine;
    MenuEngine *menuEngine;
    SymbolEngine *symbolEngine;
    FMDatabase *hemaDatabase;
}

@property (strong, nonatomic) NSArray *menuArray;
@property (readwrite) NSUInteger numOfRows;
@property (strong, nonatomic) NSArray *candidateArray;

- (id)initWithDatabase:(FMDatabase*)heMaDB;

- (BOOL)generateCandidates:(Input_Setting*)setting TypingState: (Input_TypingState*)typingState;
- (NSString*)getPinYinPromptStr:(NSString*)danZi;

- (ZiCiObject*)provideZiCiObject:(NSString*)ziCiStr WithCertainty:(BOOL)moreCertain;

@end
