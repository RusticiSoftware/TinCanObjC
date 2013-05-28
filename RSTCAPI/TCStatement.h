//
//  TCStatement.h
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

// https://github.com/timburks/NuHTTPHelpers/blob/master/objc/NuHTTPHelpers.m
// for parsing multipart/mixed for 1.0

#import <Foundation/Foundation.h>
#import "TCVerb.h"
#import "TCAgent.h"
#import "TCActivity.h"
#import "TCAttachment.h"
#import "TCAttachmentCollection.h"

@interface TCStatement : NSObject

@property (nonatomic, retain) NSString *statementId;
@property (nonatomic, retain) TCAgent *actor;
@property (nonatomic, retain) NSObject *target;
@property (nonatomic, retain) TCVerb *verb;
@property (nonatomic, retain) NSDictionary *result;
@property (nonatomic, retain) NSString *boundary;
@property (nonatomic, retain) TCAttachmentCollection *attachments;

- (id) initWithId:(NSString *)statementId withActor:(TCAgent *)actor withTarget:(NSObject *)target withVerb:(TCVerb *)verb withResult:(NSDictionary *)result;

- (id) initWithJSON:(NSString *)statementJSON;

- (id) initWithId:(NSString *)statementId withActor:(TCAgent *)actor withTarget:(NSObject *)target withVerb:(TCVerb *)verb withBoundary:(NSString *)boundary withAttachments:(TCAttachmentCollection *)attachmentArray;

- (NSDictionary *) dictionary;

- (NSString *) JSONString;

@end
