//
//  SymbolEngine.m
//  iHeInput
//
//  Created by Guilin on 2014-10-01.
//  Copyright (c) 2014 HeZi.net. All rights reserved.
//

#import "SymbolEngine.h"

@implementation SymbolEngine

- (NSArray*)generateCandidates:(Input_Setting*)setting TypingState: (Input_TypingState*)typingState Database: (FMDatabase*)hemaDatabase;
{
    NSString *queryStr = @"";
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    ZiCiObject *ziCiObj = nil;
    [hemaDatabase open];
    
    switch(typingState.maShu)
    {
        case 2:
        {
            queryStr = [NSString stringWithFormat:
                        @"SELECT * FROM HanZi where m1 = %ld and m3 = 11 order by m2",
                        (long)typingState.ma1];
            
            FMResultSet *s = [hemaDatabase executeQuery:queryStr];
            
            while ([s next])
            {
                ziCiObj = [[ZiCiObject alloc] init];
                ziCiObj.ziCi = [s stringForColumn:@"HanZi"];
                //ziCiObj.ma1 = [s intForColumn:@"M1"];
                ziCiObj.ma2 = [s intForColumn:@"M2"];
                //ziCiObj.ma3 = [s intForColumn:@"M3"];
                //ziCiObj.ma4 = [s intForColumn:@"M4"];
                ziCiObj.promptMa = ziCiObj.ma2;
                //ziCiObj.danZiOrder = [s intForColumn:danZiOrder];
                [resultArray addObject:ziCiObj];
            }
            [s close];
        }
            break;
        case 3:
        {
            queryStr = [NSString stringWithFormat:
                        @"SELECT * FROM HanZi where m1 = %ld and m2 > %ld and m2 < %ld and m3 = 11 order by m2",
                        (long)typingState.ma1, (long)typingState.ma2*10, (long)(typingState.ma2+1)*10];
            
            FMResultSet *s = [hemaDatabase executeQuery:queryStr];
            
            while ([s next])
            {
                ziCiObj = [[ZiCiObject alloc] init];
                ziCiObj.ziCi = [s stringForColumn:@"HanZi"];
                //ziCiObj.ma1 = [s intForColumn:@"M1"];
                ziCiObj.ma2 = [s intForColumn:@"M2"];
                //ziCiObj.ma3 = [s intForColumn:@"M3"];
                //ziCiObj.ma4 = [s intForColumn:@"M4"];
                ziCiObj.promptMa = ziCiObj.ma2%10;
                //ziCiObj.danZiOrder = [s intForColumn:danZiOrder];
                [resultArray addObject:ziCiObj];
            }
            [s close];
        }
            break;
        case 4:
        {
            queryStr = [NSString stringWithFormat:
                        @"SELECT * FROM HanZi where m1 = %ld and m2 = %ld order by m3",
                        (long)typingState.ma1, (long)typingState.ma2];
            
            FMResultSet *s = [hemaDatabase executeQuery:queryStr];
            
            while ([s next])
            {
                ziCiObj = [[ZiCiObject alloc] init];
                ziCiObj.ziCi = [s stringForColumn:@"HanZi"];
                //ziCiObj.ma1 = [s intForColumn:@"M1"];
                //ziCiObj.ma2 = [s intForColumn:@"M2"];
                ziCiObj.ma3 = [s intForColumn:@"M3"];
                //ziCiObj.ma4 = [s intForColumn:@"M4"];
                ziCiObj.promptMa = ziCiObj.ma3;
                //ziCiObj.danZiOrder = [s intForColumn:danZiOrder];
                [resultArray addObject:ziCiObj];
            }
            [s close];
        }
            break;
        case 5:
        {
            queryStr = [NSString stringWithFormat:
                        @"SELECT * FROM HanZi where m1 = %ld and m2 = %ld and m3 > %ld and m3 < %ld order by m3",
                        (long)typingState.ma1, (long)typingState.ma2,(long)typingState.ma3*10, (long)(typingState.ma3+1)*10];
            
            FMResultSet *s = [hemaDatabase executeQuery:queryStr];
            
            while ([s next])
            {
                ziCiObj = [[ZiCiObject alloc] init];
                ziCiObj.ziCi = [s stringForColumn:@"HanZi"];
                //ziCiObj.ma1 = [s intForColumn:@"M1"];
                ziCiObj.ma3 = [s intForColumn:@"M3"];
                //ziCiObj.ma3 = [s intForColumn:@"M3"];
                //ziCiObj.ma4 = [s intForColumn:@"M4"];
                ziCiObj.promptMa = ziCiObj.ma3%10;
                //ziCiObj.danZiOrder = [s intForColumn:danZiOrder];
                [resultArray addObject:ziCiObj];
            }
            [s close];
        }
            break;
        case 6:
        {
            queryStr = [NSString stringWithFormat:
                        @"SELECT * FROM HanZi where m1 = %ld and m2 = %ld and m3 = %ld",
                        (long)typingState.ma1, (long)typingState.ma2,(long)typingState.ma3];
            
            FMResultSet *s = [hemaDatabase executeQuery:queryStr];
            
            while ([s next])
            {
                ziCiObj = [[ZiCiObject alloc] init];
                ziCiObj.ziCi = [s stringForColumn:@"HanZi"];
                //ziCiObj.ma1 = [s intForColumn:@"M1"];
                //ziCiObj.ma2 = [s intForColumn:@"M2"];
                //ziCiObj.ma3 = [s intForColumn:@"M3"];
                //ziCiObj.ma4 = [s intForColumn:@"M4"];
                ziCiObj.promptMa = 0;
                //ziCiObj.danZiOrder = [s intForColumn:danZiOrder];
                [resultArray addObject:ziCiObj];
            }
            [s close];
        }
            break;
        default:
            break;
    }
    
    [hemaDatabase close];
    
    return [NSArray arrayWithArray:resultArray];
}

@end
