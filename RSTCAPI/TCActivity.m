//
//  TCTarget.m
//  RSTCAPI
//
//  Created by Brian Rogers on 3/6/13.
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

#import "TCActivity.h"

@interface TCActivity()
{
    NSString *_activityId;
    TCActivityDefinition *_actDefinition;
    NSString *_objectType;
    NSMutableDictionary *_activityDict;
}

@end

@implementation TCActivity

- (id)initWithId:(NSString *)activityId withActivityDefinition:(TCActivityDefinition *)actDefinition
{
    if ((self = [super init])) {
        _activityId = activityId;
        _actDefinition = actDefinition;
        _objectType = @"Activity";
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)activityDictionary
{
    if ((self = [super init])) {
        _activityId = [activityDictionary valueForKey:@"id"];
        _actDefinition = [[TCActivityDefinition alloc] initWithDictionary:[activityDictionary objectForKey:@"definition"]];
        _objectType = @"Activity";
    }
    return self;
}

- (NSDictionary *)dictionary
{
    _activityDict = [[NSMutableDictionary alloc] init];
    [_activityDict setValue:_activityId forKey:@"id"];
    [_activityDict setValue:[_actDefinition dictionary] forKey:@"definition"];
    [_activityDict setValue:_objectType forKey:@"objectType"];
    return [_activityDict copy];
}

- (NSString *) JSONString
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self dictionary]
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString = [[TCUtil stringByRemovingControlCharacters:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    return jsonString;
}
@end
