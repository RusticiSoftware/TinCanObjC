//
//  TCQueryOptions.m
//  RSTCAPI
//
//  Created by Brian Rogers on 3/8/13.
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

#import "TCQueryOptions.h"

@interface TCQueryOptions()
{
    TCAgent *_actor;
    TCVerb *_verb;
    NSObject *_target;
    TCAgent *_instructor;
    NSString *_registration;
    BOOL _useContext;
    NSString *_since;
    NSString *_until;
    NSNumber *_limit;
    BOOL _authoritative;
    BOOL _sparse;
    BOOL _ascending;
}

@end

@implementation TCQueryOptions

- (id) initWithActor:(TCAgent *)actor withVerb:(TCVerb *)verb withTarget:(NSObject *)target withInstructor:(TCAgent *)instructor withRegistration:(NSString *)registration withContext:(BOOL)useContext withSince:(NSString *)since withUntil:(NSString *)until withLimit:(NSNumber *)limit withAuthoritative:(BOOL)authoritative withSparse:(BOOL)sparse withAscending:(BOOL)ascending
{
    if ((self = [super init])) {
        _actor = actor;
        _verb = verb;
        _target = target;
        _instructor = instructor;
        _registration = registration;
        _useContext = useContext;
        _since = since;
        _until = until;
        _limit = limit;
        _authoritative = authoritative;
        _sparse = sparse;
        _ascending = ascending;
    }
    return self;
}

- (NSString *) querystring
{
    NSMutableString *querystring = [[NSMutableString alloc] init];
    NSCharacterSet *acceptedInput = [NSCharacterSet characterSetWithCharactersInString:@":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"];
    
    [querystring appendFormat:@"%@",@"?"];

    
    //add the BOOLs - the first one is after the '?' and will always be output
    [querystring appendFormat:@"context=%s", _useContext ? "true" : "false" ];
    [querystring appendFormat:@"&authoritative=%s", _authoritative ? "true" : "false" ];
    [querystring appendFormat:@"&sparse=%s", _sparse ? "true" : "false" ];
    [querystring appendFormat:@"&ascending=%s", _ascending ? "true" : "false" ];
    
    if (_limit) {
        [querystring appendFormat:@"&limit=%@", [_limit stringValue]];
    }
    
    if (_actor) {
        [querystring appendFormat:@"&actor=%@",[[_actor JSONString] stringByAddingPercentEncodingWithAllowedCharacters:acceptedInput]];
    }
    
    if (_verb) {
        [querystring appendFormat:@"&verb=%@",[TCUtil encodeURL:[[_verb dictionary] valueForKey:@"id"]]];
    }
    
    if (_instructor) {
        [querystring appendFormat:@"&instructor=%@",[[_instructor JSONString] stringByAddingPercentEncodingWithAllowedCharacters:acceptedInput]];
    }
    
    if (_registration) {
        [querystring appendFormat:@"&registration=%@",[_registration stringByAddingPercentEncodingWithAllowedCharacters:acceptedInput]];
    }
    
    if (_since) {
        [querystring appendFormat:@"&since=%@",[_since stringByAddingPercentEncodingWithAllowedCharacters:acceptedInput]];
    }

    if (_until) {
        [querystring appendFormat:@"&since=%@",[_until stringByAddingPercentEncodingWithAllowedCharacters:acceptedInput]];
    }
    
    if (_target) {
        if (_target.class == TCAgent.class) {
            [querystring appendFormat:@"&object=%@",[(TCAgent*)_target JSONString]];
        }
        else if (_target.class == TCActivity.class)
        {
            [querystring appendFormat:@"&object=%@",[(TCActivity*)_target JSONString]];
        }else if (_target.class == TCStatement.class)
        {
            [querystring appendFormat:@"&object=%@",[(TCStatement*)_target JSONString]];
        }
    }
    
    //remove extra spaces and encode the string before returning it
    NSString *qs = [[querystring copy] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return qs;
}

@end
