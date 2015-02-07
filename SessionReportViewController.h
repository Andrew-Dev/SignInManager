//
//  SessionReportViewController.h
//  SignInManager
//
//  Created by Andrew on 10/9/14.
//  Copyright (c) 2014 Andrew Arpasi. Licensed under the MIT license.
//

#import <UIKit/UIKit.h>
#import "Session.h"
#import "Student.h"

@interface SessionReportViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UILabel * titleLabel;
    IBOutlet UILabel * timeLabel;
    IBOutlet UILabel * studentStatsLabel;
    IBOutlet UITableView * attendanceTable;
}
@property Session * session;

@end
