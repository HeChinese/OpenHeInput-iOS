//
//  MenuEngine.h
//  iHeInput
//
//  Created by Guilin on 2/25/2014.
//  Copyright (c) 2014 HeZi.net. All rights reserved.
//

#import "EngineBase.h"

@interface MenuEngine : EngineBase

- (NSArray*)generateCandidates:(Input_Setting*)setting TypingState: (Input_TypingState*)typingState MenuArray: (NSArray*)menuArray;

@end
