//
//  TCAttachmentCollection.h
//  RSTCAPI
//
//  Created by Brian Rogers on 4/27/13.
//  Copyright (c) 2013 Rustici Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCAttachment.h"

@interface TCAttachmentCollection : NSObject

@property (nonatomic, strong) NSMutableArray *attachmentArray;

- (id) init;
- (int) count;
- (TCAttachment *)attachmentAtIndex:(int)index;
- (void)addAttachment:(TCAttachment *)attachement;
- (NSArray *) array;
- (NSString *) JSONString;

@end
