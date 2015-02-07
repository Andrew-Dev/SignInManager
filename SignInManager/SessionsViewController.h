//
//  SessionsViewController.h
//  SignInManager
//
//  Created by Andrew on 10/21/14.
//  Copyright (c) 2014 Andrew Arpasi. Licensed under the MIT license.
//

#import <UIKit/UIKit.h>
#import "Session.h"
#import "SessionReportViewController.h"

@interface SessionsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView * sessionList;
    Session * sessionToView;
}
@end
