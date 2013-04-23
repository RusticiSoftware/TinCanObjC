//
//  TCQueryOptions.h
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

#import <Foundation/Foundation.h>
#import "TCStatement.h"
#import "TCAgent.h"
#import "TCActivity.h"
#import "TCVerb.h"

@interface TCQueryOptions : NSObject

- (id) initWithActor:(TCAgent *)agent withVerb:(TCVerb *)verb withTarget:(NSObject *)target withInstructor:(TCAgent *)instructor withRegistration:(NSString *)registration withContext:(BOOL)useContext withSince:(NSString *)since withUntil:(NSString *)until withLimit:(NSNumber *)limit withAuthoritative:(BOOL)authoritative withSparse:(BOOL)sparse withAscending:(BOOL)ascending;


- (NSString *) querystring;

@end
