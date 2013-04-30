//
//  TCAttachment.m
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

#import "TCAttachment.h"

@implementation TCAttachment

@synthesize sha2 = _sha2;
@synthesize usageType = _usageType;
@synthesize contentType = _contentType;
@synthesize contentTransferEncoding = _contentTransferEncoding;
@synthesize fileUrl = _fileUrl;
@synthesize display = _display;
@synthesize description = _description;
@synthesize length = _length;
@synthesize dataString = _dataString;


- (id) initWithSha2:(NSString *)sha2 withDataString:(NSString *)dataString withUsageType:(NSString *)usageType withContentType:(NSString *)contentType withContentTransferEncoding:(NSString *)contentTransferEncoding withDisplay:(TCLocalizedValues *)display withDescription:(TCLocalizedValues *)description withLength:(NSNumber *)length withFileUrl:(NSString *)fileUrl
{
    if ((self = [super init])) {
        _sha2 = sha2;
        _dataString = dataString;
        _usageType = usageType;
        _contentType = contentType;
        _contentTransferEncoding = contentTransferEncoding;
        _display = display;
        _description = description;
        _length = length;
        _fileUrl = fileUrl;
    }
    return self;
}

- (NSDictionary *) dictionary
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:_sha2 forKey:@"sha2"];
    //[dict setValue:_dataString forKey:@"dataString"];
    [dict setValue:_usageType forKey:@"usageType"];
    [dict setValue:_contentType forKey:@"contentType"];
    //[dict setValue:_contentTransferEncoding forKey:@"contentTransferEncoding"];
    [dict setValue:[_display dictionary] forKey:@"display"];
    if(_description){
        [dict setValue:[_description dictionary] forKey:@"description"];
    }
    [dict setValue:_length forKey:@"length"];
    if(_fileUrl){
        [dict setValue:_fileUrl forKey:@"fileUrl"];
    }
    NSLog(@"%@", dict);
    return [dict copy];
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
