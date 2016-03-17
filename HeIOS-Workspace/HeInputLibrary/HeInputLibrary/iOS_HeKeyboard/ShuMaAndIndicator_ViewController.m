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

#import "ShuMaAndIndicator_ViewController.h"
#import "HeInputLibrary/Input_Constants.h"
#import "HeInputLibrary/Globel_Helper.h"

@interface ShuMaAndIndicator_ViewController ()

@end

@implementation ShuMaAndIndicator_ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    self.screenHeightPoints = [Globel_Helper detectScreenHeightPoints];
    
    CGFloat fontSize10 = 10;
    CGFloat fontSize20 = 20;
    
    if (self.screenHeightPoints == IPadHeightPoints)
    {
        fontSize10 = 18;
        fontSize20 = 24;
    }
    else if(self.screenHeightPoints == IPhone6PlusHeightPoints || self.screenHeightPoints == IPhone6HeightPoints)
    {
        fontSize10 = 14;
        fontSize20 = 16;
    }
    else  //iPhone 4 or 5
    {
        fontSize10 = 12;
        fontSize20 = 14;
    }
    
    self.shuMaLabel.font = [UIFont systemFontOfSize:fontSize20];
    self.pinYinLabel.font = [UIFont systemFontOfSize:fontSize10];
    self.pageLabel.font = [UIFont systemFontOfSize:fontSize20];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
