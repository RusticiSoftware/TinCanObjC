//
//  TCResult.m
//  RSTCAPI
//
//  Created by Brian Rogers on 7/3/13.
//  Copyright (c) 2013 Rustici Software. All rights reserved.
//

#import "TCResult.h"
#import "TCUtil.h"

@interface TCResult()
{
    NSString *_response;
    NSDictionary *_score;
    Boolean *_success;
    Boolean *_completion;
    NSString *_duration;
    NSDictionary *_extensions;
    NSMutableDictionary *_resultDict;
}

@end

@implementation TCResult

- (id) initWithResponse:(NSString *)response withScore:(NSDictionary *)scoreDict withSuccess:(Boolean)success withCompletion:(Boolean)completion withDuration:(NSString *)duration withExtensions:(NSDictionary *)extensions
{
    if ((self = [super init])) {
        _response = response;
        _score = scoreDict;
		_success = &success;
		_completion = &completion;
        _duration = duration;
        _extensions = extensions;
    }
    return self;
}


- (id) initWithDictionary:(NSDictionary *)resultDictionary
{
    if ((self = [super init])) {
        
        NSString *resultResponse = [resultDictionary objectForKey:@"response"];
        NSDictionary *resultScore = [resultDictionary objectForKey:@"score"];
        NSNumber *resultSuccess = [resultDictionary objectForKey:@"success"];
        NSNumber *resultCompletion = [resultDictionary objectForKey:@"completion"];
        NSString *resultDuration = [resultDictionary objectForKey:@"duration"];
        NSDictionary *resultExtensions = [resultDictionary objectForKey:@"extensions"];
        
        if(resultResponse)
        {
            _response = resultResponse;
        }
        
        if(resultScore)
        {
            _score = resultScore;
        }
        
        if(resultSuccess)
        {
			_success = resultSuccess.boolValue;
        }
        
        if(resultCompletion)
        {
			_completion = resultCompletion.boolValue;
        }
        
        if(resultDuration)
        {
            _duration = resultDuration;
        }
        
        if(resultExtensions)
        {
            _extensions = resultExtensions;
        }
    }
    return self;
}

- (NSDictionary *)dictionary
{
    _resultDict = [[NSMutableDictionary alloc] init];
    [_resultDict setValue:_response forKey:@"response"];
    [_resultDict setValue:_score forKey:@"score"];
	[_resultDict setValue:[NSNumber numberWithBool:_success] forKey:@"success"];
	[_resultDict setValue: [NSNumber numberWithBool: _completion] forKey:@"completion"];
    [_resultDict setValue:_duration forKey:@"duration"];
    [_resultDict setValue:_extensions forKey:@"extensions"];
    return [_resultDict copy];
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
