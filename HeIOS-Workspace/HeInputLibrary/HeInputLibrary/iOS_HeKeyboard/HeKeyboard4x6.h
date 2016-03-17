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

#import <UIKit/UIKit.h>
#import "ShuMaAndIndicator_ViewController.h"
#import "HeInputLibrary/Input_DataServer.h"

@protocol HeKeyboard_Protocol <NSObject>
- (void)heInsertText:(NSString*)text;
- (void)leftArrow;
- (void)rightArrow;
- (void)upArrow;
- (void)downArrow;
- (void)backspace;
- (void)nextInputMode;
- (void)passDismissKeyboard;

//- (void)pleaseChangeKeyboard;
@end

//HeKeyboard4x6 responsible for HeKeyboard4x6 and tableView UI
@interface HeKeyboard4x6 : UIInputView
<UITableViewDataSource, UITableViewDelegate>
{
    bool bPreviousPage, bNextPage;
    NSUInteger maxItemsOfPage, numOfItemsInCurrentPage, pageIndex, itemIndex;
    
    UIView *bgColorView;
    
    BOOL bPreviousChineseChar;
    
    NSInteger atSignContinueTypedTimes;
    NSInteger periodSignContinueTypedTimes;
    NSInteger commaSignContinueTypedTimes;
    
    CGFloat fontSize10, fontSize20;
    int tableRowHeight;
}

@property (weak) id<HeKeyboard_Protocol> delegate;

@property (strong, nonatomic) Input_DataServer *dataServer;
@property (strong, nonatomic) ShuMaAndIndicator_ViewController *shuMaVC;

@property (readwrite) UIInputViewStyle inputStyle;
@property (readwrite) NSUInteger tableHeight, tableWidth;

@property (readwrite) int screenHeightPoints;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *heKeyCollection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableWidthConstraint;

@property (strong, nonatomic) NSString *previousInsertText;

- (void)initialKeyboard;

- (BOOL)handleNumKey4HeKeyboard4x6:(NSInteger)keyCode;
- (void)handleControlKey:(NSInteger)keyCode;

- (void)heLeftArrow;
- (void)heRightArrow;
- (void)heUpArrow;
- (void)heDownArrow;

- (void)turnOffPreviousTrace;

@end
