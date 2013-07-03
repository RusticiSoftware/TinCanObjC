//
//  TCResult.h
//  RSTCAPI
//
//  Created by Brian Rogers on 7/3/13.
//  Copyright (c) 2013 Rustici Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCResult : NSObject

- (id) initWithResponse:(NSString *)response withScore:(NSDictionary *)scoreDict withSuccess:(NSNumber *)success withCompletion:(NSNumber *)completion withDuration:(NSString *)duration withExtensions:(NSDictionary *)extensions;

- (id) initWithDictionary:(NSDictionary *)verbDictionary;
- (NSDictionary *)dictionary;
- (NSString *) JSONString;

@end
