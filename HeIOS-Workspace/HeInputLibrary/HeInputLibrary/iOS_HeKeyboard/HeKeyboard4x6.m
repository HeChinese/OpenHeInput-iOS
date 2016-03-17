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

#import "HeKeyboard4x6.h"
#import "HeInputLibrary/Globel_Helper.h"

@implementation HeKeyboard4x6

- (void)initialKeyboard
{
    maxItemsOfPage=4, numOfItemsInCurrentPage=0, pageIndex=0, itemIndex=0;
    
    self.shuMaVC = [[ShuMaAndIndicator_ViewController alloc] init];
    _dataServer = [Input_DataServer sharedInstance];
    
    self.previousInsertText = @"";
    bPreviousChineseChar = true;
    [self clearState];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor greenColor]];
    
    self.screenHeightPoints = [Globel_Helper detectScreenHeightPoints];
    
    int screenWidth = [Globel_Helper screenDimensionSmall];
    
    if (self.screenHeightPoints == IPadHeightPoints)
    {
        self.tableWidth = screenWidth*0.5;
        tableRowHeight = 35;
        fontSize10 = 24.0;
        fontSize20 = 30.0;
        maxItemsOfPage = 3;
        bgColorView.layer.cornerRadius = 6;
    }
    else if(self.screenHeightPoints == IPhone6HeightPoints || self.screenHeightPoints == IPhone6PlusHeightPoints)
    {
        bgColorView.layer.cornerRadius = 4;
        self.tableWidth = screenWidth*0.6;
        tableRowHeight = 25;
        fontSize10 = 16.0;
        fontSize20 = 22.0;
        maxItemsOfPage = 3;
    }
    else if (self.screenHeightPoints == IPhone5HeightPoints)
    {
        bgColorView.layer.cornerRadius = 2;
        self.tableWidth = screenWidth*0.7;
        tableRowHeight = 22;
        fontSize10 = 15.0;
        fontSize20 = 18.0;
        maxItemsOfPage = 3;
    }
    else
    {
        bgColorView.layer.cornerRadius = 2;
        self.tableWidth = screenWidth*0.7;
        tableRowHeight = 20;
        fontSize10 = 14.0;
        fontSize20 = 16.0;
        maxItemsOfPage = 3;
    }
    
    self.tableHeight = tableRowHeight*(maxItemsOfPage + 1);
    self.tableView.rowHeight = tableRowHeight;
    self.tableWidthConstraint.constant = self.tableWidth;
    
    [self addGesturesToKeyboard];

    UIButton *aBtn = nil;
    aBtn = (UIButton*)[self viewWithTag:11];
    [aBtn setTitle:NSLocalizedString(@"NumPad_Escape",@"Escape") forState:UIControlStateNormal];
    aBtn = (UIButton*)[self viewWithTag:64];
    [aBtn setTitle:NSLocalizedString(@"NumPad_Mode",@"Change Mode") forState:UIControlStateNormal];
    //aBtn = (UIButton*)[self.view viewWithTag:24];
    //[aBtn setTitle:NSLocalizedString(@"NumP",@"Sound Switch") forState:UIControlStateNormal];
    aBtn = (UIButton*)[self viewWithTag:34];
    [aBtn setTitle:NSLocalizedString(@"NumPad_Space",@"Space") forState:UIControlStateNormal];
    aBtn = (UIButton*)[self viewWithTag:54];
    [aBtn setTitle:NSLocalizedString(@"NumPad_Return",@"Return") forState:UIControlStateNormal];
    aBtn = (UIButton*)[self viewWithTag:61];
    [aBtn setTitle:NSLocalizedString(@"NumPad_Backspace",@"Back") forState:UIControlStateNormal];
    
    aBtn = (UIButton*)[self viewWithTag:14];
    [aBtn setTitle:NSLocalizedString(@"NumPad_English",@"English") forState:UIControlStateNormal];
}

- (void)addGesturesToKeyboard
{
    for (UIButton *key in self.heKeyCollection)
    {
        [key addTarget:self action:@selector(pressHeKey:) forControlEvents:UIControlEventTouchDown];
        key.titleLabel.font = [UIFont systemFontOfSize:fontSize20];
        key.layer.cornerRadius = key.frame.size.height/3;
    }
}

- (void)turnOffPreviousTrace;
{
    atSignContinueTypedTimes = 0;
    periodSignContinueTypedTimes = 0;
    commaSignContinueTypedTimes = 0;
}

- (void)pressHeKey:(UIButton *)heKey
{
    NSInteger keyboardLocation = [heKey tag];
    NSInteger keyCode = -1;
    switch (keyboardLocation) {
        case 11:  //Esc
            keyCode = HeKeyCode_Escape;
            break;
        case 12:
            keyCode = HeKeyCode_UpArrow; //up arrow
            break;
        case 13:
            keyCode = HeKeyCode_DownArrow; //down arrow
            break;
        case 14:
            keyCode = HeKeyCode_NextInputMode;     //#123
            break;
        case 21:
            keyCode = 7;
            break;
        case 22:
            keyCode = 4;
            break;
        case 23:
            keyCode = 1;
            break;
        case 24:
            keyCode = 0;     //space Sound On/Off
            break;
        
        case 31:
            keyCode = 8;
            break;
        case 32:
            keyCode = 5;
            break;
        case 33:
            keyCode = 2;
            break;
        case 34:
            keyCode = HeKeyCode_Space;     //Sound On/Off
            break;
            
        case 41:
            keyCode = 9;
            break;
        case 42:
            keyCode = 6;
            break;
        case 43:
            keyCode = 3;
            break;
            
            
        case 51:
            keyCode = HeKeyCode_Underscore;
            break;
        case 52:
            keyCode = HeKeyCode_Period;
            break;
        case 53:
            keyCode = HeKeyCode_Comma;
            break;
        case 54:
            keyCode = HeKeyCode_Return;     //Return  //no comparable at 6x6
            break;
            
        case 61:
            keyCode = HeKeyCode_Backspace;     //back delete Pause
            break;
        case 62:
            keyCode = HeKeyCode_LeftArrow;    //left arrow
            break;
        case 63:
            keyCode = HeKeyCode_RightArrow;    //right arrow
            break;
        case 64:
            keyCode = HeKeyCode_Mode; //Mode change;
            break;
            
            
        default:
            break;
    }
    
    [self typeHeKeyboard4x6Key:keyCode];
}

- (void)typeHeKeyboard4x6Key:(NSInteger)keyCode;
{
    switch(keyCode)
    {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        {
            [self decideHandler4NumKey:keyCode];
            //[self.delegate heInsertText:[@(keyCode) stringValue]];
        }
            break;
        case HeKeyCode_Underscore:
        case HeKeyCode_Period:
        case HeKeyCode_Comma:
            
        case HeKeyCode_Space:	//Space
        case HeKeyCode_Escape:	//Esc
        case HeKeyCode_Mode:	//Mode
        case HeKeyCode_Backspace:
        case HeKeyCode_Return:  //return
        case HeKeyCode_LeftArrow:
        case HeKeyCode_RightArrow:
        case HeKeyCode_UpArrow:
        case HeKeyCode_DownArrow:
        case HeKeyCode_NextInputMode:
            //special keys which do not have compatable key on keyboard 6x6
            [self handleControlKey:keyCode];
            break;
        default:
            break;
    }
}

#pragma Decide who should process the key, HeKeyboard4x6 or HeKeyboard_ViewController
//HeKeyboard4x6 responsible for HeKeyboard4x6 and tableView UI
//HeKeyboard_ViewController responsible communite HeKeyboard4x6 to Client Text Field

- (BOOL)decideHandler4NumKey:(NSInteger)keyCode;
{
    if (self.dataServer.setting.currentKeyMode == NumberMode)
    {
        [self.delegate heInsertText:[@(keyCode) stringValue]];
        [self turnOffPreviousTrace];
        bPreviousChineseChar = false;
        return true;
    }
    
    if (self.dataServer.numOfCand == 0) {
        //[self showOrHideInputAccessoryView:YES];
    }
    
    return [self handleNumKey4HeKeyboard4x6:keyCode];
}

#pragma HeKeyboard4x6 UI functions

- (void)heLeftArrow;
{
    if (self.dataServer.numOfCand>0) {
        [self changePageIndexBy:-1];
    }
    else
        [self.delegate leftArrow];
}

- (void)heRightArrow;
{
    if (self.dataServer.numOfCand>0) {
        [self changePageIndexBy:1];
    }
    else
        [self.delegate rightArrow];
}

- (void)heUpArrow;
{
    if (self.dataServer.numOfCand>0) {
        [self changeItemIndexBy:-1];
    }
    else
        [self.delegate leftArrow];
}

- (void)heDownArrow;
{
    if (self.dataServer.numOfCand>0) {
        [self changeItemIndexBy:1];
    }
    else
        [self.delegate rightArrow];
}

- (BOOL)handleNumKey4HeKeyboard4x6:(NSInteger)keyCode;
{
    //If it is continue typing
    if ([self.dataServer judgeContinueTyping:keyCode])
    {
        if (keyCode == 0)  //type 0 key
        {
            [self changeItemIndexBy:1];
            return true;
        }
        
        if (keyCode == 100)  //where shuma == 8  and backspace then come to here
        {
            
        }
        else  //6, 7 8 9
        {
            ZiCiObject *candItem = self.dataServer.candidateArray[pageIndex*maxItemsOfPage+itemIndex];
            
            self.previousInsertText = candItem.ziCi;
            [self.delegate heInsertText:self.previousInsertText];
            [self turnOffPreviousTrace];
            [self clearState];
        }
    }
    
    DataServer_Return returnValue = [self.dataServer typingCharOrNumber:0xffff TypedShuMa:keyCode];
    
    switch (returnValue) {
        case CandidateArrayChanged:
        {
            pageIndex = 0;
            [self changePage];
            [self turnOffPreviousTrace];
        }
            break;
        case ShuMaChanged:
        {
            self.shuMaVC.shuMaLabel.text = [self.dataServer provideTypedString];
        }
            break;
        case ChangeSelection:
        {
            [self changeItemIndexBy:1];
        }
            break;
        case TypeAndTypeBack:
            break;
        case CandidateArrayEmpty:
        {
            [self clearState];
            [self changePage];
        }
            break;
        case InvalidShuMa:
            break;
            
            //Menu Selected Return
        case MenuSelected_Repeat:
            [self.delegate heInsertText:self.previousInsertText];
            [self turnOffPreviousTrace];
            [self clearState];
            [self changePage];
            break;
            //case Return_MenuSelected_ContinueTyping:
            //case Return_MenuSelected_Error:
        case MenuSelected_InputMode_Changed:
            //[self.delegate pleaseChangeKeyboard];
            [self.dataServer setMenuArray];
            [self clearState];
            [self changePage];
            break;
        case MenuSelected_MenuArray_NeedUpdate:
            [self.dataServer setMenuArray];
            [self clearState];
            [self changePage];
            break;
        case MenuSelected_PleaseSaveSetting:
            break;
        default:
            break;
    }
    return true;
}

- (void)handleControlKey:(NSInteger)keyCode;
{
    switch(keyCode)
    {
        case HeKeyCode_Underscore:
            if (atSignContinueTypedTimes%2 == 1) {
                [self.delegate backspace];
                [self commitCandidate:pageIndex*maxItemsOfPage+itemIndex additionalText:@"_"];
                atSignContinueTypedTimes++;
            }
            else //if(atSignContinueTypedTimes%2 == 0)
            {
                if (atSignContinueTypedTimes > 0)
                    [self.delegate backspace];
                //[self.delegate heInsertText:@"@"];
                [self commitCandidate:pageIndex*maxItemsOfPage+itemIndex additionalText:@"@"];
                atSignContinueTypedTimes++;
            }
            break;
        case HeKeyCode_Period:      //？；
            if (bPreviousChineseChar) {
                if (periodSignContinueTypedTimes%2 == 1) {
                    [self.delegate backspace];
                    [self commitCandidate:pageIndex*maxItemsOfPage+itemIndex additionalText:@"？"];
                    periodSignContinueTypedTimes++;
                }
                else
                {
                    if (periodSignContinueTypedTimes>0) {
                        [self.delegate backspace];
                    }
                    [self commitCandidate:pageIndex*maxItemsOfPage+itemIndex additionalText:@"。"];
                    periodSignContinueTypedTimes++;
                }
            }
            else
            {
                if (periodSignContinueTypedTimes%2 == 1) {
                    [self.delegate backspace];
                    [self commitCandidate:pageIndex*maxItemsOfPage+itemIndex additionalText:@"?"];
                    periodSignContinueTypedTimes++;
                }
                else
                {
                    if (periodSignContinueTypedTimes > 0) {
                        [self.delegate backspace];
                    }
                    [self commitCandidate:pageIndex*maxItemsOfPage+itemIndex additionalText:@"."];
                    periodSignContinueTypedTimes++;
                }

            }
            break;
        case HeKeyCode_Comma:
            if (bPreviousChineseChar) {
                if (commaSignContinueTypedTimes%2 == 1) {
                    [self.delegate backspace];
                    [self commitCandidate:pageIndex*maxItemsOfPage+itemIndex additionalText:@"；"];
                    commaSignContinueTypedTimes++;
                }
                else
                {
                    if (commaSignContinueTypedTimes>0) {
                        [self.delegate backspace];
                    }
                    [self commitCandidate:pageIndex*maxItemsOfPage+itemIndex additionalText:@"，"];
                    commaSignContinueTypedTimes++;
                }
            }
            else
            {
                if (commaSignContinueTypedTimes%2 == 1) {
                    [self.delegate backspace];
                    [self commitCandidate:pageIndex*maxItemsOfPage+itemIndex additionalText:@";"];
                    commaSignContinueTypedTimes++;
                }
                else
                {
                    if (commaSignContinueTypedTimes > 0) {
                        [self.delegate backspace];
                    }
                    [self commitCandidate:pageIndex*maxItemsOfPage+itemIndex additionalText:@","];
                    commaSignContinueTypedTimes++;
                }
            }
            break;
        case HeKeyCode_Space:	//Space
            if (self.dataServer.numOfCand>0)
            {
                [self commitCandidate:pageIndex*maxItemsOfPage+itemIndex additionalText:@""];
            }
            else
            {
                if (bPreviousChineseChar) {
                     [self.delegate heInsertText:@"　"];
                }
                else
                    [self.delegate heInsertText:@" "];
                
                [self turnOffPreviousTrace];
            }
            break;
        case HeKeyCode_Return:  //return
            if (self.dataServer.numOfCand>0)
            {
                [self commitCandidate:pageIndex*maxItemsOfPage+itemIndex additionalText:@""];
            }
            else
            {
                [self.delegate heInsertText:@"\n"];
                [self turnOffPreviousTrace];
            }
            break;
        case HeKeyCode_Escape:	//Esc
            if (self.dataServer.numOfCand>0)
            {
                [self clearState];
                [self changePage];
            }
            else
            {
                [self.delegate passDismissKeyboard];
            }
            break;
        case HeKeyCode_Mode:	//Mode
            [self handleNumKey4HeKeyboard4x6:-2];
            break;
        case HeKeyCode_Backspace:
            if (self.dataServer.numOfCand>0)
            {
                [self handleNumKey4HeKeyboard4x6:100]; //backspace
            }
            else
            {
                if (periodSignContinueTypedTimes>0 || commaSignContinueTypedTimes>0)
                {
                    bPreviousChineseChar = !bPreviousChineseChar;
                }
                [self.delegate backspace];
                [self turnOffPreviousTrace];
            }
            break;
        case HeKeyCode_LeftArrow:
            [self heLeftArrow];
            break;
        case HeKeyCode_RightArrow:
            [self heRightArrow];
            break;
        case HeKeyCode_UpArrow:
            [self heUpArrow];
            break;
        case HeKeyCode_DownArrow:
            [self heDownArrow];
            break;
        case HeKeyCode_NextInputMode:
            [self.delegate nextInputMode];
            break;
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return numOfItemsInCurrentPage;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    [cell setSelectedBackgroundView:bgColorView];
    
    ZiCiObject *candItem = self.dataServer.candidateArray[pageIndex*maxItemsOfPage + indexPath.row];
    cell.textLabel.text = candItem.ziCi;
    
    if (candItem.promptMa == 404) //indicate PinYin
    {
        cell.detailTextLabel.text = [self.dataServer provideDanZiCodeString:candItem.ziCi];
    }
    else if (candItem.promptMa == 26)  //indicate HeEnglish
    {
        ;
    }
    else
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)candItem.promptMa];
    }
    
    cell.textLabel.textColor = [UIColor blueColor];
    cell.detailTextLabel.textColor = [UIColor blueColor];
    
    cell.textLabel.font = [UIFont systemFontOfSize:fontSize10];
    
    if (self.screenHeightPoints == IPadHeightPoints)
    {
        cell.detailTextLabel.font = [UIFont systemFontOfSize:fontSize10*0.8];
    }
    else if(self.screenHeightPoints == IPhone6HeightPoints || self.screenHeightPoints == IPhone6PlusHeightPoints)
    {
        cell.detailTextLabel.font = [UIFont systemFontOfSize:fontSize10*0.8];
    }
    else // iPhone 4 or 5
    {
        cell.detailTextLabel.font = [UIFont systemFontOfSize:fontSize10*0.9];
    }
    
    cell.backgroundColor = [UIColor cyanColor];
    
    //when last row loaded, seleted the default row
    if (indexPath.row == numOfItemsInCurrentPage-1)
    {
        NSUInteger numOfCand = self.dataServer.numOfCand;
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:itemIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
        [self displayPinYinPrompt];
        self.shuMaVC.shuMaLabel.text = [self.dataServer provideTypedString];
        
        self.shuMaVC.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)pageIndex+1, (long)1 + (numOfCand-1)/maxItemsOfPage];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return tableRowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.shuMaVC.view;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self commitCandidate:pageIndex*maxItemsOfPage+indexPath.row additionalText:@""];
}

- (void)commitCandidate:(NSUInteger)itemInd additionalText:(NSString*)str
{
    ZiCiObject *candItem = self.dataServer.candidateArray[itemInd];
    
    if (![self.dataServer isInputable] && self.dataServer.numOfCand>0)
    {
        if (candItem.ma1 == 0 || candItem.ma1 == -2) {
            [self handleNumKey4HeKeyboard4x6:candItem.promptMa];
        }
        return;
    }
    else if (self.dataServer.numOfCand>0 && str.length == 0)
    {
        self.previousInsertText = candItem.ziCi;
        [self.delegate heInsertText: [NSString stringWithFormat:@"%@", self.previousInsertText]];
        bPreviousChineseChar = [self.dataServer isChineseCandidate];
    }
    else if (self.dataServer.numOfCand>0 && str.length > 0)
    {
        self.previousInsertText = candItem.ziCi;
        [self.delegate heInsertText: [NSString stringWithFormat:@"%@%@", self.previousInsertText, str]];
        bPreviousChineseChar = [self.dataServer isChineseCandidate];
    }
    else if (str.length>0)
    {
        [self.delegate heInsertText: [NSString stringWithFormat:@"%@", str]];
    }
    else
        return;
    
    [self clearState];
    [self changePage];
    if(str.length==0)
        [self turnOffPreviousTrace];
}

- (BOOL)changePageIndexBy:(NSInteger)num
{
    NSUInteger numOfCand = self.dataServer.numOfCand;
    
    if(numOfCand <= 0)
    {
        return false;
    }
    
    NSInteger pageIndexBeforeChange = pageIndex;
    
    if(num == 1)
    {
        pageIndex++;
        //next page is empty, then go to first page
        if(pageIndex*maxItemsOfPage >= numOfCand)
        {
            pageIndex=0;
        }
    }
    else if( num == -1)
    {
        //if previous page is empty, then go to last page
        if(pageIndex == 0)
        {
            pageIndex = (numOfCand + maxItemsOfPage - 1)/maxItemsOfPage-1; //when numOfCand = 1
        }
        else
        {
            pageIndex--;
        }
    }
    
    if(pageIndex != pageIndexBeforeChange)
    {
        if ([self.dataServer needShowEnglishCodeList])
        {
            //need to change typing state;
            itemIndex = 0;
            [self.dataServer heBackspace];
            [self.dataServer typingCharOrNumber:0xffff TypedShuMa:pageIndex*maxItemsOfPage + itemIndex+1];
        }

        [self changePage];
        return true;
    }
    else
        return false;
}

- (void)changePage
{
    itemIndex = 0;
    
    NSUInteger numOfCand = self.dataServer.numOfCand;
    
    if (numOfCand>0) {
        [self getNumOfItemsOfCurrentPage];
        
        [self.tableView reloadData];
    }
    else
    {
        self.shuMaVC.shuMaLabel.text = @"";
        self.shuMaVC.pinYinLabel.text = @"";
        self.shuMaVC.pageLabel.text = @"";
        [self.tableView reloadData];
    }
}

- (void)changeRow
{
    itemIndex = 0;
    
    NSUInteger numOfCand = self.dataServer.numOfCand;
    
    if (numOfCand>0)
    {
        [self getNumOfItemsOfCurrentPage];
        [self.tableView reloadData];
    }
    else
    {
        self.shuMaVC.shuMaLabel.text = @"";
        self.shuMaVC.pinYinLabel.text = @"";
        self.shuMaVC.pageLabel.text = @"";
        [self.tableView reloadData];
    }
}

- (void)getNumOfItemsOfCurrentPage
{
    NSUInteger numOfCand = self.dataServer.numOfCand;
    
    if ([self.dataServer needShowEnglishCodeList])
    {
        NSUInteger charShuMa = [self.dataServer provideEnglishShuMa];
        
        pageIndex = (charShuMa-1)/maxItemsOfPage;
        itemIndex = (charShuMa-1)%maxItemsOfPage;
    }
    
    NSUInteger numOfItemLeft = numOfCand - pageIndex*maxItemsOfPage;
    numOfItemsInCurrentPage = (numOfItemLeft>=maxItemsOfPage)? maxItemsOfPage:numOfItemLeft;
}

- (void)clearState;
{
    itemIndex = 0;
    pageIndex = 0;
    numOfItemsInCurrentPage = 0;
    [self.dataServer clearState];
}

- (BOOL)changeItemIndexBy:(NSInteger)num
{
    NSInteger itemIndexBeforeChange = itemIndex;
    
    if(numOfItemsInCurrentPage<=1)
        return false;
    
    if(num==1)
    {
        itemIndex++;
        //next page is empty, then go to first page
        if(itemIndex == numOfItemsInCurrentPage)
        {
            itemIndex=0;
        }
    }
    else
    {
        itemIndex--;
        //if previous page is empty, then go to last page
        if(itemIndex == -1)
        {
            itemIndex = numOfItemsInCurrentPage-1;
        }
    }
    
    if(itemIndex != itemIndexBeforeChange)
    {
        if ([self.dataServer needShowEnglishCodeList])
        {
            //need to change typing state;
            [self.dataServer heBackspace];
            [self.dataServer typingCharOrNumber:0xffff TypedShuMa:pageIndex*maxItemsOfPage + itemIndex+1];
            
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:itemIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            self.shuMaVC.shuMaLabel.text = [self.dataServer provideTypedString];
            
            return true;
        }
        
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:itemIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        [self displayPinYinPrompt];
        return true;
    }
    else
        return false;
    
}

- (void)displayPinYinPrompt
{
    NSString *danZiStr = ((ZiCiObject*)self.dataServer.candidateArray[pageIndex*maxItemsOfPage+itemIndex]).ziCi;
    
    self.shuMaVC.pinYinLabel.text = [self.dataServer getPinYinPromptString:danZiStr];
    
}
@end
