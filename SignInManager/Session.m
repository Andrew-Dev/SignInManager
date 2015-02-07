//
//  Session.m
//  SignInManager
//
//  Created by Andrew on 9/30/14.
//  Copyright (c) 2014 Andrew Arpasi. Licensed under the MIT license.
//

#import "Session.h"

@implementation Session
@synthesize studentSessions,title;

- (id)init
{
    if(self = [super init])
    {
        studentSessions = [[NSMutableArray alloc] init];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        startTime = [decoder decodeObjectForKey:@"startTime"];
        endTime = [decoder decodeObjectForKey:@"endTime"];
        studentSessions = [decoder decodeObjectForKey:@"students"];
        title = [decoder decodeObjectForKey:@"title"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:startTime forKey:@"startTime"];
    [encoder encodeObject:endTime forKey:@"endTime"];
    [encoder encodeObject:studentSessions forKey:@"students"];
    [encoder encodeObject:title forKey:@"title"];
}
-(void)start
{
    startTime = [NSDate date];
}
-(void)stop
{
    endTime = [NSDate date];
}
-(NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}
-(NSString*)getSessionTimeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSString * dateString = [formatter stringFromDate:startTime];
    [formatter setDateFormat:@"hh:mm"];
    NSString * firstTime = [formatter stringFromDate:startTime];
    NSString * secondTime = [formatter stringFromDate:endTime];
    NSTimeInterval totalSessionTime = [endTime timeIntervalSinceDate:startTime];
    return [NSString stringWithFormat:@"Session Date: %@ Start At: %@, Stop: %@ - Total: %@",dateString,firstTime,secondTime,[self stringFromTimeInterval:totalSessionTime]];
}
-(NSMutableArray*)getUnclockedStudents
{
    NSMutableArray * stusesses = [self getAllStudentSessionsFromThisSessionAsDataObjectsAsData];
    NSMutableArray * unclocked = [[NSMutableArray alloc] init];
    for(int i=0;i<[stusesses count];i++)
    {
        StudentSession * sess = [NSKeyedUnarchiver unarchiveObjectWithData:[stusesses objectAtIndex:i]];
        if(sess.outTime == nil)
        {
            [unclocked addObject:[NSKeyedArchiver archivedDataWithRootObject:sess]];
        }
    }
    return unclocked;
}
+(NSMutableArray*)getAllSessions
{
    NSMutableArray * sessions = [[NSMutableArray alloc] init];
    for(NSData * s in [[NSUserDefaults standardUserDefaults] objectForKey:@"sessions"])
    {
        [sessions addObject:s];
    }
    return sessions;
}
+(Session*)getSessionThatHasStudentSession:(StudentSession*)studentSession
{
    for(NSData * s in [self getAllSessions])
    {
        Session * sess = [NSKeyedUnarchiver unarchiveObjectWithData:s];
        //[studentSessions removeObject:s];
        if([sess.studentSessions containsObject:[NSKeyedArchiver archivedDataWithRootObject:studentSession]])
        {
            return sess;
        }
    }
    return nil;
}
+(NSMutableArray*)getAllSessionsForStudentAsData:(NSString*)studentId
{
    NSMutableArray * sesses = [[NSMutableArray alloc] init];
    for(NSData * s in [self getAllSessions])
    {
        Session * sess = [NSKeyedUnarchiver unarchiveObjectWithData:s];
        //[studentSessions removeObject:s];
        if([[sess getAllSessionsForStudentAsData:studentId] count] > 0)
        {
            [sesses addObject:[NSKeyedArchiver archivedDataWithRootObject:sess]];
        }
    }
    return sesses;
}
+(NSMutableArray*)getAllStudentSessionsInAllSessionsForStudentAsDataInOneHugeAssArray:(NSString*)studentId
{
    NSMutableArray * stusesses = [[NSMutableArray alloc] init];
    for(NSData * s in [self getAllSessions])
    {
        Session * sess = [NSKeyedUnarchiver unarchiveObjectWithData:s];
        //[studentSessions removeObject:s];
        for(NSData * stu in sess.studentSessions)
        {
            StudentSession * stusess = [NSKeyedUnarchiver unarchiveObjectWithData:stu];
            if([stusess.stucode isEqualToString:studentId])
            {
                [stusesses addObject:[NSKeyedArchiver archivedDataWithRootObject:stusess]];
            }
        }
    }
    return stusesses;
}
-(NSMutableArray*)getAllSessionsForStudentAsData:(NSString*)studentId
{
    NSMutableArray * stusesses = [[NSMutableArray alloc] init];
    for(NSData * s in studentSessions)
    {
        StudentSession * stusess = [NSKeyedUnarchiver unarchiveObjectWithData:s];
        //[studentSessions removeObject:s];
        if([stusess.stucode isEqualToString:studentId])
        {
            [stusesses addObject:[NSKeyedArchiver archivedDataWithRootObject:stusess]];
        }
    }
    return stusesses;
}
-(NSMutableArray*)getAllStudentSessionsFromThisSessionAsDataObjectsAsData
{
    NSMutableArray * stusesses = [[NSMutableArray alloc] init];
    for(NSData * s in studentSessions)
    {
        [stusesses addObject:s];
    }
    return stusesses;
}

@end
