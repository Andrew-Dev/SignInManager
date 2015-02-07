//
//  StudentSession.m
//  SignInManager
//
//  Created by Andrew on 10/7/14.
//  Copyright (c) 2014 Andrew Arpasi. Licensed under the MIT license.
//

#import "StudentSession.h"

@implementation StudentSession
@synthesize stucode,inTime,outTime;

- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        inTime = [decoder decodeObjectForKey:@"inTime"];
        outTime = [decoder decodeObjectForKey:@"outTime"];
        stucode = [decoder decodeObjectForKey:@"student"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:inTime forKey:@"inTime"];
    [encoder encodeObject:outTime forKey:@"outTime"];
    [encoder encodeObject:stucode forKey:@"student"];
}

@end