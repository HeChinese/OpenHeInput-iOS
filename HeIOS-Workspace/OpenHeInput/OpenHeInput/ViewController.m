//
//  ViewController.m
//  OpenHeInput
//
//  Created by Ouyang on 2016-03-16.
//  Copyright © 2016 Guilin Ouyang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.heInput_title.text = NSLocalizedString(@"Input_Title", @"Open HeInput");
    self.setting_steps.text = NSLocalizedString(@"Setting_Step", @"Setting steps") ;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToHeInputOpenSource:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/HeChinese/OpenHeInput-iOS"]];
}

- (IBAction)openHeZiWebSite:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.HeZi.net"]];
}
@end
