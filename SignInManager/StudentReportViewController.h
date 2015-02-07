//
//  StudentReportViewController.h
//  SignInManager
//
//  Created by Andrew on 10/23/14.
//  Copyright (c) 2014 Andrew Arpasi. Licensed under the MIT license.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "Session.h"

@interface StudentReportViewController : UIViewController
{
    IBOutlet UILabel * studentLabel;
    IBOutlet UILabel * hoursLabel;
    IBOutlet UILabel * sessionStatsLabel;
    IBOutlet UITableView * sessionsTable;
}
@property Student * student;

@end
