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

#import "HeKeyboard_ViewController.h"
#import "HeInputLibrary/Globel_Helper.h"

@interface HeKeyboard_ViewController ()

@property (nonatomic, strong) UIButton *nextKeyboardButton;

@end

@implementation HeKeyboard_ViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.screenHeightPoints = [Globel_Helper detectScreenHeightPoints];
    
    if (self.screenHeightPoints == IPadHeightPoints)
    {
        _keyboard4x6 = [[[NSBundle mainBundle] loadNibNamed:@"HeKeyboard4x6-iPad" owner:nil options:nil] objectAtIndex:0];
    }
    else if (self.screenHeightPoints == IPhone6HeightPoints || self.screenHeightPoints == IPhone6PlusHeightPoints)
    {
        _keyboard4x6 = [[[NSBundle mainBundle] loadNibNamed:@"HeKeyboard4x6-iPhone6" owner:nil options:nil] objectAtIndex:0];
    }
    else if (self.screenHeightPoints == IPhone5HeightPoints)
    {
        _keyboard4x6 = [[[NSBundle mainBundle] loadNibNamed:@"HeKeyboard4x6-iPhone5" owner:nil options:nil] objectAtIndex:0];
    }
    else //iPhone 4
    {
        _keyboard4x6 = [[[NSBundle mainBundle] loadNibNamed:@"HeKeyboard4x6-iPhone4" owner:nil options:nil] objectAtIndex:0];
    }
    
    [self.keyboard4x6 initialKeyboard];
    self.keyboard4x6.delegate = self;

    self.view = self.keyboard4x6;
    self.view.backgroundColor = [UIColor clearColor];
    self.inputView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGFloat keyboard_height = 0;
    
    if (self.screenHeightPoints == IPadHeightPoints)
    {
        keyboard_height = self.keyboard4x6.tableHeight + 132 + 4*25; //35*4 + 132+ 100 = 140+ 132+ 100 = 372
    }
    else if (self.screenHeightPoints == IPhone6HeightPoints || self.screenHeightPoints == IPhone6PlusHeightPoints)
    {
        keyboard_height = self.keyboard4x6.tableHeight + 132 + 40;   //25*4 + 172 = 100 + 172 = 272
    }
    else if(self.screenHeightPoints == IPhone5HeightPoints)
    {
        keyboard_height = self.keyboard4x6.tableHeight + 132 + 16;   //22*4 + 132 + 16 = 236
    }
    else //iPHone 4
    {
        keyboard_height = self.keyboard4x6.tableHeight + 132;   //20*4 + 132 = 212
    }
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant: keyboard_height];
    
    [self.view addConstraint: heightConstraint];
}

- (void)addNextKeyboard
{
    // Perform custom UI setup here
    self.nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.nextKeyboardButton setTitle:NSLocalizedString(@"Next Keyboard", @"Title for 'Next Keyboard' button") forState:UIControlStateNormal];
    [self.nextKeyboardButton sizeToFit];
    self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.nextKeyboardButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.nextKeyboardButton];
    
    NSLayoutConstraint *nextKeyboardButtonLeftSideConstraint = [NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    NSLayoutConstraint *nextKeyboardButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [self.view addConstraints:@[nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    /*
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    //*/
//    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}

- (void)heInsertText:(NSString *)text
{
    [self.textDocumentProxy insertText:text];

    /*
    if (self.bPracticeMode)
    {
        [self.heInput_textView_delegate typedString4Practice:text];
    }
    else
    {
        [self insertText:text];
        
        AppSingleton *appSingleton = [AppSingleton sharedInstance];
        appSingleton.srAtRuntime.typeWords += [text length];
    }
    [self showOrHideInputAccessoryView:NO];
    //*/
}

#pragma mark HeKeyboard

- (void)help
{
    //HelpPage_ViewController *helpPage_VC = [[HelpPage_ViewController alloc] init];
     //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSLocalizedString(@"URL_HeInputHelp", @"HelpPage")]];
    //[self presentViewController:helpPage_VC animated:nil completion:nil];
}

- (void)leftArrow;
{
    [self.textDocumentProxy adjustTextPositionByCharacterOffset:-1];
}

- (void)rightArrow;
{
    [self.textDocumentProxy adjustTextPositionByCharacterOffset:1];
}

- (void)upArrow;
{
    [self.textDocumentProxy adjustTextPositionByCharacterOffset:-1];
}

- (void)downArrow;
{
    [self.textDocumentProxy adjustTextPositionByCharacterOffset:1];
}

- (void)backspace{
    [self.textDocumentProxy deleteBackward];
}

- (void)nextInputMode{
    [self advanceToNextInputMode];
}

- (void)passDismissKeyboard;
{
    [self dismissKeyboard];
}
@end
