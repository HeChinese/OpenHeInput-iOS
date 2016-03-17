//
//  MenuEngine.m
//  iHeInput
//
//  Created by Guilin on 2/25/2014.
//  Copyright (c) 2014 HeZi.net. All rights reserved.
//

#import "MenuEngine.h"

@implementation MenuEngine

//This function is similar as engineCollect.typingCharAndNumber()
- (NSArray*)generateCandidates:(Input_Setting*)setting TypingState: (Input_TypingState*)typingState MenuArray: (NSArray*)menuArray;
{
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    
    switch(typingState.maShu)
    {
        case 2:
            if(typingState.ma1 == 0)
            {
                for(ZiCiObject *item in menuArray)
                {
                    item.promptMa = item.ma2;
                    [resultArray addObject:item];
                }
            }
            else if(typingState.ma1 == -2) //mode
            {
                for(ZiCiObject *item in menuArray)
                {
                    if (item.ma1 != 0) {
                        item.promptMa = item.ma2;
                        [resultArray addObject:item];
                    }
                }
            }
            break;
        case 3:
        {
            if(typingState.ma1 == 0)
            {
                for(ZiCiObject *item in menuArray)
                {
                    if (item.ma2/10 == typingState.ma2) {
                        item.promptMa = item.ma2%10;
                        [resultArray addObject:item];
                    }
                }
            }
            else if(typingState.ma1 == -2) //mode
            {
                for(ZiCiObject *item in menuArray)
                {
                    if (item.ma1 != 0 && item.ma2/10 == typingState.ma2) {
                        item.promptMa = item.ma2%10;
                        [resultArray addObject:item];
                    }
                }
            }			 		 		
        }
		 	break;
        case 4:
        default:
            break;		
    }
    
    return [NSArray arrayWithArray:resultArray];
}

@end
