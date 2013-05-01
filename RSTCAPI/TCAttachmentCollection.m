//
//  TCAttachmentCollection.m
//  RSTCAPI
//
//  Created by Brian Rogers on 4/27/13.
//  Copyright (c) 2013 Rustici Software. All rights reserved.
//

#import "TCAttachmentCollection.h"

@implementation TCAttachmentCollection

@synthesize attachmentArray = _attachmentArray;

- (id) init
{
    if ((self = [super init])) {
        _attachmentArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addAttachment:(TCAttachment *)attachement
{
    [_attachmentArray addObject:attachement];
}

- (int) count
{
    return _attachmentArray.count;
}

- (TCAttachment *)attachmentAtIndex:(int)index
{
    return [_attachmentArray objectAtIndex:index];
}

- (NSArray *) array
{
    NSMutableArray *output = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<_attachmentArray.count; i++) {
        [output addObject:[[self attachmentAtIndex:i] dictionary] ];
    }
    
    return [output copy];
}

- (NSString *) JSONString
{
    NSMutableString *output = [[NSMutableString alloc] init];
    [output appendFormat:@"["];
    for (int i=0; i < _attachmentArray.count; i++) {
        TCAttachment *attachment = (TCAttachment *)[_attachmentArray objectAtIndex:i];
        [output appendFormat:@"%@", [attachment JSONString]];
    }
    
    [output appendFormat:@"]"];
    return output;
}

@end
