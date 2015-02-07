//
//  SessionsViewController.m
//  SignInManager
//
//  Created by Andrew on 10/21/14.
//  Copyright (c) 2014 Andrew Arpasi. Licensed under the MIT license.
//

#import "SessionsViewController.h"

@interface SessionsViewController ()

@end

@implementation SessionsViewController

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
    return [[Session getAllSessions] count];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"All Sessions";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // Configure the cell...
    UILabel * nameLabel = (UILabel*)[cell viewWithTag:1];
    UILabel * timeLabel = (UILabel*)[cell viewWithTag:2];
    NSArray * sessions = [[[Session getAllSessions] reverseObjectEnumerator] allObjects];
    Session * session = [NSKeyedUnarchiver unarchiveObjectWithData:[sessions objectAtIndex:indexPath.row]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm"];
    nameLabel.text = session.title;
    timeLabel.text = [session getSessionTimeString];
    
    return cell;
}
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    NSArray * sessions = [[[Session getAllSessions] reverseObjectEnumerator] allObjects];
    sessionToView = [NSKeyedUnarchiver unarchiveObjectWithData:[sessions objectAtIndex:indexPath.row]];
    [self performSegueWithIdentifier:@"sessionReportFromSessionReportsViewSegue" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSArray * sessionsArray = [[[Session getAllSessions] reverseObjectEnumerator] allObjects];
        NSMutableArray * sessions = [[NSMutableArray alloc] initWithArray:sessionsArray];
        [sessions removeObjectAtIndex:indexPath.row];
        sessionsArray = [[sessions reverseObjectEnumerator] allObjects];
        sessions = [[NSMutableArray alloc] initWithArray:sessionsArray];
        [[NSUserDefaults standardUserDefaults] setObject:sessions forKey:@"sessions"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
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



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"sessionReportFromSessionReportsViewSegue"])
    {
        SessionReportViewController * vc = [segue destinationViewController];
        vc.session = sessionToView;
    }
}


@end
