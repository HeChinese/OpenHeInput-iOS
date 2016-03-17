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


#import "HeMaEngine.h"

@implementation HeMaEngine

- (id)init
{
    self = [super init];
    if (self) {
        danZiResult4ShuMa4 = [[NSMutableArray alloc] init];
        ciZuResult4ShuMa6 = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray*)generateCandidates:(Input_Setting*)setting TypingState: (Input_TypingState*)typingState Database: (FMDatabase*)hemaDatabase;
{
    NSString *queryStr = @"";
    NSString *danZiOrder = nil;
    NSString *danZiGBKStatement = nil;
    NSString *ciZuJianFanStatement = nil;
    
    if (setting.bSimplified_Chinese) {
        danZiOrder = @"GBOrder";
        ciZuJianFanStatement = @" and JianFan <2 order by HeMaOrder";
    }
    else
    {
        danZiOrder = @"B5Order";
        ciZuJianFanStatement = @" and JianFan <> 1 Order by HeMaOrder ";
    }
    
    if(setting.bNormalZiKu)
    {
        danZiGBKStatement = [NSString stringWithFormat: @" and %@ <> %d ", danZiOrder, HEMAORDER_GBK];
    }
    else
    {
        danZiGBKStatement = @"";
    }

    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    ZiCiObject *ziCiObj = nil;
    
    [hemaDatabase open];
    
    FMResultSet *s = nil;
    
    switch (typingState.maShu) {
        case 0:
            break;
        case 1:
        {
            ziCiObj = [[ZiCiObject alloc] init];
            switch (typingState.ma1)
            {
                case 1: //for 'Bu' char
                {
                    ziCiObj.ziCi = @"不";
                    ziCiObj.ma1 = 11;
                    ziCiObj.promptMa = 1;
                    ziCiObj.danZiOrder = 0;
                }
                    break;
                case 2: //
                {
                    ziCiObj.ziCi = @"是";
                    ziCiObj.ma1 = 24;
                    ziCiObj.promptMa = 4;
                    ziCiObj.danZiOrder = 0;
                }
                    break;
                case 3: //
                {
                    ziCiObj.ziCi = @"去";
                    ziCiObj.ma1 = 32;
                    ziCiObj.promptMa = 2;
                    ziCiObj.danZiOrder = 0;
                }
                    break;
                case 4: //for 'He' char
                {
                    ziCiObj.ziCi = @"和";
                    ziCiObj.ma1 = 41;
                    ziCiObj.promptMa = 1;
                    ziCiObj.danZiOrder = 0;
                }
                    break;
                case 5: //for 'Qing' char
                {
                    if(setting.bSimplified_Chinese)
                    {
                        ziCiObj.ziCi = @"请";
                        ziCiObj.ma1 = 52;
                        ziCiObj.promptMa = 2;
                        ziCiObj.danZiOrder = 0;
                    }
                    else
                    {
                        ziCiObj.ziCi = @"請";
                        ziCiObj.ma1 = 52;
                        ziCiObj.promptMa = 2;
                        ziCiObj.danZiOrder = 0;
                    }
                }
                    break;
                default:
                    break;
            }
            
            [resultArray addObject:ziCiObj];
            
            queryStr = [NSString stringWithFormat:
                        @"SELECT * FROM HanZi where m2 = 0 and M1>%ld and M1<%ld %@ and %@>%d and %@<%d order by M1 DESC",
                        (long)typingState.ma1*10, (long)(typingState.ma1+1)*10, danZiGBKStatement, danZiOrder, HEMAORDER_1MAZISPECIAL, danZiOrder,HEMAORDER_RONGCUOMA];
            
            s = [hemaDatabase executeQuery:queryStr];
            
            while ([s next])
            {
                ziCiObj = [[ZiCiObject alloc] init];
                ziCiObj.ziCi = [s stringForColumn:@"HanZi"];
                ziCiObj.ma1 = [s intForColumn:@"M1"];
                //ziCiObj.ma2 = [s intForColumn:@"M2"];
                //ziCiObj.ma3 = [s intForColumn:@"M3"];
                //ziCiObj.ma4 = [s intForColumn:@"M4"];
                ziCiObj.promptMa = ziCiObj.ma1%10;
                //ziCiObj.danZiOrder = [s intForColumn:danZiOrder];
                [resultArray addObject:ziCiObj];
            }
            [s close];
        }
            break;
        case 2:
        {
            queryStr = [NSString stringWithFormat:
                        @"SELECT * FROM HanZi where m1 = %ld and m2 = 0 %@ order by %@",
                        (long)typingState.ma1, danZiGBKStatement, danZiOrder];
            
            s = [hemaDatabase executeQuery:queryStr];
            
            while ([s next])
            {
                ziCiObj = [[ZiCiObject alloc] init];
                ziCiObj.ziCi = [s stringForColumn:@"HanZi"];
                ziCiObj.ma1 = [s intForColumn:@"M1"];
                ziCiObj.ma2 = [s intForColumn:@"M2"];
                //ziCiObj.ma3 = [s intForColumn:@"M3"];
                //ziCiObj.ma4 = [s intForColumn:@"M4"];
                ziCiObj.promptMa = ziCiObj.ma2;
                //ziCiObj.danZiOrder = [s intForColumn:danZiOrder];
                [resultArray addObject:ziCiObj];
            }
            [s close];
        }
        case 3:
        {
            //Order = 3SHUMaZi
            queryStr = [NSString stringWithFormat:
                        @"SELECT * FROM HanZi where m1 = %ld and %@ = %d and m2 > %ld and M2< %ld %@ order by %@",
                        (long)typingState.ma1, danZiOrder, HEMAORDER_3SHUMAZI, (long)typingState.ma2*10, (long)(typingState.ma2+1)*10, danZiGBKStatement, danZiOrder];
            
            s = [hemaDatabase executeQuery:queryStr];
            
            while ([s next])
            {
                ziCiObj = [[ZiCiObject alloc] init];
                
                ziCiObj.ziCi = [s stringForColumn:@"HanZi"];
                //ziCiObj.ma1 = [s intForColumn:@"M1"];
                ziCiObj.ma2 = [s intForColumn:@"M2"];
                ziCiObj.promptMa = ziCiObj.ma2%10;
                //ziCiObj.ma3 = [s intForColumn:@"M3"];
                //ziCiObj.ma4 = [s intForColumn:@"M4"];
                //ziCiObj.danZiOrder = [s intForColumn:danZiOrder];
                
                [resultArray addObject:ziCiObj];
            }
            
            [s close];
            //Prompt ZiGen Code
            queryStr = [NSString stringWithFormat:
                        @"SELECT * FROM HanZi where m2 = 0 %@ and M1>%ld and M1<%ld  and %@>%d and %@<%d  order by M1 DESC",
                        danZiGBKStatement, (long)typingState.ma2*10, (long)(typingState.ma2+1)*10, danZiOrder, HEMAORDER_1MAZISPECIAL, danZiOrder, HEMAORDER_RONGCUOMA];
            
            s = [hemaDatabase executeQuery:queryStr];
            
            while ([s next])
            {
                ziCiObj = [[ZiCiObject alloc] init];
                
                ziCiObj.ziCi = [s stringForColumn:@"HanZi"];
                ziCiObj.ma1 = [s intForColumn:@"M1"];
                //ziCiObj.ma2 = [s intForColumn:@"M2"];
                //ziCiObj.ma3 = [s intForColumn:@"M3"];
                //ziCiObj.ma4 = [s intForColumn:@"M4"];
                ziCiObj.promptMa = ziCiObj.ma1%10;
                //ziCiObj.danZiOrder = [s intForColumn:danZiOrder];
                
                [resultArray addObject:ziCiObj];
            }
            [s close];
        }
            break;
        case 4:
        {
            if (!typingState.isTypeBack)
            {
                //Get danZiResult4ShuMa4
                queryStr = [NSString stringWithFormat:
                            @"SELECT * FROM HanZi where m1 = %ld and m2 = %ld %@ order by %@",
                            (long)typingState.ma1, (long)typingState.ma2, danZiGBKStatement, danZiOrder];
                s = [hemaDatabase executeQuery:queryStr];
                
                [danZiResult4ShuMa4 removeAllObjects];
                while ([s next])
                {
                    ziCiObj = [[ZiCiObject alloc] init];
                    
                    ziCiObj.ziCi = [s stringForColumn:@"HanZi"];
                    //ziCiObj.ma1 = [s intForColumn:@"M1"];
                    //ziCiObj.ma2 = [s intForColumn:@"M2"];
                    ziCiObj.ma3 = [s intForColumn:@"M3"];
                    ziCiObj.ma4 = [s intForColumn:@"M4"];
                    ziCiObj.danZiOrder = [s intForColumn:danZiOrder];
                    
                    [danZiResult4ShuMa4 addObject:ziCiObj];
                }
                [s close];
            }

            //Order >= 2MaZi
            for (ZiCiObject *item in danZiResult4ShuMa4) {
                if (item.danZiOrder >= HEMAORDER_2MAZI) {
                    item.promptMa = item.ma3;
                    [resultArray addObject:item];
                }
            }
            
            //Order < 2MaZi
            for (ZiCiObject *item in danZiResult4ShuMa4) {
                if (item.danZiOrder < HEMAORDER_2MAZI) {
                    item.promptMa = item.ma3;
                    [resultArray addObject:item];
                }
            }
            
            //CiZu m3=0
            queryStr = [NSString stringWithFormat:
                        @"SELECT * FROM CiZu where m1 = %ld and m2 = %ld and m3 = 0 %@",
                        (long)typingState.ma1, (long)typingState.ma2, ciZuJianFanStatement];
            s = [hemaDatabase executeQuery:queryStr];
            
            while ([s next])
            {
                ziCiObj = [[ZiCiObject alloc] init];
                
                ziCiObj.ziCi = [s stringForColumn:@"CiZu"];
                //ziCiObj.ma1 = [s intForColumn:@"M1"];
                //ziCiObj.ma2 = [s intForColumn:@"M2"];
                ziCiObj.ma3 = [s intForColumn:@"M3"];
                //ziCiObj.ma4 = [s intForColumn:@"M4"];
                ziCiObj.promptMa = ziCiObj.ma3;
                //ziCiObj.ciZuOrder = [s intForColumn:@"HeMaOrder"];
                [resultArray addObject:ziCiObj];
            }
            [s close];
        }
            break;
        case 5:
        {
            //DanZi hemaorder ==HEMAORDER_4MAZI
            for (ZiCiObject *item in danZiResult4ShuMa4) {
                if (item.danZiOrder == HEMAORDER_4MAZI && item.ma3/10 == typingState.ma3)
                {
                    item.promptMa = item.ma3%10;
                    [resultArray addObject:item];
                }
            }
        
            //CiZu HEMAORDER <=221597 or <=3 : 36611; <=5
            queryStr = [NSString stringWithFormat:
                        @"SELECT * FROM CiZu where m1 = %ld and m2 = %ld and m3>%ld and M3<%ld and HeMaOrder<=6 %@ limit 10",
                        (long)typingState.ma1, (long)typingState.ma2,
                        (long)typingState.ma3*10, (long)(typingState.ma3+1)*10,
                        ciZuJianFanStatement];
            
            s = [hemaDatabase executeQuery:queryStr];
            
            while ([s next])
            {
                ziCiObj = [[ZiCiObject alloc] init];
                
                ziCiObj.ziCi = [s stringForColumn:@"CiZu"];
                //ziCiObj.ma1 = [s intForColumn:@"M1"];
                //ziCiObj.ma2 = [s intForColumn:@"M2"];
                ziCiObj.ma3 = [s intForColumn:@"M3"];
                ziCiObj.promptMa = ziCiObj.ma3%10;
                //ziCiObj.ma4 = [s intForColumn:@"M4"];
                //ziCiObj.ciZuOrder = [s intForColumn:@"HeMaOrder"];
                [resultArray addObject:ziCiObj];
            }
            [s close];

            //DanZi hemaorder ==HEMAORDER_3MAZI or >HEMAORDER_4MAZI
            for (ZiCiObject *item in danZiResult4ShuMa4) {
            if(item.ma3/10 == typingState.ma3 && (item.danZiOrder == HEMAORDER_3MAZI || item.danZiOrder > HEMAORDER_4MAZI))
                {
                    item.promptMa = item.ma3%10;
                    [resultArray addObject:item];
                }
            }

            //DanZi hemaOrder< HEMAORDER_3MAZI
            for (ZiCiObject *item in danZiResult4ShuMa4) {
                if (item.ma3/10 == typingState.ma3 && item.danZiOrder < HEMAORDER_3MAZI)
                {
                    item.promptMa = item.ma3%10;
                    [resultArray addObject:item];
                }
            }
        }
            break;
        case 6:
        {
            if (!typingState.isTypeBack)
            {
                [ciZuResult4ShuMa6 removeAllObjects];
                
                queryStr = [NSString stringWithFormat:
                            @"SELECT * FROM CiZu where m1 = %ld and m2 = %ld and m3 = %ld %@",
                            (long)typingState.ma1, (long)typingState.ma2, (long)typingState.ma3, ciZuJianFanStatement];
                
                s = [hemaDatabase executeQuery:queryStr];
                
                while ([s next])
                {
                    ziCiObj = [[ZiCiObject alloc] init];
                    
                    ziCiObj.ziCi = [s stringForColumn:@"CiZu"];
                    //ziCiObj.ma1 = [s intForColumn:@"M1"];
                    //ziCiObj.ma2 = [s intForColumn:@"M2"];
                    //ziCiObj.ma3 = [s intForColumn:@"M3"];
                    ziCiObj.ma4 = [s intForColumn:@"M4"];
                    ziCiObj.promptMa = ziCiObj.ma4;
                    ziCiObj.ciZuOrder = [s intForColumn:@"HeMaOrder"];
                    [ciZuResult4ShuMa6 addObject:ziCiObj];
                }
                [s close];
            }
            else //isTypeBack, need to reset promptMa to m3
            {
                for (ZiCiObject *item in ciZuResult4ShuMa6)
                {
                    item.promptMa = item.ma4;
                }
            }

            //DanZi hemaorder >=HEMAORDER_3SHUMAZI and <=HEMAORDER_4MAZI
            for (ZiCiObject *item in danZiResult4ShuMa4) {
                if (item.ma3 == typingState.ma3 && item.danZiOrder >= HEMAORDER_3SHUMAZI && item.danZiOrder <= HEMAORDER_4MAZI)
                {
                    item.promptMa = item.ma4;
                    [resultArray addObject:item];
                }
            }

            //All CiZu HEMAORDER_CIZU
            [resultArray addObjectsFromArray:ciZuResult4ShuMa6];
            
            //DanZi hemaorder > HEMAORDER_CIZU
            for (ZiCiObject *item in danZiResult4ShuMa4) {
                if (item.ma3 == typingState.ma3 && item.danZiOrder > HEMAORDER_4MAZI)
                {
                    item.promptMa = item.ma4;
                    [resultArray addObject:item];
                }
            }
            
            //DanZi hemaOrder< HEMAORDER_3SHUMAZI
            for (ZiCiObject *item in danZiResult4ShuMa4)
            {
                if (item.ma3 == typingState.ma3 && item.danZiOrder < HEMAORDER_3SHUMAZI)
                {
                    item.promptMa = item.ma4;
                    [resultArray addObject:item];
                }
            }
        }
            break;
        case 7:
        {
            //All CiZu HEMAORDER_CIZU
            for (ZiCiObject *item in ciZuResult4ShuMa6)
            {
                if (item.ma4/10 == typingState.ma4)
                {
                    item.promptMa = item.ma4%10;
                    [resultArray addObject:item];
                }
            }

            //DanZi hemaorder == HEMAORDER_4MAZI
            for (ZiCiObject *item in danZiResult4ShuMa4)
            {
                if (item.danZiOrder == HEMAORDER_4MAZI && item.ma3 == typingState.ma3 && item.ma4/10 == typingState.ma4)
                {
                    item.promptMa = item.ma4%10;
                    [resultArray addObject:item];
                }
            }

            //DanZi hemaorder > HEMAORDER_CIZU
            for (ZiCiObject *item in danZiResult4ShuMa4)
            {
                if (item.ma3 == typingState.ma3 && item.ma4/10 == typingState.ma4 && item.danZiOrder > HEMAORDER_4MAZI)
                {
                    item.promptMa = item.ma4%10;
                    [resultArray addObject:item];
                }
            }

            //DanZi hemaorder < HEMAORDER_4MaZi
            for (ZiCiObject *item in danZiResult4ShuMa4)
            {
                if (item.ma3 == typingState.ma3 && item.ma4/10 == typingState.ma4 && item.danZiOrder < HEMAORDER_4MAZI)
                {
                    item.promptMa = item.ma4%10;
                    [resultArray addObject:item];
                }
            }
        }
            break;
        case 8:
        {
            //DanZi hemaorder == HEMAORDER_4MAZI
            for (ZiCiObject *item in danZiResult4ShuMa4)
            {
                if (item.danZiOrder == HEMAORDER_4MAZI && item.ma3 == typingState.ma3 && item.ma4 == typingState.ma4)
                {
                    item.promptMa = 0;
                    [resultArray addObject:item];
                }
            }
            
            //All CiZu HEMAORDER_CIZU
            for (ZiCiObject *item in ciZuResult4ShuMa6)
            {
                if (item.ma4 == typingState.ma4)
                {
                    item.promptMa = 0;
                    [resultArray addObject:item];
                }
            }
            
            //DanZi hemaorder > HEMAORDER_CIZU
            for (ZiCiObject *item in danZiResult4ShuMa4)
            {
                if (item.ma3 == typingState.ma3 && item.ma4 == typingState.ma4 && item.danZiOrder > HEMAORDER_4MAZI)
                {
                    item.promptMa = 0;
                    [resultArray addObject:item];
                }
            }
            
            //DanZi hemaOrder< HEMAORDER_4MAZI
            for (ZiCiObject *item in danZiResult4ShuMa4)
            {
                if (item.ma3 == typingState.ma3 && item.ma4 == typingState.ma4 && item.danZiOrder < HEMAORDER_4MAZI)
                {
                    item.promptMa = 0;
                    [resultArray addObject:item];
                }
            }
            
        }
            break;
            
        default:
            break;
    }
    
    
    [hemaDatabase close];
    
    return [NSArray arrayWithArray:resultArray];
}


- (ZiCiObject*)provideZiCiObject:(NSString*)ziCiStr Database:(FMDatabase*)hemaDatabase WithCertainty:(BOOL)moreCertain;
{
    [hemaDatabase open];
    
    FMResultSet *s = nil;
    
    if ([ziCiStr length] > 1)
    {
        s = [hemaDatabase executeQuery: @"SELECT M1, M2, M3 FROM CiZu where cizu = ?",ziCiStr];
    }
    else
    {
        if (moreCertain) {
            s = [hemaDatabase executeQuery: @"SELECT M1, M2, M3 FROM HanZi where HanZi = ? and GBOrder>0 and B5Order>0", ziCiStr];
        }
        else
        {
            s = [hemaDatabase executeQuery: @"SELECT M1, M2, M3 FROM HanZi where HanZi = ?", ziCiStr];
        }
    }
    
    ZiCiObject *ziCiObj = nil;
    
    if([s next])
    {
        ziCiObj = [[ZiCiObject alloc] init];
        ziCiObj.ziCi = ziCiStr;
        ziCiObj.ma1 = [s intForColumn:@"M1"];
        ziCiObj.ma2 =[s intForColumn:@"M2"];
        ziCiObj.ma3 = [s intForColumn:@"M3"];
    }
    
    [s close];
    [hemaDatabase close];
    
    return ziCiObj;
}
@end
