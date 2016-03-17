//
//  HeEnglishEngine.m
//  iHeInput
//
//  Created by Guilin on 2/25/2014.
//  Copyright (c) 2014 HeZi.net. All rights reserved.
//

#import "HeEnglishEngine.h"

@implementation HeEnglishEngine

- (NSArray*)generateCandidates:(Input_Setting*)setting TypingState: (Input_TypingState*)typingState Database: (FMDatabase*)hemaDatabase;
{
    //Cursor cursor =  null;
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    ZiCiObject *ziCiObj = nil;
    
    if(typingState.engShuMa>=1 && typingState.engShuMa<=5)
    {
        ziCiObj = [[ZiCiObject alloc] init];
        ziCiObj.ziCi = @"1- F1 E2 T3 J4 Z5";
        ziCiObj.promptMa = 0;
        [resultArray addObject:ziCiObj];
        
        ziCiObj = [[ZiCiObject alloc] init];
        ziCiObj.ziCi = @"2- B1 A2 D3 P4 R5";
        ziCiObj.promptMa = 0;
        [resultArray addObject:ziCiObj];
        
        ziCiObj = [[ZiCiObject alloc] init];
        ziCiObj.ziCi = @"3- L1 I2 N3 H4 K5 M6";
        ziCiObj.promptMa = 0;
        [resultArray addObject:ziCiObj];
        
        ziCiObj = [[ZiCiObject alloc] init];
        ziCiObj.ziCi = @"4- C1 O2 S3 G4 Q5";
        ziCiObj.promptMa = 0;
        [resultArray addObject:ziCiObj];
        
        ziCiObj = [[ZiCiObject alloc] init];
        ziCiObj.ziCi = @"5- V1 U2 W3 Y4 X5";
        ziCiObj.promptMa = 0;
        [resultArray addObject:ziCiObj];
        
        return resultArray;
    }

    switch(typingState.typedEngStrLen)
    {
        //case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        {
            [hemaDatabase open];
            FMResultSet *s = nil;
            
            s = [hemaDatabase executeQuery:@"SELECT Word, HeMaOrder FROM English_Word where word like ? order by HeMaOrder limit 100",
                 [NSString stringWithFormat:@"%@%%", typingState.typedEngStr]];
            
            while ([s next])
            {
                ziCiObj = [[ZiCiObject alloc] init];
                ziCiObj.ziCi = [s stringForColumn:@"Word"];
                ziCiObj.promptMa = 26;
                //ziCiObj.danZiOrder = [s intForColumn:@"HeMaOrder"];
                [resultArray addObject:ziCiObj];
            }
            
            [s close];
            [hemaDatabase close];
        }
            break;
            
        default:
            break;
    }
    
    return [NSArray arrayWithArray:resultArray];
}

@end
