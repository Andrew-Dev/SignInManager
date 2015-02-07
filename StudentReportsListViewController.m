//
//  StudentReportsListViewController.m
//  SignInManager
//
//  Created by Andrew on 10/23/14.
//  Copyright (c) 2014 Andrew Arpasi. Licensed under the MIT license.
//

#import "StudentReportsListViewController.h"

@interface StudentReportsListViewController ()

@end

@implementation StudentReportsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [[Student getAllStudents] count];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"All Students";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // Configure the cell...
    UILabel * nameLabel = (UILabel*)[cell viewWithTag:1];
    UILabel * descLabel = (UILabel*)[cell viewWithTag:2];
    NSMutableArray * students = [Student getAllStudents];
    Student * student = [NSKeyedUnarchiver unarchiveObjectWithData:[students objectAtIndex:indexPath.row]];
    //selectedStudent = student;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm"];
    nameLabel.text = student.name;
    descLabel.text = [NSString stringWithFormat:@"Attended %lu Robotics Sessions",(unsigned long)[[Session getAllSessionsForStudentAsData:student.code] count]];
    return cell;
}
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    //NSMutableArray * sessions = [Student getAllStudents];
    //sessionToView = [NSKeyedUnarchiver unarchiveObjectWithData:[sessions objectAtIndex:indexPath.row]];
    NSMutableArray * students = [Student getAllStudents];
    selectedStudent = [NSKeyedUnarchiver unarchiveObjectWithData:[students objectAtIndex:indexPath.row]];
    if([[Session getAllSessionsForStudentAsData:selectedStudent.code] count] == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Could not present student report." message:@"No data for student. They must sign in at least once." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    }
    else
    {
        [self performSegueWithIdentifier:@"studentReportSegue" sender:self];
        [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"studentReportSegue"])
    {
        StudentReportViewController * vc = [segue destinationViewController];
        vc.student = selectedStudent;
    }
}


@end
