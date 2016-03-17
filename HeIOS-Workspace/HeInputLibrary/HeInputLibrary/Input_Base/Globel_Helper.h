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

@interface Globel_Helper : NSObject

+(NSUInteger)indexToShuMa:(NSUInteger)sm;
+(NSUInteger)shuMaToIndex:(NSUInteger)index;


+(NSString*)indexToHeEnglishChar:(NSUInteger)index;
+(NSString*)shuMaToHeEnglishChar:(NSUInteger)sm;

+(NSString*)indexToCharacterSet:(NSUInteger)sm;
+(NSString*)shuMaToCharacterSet:(NSUInteger)sm;

+(NSUInteger)charToShuMa:(unichar)unic;

// For iOS
+ (int) detectScreenHeightPoints;
+ (int) screenDimensionLarge;
+ (int) screenDimensionSmall;

// For Mac OS X
//+(NSUInteger)keyCodeToShuMa:(NSInteger)keyCode;

//+(BOOL)is26EnglishCharKey:(NSInteger)keyCode;
//+(BOOL)isMainKeyboardNumberKey:(NSInteger)keyCode;
//+(BOOL)isNumberPadNumberKey:(NSInteger)keyCode;
//
//+(BOOL)isPunctuationKey:(NSInteger)keyCode;
//+(BOOL)isMainKeyboardControlKey:(NSInteger)keyCode;
//+(BOOL)isNumPadControlKey:(NSInteger)keyCode;


@end
