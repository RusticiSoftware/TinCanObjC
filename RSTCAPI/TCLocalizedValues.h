//
//  TCLocalizedValue.h
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

#import <Foundation/Foundation.h>
#import "TCUtil.h"

@interface TCLocalizedValues : NSObject


- (id) initWithLanguageCode:(NSString *)languageCode withValue:(NSString *)value;
- (id) initWithDictionary:(NSDictionary *)dictionary;

- (void) addLocalizedValue:(NSString *)value withLanguageCode:(NSString *)languageCode;

- (NSString *) JSONString;
- (NSDictionary *) dictionary;

@end
