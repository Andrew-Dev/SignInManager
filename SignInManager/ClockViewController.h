//
//  ClockViewController.h
//  SignInManager
//
//  Created by Andrew on 9/28/14.
//  Copyright (c) 2014 Andrew Arpasi. Licensed under the MIT license.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "Session.h"

@interface ClockViewController : UIViewController
{
    IBOutlet UILabel * welcomeLabel;
    IBOutlet UILabel * idLabel;
    IBOutlet UILabel * nameLabel;
    IBOutlet UILabel * timeLabel;
}
@property (weak) NSString * student;

@end
