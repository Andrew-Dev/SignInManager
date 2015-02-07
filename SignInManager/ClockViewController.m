//
//  ClockViewController.m
//  SignInManager
//
//  Created by Andrew on 9/28/14.
//  Copyright (c) 2014 Andrew Arpasi. Licensed under the MIT license.
//

#import "ClockViewController.h"

@interface ClockViewController ()

@end

@implementation ClockViewController
@synthesize student;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate * now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm"];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"session"])
    {
        Session * current = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"session"]];
        NSMutableArray * studentInSession = [current getAllSessionsForStudentAsData:student];
        if([studentInSession count] == 0)
        {
            [self newStudentSession];
            NSLog(@"zero");
        }
        else
        {
            for(int i=0;i<[studentInSession count];i++)
            {
                StudentSession * stusess = (StudentSession*)[NSKeyedUnarchiver unarchiveObjectWithData:[studentInSession objectAtIndex:i]];
                [[current studentSessions] removeObject:[studentInSession objectAtIndex:i]];
                
                if(stusess.outTime == nil)
                {
                    stusess.outTime = [NSDate date];
                    
                    NSString * nowString = [formatter stringFromDate:now];
                    timeLabel.text = [NSString stringWithFormat:@"Clock out at: %@",nowString];
                    idLabel.text = [NSString stringWithFormat:@"ID#: %@",stusess.stucode];
                    welcomeLabel.text = @"Goodbye!";
                    Student * stu = [Student getStudentFromCode:stusess.stucode];
                    nameLabel.text = stu.name;
                    
                    [current.studentSessions addObject:[NSKeyedArchiver archivedDataWithRootObject:stusess]];
                    
                    NSData * currentSessionData = [NSKeyedArchiver archivedDataWithRootObject:current];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:currentSessionData forKey:@"session"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else
                {
                    [self newStudentSession];
                    NSLog(@"more than 0");
                }
                NSLog(@"count");
                [current.studentSessions addObject:[NSKeyedArchiver archivedDataWithRootObject:stusess]];
            }
        }
    }
    // Do any additional setup after loading the view.
}
-(void)newStudentSession
{
    NSDate * now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm"];
    NSString * nowString = [formatter stringFromDate:now];
    timeLabel.text = [NSString stringWithFormat:@"Clock in at: %@",nowString];
    Student * stu = [Student getStudentFromCode:student];
    
    nameLabel.text = stu.name;
    
    welcomeLabel.text = @"Welcome!";
    idLabel.text = [NSString stringWithFormat:@"ID#: %@",stu.code];
    
    StudentSession * stusession = [[StudentSession alloc] init];
    stusession.stucode = stu.code;
    stusession.inTime = now;
    
    NSData * stuSessionData = [NSKeyedArchiver archivedDataWithRootObject:stusession];
    NSData * currentSessionData = [[NSUserDefaults standardUserDefaults] objectForKey:@"session"];
    
    Session * session = [NSKeyedUnarchiver unarchiveObjectWithData:currentSessionData];
    
    [session.studentSessions addObject:stuSessionData];
    
    currentSessionData = [NSKeyedArchiver archivedDataWithRootObject:session];
    
    [[NSUserDefaults standardUserDefaults] setObject:currentSessionData forKey:@"session"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5];
}
-(void)dismiss
{
    [self dismissViewControllerAnimated:TRUE completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"resumeScan" object:nil];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
