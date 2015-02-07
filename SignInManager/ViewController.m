//
//  ViewController.m
//  SignInManager
//
//  Created by Andrew on 9/24/14.
//  Copyright (c) 2014 Andrew Arpasi. Licensed under the MIT license.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startScan) name:@"resumeScan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedSession) name:@"finishedSessionNotification" object:nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Robotics Sign In Manager" message:[NSString stringWithFormat:@"Please enter the administrator password."] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Authenticate",nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    alert.tag = 3;
    [alert textFieldAtIndex:0].delegate = self;
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)finishedSession
{
    NSLog(@"finished session");
    NSData * currentSessionData = [[NSUserDefaults standardUserDefaults] objectForKey:@"session"];
    sessionToReport = [NSKeyedUnarchiver unarchiveObjectWithData:currentSessionData];
    [self performSelector:@selector(presentFinishedReport) withObject:nil afterDelay:0.8];
}
-(void)presentFinishedReport
{
    [self performSegueWithIdentifier:@"sessionReportSegue" sender:self];
}
-(void)startScan
{
    scanning = TRUE;
}
-(IBAction)scan:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Start Session" message:[NSString stringWithFormat:@"Enter a title for the session. Leave blank to use the current date and time."] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Start",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 1;
    [alert textFieldAtIndex:0].delegate = self;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1 && buttonIndex == 1)
    {
        Session * session = [[Session alloc] init];
        UITextField * text = [alertView textFieldAtIndex:0];
        if([text.text isEqual:@""] || text.text == nil)
        {
            NSDate * now = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM/dd/yyyy"];
            NSString * nowString = [formatter stringFromDate:now];
            NSLog(@"now: %@",nowString);
            session.title = nowString;
        }
        else
        {
            session.title = text.text;
        }
        [session start];
        NSData * currentSessionData = [NSKeyedArchiver archivedDataWithRootObject:session];
        [[NSUserDefaults standardUserDefaults] setObject:currentSessionData forKey:@"session"];
        if ([BCScannerViewController scannerAvailable]) {
            BCScannerViewController *scanner = [[BCScannerViewController alloc] init];
            scanner.delegate = self;
            scanner.scanningForNewStudents = FALSE;
            scanner.codeTypes = @[ BCScannerQRCode ];
            [self presentViewController:scanner animated:TRUE completion:nil];
            [self startScan];
        }
    }
    if(alertView.tag == 3)
    {
        UITextField * text = [alertView textFieldAtIndex:0];
        if([text.text isEqualToString:@"1234"])
        {
            NSLog(@"yay");
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Robotics Sign In Manager" message:[NSString stringWithFormat:@"Please enter the administrator password."] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Authenticate",nil];
            alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
            alert.tag = 3;
            [alert textFieldAtIndex:0].delegate = self;
            [alert show];
        }
    }
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 2)
    {
        [self startScan];
    }
}
-(IBAction)editStudents:(id)sender
{
    [self performSegueWithIdentifier:@"editSegue" sender:sender];
}
-(IBAction)sessionReports:(id)sender
{
    [self performSegueWithIdentifier:@"sessionReportsSegue" sender:sender];
}
-(IBAction)studentReports:(id)sender
{
    [self performSegueWithIdentifier:@"studentReportsSegue" sender:sender];
}
#pragma mark - BCScannerViewControllerDelegate

- (void)scanner:(BCScannerViewController *)scanner codesDidEnterFOV:(NSSet *)codes
{
    if(scanning)
    {
        NSString * fullcode = [[codes allObjects] objectAtIndex:0];
        NSLog(@"code: %@",fullcode);
        code = fullcode;
        Student * stu = [Student getStudentFromCode:fullcode];
        if(stu != nil)
        {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle: nil];
            ClockViewController * clock = [mainStoryboard instantiateViewControllerWithIdentifier:@"authView"];
            clock.student = fullcode;
            clock.modalPresentationStyle = UIModalPresentationFormSheet;
            [scanner presentViewController:clock animated:TRUE completion:nil];
        }
        else
        {
            UIAlertView * welcomeView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Could not find student with ID# %@.",fullcode] message:[NSString stringWithFormat:@"A student with number %@ could not be found. Please ask an instructor to add your id.",fullcode] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            welcomeView.tag = 2;
            [welcomeView show];
            scanning = FALSE;
        }
    }
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"clockSegue"])
    {
        ClockViewController * clockView = [segue destinationViewController];
        clockView.student = code;
    }
    if([[segue identifier] isEqualToString:@"sessionReportSegue"])
    {
        SessionReportViewController * sessionView = [segue destinationViewController];
        sessionView.session = sessionToReport;
    }
}

@end
