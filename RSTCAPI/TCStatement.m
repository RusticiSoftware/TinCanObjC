//
//  TCStatement.m
//  RSTCAPI
//
//  Created by Brian Rogers on 2/28/13.
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

#import "TCStatement.h"
#import "TCUtil.h"

@implementation TCStatement

@synthesize statementId = _statementId, actor = _actor, target = _target, verb = _verb;

- (id) initWithId:(NSString *)statementId withActor:(TCAgent *)actor withTarget:(NSObject *)target withVerb:(TCVerb *)verb
{
    if ((self = [super init])) {
        _statementId = statementId;
        _actor = actor;
        _target = target;
        _verb = verb;
    }
    return self;
}

- (id) initWithJSON:(NSString *)statementJSON
{
    if ((self = [super init])) {
        NSError* error;
        NSDictionary *statementDict = [NSJSONSerialization JSONObjectWithData:[statementJSON dataUsingEncoding:NSStringEncodingConversionAllowLossy] options:kNilOptions error:&error];
        NSLog(@"statement Dict %@", statementDict);
        
        NSString *statementId = [statementDict objectForKey:@"id"];
        if(statementId)
        {
            _statementId = statementId;
        }else{
            // let's go ahead and create that ID if its not there
            _statementId = [TCUtil GetUUID];
        }

        _actor = [[TCAgent alloc] initWithDictionary:[statementDict objectForKey:@"actor"]];
        _verb = [[TCVerb alloc] initWithDictionary:[statementDict objectForKey:@"verb"]];
        
        if([[[statementDict objectForKey:@"object"] valueForKey:@"objectType"] isEqualToString:@"Activity"])
        {
            _target = [[TCActivity alloc] initWithDictionary:[statementDict objectForKey:@"object"]];
        }
        // add the other types here
    }
    return self;
}

- (NSDictionary *) dictionary
{
    NSMutableDictionary *statement = [[NSMutableDictionary alloc] init];
    [statement setValue:_statementId forKey:@"id"];
    [statement setValue:[_actor dictionary] forKey:@"actor"];
    if([_target class] == [TCActivity class]){
        [statement setValue:[(TCActivity *)_target dictionary] forKey:@"object"];
    }
    [statement setValue:[_verb dictionary] forKey:@"verb"];

    return [statement copy];
}

- (NSString *) JSONString
{
    NSMutableDictionary *statement = [[NSMutableDictionary alloc] init];
    [statement setValue:_statementId forKey:@"id"];
    [statement setValue:[_actor dictionary] forKey:@"actor"];
    if([_target class] == [TCActivity class]){
        [statement setValue:[(TCActivity *)_target dictionary] forKey:@"object"];
    }
    [statement setValue:[_verb dictionary] forKey:@"verb"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:statement
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];

    NSString *jsonString = [[TCUtil stringByRemovingControlCharacters:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    NSLog(@"jsonString from statement : %@", jsonString);

    return jsonString;
}
@end
