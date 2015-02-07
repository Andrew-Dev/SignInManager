//
//  Student.m
//  SignInManager
//
//  Created by Andrew on 9/24/14.
//  Copyright (c) 2014 Andrew Arpasi. Licensed under the MIT license.
//

#import "Student.h"

@implementation Student
@synthesize code,name;

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        code = [decoder decodeObjectForKey:@"code"];
        name = [decoder decodeObjectForKey:@"name"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:code forKey:@"code"];
    [encoder encodeObject:name forKey:@"name"];
}
+(NSMutableArray*)getAllStudents
{
    NSMutableArray * students = [[NSMutableArray alloc] init];
    for(NSData * s in [[NSUserDefaults standardUserDefaults] objectForKey:@"students"])
    {
        [students addObject:s];
    }
    return students;
}
+(Student*)getStudentFromCode:(NSString*)code
{
    for(int i=0;i<[[self getAllStudents] count];i++)
    {
        Student * student = [NSKeyedUnarchiver unarchiveObjectWithData:[[self getAllStudents] objectAtIndex:i]];
        if([student.code isEqualToString:code])
        {
            return student;
        }
    }
    return nil;
}
-(NSString*)getStudentHoursTotalAsString
{
    NSMutableArray * stusesses = [Session getAllStudentSessionsInAllSessionsForStudentAsDataInOneHugeAssArray:code];
    NSTimeInterval totalTime = 0;
    for(NSData * s in stusesses)
    {
        StudentSession * sess = [NSKeyedUnarchiver unarchiveObjectWithData:s];
        NSTimeInterval time = [sess.outTime timeIntervalSinceDate:sess.inTime];
        totalTime += time;
    }
    return [NSString stringWithFormat:@"Total Hours Attended: %@",[self stringFromTimeInterval:totalTime]];
}
- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}
-(Session*)getLastSessionAttended
{
    NSMutableArray * sessions = [Session getAllSessionsForStudentAsData:code];
    Session * lastSession = [NSKeyedUnarchiver unarchiveObjectWithData:[sessions objectAtIndex:[sessions count]-1]];
    return lastSession;
}

@end
