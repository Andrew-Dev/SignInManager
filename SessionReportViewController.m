//
//  SessionReportViewController.m
//  SignInManager
//
//  Created by Andrew on 10/9/14.
//  Copyright (c) 2014 Andrew Arpasi. Licensed under the MIT license.
//

#import "SessionReportViewController.h"

@interface SessionReportViewController ()

@end

@implementation SessionReportViewController
@synthesize session;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"sesstitle: %@",session.title);
    titleLabel.text = session.title;
    timeLabel.text = [session getSessionTimeString];
    int studentSessionsCount = [[session getAllStudentSessionsFromThisSessionAsDataObjectsAsData] count];
    int clockOutForgotCount = [[session getUnclockedStudents] count];
    NSLog(@"sesscount: %d clockoutcount: %d",studentSessionsCount,clockOutForgotCount);
    studentStatsLabel.text = [NSString stringWithFormat:@"Student Attendances: %d - Did not clock out: %d",studentSessionsCount,clockOutForgotCount];
    // Do any additional setup after loading the view.
}
-(IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [[session getAllStudentSessionsFromThisSessionAsDataObjectsAsData] count];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Student Time In This Session";
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
 
 // Configure the cell...
     UILabel * nameLabel = (UILabel*)[cell viewWithTag:1];
     UILabel * totalTimeLabel = (UILabel*)[cell viewWithTag:2];
     UILabel * clockInOutLabel = (UILabel*)[cell viewWithTag:3];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     NSMutableArray * stusesses = [session getAllStudentSessionsFromThisSessionAsDataObjectsAsData];
     StudentSession * stusess = [NSKeyedUnarchiver unarchiveObjectWithData:[stusesses objectAtIndex:indexPath.row]];
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     [formatter setDateFormat:@"hh:mm"];
     nameLabel.text = [Student getStudentFromCode:stusess.stucode].name;
     clockInOutLabel.text = [NSString stringWithFormat:@"Clock In: %@, Clock Out: %@",[formatter stringFromDate:stusess.inTime],[formatter stringFromDate:stusess.outTime]];
     NSTimeInterval totalTime = [stusess.outTime timeIntervalSinceDate:stusess.inTime];
     totalTimeLabel.text = [NSString stringWithFormat:@"%@",[self stringFromTimeInterval:totalTime]];
     
 return cell;
 }

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
