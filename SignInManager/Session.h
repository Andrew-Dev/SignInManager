//
//  Session.h
//  SignInManager
//
//  Created by Andrew on 9/30/14.
//  Copyright (c) 2014 Andrew Arpasi. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>
#import "StudentSession.h"

@interface Session : NSObject
{
    NSDate * startTime;
    NSDate * endTime;
}

-(NSMutableArray*)getAllSessionsForStudentAsData:(NSString*)studentId;
+(NSMutableArray*)getAllSessionsForStudentAsData:(NSString*)studentId;
-(NSMutableArray*)getAllStudentSessionsFromThisSessionAsDataObjectsAsData;
+(NSMutableArray*)getAllStudentSessionsInAllSessionsForStudentAsDataInOneHugeAssArray:(NSString*)studentId;
+(NSMutableArray*)getAllSessions;
+(Session*)getSessionThatHasStudentSession:(StudentSession*)studentSession;
-(NSMutableArray*)getUnclockedStudents;
-(NSString*)getSessionTimeString;
-(void)start;
-(void)stop;

@property NSMutableArray * studentSessions;
@property NSString * title;
@end
