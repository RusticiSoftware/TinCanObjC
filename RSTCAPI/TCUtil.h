//
//  TCUtil.h
//  RSTCAPI
//
//  Created by Brian Rogers on 3/1/13.
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
#import <Security/Security.h>
#import <CommonCrypto/CommonHMAC.h>

@interface TCUtil : NSObject

+ (NSString *)GetUUID;

+ (NSString *)stringByRemovingControlCharacters: (NSString *)inputString;

+ (NSString*)encodeURL:(NSString *)string;

+ (NSString*)computeSHA256DigestForString:(NSString*)input;

@end
