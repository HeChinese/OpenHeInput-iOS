//
//  PinYinEngine.h
//  iHeInput
//
//  Created by Guilin on 2/25/2014.
//  Copyright (c) 2014 HeZi.net. All rights reserved.
//

#import "EngineBase.h"

@interface PinYinEngine : EngineBase

- (NSString*)getPinYinPromptStr:(NSString*)danZi Database: (FMDatabase*)database;

@end
