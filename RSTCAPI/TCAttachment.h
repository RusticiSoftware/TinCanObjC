//
//  TCAttachment.h
//  RSTCAPI
//
//  Created by Brian Rogers on 4/26/13.
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
#import "TCLocalizedValues.h"

@interface TCAttachment : NSObject

@property (nonatomic, strong) NSString *sha2;
@property (nonatomic, strong) NSString *usageType;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSString *contentTransferEncoding; //Content-Transfer-Encoding := "BASE64" | "QUOTED-PRINTABLE" | "8BIT" | "7BIT" | "BINARY" | x-token   - not case sensitive - used in the header
@property (nonatomic, strong) NSString *fileUrl;
@property (nonatomic, strong) TCLocalizedValues *display;
@property (nonatomic, strong) TCLocalizedValues *description;
@property (nonatomic, strong) NSNumber *length;
@property (nonatomic, strong) NSString *dataString;


- (id) initWithSha2:(NSString *)sha2 withDataString:(NSString *)dataString withUsageType:(NSString *)usageType withContentType:(NSString *)contentType withContentTransferEncoding:(NSString *)contentTransferEncoding withDisplay:(TCLocalizedValues *)display withDescription:(TCLocalizedValues *)description withLength:(NSNumber *)length withFileUrl:(NSString *)fileUrl;

-(NSDictionary *)dictionary;
- (NSString *) JSONString;

@end
