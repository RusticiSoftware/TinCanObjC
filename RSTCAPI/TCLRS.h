//
//  TCLRS.h
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

#import <Foundation/Foundation.h>
#import "TCError.h"
#import "TCStatement.h"
#import "TCQueryOptions.h"
#import "TCState.h"
#import "TCStatementCollection.h"

@interface TCLRS : NSObject


- (id)initWithOptions:(NSDictionary *)options;

/**
 Save a statement, when used from a browser sends to the endpoint using the RESTful interface.
 Use a callback to make the call asynchronous.
 
 @method saveStatement
 @param {Object} TinCan.Statement to send
 @param {Object} [cfg] Configuration used when saving
 @param {Function} [cfg.callback] Callback to execute on completion
 */
- (void) saveStatement:(TCStatement *)statement withOptions:(NSDictionary *)options withCompletionBlock:(void (^)())completionBlock  withErrorBlock:(void(^)(TCError *))errorBlock;

/**
 Save a set of statements, when used from a browser sends to the endpoint using the RESTful interface.
 Use a callback to make the call asynchronous.
 
 @method saveStatements
 @param {Array} Array of statements or objects convertable to statements
 @param {Object} [cfg] Configuration used when saving
 @param {Function} [cfg.callback] Callback to execute on completion
 */
- (void) saveStatements:(TCStatementCollection *)statementArray withOptions:(NSDictionary *)options withCompletionBlock:(void (^)())completionBlock  withErrorBlock:(void(^)(TCError *))errorBlock;

/**
 Retrieve a statement, when used from a browser sends to the endpoint using the RESTful interface.
 
 @method retrieveStatement
 @param {String} ID of statement to retrieve
 @param {Object} [cfg] Configuration options
 @param {Function} [cfg.callback] Callback to execute on completion
 @return {Object} TinCan.Statement retrieved
 */
- (void) retrieveStatementWithId:(NSString *)statementId withOptions:(NSDictionary *)options withCompletionBlock:(void (^)(TCStatement *))completionBlock withErrorBlock:(void(^)(TCError *))errorBlock;

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
- (void) queryStatementsWithOptions:(TCQueryOptions *)queryOptions withCompletionBlock:(void (^)(NSArray *))completionBlock  withErrorBlock:(void(^)(TCError *))errorBlock;

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
-(void) moreStatements:(NSDictionary *)options withMoreUrl:(NSString *)moreUrl withCompletionBlock:(void (^)(NSArray *))completionBlock withErrorBlock:(void(^)(TCError *))errorBlock;

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
- (void) retrieveStateWithStateId:(NSString *)stateId withActivityId:(NSString *)activityId withAgent:(TCAgent *)agent withRegistration:(NSString *)registration withOptions:(NSDictionary *)options withCompletionBlock:(void (^)(NSDictionary *))completionBlock withErrorBlock:(void(^)(TCError *))errorBlock;

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
- (void) saveStateWithValue:(NSDictionary*)value withStateId:(NSString *)stateId withActivityId:(NSString *)activityId withAgent:(TCAgent *)agent withRegistration:(NSString *)registration withLastSHA1:(NSString *)lastSHA1 withOptions:(NSDictionary *)options withCompletionBlock:(void (^)())completionBlock withErrorBlock:(void(^)(TCError *))errorBlock;

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
- (void) dropStateWithStateId:(NSString *)stateId withActivityId:(NSString *)activityId withAgent:(TCAgent *)agent withRegistration:(NSString *)registration withOptions:(NSDictionary *)options withCompletionBlock:(void (^)())completionBlock withErrorBlock:(void(^)(TCError *))errorBlock;

/**
 Retrieve an activity profile value, when used from a browser sends to the endpoint using the RESTful interface.
 
 @method retrieveActivityProfile
 @param {String} key Key of activity profile to retrieve
 @param {Object} cfg Configuration options
 @param {Object} cfg.activity TinCan.Activity
 @param {Function} [cfg.callback] Callback to execute on completion
 @return {Object} Value retrieved
 */
- (void) retrieveActivityProfileWithKey:(NSString *)key withActivity:(TCActivity *)activity withOptions:(NSDictionary *)options withCompletionBlock:(void (^)())completionBlock withErrorBlock:(void(^)(TCError *))errorBlock;

/**
 Save an activity profile value, when used from a browser sends to the endpoint using the RESTful interface.
 
 @method saveActivityProfile
 @param {String} key Key of activity profile to retrieve
 @param {Object} cfg Configuration options
 @param {Object} cfg.activity TinCan.Activity
 @param {String} [cfg.lastSHA1] SHA1 of the previously seen existing profile
 @param {Function} [cfg.callback] Callback to execute on completion
 */
- (void) saveActivityProfileWithValue:(NSDictionary *)profile forKey:(NSString *)key withOptions:(NSDictionary *)options withCompletionBlock:(void (^)())completionBlock withErrorBlock:(void(^)(TCError *))errorBlock;

/**
 Drop an activity profile value or all of the activity profile, when used from a browser sends to the endpoint using the RESTful interface.
 
 @method dropActivityProfile
 @param {String|null} key Key of activity profile to delete, or null for all
 @param {Object} cfg Configuration options
 @param {Object} cfg.activity TinCan.Activity
 @param {Function} [cfg.callback] Callback to execute on completion
 */
- (void) dropActivityProfileWithKey:(NSString *)key withActivity:(TCActivity *)activity withOptions:(NSDictionary *)options withCompletionBlock:(void (^)())completionBlock withErrorBlock:(void(^)(TCError *))errorBlock;

@end
