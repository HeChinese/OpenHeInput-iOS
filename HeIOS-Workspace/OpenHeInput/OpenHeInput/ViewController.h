//
//  ViewController.h
//  OpenHeInput
//
//  Created by Ouyang on 2016-03-16.
//  Copyright © 2016 Guilin Ouyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *heInput_title;
@property (weak, nonatomic) IBOutlet UITextView *setting_steps;

- (IBAction)goToHeInputOpenSource:(id)sender;
- (IBAction)openHeZiWebSite:(id)sender;
@end

