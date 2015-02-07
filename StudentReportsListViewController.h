//
//  StudentReportsListViewController.h
//  SignInManager
//
//  Created by Andrew on 10/23/14.
//  Copyright (c) 2014 Andrew Arpasi. Licensed under the MIT license.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "Session.h"
#import "StudentReportViewController.h"

@interface StudentReportsListViewController : UIViewController
{
    IBOutlet UITableView * studentListView;
    Student * selectedStudent;
}
@end
