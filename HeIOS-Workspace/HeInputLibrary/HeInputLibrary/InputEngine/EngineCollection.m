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

#import "EngineCollection.h"

@implementation EngineCollection

- (id)init
{
    self = [super init];
    
    if (self) {
        heMaEngine = [[HeMaEngine alloc] init];
        pinYinEngine = [[PinYinEngine alloc] init];
        heEnglishEngine = [[HeEnglishEngine alloc] init];
        menuEngine = [[MenuEngine alloc] init];
        symbolEngine = [[SymbolEngine alloc] init];
    }
    
    return self;
}

- (id)initWithDatabase:(FMDatabase*)heMaDB;
{
    self = [self init];
    hemaDatabase = heMaDB;
    
    return self;
}

- (BOOL)generateCandidates:(Input_Setting*)setting TypingState: (Input_TypingState*)typingState;
{
    //Log.d("Debug","------EngineCollection generateCandidates------");
    if(typingState.maShu >= 2 && (typingState.ma1 == 0 || typingState.ma1 == -2))
    {
        self.candidateArray = [menuEngine generateCandidates:setting TypingState:typingState MenuArray:self.menuArray];
    }
    else if (typingState.maShu >= 2 && (typingState.ma1>=6 && typingState.ma1 <= 9))
    {
        self.candidateArray = [symbolEngine generateCandidates:setting TypingState: typingState Database:hemaDatabase];
    }
    else
    {
        switch(setting.currentKeyMode)
        {
            case HeMaMode:
            {
                self.candidateArray = [heMaEngine generateCandidates:setting TypingState:typingState Database:hemaDatabase];
            }
				break;
            case PinYinMode:
            {
                self.candidateArray = [pinYinEngine generateCandidates:setting TypingState:typingState Database:hemaDatabase];
            }
                break;
            case HeEnglishMode:
            {
                self.candidateArray = [heEnglishEngine generateCandidates:setting TypingState:typingState Database:hemaDatabase];
            }
                break;
            default:
                break;
        }
    }
    
    if(self.candidateArray != nil)
    {
        self.numOfRows = [self.candidateArray count];
    }
    else
        self.numOfRows = 0;
    
    return (self.numOfRows>0);
}

- (NSString*)getPinYinPromptStr:(NSString*)danZi;
{
    return [pinYinEngine getPinYinPromptStr:danZi Database:hemaDatabase];
}

- (ZiCiObject*)provideZiCiObject:(NSString*)ziCiStr WithCertainty:(BOOL)moreCertain;
{
    return [heMaEngine provideZiCiObject:ziCiStr Database:hemaDatabase WithCertainty:moreCertain];
}
@end
