//
//  TCLocalizedValue.m
//  RSTCAPI
//
//  Created by Brian Rogers on 3/2/13.
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

#import "TCLocalizedValues.h"

@interface TCLocalizedValues()
{
    NSMutableDictionary *_localizedValues;
}

@end

@implementation TCLocalizedValues


- (id) initWithLanguageCode:(NSString *)languageCode withValue:(NSString *)value
{
    if ((self = [super init])) {
        _localizedValues = [[NSMutableDictionary alloc] init];
        [_localizedValues setValue:value forKey:languageCode];
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary *)dictionary
{
    if ((self = [super init])) {
        _localizedValues = [dictionary mutableCopy];
    }
    return self;
}

- (void) addLocalizedValue:(NSString *)value withLanguageCode:(NSString *)languageCode
{
    [_localizedValues setValue:value forKey:languageCode];
}

- (NSDictionary *) dictionary
{
    return [_localizedValues copy];
}

- (NSString *) JSONString
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_localizedValues
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

@end
