//
//  StudentReportViewController.m
//  SignInManager
//
//  Created by Andrew on 10/23/14.
//  Copyright (c) 2014 Andrew Arpasi. Licensed under the MIT license.
//

#import "StudentReportViewController.h"

@interface StudentReportViewController ()

@end

@implementation StudentReportViewController
@synthesize student;

- (void)viewDidLoad {
    [super viewDidLoad];
    studentLabel.text = student.name;
    hoursLabel.text = [student getStudentHoursTotalAsString];
    sessionStatsLabel.text = [NSString stringWithFormat:@"Last Session Attended: %@",[student getLastSessionAttended].title];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
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
    return [[Session getAllStudentSessionsInAllSessionsForStudentAsDataInOneHugeAssArray:student.code] count];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Session Attendances For This Student";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    UILabel * nameLabel = (UILabel*)[cell viewWithTag:1];
    UILabel * totalTimeLabel = (UILabel*)[cell viewWithTag:2];
    UILabel * clockInOutLabel = (UILabel*)[cell viewWithTag:3];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableArray * stusesses = [Session getAllStudentSessionsInAllSessionsForStudentAsDataInOneHugeAssArray:student.code];
    StudentSession * stusess = [NSKeyedUnarchiver unarchiveObjectWithData:[stusesses objectAtIndex:indexPath.row]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm"];
    nameLabel.text = [Session getSessionThatHasStudentSession:stusess].title;
    clockInOutLabel.text = [NSString stringWithFormat:@"Clock In: %@, Clock Out: %@",[formatter stringFromDate:stusess.inTime],[formatter stringFromDate:stusess.outTime]];
    NSTimeInterval totalTime = [stusess.outTime timeIntervalSinceDate:stusess.inTime];
    totalTimeLabel.text = [NSString stringWithFormat:@"%@",[self stringFromTimeInterval:totalTime]];
    
    return cell;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
