//
//  PinYinEngine.m
//  iHeInput
//
//  Created by Guilin on 2/25/2014.
//  Copyright (c) 2014 HeZi.net. All rights reserved.
//

#import "PinYinEngine.h"

@implementation PinYinEngine

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

            /*
            NSString *queryStr = [NSString stringWithFormat:
                        @"SELECT HanZiString, PinYin FROM PinYin_HanZi where PinYin like %@ order by PinYin",
                        typingState.engCharArray];
            //*/
            
            s = [hemaDatabase executeQuery:@"SELECT HanZiString, PinYin FROM PinYin_HanZi where PinYin like ? order by PinYin",
                 [NSString stringWithFormat:@"%@%%", typingState.typedEngStr]];
            
            NSString *danZiArray = nil;
            NSString *pinYin = nil;
         
            while ([s next])
            {
                danZiArray = [s stringForColumn:@"HanZiString"];
                pinYin = [s stringForColumn:@"PinYin"];
                
                for (int i = 0; i<danZiArray.length; i++)
                {
                    ziCiObj = [[ZiCiObject alloc] init];
                    ziCiObj.ziCi = [NSString stringWithFormat:@"%C", [danZiArray characterAtIndex:i]];
                    ziCiObj.promptMa = 404; //indicate PinYin
                    ziCiObj.pinYin = pinYin;
                    [resultArray addObject:ziCiObj];
                }
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

- (NSString*)getPinYinPromptStr:(NSString*)danZi  Database: (FMDatabase*)hemaDatabase;
{
    NSMutableString *pinYinStr = [[NSMutableString alloc] init];
    
    [hemaDatabase open];
    FMResultSet *s = nil;

    if (danZi.length == 1)
    {
        s = [hemaDatabase executeQuery:@"SELECT PinYin, ShengDiao FROM HanZi_PinYin where HanZi = ? ", danZi];
    }
    else if (danZi.length > 1)
    {
        s = [hemaDatabase executeQuery:@"SELECT PinYin, ShengDiao FROM HanZi_PinYin where HanZi = ? ", [danZi substringToIndex:1]];
    }
    else //danZi.length = 0;
    {
        [hemaDatabase close];
        return @"";
    }
    
    if ([s next]) {
        [pinYinStr appendString:[s stringForColumn:@"PinYin"]];
        [pinYinStr appendString:[s stringForColumn:@"ShengDiao"]];
    }
    if ([s next]) {
        [pinYinStr appendString:@" | "];
        [pinYinStr appendString:[s stringForColumn:@"PinYin"]];
        [pinYinStr appendString:[s stringForColumn:@"ShengDiao"]];
    }
    
    [s close];
    [hemaDatabase close];
    
    return pinYinStr;
}

@end
