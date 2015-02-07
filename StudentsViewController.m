//
//  StudentsViewController.m
//  SignInManager
//
//  Created by Andrew on 9/24/14.
//  Copyright (c) 2014 Andrew Arpasi. Licensed under the MIT license.
//

#import "StudentsViewController.h"

@interface StudentsViewController ()

@end

@implementation StudentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)createStudent:(id)sender
{
    Student * stu = [[Student alloc] init];
    stu.code = codeField.text;
    stu.name = nameField.text;
    NSMutableArray * students = [Student getAllStudents];
    [students addObject:[NSKeyedArchiver archivedDataWithRootObject:stu]];
    [[NSUserDefaults standardUserDefaults] setObject:students forKey:@"students"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [studentsView reloadData];
}
-(IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}
-(IBAction)scanForNewStudents:(id)sender
{
    if ([BCScannerViewController scannerAvailable]) {
        BCScannerViewController *scanner = [[BCScannerViewController alloc] init];
        scanner.delegate = self;
        scanner.scanningForNewStudents = TRUE;
        scanner.codeTypes = @[ BCScannerQRCode ];
        [self presentViewController:scanner animated:TRUE completion:nil];
        [self startScan];
    }
}
-(void)startScan
{
    scanning = TRUE;
}


#pragma mark - BCScannerViewControllerDelegate

- (void)scanner:(BCScannerViewController *)scanner codesDidEnterFOV:(NSSet *)codes
{
    if(scanning)
    {
        NSString * fullcode = [[codes allObjects] objectAtIndex:0];
        code = fullcode;
        NSLog(@"code: %@",fullcode);
        Student * stu = [Student getStudentFromCode:fullcode];
        if(stu != nil)
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Student Already Added" message:[NSString stringWithFormat:@"A student with code %@ has already been created.",fullcode] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            scanning = FALSE;
        }
        else
        {
            UIAlertView * newView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"New Student"] message:[NSString stringWithFormat:@"Please enter the student name. Code: %@.",fullcode] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create", nil];
            newView.alertViewStyle = UIAlertViewStylePlainTextInput;
            newView.tag = 2;
            [newView textFieldAtIndex:0].delegate = self;
            [newView show];
            scanning = FALSE;
        }
    }
}
- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

//- (void)scanner:(BCScannerViewController *)scanner codesDidUpdate:(NSSet *)codes
//{
//	NSLog(@"Updated: [%lu]", (unsigned long)codes.count);
//}

- (void)scanner:(BCScannerViewController *)scanner codesDidLeaveFOV:(NSSet *)codes
{
    NSLog(@"Deleted: [%@]", codes);
}

- (UIImage *)scannerHUDImage:(BCScannerViewController *)scanner
{
    return [UIImage imageNamed:@"HUD"];
}

-(void)didPresentAlertView:(UIAlertView *)alertView
{
    if(alertView.tag == 2)
        [[alertView textFieldAtIndex:0] becomeFirstResponder];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 2 && buttonIndex == 1)
    {
        Student * stu = [[Student alloc] init];
        stu.code = code;
        stu.name = [alertView textFieldAtIndex:0].text;
        NSMutableArray * students = [Student getAllStudents];
        [students addObject:[NSKeyedArchiver archivedDataWithRootObject:stu]];
        [[NSUserDefaults standardUserDefaults] setObject:students forKey:@"students"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [studentsView reloadData];
    }
    if(alertView.tag == 2)
    {
        [[alertView textFieldAtIndex:0] resignFirstResponder];
    }
    [self startScan];
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 2)
    {
        [self startScan];
    }
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
    NSMutableArray * students = [Student getAllStudents];
    return [students count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
     // Configure the cell...
     NSMutableArray * students = [Student getAllStudents];
     Student * stu = [NSKeyedUnarchiver unarchiveObjectWithData:[students objectAtIndex:indexPath.row]];
     UILabel * nameLabel = (UILabel*)[cell viewWithTag:1];
     UILabel * codeLabel = (UILabel*)[cell viewWithTag:2];
     nameLabel.text = stu.name;
     codeLabel.text = [NSString stringWithFormat:@"ID#: %@",stu.code];
     return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         // Delete the row from the data source
         NSMutableArray * students = [Student getAllStudents];
         [students removeObjectAtIndex:indexPath.row];
         [[NSUserDefaults standardUserDefaults] setObject:students forKey:@"students"];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
