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

//It include DanZi, CiZu, English, PinYin etc.
@interface ZiCiObject : NSObject

@property (readwrite) NSString *ziCi;
@property (readwrite) NSInteger ma1,ma2,ma3,ma4, promptMa;

//For DanZi Table
@property (readwrite) NSUInteger danZiOrder;

//For Cizu Table
@property (readwrite) NSUInteger ziShu;
@property (readwrite) NSUInteger ciZuOrder;
@property (readwrite) NSUInteger jianFan;

//For HanZi_PinYin table
@property (strong, nonatomic) NSString *pinYin;
@property (readwrite) NSUInteger shengDiao;

//For English
@property (strong, nonatomic) NSString *english;

- (NSString*)provideZiCiPlusPromptMa;

@end
