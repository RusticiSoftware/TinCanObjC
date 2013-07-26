//
//  TCVerb.m
//  RSTCAPI
//
//  Created by Brian Rogers on 3/3/13.
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

#import "TCVerb.h"

@interface TCVerb()
{
    NSString *_verbId;
    TCLocalizedValues *_display;
    NSMutableDictionary *_verbDict;
}

@end

@implementation TCVerb

- (id) initWithId:(NSString *)verbId withVerbDisplay:(TCLocalizedValues *)display
{
    if ((self = [super init])) {
        _verbId = verbId;
        _display = display;
    }
    return self;
}

- (id) initWithJSON:(NSString *)verbJSON
{
    if ((self = [super init])) {
        NSError* error;
        NSDictionary *verbDict = [NSJSONSerialization JSONObjectWithData:[verbJSON dataUsingEncoding:NSStringEncodingConversionAllowLossy] options:kNilOptions error:&error];
        
        NSString *verbId = [verbDict objectForKey:@"id"];
        TCLocalizedValues *verbDisplay = [[TCLocalizedValues alloc] initWithDictionary:[verbDict objectForKey:@"display"]];
        
        if(verbId)
        {
            _verbId = verbId;
        }
        
        if(verbDisplay)
        {
            _display = verbDisplay;
        }
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary *)verbDictionary
{
    if ((self = [super init])) {
        _verbId = [verbDictionary objectForKey:@"id"];
        _display = [[TCLocalizedValues alloc] initWithDictionary:[verbDictionary objectForKey:@"display"]];
    }
    return self;
}

- (NSDictionary *)dictionary
{
    _verbDict = [[NSMutableDictionary alloc] init];
    [_verbDict setValue:_verbId forKey:@"id"];
    [_verbDict setValue:[_display dictionary] forKey:@"display"];
    return [_verbDict copy];
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
