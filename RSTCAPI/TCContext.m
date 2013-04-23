//
//  TCContext.m
//  RSTCAPI
//
//  Created by Brian Rogers on 3/16/13.
/*
 Copyright 2013 Rustici Software
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "TCContext.h"

@interface TCContext()
{
    NSString *_registration;
    NSObject *_instructor;
    NSObject *_team;
    NSDictionary *_contextActivities;
}
@end

@implementation TCContext

- (id)initWithRegistration:(NSString *)registration withInstructor:(NSObject *)instructor withTeam:(NSObject *)team withContextActivities:(NSDictionary *)contextActivities withExtensions:(NSDictionary *)extensions
{
    if ((self = [super init])) {
        
    }
    return self;
}

- (NSString *) JSONString
{
    NSString *result = [NSString stringWithFormat:@"Not Implemented Yet"];
    return result;
}

- (NSString *)querystring
{
    NSString *result = [NSString stringWithFormat:@"Not Implemented Yet"];
    return result;
}

@end
