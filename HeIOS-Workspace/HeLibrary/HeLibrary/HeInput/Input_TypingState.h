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

@interface Input_TypingState : NSObject
{
    NSInteger ma1, ma2, ma3, ma4, maShu, previousShuMa;
    
    //BOOL bEngCharArrayLenChanged;
}

@property (readwrite) NSInteger ma1, ma2, ma3, ma4, maShu, previousShuMa;
@property (readwrite) BOOL isTypeBack;

@property (readwrite) NSUInteger engShuMa;
@property (strong, nonatomic) NSMutableString *typedEngStr;
@property (readwrite) NSUInteger typedEngStrLen;

- (void)clearState;

- (BOOL)typeShuMa:(NSInteger)shuMa;
- (BOOL)typeBackShuMa;

- (BOOL)isValid25ShuMaPlus0:(NSInteger)newMa;   //it could be minus digital
- (BOOL)isHeMaValid;
- (BOOL)isHeMa1Valid;
- (BOOL)isHeMa2Valid;
- (BOOL)isHeMa3Valid;
- (BOOL)isHeMa4Valid;

- (BOOL)isValidEnglishShuMa:(NSInteger)shuMa;
- (BOOL)isValidEnglishChar:(unichar)uniChar;

- (BOOL)typeEnglishCharOrShuMa:(unichar)uniChar TypedShuMa:(NSInteger)shuMa;
- (BOOL)typeBackEnglishCharOrShuMa;
- (unichar)engShuMaToEngCharacter:(NSUInteger)shuMa;

- (NSString*)provideTypedMaStr;
- (NSString*)provideMenuTypedMaStr;

- (NSString*)getTypedEngStr;

@end
