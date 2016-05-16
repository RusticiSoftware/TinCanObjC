//
//  TCStatementCollection.m
//  RSTCAPI
//
//  Created by Brian Rogers on 3/7/13.
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

#import "TCStatementCollection.h"

@interface TCStatementCollection()
{
    NSMutableArray *_statementArray;
}


@end

@implementation TCStatementCollection

- (id) init
{
    if ((self = [super init])) {
        _statementArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addStatement:(TCStatement *)statement
{
    [_statementArray addObject:[statement dictionary]];
}

- (NSString *)JSONString
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_statementArray
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString = [[TCUtil stringByRemovingControlCharacters:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    return jsonString;
}

@end
