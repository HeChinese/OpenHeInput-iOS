//
//  EngineBase.h
//  iHeInput
//
//  Created by Guilin on 2/25/2014.
//  Copyright (c) 2014 HeZi.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeLibrary/FMDatabase.h"
#import "Input_Setting.h"
#import "HeLibrary/Input_TypingState.h"
#import "HeLibrary/ZiCiObject.h"
#import "Input_Constants.h"

@interface EngineBase : NSObject

- (NSArray*)generateCandidates:(Input_Setting*)setting TypingState: (Input_TypingState*)typingState Database: (FMDatabase*)hemaDatabase;

@end
