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

@synthesize statementId = _statementId;
@synthesize actor = _actor;
@synthesize target = _target;
@synthesize verb = _verb;
@synthesize result = _result;
@synthesize boundary = _boundary;
@synthesize attachments = _attachments;
@synthesize context = _context;

- (id) initWithId:(NSString *)statementId withActor:(TCAgent *)actor withTarget:(NSObject *)target withVerb:(TCVerb *)verb withResult:(TCResult *)result withContext:(TCContext *)context
{
    if ((self = [super init])) {
        _statementId = statementId;
        _actor = actor;
        _target = target;
        _verb = verb;
        _result = result;
        _context = context;
    }
    return self;
}

- (id) initWithId:(NSString *)statementId withActor:(TCAgent *)actor withTarget:(NSObject *)target withVerb:(TCVerb *)verb withResult:(TCResult *)result withContext:(TCContext *)context withBoundary:(NSString *)boundary withAttachments:(TCAttachmentCollection *)attachmentArray
{
    if ((self = [super init])) {
        _statementId = statementId;
        _actor = actor;
        _target = target;
        _verb = verb;
        _result = result;
        _context = context;
        _boundary = boundary;
        _attachments = attachmentArray;
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
    
        _context = [[TCContext alloc] initWithDictionary:[statementDict objectForKey:@"context"]];
        _result = [[TCResult alloc] initWithDictionary:[statementDict objectForKey:@"result"]];
    
    }
    return self;
}


- (NSDictionary *) dictionary
{
    NSMutableDictionary *statement = [[NSMutableDictionary alloc] init];
    [statement setValue:_statementId forKey:@"id"];
    [statement setValue:[_actor dictionary] forKey:@"actor"];
    if([_target class] == [TCActivity class] || [_target class] == [TCAgent class]){
        [statement setValue:[(TCActivity *)_target dictionary] forKey:@"object"];
    }
    [statement setValue:[_verb dictionary] forKey:@"verb"];
    [statement setValue:[_result dictionary] forKey:@"result"];
    [statement setValue:[_context dictionary] forKey:@"context"];
    
    if(_attachments.count>0){
        [statement setValue:_attachments forKey:@"attachments"];
    }
    return [statement copy];
}

- (NSString *) JSONString
{
    NSMutableString *output = [[NSMutableString alloc] init];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self dictionary]
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString = [[TCUtil stringByRemovingControlCharacters:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    if(_boundary){
        [output appendFormat:@"\r\n--%@", _boundary];
        [output appendFormat:@"\r\n"];
        [output appendFormat:@"Content-Type:application/json"];
        [output appendFormat:@"\r\n\r\n"];
        [output appendFormat:@"%@",jsonString ];
        [output appendFormat:@"\r\n"];
        [output appendFormat:@"--%@", _boundary];
        [output appendFormat:@"\r\n"];
        //foreach attachment
        TCAttachment *attachment = (TCAttachment *)[_attachments attachmentAtIndex:0];
        [output appendFormat:@"Content-Type:%@", [attachment valueForKey:@"contentType" ]];
        [output appendFormat:@"\r\n"];
        [output appendFormat:@"Content-Transfer-Encoding:%@", [attachment valueForKey:@"contentTransferEncoding"]];
        [output appendFormat:@"\r\n"];
        [output appendFormat:@"X-Experience-API-Hash:%@", [attachment valueForKey:@"sha2"]];
        [output appendFormat:@"\r\n\r\n"];
        [output appendFormat:@"%@", [attachment valueForKey:@"dataString"]];
        [output appendFormat:@"\r\n"];
        [output appendFormat:@"--%@--\r\n", _boundary];
    }else{

        [output appendFormat:@"%@",jsonString ];
    }
    
    return output;
}
@end
