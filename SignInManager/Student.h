//
//  Student.h
//  SignInManager
//
//  Created by Andrew on 9/24/14.
//  Copyright (c) 2014 Andrew Arpasi. Licensed under the MIT license.
//

#import <Foundation/Foundation.h>
#import "Session.h"

@interface Student : NSObject

@property NSString * code;
@property NSString * name;

+(NSMutableArray*)getAllStudents;
+(Student*)getStudentFromCode:(NSString*)code;
-(NSString*)getStudentHoursTotalAsString;
-(Session*)getLastSessionAttended;

@end
