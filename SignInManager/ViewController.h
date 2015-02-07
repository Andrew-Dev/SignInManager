//
//  ViewController.h
//  SignInManager
//
//  Created by Andrew on 9/24/14.
//  Copyright (c) 2014 Andrew Arpasi. Licensed under the MIT license.
//

#import <UIKit/UIKit.h>
#import "BCScanner/BCScannerViewController.h"
#import "ClockViewController.h"
#import "Student.h"
#import "SessionReportViewController.h"

@interface ViewController : UIViewController <BCScannerViewControllerDelegate, UIContentContainer,UIAlertViewDelegate,UITextFieldDelegate>
{
    __weak IBOutlet UIView *CameraContainer;
    BOOL scanning;
    NSString * code;
    Session * sessionToReport;
}

@end

