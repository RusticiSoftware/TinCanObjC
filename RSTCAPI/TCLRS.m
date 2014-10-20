//
//  TCLRS.m
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

#import "TCLRS.h"
#import "TCStatement.h"
#import "TCError.h"
#import "TCUtil.h"

@interface TCLRS()
{
    NSString *_endpoint;
    NSString *_auth;
    NSString *_currentMoreUrl;
    NSString *_version;
}

@end

#define kTC_VERSION_0_95 @"0.95"
#define kTC_VERSION_1_0_0 @"1.0.0"

@implementation TCLRS



- (id)initWithOptions:(NSDictionary *)options {
    if ((self = [super init])) {
        _endpoint = [options valueForKey:@"endpoint"];
        _auth = [options valueForKey:@"auth"];
        _version = (NSString *)[options valueForKey:@"version"];
        if(![_version isEqualToString:kTC_VERSION_0_95] && ![_version isEqualToString:kTC_VERSION_1_0_0])
        {
            _version = kTC_VERSION_1_0_0; //default to 1.0.0 for now
        }
    }
    return self;
}

/**
 Save a statement, when used from a browser sends to the endpoint using the RESTful interface.
 Use a callback to make the call asynchronous.
 
 @method saveStatement
 @param {Object} TinCan.Statement to send
 @param {Object} [cfg] Configuration used when saving
 @param {Function} [cfg.callback] Callback to execute on completion
 */
- (void) saveStatement:(TCStatement *)statement withOptions:(NSDictionary *)options withCompletionBlock:(void (^)())completionBlock  withErrorBlock:(void(^)(TCError *))errorBlock
{
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statements?statementId=%@", _endpoint, statement.statementId ]]];
    
    NSString *requestString = [NSString stringWithFormat:@"%@", [statement JSONString], nil];
    NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
    NSString *postLength = [NSString stringWithFormat:@"%d", [requestData length]];

    NSLog(@"statement JSON %@", [statement JSONString]);
    
    if(statement.boundary){
        // multipart/mixed format
        [urlRequest setValue:[NSString stringWithFormat:@"multipart/mixed; boundary=%@", statement.boundary] forHTTPHeaderField:@"Content-Type"];
    }else{
        //standard JSON format
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    [urlRequest setValue:_auth forHTTPHeaderField:@"Authorization"];
    [urlRequest setValue:_version forHTTPHeaderField:@"X-Experience-API-Version"];
    [urlRequest setHTTPMethod:@"PUT"];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    [urlRequest setHTTPBody: requestData];
 
    NSLog(@"request headers : %@", urlRequest.allHTTPHeaderFields);
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        NSLog(@"HTTP response code: %i", httpResponse.statusCode);

        if(httpResponse.statusCode == 204){
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock();
            });
        }
        else if (httpResponse.statusCode >= 400){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString* errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                TCError *error400 = [[TCError alloc] initWithMessage:[NSString stringWithFormat:@"%@", errorStr]];
                errorBlock(error400);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock();
            });
        }
        
    }];
}

/**
 Save a set of statements, when used from a browser sends to the endpoint using the RESTful interface.
 Use a callback to make the call asynchronous.
 
 @method saveStatements
 @param {Array} Array of statements or objects convertable to statements
 @param {Object} [cfg] Configuration used when saving
 @param {Function} [cfg.callback] Callback to execute on completion
 */
- (void) saveStatements:(TCStatementCollection *)statementArray withOptions:(NSDictionary *)options withCompletionBlock:(void (^)())completionBlock  withErrorBlock:(void(^)(TCError *))errorBlock
{
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statements", _endpoint]]];
    
    NSString *requestString = [NSString stringWithFormat:@"%@", [statementArray JSONString], nil];
    NSLog(@"saveStatements requestString %@", requestString);
    NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
    NSString *postLength = [NSString stringWithFormat:@"%d", [requestData length]];
    
    
    [urlRequest setValue:_auth forHTTPHeaderField:@"Authorization"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:_version forHTTPHeaderField:@"X-Experience-API-Version"];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [urlRequest setHTTPBody: requestData];
    
    NSLog(@"request headers : %@", urlRequest.allHTTPHeaderFields);
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        NSLog(@"HTTP response code: %i", httpResponse.statusCode);
        
        if(httpResponse.statusCode == 200){
            NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"saveStatements 200 - %@", responseStr);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock();
            });
        }
        else if (httpResponse.statusCode == 400){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString* errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                TCError *error400 = [[TCError alloc] initWithMessage:[NSString stringWithFormat:@"%@", errorStr]];
                errorBlock(error400);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock((TCError*)error);
            });
        }
        
    }];
    
}

/**
 Retrieve a statement, when used from a browser sends to the endpoint using the RESTful interface.
 
 @method retrieveStatement
 @param {String} ID of statement to retrieve
 @param {Object} [cfg] Configuration options
 @param {Function} [cfg.callback] Callback to execute on completion
 @return {Object} TinCan.Statement retrieved
 */
- (void) retrieveStatementWithId:(NSString *)statementId withOptions:(NSDictionary *)options withCompletionBlock:(void (^)(TCStatement *))completionBlock withErrorBlock:(void(^)(TCError *))errorBlock
{
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statements?statementId=%@", _endpoint, statementId ]]];
    
    [urlRequest setValue:_auth forHTTPHeaderField:@"Authorization"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:_version forHTTPHeaderField:@"X-Experience-API-Version"];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"retrieveStatement - %@", responseStr);
        
        //parse result as JSON
        id statements = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"response : %@ - result: %@ - Error: %@", response.description, statements, error.userInfo);
        if(error){
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock((TCError*)error);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([statements valueForKey:@"statement"]);
            });
        }
        
    }];
}

/**
 Fetch a set of statements, when used from a browser sends to the endpoint using the
 RESTful interface.  Use a callback to make the call asynchronous.
 
 @method queryStatements
 @param {Object} [cfg] Configuration used to query
 @param {Object} [cfg.params] Query parameters
 @param {TinCan.Agent} [cfg.params.actor] Agent matches 'actor'
 @param {TinCan.Verb} [cfg.params.verb] Verb to query on
 @param {TinCan.Activity|TinCan.Agent|TinCan.Statement} [cfg.params.target] Activity, Agent, or Statement matches 'object'
 @param {TinCan.Agent} [cfg.params.instructor] Agent matches 'context:instructor'
 @param {String} [cfg.params.registration] Registration UUID
 @param {Boolean} [cfg.params.context] When filtering on target, include statements with matching context
 @param {String} [cfg.params.since] Match statements stored since specified timestamp
 @param {String} [cfg.params.until] Match statements stored at or before specified timestamp
 @param {Integer} [cfg.params.limit] Number of results to retrieve
 @param {Boolean} [cfg.params.authoritative] Get authoritative results
 @param {Boolean} [cfg.params.sparse] Get sparse results
 @param {Boolean} [cfg.params.ascending] Return results in ascending order of stored time
 @param {Function} [cfg.callback] Callback to execute on completion
 @param {String|null} cfg.callback.err Error status or null if succcess
 @param {TinCan.StatementsResult|XHR} cfg.callback.response Receives a StatementsResult argument
 @return {Object} Request result
 */
- (void) queryStatementsWithOptions:(TCQueryOptions *)queryOptions withCompletionBlock:(void (^)(NSArray *))completionBlock  withErrorBlock:(void(^)(TCError *))errorBlock
{
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/statements%@", _endpoint, [queryOptions querystring] ]]];

    [urlRequest setValue:_auth forHTTPHeaderField:@"Authorization"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:_version forHTTPHeaderField:@"X-Experience-API-Version"];
    
    NSLog(@"request %@", urlRequest.allHTTPHeaderFields);
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"queryStatementsWithOptions - %@", responseStr);

        //parse result as JSON
        id statements = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSLog(@"response : %@ - result: %@ - Error: %@", response.description, statements, error.userInfo);
        if(error){
            dispatch_async(dispatch_get_main_queue(), ^{
                errorBlock((TCError*)error);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                _currentMoreUrl = [statements valueForKey:@"more"];
                completionBlock([statements valueForKey:@"statements"]);
            });
        }
        
    }];
    
}

/**
 Fetch more statements from a previous query, when used from a browser sends to the endpoint using the
 RESTful interface.  Use a callback to make the call asynchronous.
 
 @method moreStatements
 @param {Object} [cfg] Configuration used to query
 @param {String} [cfg.url] More URL
 @param {Function} [cfg.callback] Callback to execute on completion
 @param {String|null} cfg.callback.err Error status or null if succcess
 @param {TinCan.StatementsResult|XHR} cfg.callback.response Receives a StatementsResult argument
 @return {Object} Request result
 */
-(void) moreStatements:(NSDictionary *)options withMoreUrl:(NSString *)moreUrl withCompletionBlock:(void (^)(NSArray *))completionBlock withErrorBlock:(void(^)(TCError *))errorBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        TCError *error = [[TCError alloc] initWithMessage:@"Not Implemented"];
        errorBlock(error);
    });
}

/**
 Retrieve a state value, when used from a browser sends to the endpoint using the RESTful interface.
 
 @method retrieveState
 @param {String} key Key of state to retrieve
 @param {Object} cfg Configuration options
 @param {Object} cfg.activity TinCan.Activity
 @param {Object} cfg.agent TinCan.Agent
 @param {String} [cfg.registration] Registration
 @param {Function} [cfg.callback] Callback to execute on completion
 @param {Object|Null} cfg.callback.error
 @param {TinCan.State|null} cfg.callback.result null if state is 404
 @return {Object} TinCan.State retrieved when synchronous, or result from sendRequest
 */
- (void) retrieveStateWithStateId:(NSString *)stateId withActivityId:(NSString *)activityId withAgent:(TCAgent *)agent withRegistration:(NSString *)registration withOptions:(NSDictionary *)options withCompletionBlock:(void (^)(NSDictionary *))completionBlock withErrorBlock:(void(^)(TCError *))errorBlock
{
    TCState *state = [[TCState alloc] initWithContents:nil withStateId:stateId withActivityId:activityId withAgent:agent withRegistration:registration];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/activities/state%@", _endpoint, [state querystring] ]]];
        
    [urlRequest setValue:_auth forHTTPHeaderField:@"Authorization"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:_version forHTTPHeaderField:@"X-Experience-API-Version"];
    
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSLog(@"request headers : %@", urlRequest.allHTTPHeaderFields);
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"saveStateWithValue - %@", responseStr);
        
        NSLog(@"HTTP response code: %i", httpResponse.statusCode);
        
        id state = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        if(httpResponse.statusCode == 204){
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(state);
            });
        }
        else if (httpResponse.statusCode == 400){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString* errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                TCError *error400 = [[TCError alloc] initWithMessage:[NSString stringWithFormat:@"%@", errorStr]];
                errorBlock(error400);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(state);
            });
        }
        
    }];
}

/**
 Save a state value, when used from a browser sends to the endpoint using the RESTful interface.
 
 @method saveState
 @param {String} key Key of state to save
 @param {String} val Value of state to save
 @param {Object} cfg Configuration options
 @param {Object} cfg.activity TinCan.Activity
 @param {Object} cfg.agent TinCan.Agent
 @param {String} [cfg.registration] Registration
 @param {String} [cfg.lastSHA1] SHA1 of the previously seen existing state
 @param {Function} [cfg.callback] Callback to execute on completion
 */
- (void) saveStateWithValue:(NSDictionary*)value withStateId:(NSString *)stateId withActivityId:(NSString *)activityId withAgent:(TCAgent *)agent withRegistration:(NSString *)registration withLastSHA1:(NSString *)lastSHA1 withOptions:(NSDictionary *)options withCompletionBlock:(void (^)())completionBlock withErrorBlock:(void(^)(TCError *))errorBlock
{
    
    TCState *state = [[TCState alloc] initWithContents:value withStateId:stateId withActivityId:activityId withAgent:agent withRegistration:registration];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/activities/state%@", _endpoint, [state querystring] ]]];
    
    // create JSON for body
    NSString *requestString = [NSString stringWithFormat:@"%@", [state JSONString], nil];
    NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
    NSString *postLength = [NSString stringWithFormat:@"%d", [requestData length]];
    
    
    [urlRequest setValue:_auth forHTTPHeaderField:@"Authorization"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:_version forHTTPHeaderField:@"X-Experience-API-Version"];
    
    [urlRequest setHTTPMethod:@"PUT"];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [urlRequest setHTTPBody: requestData];
    
    NSLog(@"request headers : %@", urlRequest.allHTTPHeaderFields);
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"saveStateWithValue - %@", responseStr);
        
        NSLog(@"HTTP response code: %i", httpResponse.statusCode);
        
        if(httpResponse.statusCode == 204){
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock();
            });
        }
        else if (httpResponse.statusCode == 400){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString* errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                TCError *error400 = [[TCError alloc] initWithMessage:[NSString stringWithFormat:@"%@", errorStr]];
                errorBlock(error400);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock();
            });
        }
        
    }];

}

/**
 Drop a state value or all of the state, when used from a browser sends to the endpoint using the RESTful interface.
 
 @method dropState
 @param {String|null} key Key of state to delete, or null for all
 @param {Object} cfg Configuration options
 @param {Object} [cfg.activity] TinCan.Activity
 @param {Object} [cfg.agent] TinCan.Agent
 @param {String} [cfg.registration] Registration
 @param {Function} [cfg.callback] Callback to execute on completion
 */
- (void) dropStateWithStateId:(NSString *)stateId withActivityId:(NSString *)activityId withAgent:(TCAgent *)agent withRegistration:(NSString *)registration withOptions:(NSDictionary *)options withCompletionBlock:(void (^)())completionBlock withErrorBlock:(void(^)(TCError *))errorBlock
{
    TCState *state = [[TCState alloc] initWithContents:nil withStateId:stateId withActivityId:activityId withAgent:agent withRegistration:registration];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/activities/state%@", _endpoint, [state querystring] ]]];
    
    [urlRequest setValue:_auth forHTTPHeaderField:@"Authorization"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:_version forHTTPHeaderField:@"X-Experience-API-Version"];
    
    [urlRequest setHTTPMethod:@"DELETE"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSLog(@"request headers : %@", urlRequest.allHTTPHeaderFields);
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        NSString* responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"saveStateWithValue - %@", responseStr);
        
        NSLog(@"HTTP response code: %i", httpResponse.statusCode);
        
        if(httpResponse.statusCode == 204){
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock();
            });
        }
        else if (httpResponse.statusCode == 400){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString* errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                TCError *error400 = [[TCError alloc] initWithMessage:[NSString stringWithFormat:@"%@", errorStr]];
                errorBlock(error400);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock();
            });
        }
        
    }];
}

/**
 Retrieve an activity profile value, when used from a browser sends to the endpoint using the RESTful interface.
 
 @method retrieveActivityProfile
 @param {String} key Key of activity profile to retrieve
 @param {Object} cfg Configuration options
 @param {Object} cfg.activity TinCan.Activity
 @param {Function} [cfg.callback] Callback to execute on completion
 @return {Object} Value retrieved
 */
- (void) retrieveActivityProfileWithKey:(NSString *)key withActivity:(TCActivity *)activity withOptions:(NSDictionary *)options withCompletionBlock:(void (^)())completionBlock withErrorBlock:(void(^)(TCError *))errorBlock
{
    
}

/**
 Save an activity profile value, when used from a browser sends to the endpoint using the RESTful interface.
 
 @method saveActivityProfile
 @param {String} key Key of activity profile to retrieve
 @param {Object} cfg Configuration options
 @param {Object} cfg.activity TinCan.Activity
 @param {String} [cfg.lastSHA1] SHA1 of the previously seen existing profile
 @param {Function} [cfg.callback] Callback to execute on completion
 */
- (void) saveActivityProfileWithValue:(NSDictionary *)profile forKey:(NSString *)key withOptions:(NSDictionary *)options withCompletionBlock:(void (^)())completionBlock withErrorBlock:(void(^)(TCError *))errorBlock
{
    
}

/**
 Drop an activity profile value or all of the activity profile, when used from a browser sends to the endpoint using the RESTful interface.
 
 @method dropActivityProfile
 @param {String|null} key Key of activity profile to delete, or null for all
 @param {Object} cfg Configuration options
 @param {Object} cfg.activity TinCan.Activity
 @param {Function} [cfg.callback] Callback to execute on completion
 */
- (void) dropActivityProfileWithKey:(NSString *)key withActivity:(TCActivity *)activity withOptions:(NSDictionary *)options withCompletionBlock:(void (^)())completionBlock withErrorBlock:(void(^)(TCError *))errorBlock
{
    
}

@end

