//
//  TCActor.m
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

#import "TCAgent.h"

@interface TCAgent()
{
    NSString *_name;
    NSString *_mbox;
    NSMutableDictionary *_accountDict;
    NSMutableDictionary *_actorDict;
}

@end

@implementation TCAgent

- (id)initWithName:(NSString *)name withMbox:(NSString *)mbox withAccount:(NSMutableDictionary *)accountDict
{
    if ((self = [super init])) {
        _name = name;
        _mbox = mbox;
        _accountDict = accountDict;
    }
    return self;
}

- (id)initWithJSON:(NSString *)agentJSON
{
    if ((self = [super init])) {
        NSError* error;
        NSDictionary *agentDict = [NSJSONSerialization JSONObjectWithData:[agentJSON dataUsingEncoding:NSStringEncodingConversionAllowLossy] options:kNilOptions error:&error];
        
        NSString *agentName = [agentDict objectForKey:@"name"];
        NSString *agentMbox = [agentDict objectForKey:@"mbox"];
        NSMutableDictionary *accountDict = [agentDict objectForKey:@"account"];
        
        if(agentName)
        {
            _name = agentName;
        }
        
        if(agentMbox)
        {
            _mbox = agentMbox;
        }
        
        if(accountDict)
        {
            _accountDict = accountDict;
        }
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)agentDictionary
{
    if ((self = [super init])) {
        
        NSString *agentName = [agentDictionary objectForKey:@"name"];
        NSString *agentMbox = [agentDictionary objectForKey:@"mbox"];
        NSMutableDictionary *accountDict = [agentDictionary objectForKey:@"account"];
        
        if(agentName)
        {
            _name = agentName;
        }
        
        if(agentMbox)
        {
            _mbox = agentMbox;
        }
        
        if(accountDict)
        {
            _accountDict = accountDict;
        }
    }
    return self;
}

- (NSDictionary *)dictionary
{
    _actorDict = [[NSMutableDictionary alloc] init];
    [_actorDict setValue:_name forKey:@"name"];
    [_actorDict setValue:_mbox forKey:@"mbox"];
    [_actorDict setValue:_accountDict forKey:@"account"];
    [_actorDict setValue:@"Agent" forKey:@"objectType"];
    return [_actorDict copy];
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
