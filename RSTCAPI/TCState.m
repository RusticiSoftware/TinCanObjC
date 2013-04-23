//
//  TCState.m
//  RSTCAPI
//
//  Created by Brian Rogers on 3/10/13.
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

#import "TCState.h"
#import "TCUtil.h"

@interface TCState()
{
    NSString *_stateId;
    NSDictionary *_contents;
    NSString *_activityId;
    TCAgent *_agent;
    NSString *_registration;
    NSDate *_updated;
}

@end

@implementation TCState

- (id) initWithContents:(NSDictionary *)contents withStateId:(NSString *)stateId withActivityId:(NSString *)activityId withAgent:(TCAgent *)agent withRegistration:(NSString *)registration
{
    _stateId = stateId;
    _contents = contents;
    _activityId = activityId;
    _agent = agent;
    _registration = registration;
    _updated = [NSDate date];
    
    return self;
}


- (NSString *) JSONString
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_contents
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString = [[TCUtil stringByRemovingControlCharacters:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    return jsonString;
}

- (NSString *) querystring
{
    NSMutableString *qs = [[NSMutableString alloc] init];
    
    [qs appendFormat:@"?stateId=%@", _stateId];
    [qs appendFormat:@"&activityId=%@", _activityId];
    [qs appendFormat:@"&agent=%@",[[[_agent JSONString] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy]];
    if(_registration)
    {
        [qs appendFormat:@"&registration=%@",_registration];
    }
    
    return [qs copy];
}

@end
