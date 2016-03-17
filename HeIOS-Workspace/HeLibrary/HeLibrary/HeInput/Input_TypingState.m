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

#import "Input_TypingState.h"

@implementation Input_TypingState

- (id)init
{
    self = [super init];
    if (self) {
        _typedEngStr = [[NSMutableString alloc] initWithCapacity:14];
    }
    return self;
}

@synthesize ma1,ma2,ma3,ma4,maShu,previousShuMa;

- (void)clearState;
{
    ma1 = ma2 = ma3 = ma4 = maShu = previousShuMa = 0;
    self.isTypeBack = false;
    
    self.engShuMa = 0;
    self.typedEngStrLen = 0;
    _typedEngStr = [[NSMutableString alloc] initWithCapacity:14];
    //bEngCharArrayLenChanged = false;
}

- (BOOL)typeEnglishCharOrShuMa:(unichar)uniChar TypedShuMa:(NSInteger)shuMa;
{
    if(shuMa==100)
    {
        return [self typeBackEnglishCharOrShuMa];
    }
    
    // main keyboard input
    if ([self isValidEnglishChar:uniChar]) {
        if([self typeEnglishChar: uniChar])
        {
            self.engShuMa = 0;
            return true;
        }
        else
        {
            return false;
        }
    }
    
    if ([self isValidEnglishShuMa:shuMa]) {
        
        NSUInteger engCharShuMaBefore = self.engShuMa;
        NSUInteger typedEngStrLenBefore = self.typedEngStrLen;
        
        if(shuMa <= 6)
        {
            if(self.engShuMa == 0 || self.engShuMa >10)
            {
                self.engShuMa = shuMa;
            }
            else		//engCharShuMa = 1,2,3,4,5
            {
                self.engShuMa = self.engShuMa*10 + shuMa;
            }
        }
        else
        {
            self.engShuMa = shuMa;
        }
        
        if(self.engShuMa >= 11)
        {
            unichar newFormedChar = [self engShuMaToEngCharacter:self.engShuMa];
            if([self typeEnglishChar: newFormedChar])
            {
                self.engShuMa = 0;
            }
            else
            {
                self.engShuMa = engCharShuMaBefore;
                return false;
            }
        }
        
        if(engCharShuMaBefore != self.engShuMa || typedEngStrLenBefore != self.typedEngStrLen)// when m1 = 0 and maShu = 2 and typed 6,7,8,9,
        {
            return true;
        }
        else
        {
            self.engShuMa = engCharShuMaBefore;
            self.typedEngStrLen = typedEngStrLenBefore;
            return false;
        }
    }
    return false;
}

- (BOOL)typeBackEnglishCharOrShuMa;
{
    BOOL fRet = false;
    if(self.engShuMa>0 && self.engShuMa<11)
    {
        self.engShuMa = 0;
        //bEngCharArrayLenChanged = false;
        fRet = true;		//do not need to call FormCandList4PinYin()
    }
    else if(self.typedEngStrLen>0)  //engCharShuMa >10 or = 0
    {
        NSUInteger previousEngShuMa = self.engShuMa/10;
        self.typedEngStrLen--;
        //engCharArrayLen--;
        [self.typedEngStr deleteCharactersInRange:NSMakeRange(self.typedEngStrLen, 1)];
        
        //engCharArray[engCharArrayLen]='\0';
        //bEngCharArrayLenChanged = true;
        fRet = true;
        
        if(previousEngShuMa>0 && previousEngShuMa<10) //back a digital number 1,2,3,4,5,6
        {
            self.engShuMa = previousEngShuMa;
            previousEngShuMa=0;
        }
    }
    return fRet;
}

- (BOOL)isValidEnglishShuMa:(NSInteger)shuMa;
{
    BOOL fRet = false;
    
    if(shuMa>0 && shuMa<10)
    {
        if(self.engShuMa == 0)
        {
            if(shuMa >=1 && shuMa<=5)
                fRet = true;
            else
                fRet = false;
        }
        else
        {
            if(self.engShuMa == 3 && shuMa >=1 && shuMa<=6)  //for 36 : m
                fRet = true;
            else if(shuMa >=1 && shuMa<6) //for another chars
                fRet = true;
            else
                fRet = false;
        }
    }
    else if (shuMa == 0) {
        fRet = true;
    }
    else //shuMa > 10
    {
        if((shuMa/10 >= 1 && shuMa/10 <=5) && (shuMa%10 >= 1 && shuMa%10 <=5))
        {
            fRet = true;
        }
        else if (shuMa==36)
            fRet = true;
        else
            fRet = false;
    }
    return fRet;
}

- (BOOL)isValidEnglishChar:(unichar)uniChar;
{
    if((uniChar>=65 && uniChar<=90) ||		//ABCD..XYZ
       (uniChar>=97 && uniChar <= 122))	//abcd...xyz
    {
        return true;
    }
    
    return false;
}


- (BOOL)typeShuMa:(NSInteger)typedShuMa;
{
    if(typedShuMa == 100) //Backspace
        return [self typeBackShuMa];
    
    self.isTypeBack = false;
    
    //ma1 == 99 indidate LianXiang
    if(typedShuMa == 99)
    {
        ma1 = typedShuMa; //99
        maShu =2;
        
        return true;
    }
    
    //Mode Selection
    if(typedShuMa == -2)
    {
        if(ma1==-2)  //turn off mode selection
        {
            ma1=0;
            maShu = 0;
        }
        else
        {
            ma1 = typedShuMa; //turn on mode selection
            maShu =2;
        }
        return true;
    }
    
    if(![self isValid25ShuMaPlus0:typedShuMa])
        return false;
    
    //bypass some errors
    if(typedShuMa<0 || typedShuMa>55)
        return false;
    
    NSInteger maShuBefore=maShu;
    NSInteger ma1Before = ma1;
    //int ma2Before = ma2;
    
    switch (maShu)  //this maShu is before process type
    {
        case 0:
        case 8://Continue type
        {
            ma1=typedShuMa;		//include 99
            ma2=0;
            ma3=0;
            ma4=0;
            
            if (typedShuMa>0 && typedShuMa<6)
                maShu=1;
            else //typedShuMa >10, == 0
                maShu=2;
        }
            break;
        case 1:	//MaShu==1
        {
            ma2=0;
            ma3=0;
            ma4=0;
            if (typedShuMa>10) //typedShuMa= 11,12..55
            {
                ma1=typedShuMa;
                maShu=2;
            }
            else if (typedShuMa>0 && typedShuMa<6)//typedShuMa=1,2,3,4,5
            {
                ma1 = ma1*10 + typedShuMa;
                maShu = 2;
            }
            else //typedShuMa ==0, 6,7,8,9
            {
				//  //Don't change it
            }
        }
            break;
        case 2:	//MaShu==2
        {
            ma2=0;
            ma3=0;
            ma4=0;
            if(ma1==0) //MaShu==2
            {
                switch (typedShuMa)
                {
                    case 0:
                    {
                        //for repeat input
                        ma2=0;
                        maShu=4;
                    }
                        break;
                    case 1:
                    case 2:
                    case 3:
                    case 4:
                    case 5:
                    {
                        ma2=typedShuMa;
                        maShu=3;
                    }
                        break;
                    case 11:
                        ma1=6; //mashu = 2;
                        break;
                    case 12:
                        ma1=7;
                        break;
                    case 13:
                        ma1=8;
                        break;
                    case 14:
                        ma1=9;
                        break;
                    case 15:
                        ma1=62;
                        break;
                    case 21:
                    case 22:
                    case 23:
                    case 24:
                    case 25:		//Switch ◊÷∑˚ºØUser Cizu edit
                    case 31:
                    case 32:
                    case 33:
                    case 34:
                    case 35:
                    case 41:
                    case 42:
                    case 43:
                    case 44:
                    case 45:
                    case 51:
                    case 52:
                    case 53:
                    case 54:
                    case 55:
                    {
                        ma1=0;
                        ma2=typedShuMa;
                        maShu=4;
                    }
                        break;
                    default:
                        break; //ignore
                }
            }
            else if (typedShuMa>10)  //MaShu==2 && ma1 != 0 //typedShuMa= 11 12 ... 55
            {
                ma2=typedShuMa;
                maShu=4;
            }
            else if(typedShuMa==0 && ma1 < 10)   //MaShu==2 && ma1 = 6,7,8,9
            {
                //ignore
            }
            else if(typedShuMa==0)   //MaShu==2 && ma1 > 10
            {
                maShu=4;
                ma2=typedShuMa;
            }
            else if (typedShuMa<6)		//MaShu==2 && ma1 != 0  //typedShuMa=1,2,3,4,5
            {
                ma2= typedShuMa;
                maShu = 3;
            }
            else if (typedShuMa<10) //MaShu==2 && ma1 != 0 //typedShuMa = 6,7,8,9
            {
                //ignore
            }
        }
            break;
        case 3: //maShu=3
        {
            if(ma1==0)	//maShu==3 and ma1==0
            {
                if (typedShuMa>10)	//maShu==3 and ma1==0 and typedShuMa>10
                {
                    switch (typedShuMa)
                    {
                        case 11:
                            ma1=6;
                            ma2 = 0;
                            maShu=2;
                            break;
                        case 12:
                            ma1=7;
                            ma2 = 0;
                            maShu=2;
                            break;
                        case 13:
                            ma1=8;
                            ma2 = 0;
                            maShu=2;
                            break;
                        case 14:
                            ma1=9;
                            ma2 = 0;
                            maShu=2;
                            break;
                        case 15:
                            ma1=62;
                            ma2 = 0;
                            maShu=2;
                            break;
                        case 21:
                        case 22:
                        case 23:
                        case 24:
                        case 25:		//switch ◊÷∑˚ºØ User Cizu edit
                        case 31:
                        case 32:
                        case 33:
                        case 34:  //add
                        case 35:
                        case 41:
                        case 42:
                        case 43:
                        case 44:
                        case 45:
                        case 51:
                        case 52:
                        case 53:
                        case 54:
                        case 55:
                        {
                            ma1=0;
                            ma2=typedShuMa;
                            maShu=4;
                        }
                            break;
                        default:
                            break; //ignore
                            
                    }
                }
                else if (typedShuMa<6)  //maShu==3 and ma1==0 and typedShuMa<6
                {
                    NSInteger mT= ma2*10+typedShuMa;
                    switch (mT)
                    {
                        case 11:
                            ma1=6;
                            ma2 = 0;
                            maShu=2;
                            break;
                        case 12:
                            ma1=7;
                            ma2 = 0;
                            maShu=2;
                            break;
                        case 13:
                            ma1=8;
                            ma2 = 0;
                            maShu=2;
                            break;
                        case 14:
                            ma1=9;
                            ma2 = 0;
                            maShu=2;
                            break;
                        case 15:
                            ma1=62;
                            ma2 = 0;
                            maShu=2;
                            break;
                        case 21:
                        case 22:
                        case 23:
                        case 24:
                        case 25:		//User Cizu edit
                        case 31:
                        case 32:
                        case 33:
                        case 34:  //new
                        case 35:  //new
                        case 41:
                        case 42:
                        case 43:
                        case 44:
                        case 45:
                        case 51:
                        case 52:
                        case 53:
                        case 54:
                        case 55:
                        {
                            ma1=0;
                            ma2=mT;
                            maShu=4;
                        }
                            break;
                            
                        default:
                            break; //ignore
                    }
                }
            }
            else if (typedShuMa>10) //maShu==3 and ma1 != 0 and typedShuMa>10 //typedShuMa= 11 12 ... 55 except 11 22 33
            {
                ma2=typedShuMa;
                maShu=4;
            }
            else if(typedShuMa==0 && ma1 < 10)   //MaShu==2 && ma1 = 6,7,8,9
            {
                //ignore
            }
            else if(typedShuMa==0)  ////maShu==3 and ma1 > 10 and typedShuMa==0
            {
                maShu=4;
                ma2=typedShuMa;
            }
            else if (typedShuMa<6)	//maShu==3 and ma1 != 0 and typedShuMa != 0 and typedShuMa<6 //typedShuMa=1,2,3,4,5
            {
                //Log.d("Debug","typedShuMa ma1: "+ma2 + "MaShu="+maShu);
                ma2= ma2*10+typedShuMa;
                maShu = 4;
                //Log.d("Debug","typedShuMa ma1: "+ma2 + "MaShu="+maShu);
            }
            else if (typedShuMa<10) //maShu==3 and ma1 != 0 and typedShuMa>5 and typedShuMa<10 //typedShuMa = 6,7,8,9
            {
                //ignore all
            }
        }
            break;
        case 4: //maShu=4
        {
            if (typedShuMa>10) //maShu==4 and typedShuMa>10 //typedShuMa= 11,12..55
            {
                ma3=typedShuMa;
                maShu=6;
            }
            else if(typedShuMa==0)// && ma2>0)		//maShu==4  and typedShuMa==0  don't include ma2=0 for query ma2
            {
                //it is valid for 14 0 0 0; 44 0 0 0
                maShu=6;
                ma3=typedShuMa;
            }
            else if (typedShuMa<6)		//maShu==4  and typedShuMa>0 and typedShuMa<6 //typedShuMa=1,2,3,4,5
            {
                ma3= typedShuMa;
                maShu = 5;
            }
            else if (typedShuMa<10) //maShu==4  and typedShuMa>5 and typedShuMa<10 //typedShuMa = 6,7,8,9
            {
            }
        }
            break;
        case 5://maShu=5
        {
            if (typedShuMa>10)	//maShu==5 and typedShuMa>10 //typedShuMa= 11,12..55
            {
                ma3=typedShuMa;
                maShu=6;
            }
            else if(typedShuMa==0 && ma2>0)	//maShu==5 and typedShuMa = 0, don't include ma2=0 for query ma2
            {
                //ignore  //do not procese query ma of ma3 = 0
                maShu=6;
                ma3=typedShuMa;
            }
            else if (typedShuMa<6)		//maShu==5 and typedShuMa<6 //typedShuMa=1,2,3,4,5
            {
                ma3= ma3*10+typedShuMa;
                maShu = 6;
            }
            else if (typedShuMa<10)	//maShu==5 and typedShuMa<10 //typedShuMa = 6,7,8,9
            {
            }
        }
            break;
        case 6: //maShu=6
        {
            if(ma1==99)  //indidate lianXiang
            {
                //ignore, since lianXiang only proce 3 typedShuMa, and ma1=99
            }
            else if((ma1==0)||(ma1==6)||(ma1==7)||(ma1==8)||(ma1==9)||(ma1==61)||(ma1==62)) //maShu==6 //ma1=6,7,8 only have 3 typedShuMa, ma1=0 has 2 typedShuMa
            {
                //ignore
            }
            else if(typedShuMa==0)// && ma2>0)		//maShu==6 and typedShuMa=0 
            {
                //it is valid for 14 0 0 0; 44 0 0 0
                maShu=8;
                ma4=typedShuMa;
            }
            else if (typedShuMa > 0 && typedShuMa<6)	//maShu==6 and typedShuMa<6 //typedShuMa=1,2,3,4,5
            {
                ma4= typedShuMa;
                maShu = 7;
            }
            else if (typedShuMa>10) //maShu==6 and typedShuMa>10 //typedShuMa= 11,12..55
            {
                if (ma2==0) // && ma3>0)  //after ma2 queried
                {
                    ma2=typedShuMa;
                    ma4=0;
                    maShu=6;
                }
                else if (ma2>0)
                {
                    ma4=typedShuMa;
                    maShu=8;
                }
            }
            else //if (typedShuMa<10) //maShu==6 and typedShuMa<10 //typedShuMa = 6,7,8,9
            {
                //ignore
            }
        }
            break;
        case 7://maShu=7
        {
            if(typedShuMa==0)	//maShu==7 and typedShuMa==0 
            {
                //ignore
            }
            else if (typedShuMa<6)	//maShu==7 and typedShuMa<6 //typedShuMa=1,2,3,4,5
            {
                if (ma2>0)
                {
                    ma4= ma4*10+typedShuMa;
                    maShu = 8;
                }
                else if (ma2==0 && ma3>0)
                {
                    ma2=ma4*10+typedShuMa;
                    ma4=0;
                    maShu=6;
                }
                else //if (ma2==0 && ma3==0) 
                {
                    //ignore
                }
            }
            else if (typedShuMa>10) //maShu==7 //typedShuMa= 11,12..55
            {
                if (ma2>0)
                {
                    ma4=typedShuMa;
                    maShu=8;
                }
                else if (ma2==0 && ma3>0)  //after ma2 queried
                {
                    ma2=typedShuMa;
                    maShu=6;
                }
                else //if (ma2==0 && ma3==0) 
                {
                    //ignore
                }
            }
            else //if (typedShuMa<10) //maShu==7 and typedShuMa<10 //typedShuMa = 6,7,8,9
            {
                //ignore
            }
        }
            break;
        default:
            [self clearState];
            break;
    }
    
    if(maShuBefore != maShu || ma1Before != ma1 )// when ma1 = 0 and maShu = 2 and typed 6,7,8,9, 
    {
        previousShuMa=typedShuMa;
        return true;
    }
    else
    {
        //mean typingState did not change for this typing
        //do not need call typeback()
        return false;
    }
}

- (BOOL)typeBackShuMa;
{
	//For ma1 = 6,7,8,9, and 0,1,2,3,4,5 and 99
	if(maShu==2 && (ma1<10 || ma1 ==99))
	{
		[self clearState];
        self.isTypeBack = false;
		return true;
	}
	
	if(previousShuMa>10 || previousShuMa == 0)
	{
		switch(maShu)
		{
			case 0:
                return false;
                break;
			case 1:
			case 2:
				[self clearState];
				break;
			case 3:
			case 4:
			{
				maShu = 2;
				ma2 = 0;
			}
				break;
			case 5:
			case 6:
			{
				maShu = 4;
				ma3 = 0;
			}
				break;
			case 7:
			case 8:
			{
				maShu = 6;
				ma4 = 0;
			}
				break;
			default:
				break;
		}
	}
	else		//typedMa<=10
	{
		switch (maShu)
		{
			case 0:
                return false;
                break;
			case 1:
				[self clearState];
				break;
			case 2:
			{
				maShu = 1;
				ma1 = ma1/10;
			}
				break;
			case 3:
			{
				maShu = 2;
				ma2 = 0;
			}
				break;
			case 4:
			{
				maShu = 3;
				ma2 = ma2/10;
			}
				break;
			case 5:
			{
				maShu = 4;
				ma3 = 0;
			}
				break;
			case 6:
			{
				maShu = 5;
				ma3 = ma3/10;
			}
				break;
			case 7:
			{
				maShu = 6;
				ma4 = 0;
			}
				break;
			case 8:
			{
				maShu = 7;
				ma4 = ma4/10;
			}
				break;
			default:
				break;
		}
	}
	
	//return [self isHeMaValid];
    self.isTypeBack = true;
    return true;
}

- (BOOL)isValid25ShuMaPlus0:(NSInteger)newMa;
{
    //here we do not conside PinYin ShuMa m:36
    BOOL fRet = false;
    
    switch(maShu)
    {
        case 0:
        case 8:
        {
            //0,1,2,3,...9
            if(newMa >=0 && newMa<=9)
            {
                fRet = true;
            }
            // >=11 and <=55
            else if((newMa/10 >= 1 && newMa/10 <=5) && (newMa%10 >= 1 && newMa%10 <=5))
            {
                fRet = true;
            }
            //Lian Xiang
            else if(newMa == 99)
            {
                fRet = true;
            }
            //Mode Selection
            else if(newMa == -2)
            {
                fRet = true;
            }
            else
                fRet = false;
        }
            break;
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        {
            //1,2,3,4,5
            if(newMa >=0 && newMa<=5)  //0 is valid input for all time such as 14 0 0 0, 44 0 0 0
            {
                fRet = true;
            }
            // >=11 and <=55
            else if((newMa/10 >= 1 && newMa/10 <=5) && (newMa%10 >= 1 && newMa%10 <=5)) 
            {
                fRet = true;
            }
            else
                fRet = false;
        }
            break;
        default:
            fRet = false;
            break;
    }
    
    return fRet;
}

- (BOOL)isHeMaValid;
{
    return [self isHeMa1Valid] && [self isHeMa2Valid] && [self isHeMa3Valid]; //[self isma4Valid]
}

- (BOOL)isHeMa1Valid;
{
	bool fRet = false;
	
	switch(maShu)
	{
		case 0:
		{
			if(ma1==0)
				fRet = true;
			else
				fRet = false;
		}
			break;
		case 1:
		{
			if(ma1>=1 && ma1<=5)
				fRet = true;
			else
				fRet = false;
		}
			break;
		case 2:
		case 3:
		case 4:
		{
			if(ma1 == 0 || ma1 == 99)
				fRet = true;
			else if((ma1 >=6 && ma1<=9)  || (ma1 == 62 ))
				fRet = true;
			else if((ma1/10 >= 1 && ma1/10 <=5) && (ma1%10 >= 1 && ma1%10 <=5))   //ma1 == 11...15, 21..25...51...55
				fRet = true;
			else
				fRet = false;
		}
			break;
		case 5:
		case 6:
		{
			if(ma1 == 99)
				fRet = true;
			else if((ma1 >=6 && ma1<=9)  || (ma1 == 62 ))
				fRet = true;
			else if((ma1/10 >= 1 && ma1/10 <=5) && (ma1%10 >= 1 && ma1%10 <=5))   //ma1 == 11...15, 21..25...51...55
				fRet = true;
			else
				fRet = false;
		}
			break;
		case 7:
		case 8:
		{
			if((ma1/10 >= 1 && ma1/10 <=5) && (ma1%10 >= 1 && ma1%10 <=5))   //ma1 == 11...15, 21..25...51...55
				fRet = true;
			else
				fRet = false;
		}
			break;
		default:
			break;
	}
	
	return fRet;
}

- (BOOL)isHeMa2Valid;
{
	bool fRet = false;
	
	switch(maShu)
	{
		case 0:
		case 1:
		case 2:
		{
			if(ma2==0)
				fRet = true;
			else
				fRet = false;
		}
			break;
		case 3:
		{
			if(ma2>=1 && ma2<=5)
				fRet = true;
			else
				fRet = false;
		}
			break;
		case 4:
		{
			if(ma2 == 0)
				fRet = true;
			else if((ma2/10 >= 1 && ma2/10 <=5) && (ma2%10 >= 1 && ma2%10 <=5))   //ma2 == 11...15, 21..25...51...55
				fRet = true;
			else
				fRet = false;
		}
			break;
		case 5:
		case 6:
		case 7:
		case 8:
		{
			if(ma2 == 0)
				fRet = true;
			else if((ma2/10 >= 1 && ma2/10 <=5) && (ma2%10 >= 1 && ma2%10 <=5))   //ma2 == 11...15, 21..25...51...55
				fRet = true;
			else
				fRet = false;
		}
			break;
		default:
			break;
	}
	
	return fRet;
}

- (BOOL)isHeMa3Valid;
{
	bool fRet = false;
	
	switch(maShu)
	{
		case 0:
		case 1:
		case 2:
		case 3:
		case 4:
		{
			if(ma3==0)
				fRet = true;
			else
				fRet = false;
		}
			break;
		case 5:
		{
			if(ma3>=1 && ma3<=5)
				fRet = true;
			else
				fRet = false;
		}
			break;
		case 6:
		{
			if(ma3 == 0)
				fRet = true;
			else if((ma3/10 >= 1 && ma3/10 <=5) && (ma3%10 >= 1 && ma3%10 <=5))   //ma3 == 11...15, 21..25...51...55
				fRet = true;
			else
				fRet = false;
		}
			break;
		case 7:
		case 8:
		{
			if(ma3 == 0)
				fRet = true;
			else if((ma3/10 >= 1 && ma3/10 <=5) && (ma3%10 >= 1 && ma3%10 <=5))   //ma3 == 11...15, 21..25...51...55
				fRet = true;
			else
				fRet = false;
		}
			break;
		default:
			break;
	}
	
	return fRet;
}

- (BOOL)isHeMa4Valid;
{
	bool fRet = false;
	
	switch(maShu)
	{
		case 0:
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		case 6:
		{
			if(ma4==0)
				fRet = true;
			else
				fRet = false;
		}
			break;
		case 7:
		{
			if(ma4>=1 && ma4<=5)
				fRet = true;
			else
				fRet = false;
		}
			break;
		case 8:
		{
			if(ma4 == 0)
				fRet = true;
			else if((ma4/10 >= 1 && ma4/10 <=5) && (ma4%10 >= 1 && ma4%10 <=5))   //ma4 == 11...15, 21..25...51...55
				fRet = true;
			else
				fRet = false;
		}
			break;
		default:
			break;
	}
	
	return fRet;
}

- (NSString*)provideTypedMaStr;
{
    NSString *typedMaStr = nil;
    
    switch (maShu) {
        case 0:
            typedMaStr = @" ";
            break;
        case 1:
            typedMaStr = [NSString stringWithFormat:@"%ld-", (long)ma1];
            break;
        case 2:
            typedMaStr = [NSString stringWithFormat:@"%ld", (long)ma1];
            break;
        case 3:
            typedMaStr = [NSString stringWithFormat:@"%ld %ld-",  (long)ma1, (long)ma2];
            break;
        case 4:
            typedMaStr = [NSString stringWithFormat:@"%ld %ld",  (long)ma1, (long)ma2];
            break;
        case 5:
            typedMaStr = [NSString stringWithFormat:@"%ld %ld %ld-",  (long)ma1, (long)ma2, (long)ma3];
            break;
        case 6:
            typedMaStr = [NSString stringWithFormat:@"%ld %ld %ld",  (long)ma1, (long)ma2, (long)ma3];
            break;
        case 7:
            typedMaStr = [NSString stringWithFormat:@"%ld %ld %ld %ld-",  (long)ma1, (long)ma2, (long)ma3, (long)ma4];
            break;
        case 8:
            typedMaStr = [NSString stringWithFormat:@"%ld %ld %ld %ld",  (long)ma1, (long)ma2, (long)ma3, (long)ma4];
            break;
        default:
            break;
    }
    
    return typedMaStr;
}

- (NSString*)provideMenuTypedMaStr;
{
    NSString *typedMaStr = nil;
    
    switch (maShu) {
        case 0:
            typedMaStr = @" ";
            break;
        case 1:
        case 2:
            typedMaStr = [NSString stringWithFormat:@"%@: ", NSLocalizedString(@"menu_menu", @"Menu")];
            break;
        case 3:
        case 4:
            typedMaStr = [NSString stringWithFormat:@"%@: %ld",  NSLocalizedString(@"menu_menu", @"Mode"), (long)ma2];
            break;
        case 5:
        case 6:
            typedMaStr = [NSString stringWithFormat:@"%@: %ld %ld",  NSLocalizedString(@"menu_menu", @"Mode"), (long)ma2, (long)ma3];
            break;
        case 7:
        case 8:
            typedMaStr = [NSString stringWithFormat:@"%@: %ld %ld %ld",  NSLocalizedString(@"menu_menu", @"Mode"), (long)ma2, (long)ma3, (long)ma4];
            break;
        default:
            break;
    }
    
    return typedMaStr;
}

- (NSString*)getTypedEngStr;
{
    NSMutableString *str = [NSMutableString stringWithString:self.typedEngStr];
    
    switch(self.engShuMa)
    {
        case 1:
            [str appendString:@"1-"];  // F1E2T3J4Z5"];//"1- f1e2t3j4z5";
            break;
        case 2:
            [str appendString:@"2-"];  //B1A2D3P4R5"];//"2- b1a2d3p4r5";
            break;
        case 3:
            [str appendString:@"3-"];  //L1I2N3H4K5M6"];//"3- l1i2n3h4k5m6";
            break;
        case 4:
            [str appendString:@"4-"];  // C1O2S3G4Q5"];//"4- c1o2s3g4q5";
            break;
        case 5:
            [str appendString:@"5-"];  // V1U2W3Y4X5"];//"5- v1u2w3y4x5";
            break;
        default:
            break;
    }		
    return str;
}

- (unichar)engShuMaToEngCharacter:(NSUInteger)shuMa
{
    unichar	engChar = '\0';
    
    switch(shuMa)
    {
        case 11:
            engChar = 'f';
            break;
        case 12:
            engChar = 'e';
            break;
        case 13:
            engChar = 't';
            break;
        case 14:
            engChar = 'j';
            break;
        case 15:
            engChar = 'z';
            break;
        case 21:
            engChar = 'b';
            break;
        case 22:
            engChar = 'a';
            break;
        case 23:
            engChar = 'd';
            break;
        case 24:
            engChar = 'p';
            break;
        case 25:
            engChar = 'r';
            break;
        case 31:
            engChar = 'l';
            break;
        case 32:
            engChar = 'i';
            break;
        case 33:
            engChar = 'n';
            break;
        case 34:
            engChar = 'h';
            break;
        case 35:
            engChar = 'k';
            break;
        case 36:
            engChar = 'm';
            break;
        case 41:
            engChar = 'c';
            break;
        case 42:
            engChar = 'o';
            break;
        case 43:
            engChar = 's';
            break;
        case 44:
            engChar = 'g';
            break;
        case 45:
            engChar = 'q';
            break;
        case 46:
            engChar = 0x27;
            break;
        case 51:
            engChar = 'v';
            break;
        case 52:
            engChar = 'u';
            break;
        case 53:
            engChar = 'w';
            break;
        case 54:
            engChar = 'y';
            break;
        case 55:
            engChar = 'x';
            break;
        default:
            break;
    }
    return engChar;
}

//only used by typingengCharShuMa()
- (BOOL)typeEnglishChar:(unichar)engChar
{
    //if(!isValid26Char(engChar))
    //    return false;
    
    //engCharShuMa = 0;
    //englishShuMaFormed = 0;
    
    if(self.typedEngStrLen<15)
    {
        [self.typedEngStr appendFormat:@"%C",engChar];
        self.typedEngStrLen++;
        
        //engCharArray[engCharArrayLen]=engChar;
        //engCharArrayLen++;
        //engCharArray[engCharArrayLen]='\0';
        //bEngCharArrayLenChanged = true;
        return true;
    }
    else
        return false;
}
@end
