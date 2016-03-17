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

#import <UIKit/UIKit.h>
#import "HeKeyboard4x6.h"

/*
@protocol HeKeyboard4x6_Protocol
// Sent when the user typed a char key.
- (BOOL)handleNumKey4HeKeyboard4x6:(NSInteger)keyCode;
- (void)handleControlKey:(NSInteger)keyCode;
@end
//*/

//HeKeyboard_ViewController responsible communite HeKeyboard4x6 to Client Text Field
@interface HeKeyboard_ViewController : UIInputViewController <HeKeyboard_Protocol>

@property (strong, nonatomic) HeKeyboard4x6 *keyboard4x6;
@property (readwrite) int screenHeightPoints;

- (void)heInsertText:(NSString *)text;

@end
